Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n0P5v25H098719 for <xfs@oss.sgi.com>; Sat, 24 Jan 2009 23:57:03 -0600
Received: from josefsipek.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id CE9B8B55FB
	for <xfs@oss.sgi.com>; Sat, 24 Jan 2009 21:56:18 -0800 (PST)
Received: from josefsipek.net (josefsipek.net [141.211.133.196]) by
	cuda.sgi.com with ESMTP id EBR2bHgnUIaEvpSR for
	<xfs@oss.sgi.com>; Sat, 24 Jan 2009 21:56:18 -0800 (PST)
Date: Sun, 25 Jan 2009 00:56:18 -0500
From: "Josef 'Jeff' Sipek" <jeffpc@josefsipek.net>
Subject: Re: [PATCH] xfs_admin: exit gracefully for non-XFS fileststems
Message-ID: <20090125055618.GM5587@josefsipek.net>
References: <20090125050342.GA30091@lst.de>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20090125050342.GA30091@lst.de>
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
To: Christoph Hellwig <hch@lst.de>
Cc: xfs@oss.sgi.com

On Sun, Jan 25, 2009 at 06:03:42AM +0100, Christoph Hellwig wrote:
> Exit gracefully if the magic number doesn't match xfs in xfs_admin
> and xfs_ncheck.  This is implemented by a new -C option to xfs_db
> which makes it exit with a useful error message in case the filesystem
> doesn't match the XFS superblock magic number.
> 
> 
> Reported-by: Dick Middleton <dick@lingbrae.com>
> Signed-off-by: Christoph Hellwig <hch@lst.de>
...
> Index: xfsprogs-dev/man/man8/xfs_db.8
> ===================================================================
> --- xfsprogs-dev.orig/man/man8/xfs_db.8	2009-01-24 19:15:16.855428751 +0100
> +++ xfsprogs-dev/man/man8/xfs_db.8	2009-01-24 19:17:21.689554003 +0100
...
> @@ -32,6 +34,10 @@ that run
>  .PP
>  .SH OPTIONS
>  .TP
> +.B \-C
> +Check the superblock magic number and exit gracefully if the filesystem is not
> +an XFS filesystem.

Obviously, the 'C' is supposed to stand for "check". I think that's
misleading. xfs_db _always_ checks the SB magic. This option just changes
the the behavior on a mis-match. In a way, I think this flag belongs into
the "verbose/quiet" category. It really is
--you-really-want-to-work-with-xfs-volumes-only...I guess it's a don't-force
flag.

I can't think of a good letter for it at the moment.

Josef 'Jeff' Sipek.

-- 
Hegh QaQ law'
quvHa'ghach QaQ puS

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
