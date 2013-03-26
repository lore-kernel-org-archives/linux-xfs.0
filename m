Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id F24EB7F4E
	for <xfs@oss.sgi.com>; Tue, 26 Mar 2013 17:56:11 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id E045C304032
	for <xfs@oss.sgi.com>; Tue, 26 Mar 2013 15:56:08 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	ocSrGLYLqHbUdTt7 for <xfs@oss.sgi.com>;
	Tue, 26 Mar 2013 15:56:07 -0700 (PDT)
Date: Wed, 27 Mar 2013 09:56:00 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 09/21] xfs: add version 3 inode format with CRCs
Message-ID: <20130326225600.GL6369@dastard>
References: <1363091454-8852-1-git-send-email-david@fromorbit.com>
	<1363091454-8852-10-git-send-email-david@fromorbit.com>
	<20130314160321.GV22182@sgi.com> <20130315011104.GD21651@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20130315011104.GD21651@dastard>
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

On Fri, Mar 15, 2013 at 12:11:04PM +1100, Dave Chinner wrote:
> On Thu, Mar 14, 2013 at 11:03:21AM -0500, Ben Myers wrote:
> > On Tue, Mar 12, 2013 at 11:30:42PM +1100, Dave Chinner wrote:
> > >  		xfs_buf_zero(fbuf, 0, ninodes << mp->m_sb.sb_inodelog);
> > >  		for (i = 0; i < ninodes; i++) {
> > >  			int	ioffset = i << mp->m_sb.sb_inodelog;
> > > -			uint	isize = sizeof(struct xfs_dinode);
> > > +			uint	isize = xfs_dinode_size(version);
> > >  
> > >  			free = xfs_make_iptr(mp, fbuf, i);
> > >  			free->di_magic = cpu_to_be16(XFS_DINODE_MAGIC);
> > >  			free->di_version = version;
> > >  			free->di_gen = cpu_to_be32(gen);
> > >  			free->di_next_unlinked = cpu_to_be32(NULLAGINO);
> > > +
> > > +			if (version == 3) {
> > > +				free->di_ino = cpu_to_be64(ino);
> > > +				ino++;
> > > +				uuid_copy(&free->di_uuid, &mp->m_sb.sb_uuid);
> > > +				xfs_dinode_calc_crc(mp, free);
> > > +			}
> > > +
> > >  			xfs_trans_log_buf(tp, fbuf, ioffset, ioffset + isize - 1);
> > 
> > If I have it right, it's ok not to log the literal are here (even though the
> > crc was calculated including the literal area) because the log is protected by
> > its own crcs and recovery will recalculate the crc.
> 
> Prior to CRCs it's OK not to log the literal areas because the
> contents really don't matter. The entire buffer is zeroed because
> it's faster than zeroing individual inode cores one by one and it
> ensures that we can always tell a freshly allocated inode block with
> xfs_db because the literal areas are all zero (i.e. good for
> debugging). But these are conveniences, not a necessity, and hence
> the advantage of not logging the literal areas reduces the overhead
> of logging inode allocations *significantly*.
> 
> > What do we have in the
> > literal area after log replay in that case?
> 
> For non-CRC inode buffers, it doesn't matter.
> 
> But you are right that it does matter for CRC enabled inode buffers
> as it will result in the CRC in the inode core being incorrect. I'l
> havea think about this - there are a couple of potential ways of
> solving the problem, and I need to think about them a bit first.

Ben, FYI: I've taken the easy way out for this - log the entire
inode buffer rather than just the inode core. The CRC means we are
dependent on having all the inode logged so that seems to be the
simplest way to deal with this problem overall, even though it
increases the amount of metadata logged for inode creates
substantially.

I'll address this potential performance issue in future with new
inode create and unlink transactions that allow us to avoid logging
buffers for all inode modifications. There are other good reasons
for doing this as well (e.g. avoid the subtly broken special
handling of physical inode buffer logging vs logical inode logging
in log recovery), so I think this is best to just take the simple
option here....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
