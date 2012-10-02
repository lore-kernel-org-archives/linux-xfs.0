Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q92KNY1m083696 for <xfs@oss.sgi.com>; Tue, 2 Oct 2012 15:23:34 -0500
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	mKNIJFAtVa4bLr8F for <xfs@oss.sgi.com>;
	Tue, 02 Oct 2012 13:24:57 -0700 (PDT)
Date: Wed, 3 Oct 2012 06:24:56 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 06/13] xfs: xfs_sync_data is redundant.
Message-ID: <20121002202456.GR23520@dastard>
References: <1348807485-20165-1-git-send-email-david@fromorbit.com>
	<1348807485-20165-7-git-send-email-david@fromorbit.com>
	<5069F9B0.50804@redhat.com> <20121002001021.GJ23520@dastard>
	<20121002132205.GA14572@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20121002132205.GA14572@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: Brian Foster <bfoster@redhat.com>, xfs@oss.sgi.com

On Tue, Oct 02, 2012 at 09:22:05AM -0400, Christoph Hellwig wrote:
> On Tue, Oct 02, 2012 at 10:10:22AM +1000, Dave Chinner wrote:
> > diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
> > index da69c18..0ec7a46 100644
> > --- a/fs/xfs/xfs_inode.h
> > +++ b/fs/xfs/xfs_inode.h
> > @@ -294,7 +294,7 @@ xfs_new_eof(struct xfs_inode *ip, xfs_fsize_t new_size)
> >  static inline void
> >  xfs_flush_inodes(struct xfs_inode *ip)
> >  {
> > -	writeback_inodes_sb_if_idle(VFS_I(ip)->i_sb, WB_REASON_FS_FREE_SPACE);
> > +	sync_inodes_sb(VFS_I(ip)->i_sb);
> 
> sync_inodes_sb needs s_umount held and asserts that, while our callers
> usually won't have it.

Ah, bugger. I didn't notice that, and hadn't checked dmesg after I
ran 273 a few times with this patch. I just figured that because it
waited for completion, it didn't need it.

Adding s_umount is fine for the wirte path, but the create path
holds a directory i_mutex so I'd guess that means it has to be a
trylock to avoid lock inversion warnings from lockdep....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
