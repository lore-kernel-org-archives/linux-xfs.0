Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	n01HEjH5007288 for <xfs@oss.sgi.com>; Thu, 1 Jan 2009 11:14:45 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 2AC8657F1F
	for <xfs@oss.sgi.com>; Thu,  1 Jan 2009 09:14:41 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id 1UU7Ygkn4Tp57q5i for
	<xfs@oss.sgi.com>; Thu, 01 Jan 2009 09:14:41 -0800 (PST)
Date: Thu, 1 Jan 2009 12:14:09 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: XFS internal error when NFS client accesses nonexistent inode
Message-ID: <20090101171409.GA18020@infradead.org>
References: <87zlicfncr.fsf@server.ak.quickcircuit.co.nz>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <87zlicfncr.fsf@server.ak.quickcircuit.co.nz>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
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
To: Mario Becroft <mb@gem.win.co.nz>
Cc: xfs@oss.sgi.com

On Thu, Jan 01, 2009 at 03:09:08AM +1300, Mario Becroft wrote:
> I hit a seemingly strange problem today when I xfsdump/restored some
> filesystems from one volume onto another. When I exported the new
> volumes, errors like the following started to occur:
> 
> Dec 31 09:12:46 nfs1 kernel: nfsd: non-standard errno: -117
> 
> Bumping up the XFS debug level revealed the following (full details at
> the end):
> 
> Dec 31 09:12:46 nfs1 kernel: Filesystem "dm-17": XFS internal error xfs_imap_to_bp at line 186 of file fs/xfs/xfs_inode.c.  Caller 0xffffffff80374c48

This is:


                di_ok = be16_to_cpu(dip->di_core.di_magic) ==
			    XFS_DINODE_GOOD_VERSION(dip->di_core.di_version);
		if (unlikely(XFS_TEST_ERROR(!di_ok, mp,
						XFS_ERRTAG_ITOBP_INOTOBP,
						XFS_RANDOM_ITOBP_INOTOBP))) {
			if (imap_flags & XFS_IMAP_BULKSTAT) {
				xfs_trans_brelse(tp, bp);
				return XFS_ERROR(EINVAL);
			}
 here -->		XFS_CORRUPTION_ERROR("xfs_imap_to_bp",
						XFS_ERRLEVEL_HIGH, mp, dip);

> After wasting quite a lot of time, I finally realised that this was
> probably caused by NFS clients accessing nonexistent file handles that
> they had open from when the filesystem was previously exported, prior to
> the dump/restore.
>
> Is my analysis correct? Is an internal error the expected behaviour in
> this case? And can this cause any harm?

That explanation makes a lot of sense.  As seen in the snipplet above
we actually have checks for bulkstat which might hand in invalid inode
numbers, and I think we need to extent this check to nfs export and
the handle ioctls, too as we can get arbitrary inode numbers passed
from a client / user space.  In addition we should probably translate
the error number into something more useful.

I will create a testcase using the handle ioctls for this and provide
a fix to handle this issue more gracefully.

Except for shutting down a perfectly fine filesystem this should
not cause additional damage.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
