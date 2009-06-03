Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n53NPmkL201795 for <xfs@oss.sgi.com>; Wed, 3 Jun 2009 18:25:48 -0500
Received: from josefsipek.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 9913B11934EC
	for <xfs@oss.sgi.com>; Wed,  3 Jun 2009 16:26:05 -0700 (PDT)
Received: from josefsipek.net (josefsipek.net [141.211.133.196]) by
	cuda.sgi.com with ESMTP id uTMkrasj77JokZfY for
	<xfs@oss.sgi.com>; Wed, 03 Jun 2009 16:26:05 -0700 (PDT)
Date: Wed, 3 Jun 2009 19:26:05 -0400
From: "Josef 'Jeff' Sipek" <jeffpc@josefsipek.net>
Subject: Re: [PATCH 7/7] xfs: split xfs_sync_inodes
Message-ID: <20090603232605.GB9167@josefsipek.net>
References: <20090514171233.942489000@bombadil.infradead.org>
	<20090514171559.231368000@bombadil.infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20090514171559.231368000@bombadil.infradead.org>
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
Cc: xfs@oss.sgi.com

On Thu, May 14, 2009 at 01:12:40PM -0400, Christoph Hellwig wrote:
> xfs_sync_inodes is used to write back either file data or inode metadata.
> In generally we always do these separately, except for one fishy case in
> xfs_fs_put_super that does both.  So separate xfs_sync_inodes into
> separate xfs_sync_data and xfs_sync_attr functions.  In xfs_fs_put_super
> we first call the data sync and then the attr sync as that was the previous
> order.  The moved log force in that path doesn't make a different because
                                                          ^^^^^^^^^

Typo.

> Index: xfs/fs/xfs/linux-2.6/xfs_super.c
> ===================================================================
> --- xfs.orig/fs/xfs/linux-2.6/xfs_super.c	2009-05-14 19:09:00.178792110 +0200
> +++ xfs/fs/xfs/linux-2.6/xfs_super.c	2009-05-14 19:09:05.278808755 +0200
> @@ -1070,7 +1070,18 @@ xfs_fs_put_super(
>  	int			unmount_event_flags = 0;
>  
>  	xfs_syncd_stop(mp);
> -	xfs_sync_inodes(mp, SYNC_ATTR|SYNC_DELWRI);
> +
> +	if (!(sb->s_flags & MS_RDONLY)) {
> +		/*
> +		 * XXX(hch): this should be SYNC_WAIT.
> +		 *
> +		 * Or more likely no needed at all because the VFS is already
                                  ^^

Typo.

-- 
Real Programmers consider "what you see is what you get" to be just as bad a
concept in Text Editors as it is in women. No, the Real Programmer wants a
"you asked for it, you got it" text editor -- complicated, cryptic,
powerful, unforgiving, dangerous.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
