Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q0CDM4Ar257699 for <xfs@oss.sgi.com>; Thu, 12 Jan 2012 07:22:04 -0600
Message-ID: <4F0EDE6D.4010302@oracle.com>
Date: Thu, 12 Jan 2012 21:21:49 +0800
From: Jeff Liu <jeff.liu@oracle.com>
MIME-Version: 1.0
Subject: Re: Introduce SEEK_DATA/SEEK_HOLE to XFS V5
References: <4F06F71A.2010301@oracle.com> <20120111154318.GY6390@sgi.com>
	<20120111222816.GA6519@sgi.com>
In-Reply-To: <20120111222816.GA6519@sgi.com>
Reply-To: jeff.liu@oracle.com
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Ben Myers <bpm@sgi.com>
Cc: Christoph Hellwig <hch@infradead.org>, Chris Mason <chris.mason@oracle.com>, xfs@oss.sgi.com

Hi Ben,

Thanks a lot for your so much detailed info!

On 01/12/2012 06:28 AM, Ben Myers wrote:

> Hey Jeff,
> 
> On Wed, Jan 11, 2012 at 09:43:18AM -0600, Ben Myers wrote:
>> Here are a few additional minor comments from yesterday.
>>
>> I'm looking forward to seeing your next version, and I'm still working
>> through this one.
>>
>> I would like to suggest that you split this into two patches.  The first
>> patch should be the 'simple' implementation that that you began with
>> that only looks at extents, and assumes that unwritten extents contain
>> data.  The second patch can remove the assumption that unwritten extents
>> contain data, and go over pages over the extent to determine if it is
>> clean.  I feel we have a better chance of coming to consensus that the
>> first patch is correct in the near term, and then we can move on to the
>> more complicated matter of whether the unwritten extent can be treated
>> as a hole safe in the knowledge that the initial implementation was
>> awesome.
> 
> Ok, since I'm the jackass who is asking you to do the extra work I'll
> try to be of assistance.  Understand that at this point I'm trying to
> make sure that I understand your code fully.  I'm not trying to give you
> a hard time or make your life miserable.

> 
> Here I am assuming that we'll treat unwritten extents as containing data
> and leaving the enhancement of probing unwritten extents for later.

Do you means I only need to post a patch to treat unwritten extents as
data next time, and then try to work out another patch for probing
unwritten extents until the first one became stable?

> 
> This is a table of some of the results from xfs_bmapi_read, and what
> should be done in each situation.
> 
> SEEK_DATA:
> 
> Where nmap = 0:
> return ENXIO. 	* maybe not possible, unless len = 0?

Per my previous tryout, this situation can be triggered when no extent
behind the seek offset for SEEK_HOLE; for SEEK_DATA, it will be caught
by the following checking:
if (start >= isize)
        return -ENXIO;

> 
> Where nmap = 1:
> map[0]
> written				data @ offset
> delay				data @ offset
> unwritten			data @ offset
> hole				return ENXIO?	* empty file?
> 
> Where nmap = 2:
> map[0]		map[1]
> written		written		data @ offset
> written		delay		data @ offset
> written		unwritten	data @ offset
> written		hole		data @ offset
> delay		written		data @ offset
> delay		delay		data @ offset	* maybe not possible?

Hmm, maybe we can design a case to trigger it out later. :-P.

I'm going to write the patch by referring to the following codes.

> delay		unwritten	data @ offset
> delay		hole		data @ offset
> unwritten	written		data @ offset
> unwritten	delay		data @ offset
> unwritten	unwritten	data @ offset
> unwritten	hole		data @ offset
> hole		written		data @ map[1].br_startoff
> hole		delay		data @ map[1].br_startoff
> hole		unwritten	data @ map[1].br_startoff
> hole		hole		* not possible
> 
> (DELAYSTARTBLOCK and HOLESTARTBLOCK are both 'isnullstartblock')
> 
> written:
> (!isnullstartblock(map.br_startblock) && map.br_state == XFS_EXT_NORMAL)	
> delay:
> map.br_startblock == DELAYSTARTBLOCK
> 
> unwritten:
> map.br_state == XFS_EXT_UNWRITTEN
> 
> hole:
> map.br_startblock == HOLESTARTBLOCK
> 
> xfs_seek_data(file, startoff)
> {
> 	loff_t	offset;
> 	int	error;
> 
> 	take ilock
> 
> 	isize = i_size_read
> 
> 	start_fsb = XFS_B_TO_FSBT(startoff)
> 	end_fsb = XFS_B_TO_FSB(i_size)	# inode size
> 
> 	error = xfs_bmapi_read(map, &nmap)
> 	if (error) 
> 		goto out_unlock;
> 
> 	if (nmap == 0) {
> 		/*
> 		 * return an error.  I'm not sure that this necessarily
> 		 * means we're reading after EOF, since it looks like
> 		 * xfs_bmapi_read would return one hole in that case.
> 		 */
> 
> 		error = ERROR /* EIO? */
> 		goto out_unlock
> 	}
> 
> 	/* check map[0] first */
> 	if (map[0].br_state == XFS_EXT_NORMAL &&
> 	    !isnullstartblock(map[0].br_startblock) {
> 		/*
> 		 * startoff is already within data.  remember
> 		 * that it can anywhere within start_fsb
> 		 */
> 		offset = startoff
> 	} else if (map[0].br_startblock == DELAYSTARTBLOCK) {
> 		offset = startoff
> 	} else if (map[0].br_state == XFS_EXT_UNWRITTEN) {
> 		offset = startoff;
> 	} else if (map[0].br_startblock == HOLESTARTBLOCK) {
> 		if (nmap == 1) {
> 			/*
> 			 * finding a hole in map[0] and nothing in
> 			 * map[1] probably means that we are reading
> 			 * after eof
> 			 */
> 			ASSERT(startoff >= isize)
> 			error = ENXIO
> 			goto out_unlock
> 		}
> 
> 		/*
> 		 * we have two mappings, and need to check map[1] to see
> 		 * if there is data.
> 		 */
> 		if (map[1].br_state == XFS_EXT_NORMAL &&
> 		    !isnullstartblock(map[1].br_startblock)) {
> 			offset = XFS_FSB_TO_B(map[1].br_startoff);
> 		} else if (map[1].br_startblock == DELAYSTARTBLOCK) {
> 			offset = XFS_FSB_TO_B(map[1].br_startoff);
> 		} else if (map[1].br_state == XFS_EXT_UNWRITTEN) {
> 			offset = XFS_FSB_TO_B(map[1].br_startoff);
> 		} else if (map[1].br_startblock == HOLESTARTBLOCK) {
> 			/*
> 			 * this should never happen, but we could
> 			 */
> 			ASSERT(startoff >= isize);
> 			error = ENXIO
> 			/* BUG(); */
> 		} else {
> 			offset = startoff
> 			/* BUG(); */
> 		}
> 	} else {
> 		offset = startoff
> 		/* BUG(); */
> 	}
> out_unlock:
> 	drop ilock
> 	if (error)
> 		return -error;
> 
> 	return offset;
> }
> 
> I think that is sufficiently straightforward that even I can understand
> it, or am I off my rocker?  IMO it's not that bad that we have to write
> the if/else to determine extent type twice and that there is some
> duplication when setting the offset.  When you come back to enhance it
> further by probing unwritten extents I think a goto would probably be
> more readable than trying to shoehorn this into a for/do, but that's
> just me.
> 
> Jeff, I hope that doesn't ruffle any feathers.  I know I came to the
> party a bit late.  After a break I am going to go look at your code for
> xfs_seek_data again.  I think I'll understand it better now.  After that
> I am going to look into SEEK_HOLE... 

Thanks you!
-Jeff

> 
> Regards,
> Ben
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
