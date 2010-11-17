Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oAH9Fipc216260 for <xfs@oss.sgi.com>; Wed, 17 Nov 2010 03:15:46 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 5ECD013C7F3B
	for <xfs@oss.sgi.com>; Wed, 17 Nov 2010 01:17:17 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id eRQ8MTQFu0Hts8gc for
	<xfs@oss.sgi.com>; Wed, 17 Nov 2010 01:17:17 -0800 (PST)
Received: from hch by bombadil.infradead.org with local (Exim 4.72 #1 (Red Hat
	Linux)) id 1PIe8h-0004Wy-Ik
	for xfs@oss.sgi.com; Wed, 17 Nov 2010 09:17:15 +0000
Date: Wed, 17 Nov 2010 04:17:15 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfstests: fix 108 golden output
Message-ID: <20101117091715.GA17317@infradead.org>
References: <20101110125855.GA18357@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20101110125855.GA18357@infradead.org>
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
To: xfs@oss.sgi.com

ping?

On Wed, Nov 10, 2010 at 07:58:55AM -0500, Christoph Hellwig wrote:
> The new common scratch mount filter produces slightly different
> whitespaces than the old home grown filter, so adjust the golden
> output.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> 
> Index: xfstests-dev/108.out
> ===================================================================
> --- xfstests-dev.orig/108.out	2010-11-10 12:53:41.000000000 +0000
> +++ xfstests-dev/108.out	2010-11-10 12:53:48.000000000 +0000
> @@ -33,10 +33,10 @@ projid = 3
>    Mode: (0600/-rw-------)         Uid: (1)  Gid: (2)
>  Disk quotas for User #1 (1)
>  Filesystem   Blocks  Quota  Limit Warn/Time    Mounted on
> -SCRATCH_DEV        48M      0      0  00 [------] SCRATCH_MNT
> +SCRATCH_DEV       48M      0      0  00 [------] SCRATCH_MNT
>  Disk quotas for User #1 (1)
>  Filesystem    Files  Quota  Limit Warn/Time    Mounted on
> -SCRATCH_DEV          3      0      0  00 [------] SCRATCH_MNT
> +SCRATCH_DEV         3      0      0  00 [------] SCRATCH_MNT
>  
>  ### test group accounting
>  
> @@ -65,10 +65,10 @@ projid = 3
>    Mode: (0600/-rw-------)         Uid: (1)  Gid: (2)
>  Disk quotas for Group #2 (2)
>  Filesystem   Blocks  Quota  Limit Warn/Time    Mounted on
> -SCRATCH_DEV        48M      0      0  00 [------] SCRATCH_MNT
> +SCRATCH_DEV       48M      0      0  00 [------] SCRATCH_MNT
>  Disk quotas for Group #2 (2)
>  Filesystem    Files  Quota  Limit Warn/Time    Mounted on
> -SCRATCH_DEV          3      0      0  00 [------] SCRATCH_MNT
> +SCRATCH_DEV         3      0      0  00 [------] SCRATCH_MNT
>  
>  ### create files, setting up ownership (type=p)
>    File: "SCRATCH_MNT/buffer"
> @@ -95,7 +95,7 @@ projid = 3
>    Mode: (0600/-rw-------)         Uid: (1)  Gid: (2)
>  Disk quotas for Project #3 (3)
>  Filesystem   Blocks  Quota  Limit Warn/Time    Mounted on
> -SCRATCH_DEV        48M      0      0  00 [------] SCRATCH_MNT
> +SCRATCH_DEV       48M      0      0  00 [------] SCRATCH_MNT
>  Disk quotas for Project #3 (3)
>  Filesystem    Files  Quota  Limit Warn/Time    Mounted on
> -SCRATCH_DEV          3      0      0  00 [------] SCRATCH_MNT
> +SCRATCH_DEV         3      0      0  00 [------] SCRATCH_MNT
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs
---end quoted text---

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
