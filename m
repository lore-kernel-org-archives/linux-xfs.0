Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id A371B7F52
	for <xfs@oss.sgi.com>; Tue, 26 Mar 2013 20:48:59 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 1E90FAC001
	for <xfs@oss.sgi.com>; Tue, 26 Mar 2013 18:48:59 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	ctZz7oi5X6O8xTd1 for <xfs@oss.sgi.com>;
	Tue, 26 Mar 2013 18:48:56 -0700 (PDT)
Date: Wed, 27 Mar 2013 12:48:28 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 09/21] xfs: add version 3 inode format with CRCs
Message-ID: <20130327014828.GN6369@dastard>
References: <1363091454-8852-1-git-send-email-david@fromorbit.com>
	<1363091454-8852-10-git-send-email-david@fromorbit.com>
	<20130314160321.GV22182@sgi.com> <20130315011104.GD21651@dastard>
	<20130326225600.GL6369@dastard> <20130327005307.GK30652@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20130327005307.GK30652@sgi.com>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Ben Myers <bpm@sgi.com>
Cc: xfs@oss.sgi.com

On Tue, Mar 26, 2013 at 07:53:07PM -0500, Ben Myers wrote:
> Hi Dave,
> 
> On Wed, Mar 27, 2013 at 09:56:00AM +1100, Dave Chinner wrote:
> > On Fri, Mar 15, 2013 at 12:11:04PM +1100, Dave Chinner wrote:
> > > On Thu, Mar 14, 2013 at 11:03:21AM -0500, Ben Myers wrote:
> > > > On Tue, Mar 12, 2013 at 11:30:42PM +1100, Dave Chinner wrote:
> > > > >  		xfs_buf_zero(fbuf, 0, ninodes << mp->m_sb.sb_inodelog);
> > > > >  		for (i = 0; i < ninodes; i++) {
> > > > >  			int	ioffset = i << mp->m_sb.sb_inodelog;
> > > > > -			uint	isize = sizeof(struct xfs_dinode);
> > > > > +			uint	isize = xfs_dinode_size(version);
> > > > >  
> > > > >  			free = xfs_make_iptr(mp, fbuf, i);
> > > > >  			free->di_magic = cpu_to_be16(XFS_DINODE_MAGIC);
> > > > >  			free->di_version = version;
> > > > >  			free->di_gen = cpu_to_be32(gen);
> > > > >  			free->di_next_unlinked = cpu_to_be32(NULLAGINO);
> > > > > +
> > > > > +			if (version == 3) {
> > > > > +				free->di_ino = cpu_to_be64(ino);
> > > > > +				ino++;
> > > > > +				uuid_copy(&free->di_uuid, &mp->m_sb.sb_uuid);
> > > > > +				xfs_dinode_calc_crc(mp, free);
> > > > > +			}
> > > > > +
> > > > >  			xfs_trans_log_buf(tp, fbuf, ioffset, ioffset + isize - 1);
> > > > 
> > > > If I have it right, it's ok not to log the literal are here (even though the
> > > > crc was calculated including the literal area) because the log is protected by
> > > > its own crcs and recovery will recalculate the crc.
> > > 
> > > Prior to CRCs it's OK not to log the literal areas because the
> > > contents really don't matter. The entire buffer is zeroed because
> > > it's faster than zeroing individual inode cores one by one and it
> > > ensures that we can always tell a freshly allocated inode block with
> > > xfs_db because the literal areas are all zero (i.e. good for
> > > debugging). But these are conveniences, not a necessity, and hence
> > > the advantage of not logging the literal areas reduces the overhead
> > > of logging inode allocations *significantly*.
> > > 
> > > > What do we have in the
> > > > literal area after log replay in that case?
> > > 
> > > For non-CRC inode buffers, it doesn't matter.
> > > 
> > > But you are right that it does matter for CRC enabled inode buffers
> > > as it will result in the CRC in the inode core being incorrect. I'l
> > > havea think about this - there are a couple of potential ways of
> > > solving the problem, and I need to think about them a bit first.
> > 
> > Ben, FYI: I've taken the easy way out for this - log the entire
> > inode buffer rather than just the inode core. The CRC means we are
> > dependent on having all the inode logged so that seems to be the
> > simplest way to deal with this problem overall, even though it
> > increases the amount of metadata logged for inode creates
> > substantially.
> > 
> > I'll address this potential performance issue in future with new
> > inode create and unlink transactions that allow us to avoid logging
> > buffers for all inode modifications. There are other good reasons
> > for doing this as well (e.g. avoid the subtly broken special
> > handling of physical inode buffer logging vs logical inode logging
> > in log recovery), so I think this is best to just take the simple
> > option here....
> 
> It seems like this is a more general problem with fresh on-disk
> structures.  When we calculate crc and log only part of a buffer we are
> prone to the crc being incorrect after log replay because the unlogged
> portions of the buffer are still undefined.  They aren't the 0s we
> calculated crcs with.

But it doesn't matter for all other metadata as we don't log CRC
fields except in the inode/dquot at allocation. It is the exception
rather than the rule.

> I have a couple suggestions:
> 
> 1) We could read the undefined garbage from disk before we initialize
> the structure and then calculate the crc.  That way if we log only parts
> of the result the crc would still match after a crash.

The overhead of reading every inode cluster from disk during
allocation will drop create performance by orders of magnitude. i.e.
far worse in terms of performance than logging the entire buffer.

> 2) Create a new transaction to write a known pattern over the
> entire buffer, then initialize the buffer with that pattern,
> calculate the crc, and still log only the parts of the buffer
> which were modified.  In the non-crash case we still need to
> arrange for the buffer to be patterned after the log wraps, but it
> has the advantage of not having to log large structures just to
> zero them.

We need to ensure we log the entire object if we are logging the CRC
of the object. In this case, the initialisation and calculation of
the CRC needs to be atomic, so it needs to be a single transactions.
That's what logging the entire buffer does.

In all cases except inode and dquot initialisation, CRCs are not
logged and so there is no concern about whether we are logging
unused regions or not as the eventual CRC calculations during log
recovery do not depend on the contents of unlogged regions being
known.  i.e. for buffer based objects, this is what happens:

	get a new buffer
	initialise new buffer
	modify new buffer
	log changed areas
	changed regions get written to log
<time passes>
	metadata writeback started
	verify metadata
	CRC+LSN calculated and inserted into buffer
	buffer written with CRC+LSN as unlogged changes.

So, if we crash while time is passing before metadata writeback,
recovery does this:

	read modifications out of log
	read buffer off disk *without verification* as we can't
					trust the contents at all.
	write modifications into buffer
	attach verifier to buffer
<time passes, other mods to the buffer are replayed>
	metadata writeback started
	verify metadata
	CRC+LSN calculated and inserted into buffer
	buffer written with CRC+LSN as unlogged changes.

IOWs, for everything logged exclusively as a buffer, partial logging
of intialised regions is a non-issue as CRCs are not logged and do
not play a part in log recovery.

The fact is that inodes are special little snowflakes in that they
are initialised physically in a buffer and then modified logically
in transactions. As such, the CRC is calculated at the time of
logical->physical transition in memory, not at the time of physical
IO like is done for all other buffers.

Hence source of the problem here is that inodes are allocated via
physical logging rather than logically, and as such we are logging
the CRC internal to the inode. Hence we have to care about ensuring
that we physically log the entire modified region that the CRC
covers.  i.e. this is a condition specific to inode and dquot
initialisation, not a general problem for all metadata logged in
buffers.

And seeing as I've mentioned dquots, I'll point out that
xfs_qm_init_dquot_blk() doesn't do partial logging of the physical
buffer used for initialisation - it just logs the entire buffer,
exactly as I'm proposing to do here for inodes.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
