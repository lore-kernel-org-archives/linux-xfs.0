Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 5E4F27CBF
	for <xfs@oss.sgi.com>; Mon,  3 Jun 2013 22:06:27 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id DEB13AC002
	for <xfs@oss.sgi.com>; Mon,  3 Jun 2013 20:06:23 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	SoAaeBzDvrAn917g for <xfs@oss.sgi.com>;
	Mon, 03 Jun 2013 20:06:22 -0700 (PDT)
Date: Tue, 4 Jun 2013 13:06:20 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 3/6] xfs: inode unlinked list needs to recalculate the
	inode CRC
Message-ID: <20130604030620.GC29466@dastard>
References: <1370237332-24757-1-git-send-email-david@fromorbit.com>
	<1370237332-24757-4-git-send-email-david@fromorbit.com>
	<51ACDE03.4090501@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <51ACDE03.4090501@redhat.com>
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
To: Brian Foster <bfoster@redhat.com>
Cc: bpm@sgi.com, xfs@oss.sgi.com

On Mon, Jun 03, 2013 at 02:18:43PM -0400, Brian Foster wrote:
> On 06/03/2013 01:28 AM, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > The inode unlinked list manipulations operate directly on the inode
> > buffer, and so bypass the inode CRC calculation mechanisms. Hence an
> > inode on the unlinked list has an invalid CRC. Fix this by
> > recalculating the CRC whenever we modify an unlinked list pointer in
> > an inode, ncluding during log recovery. This is trivial to do and
> > results in  unlinked list operations always leaving a consistent
> > inode in the buffer.
> > 
> > Signed-off-by: Dave Chinner <dchinner@redhat.com>
.....
> > @@ -1809,6 +1821,10 @@ xfs_iunlink_remove(
> >  		last_dip->di_next_unlinked = cpu_to_be32(next_agino);
> >  		ASSERT(next_agino != 0);
> >  		offset = last_offset + offsetof(xfs_dinode_t, di_next_unlinked);
> > +
> > +		/* need to recalc the inode CRC if appropriate */
> > +		xfs_dinode_calc_crc(mp, dip);
> > +
> 
> Ugh, sorry I didn't notice this last time around, but this one looks
> like it should recalculate the crc on last_dip instead of dip.

Yup, it should - good catch. This just highlights how hard it is to
actaully catch a filesystem in the state with a corrupt CRC on the
unlinked list...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
