Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 12 Oct 2008 15:18:19 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m9CMIGrb024995
	for <xfs@oss.sgi.com>; Sun, 12 Oct 2008 15:18:17 -0700
Received: from sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id CBA8C4E82EA
	for <xfs@oss.sgi.com>; Sun, 12 Oct 2008 15:19:53 -0700 (PDT)
Received: from sandeen.net (sandeen.net [209.173.210.139]) by cuda.sgi.com with ESMTP id TurDaTso7glqXbjh for <xfs@oss.sgi.com>; Sun, 12 Oct 2008 15:19:53 -0700 (PDT)
Message-ID: <48F27807.1080702@sandeen.net>
Date: Sun, 12 Oct 2008 17:19:51 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH] fix remount rw with unrecognized options
References: <20081012123044.GA30272@lst.de>
In-Reply-To: <20081012123044.GA30272@lst.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: xfs@oss.sgi.com

Christoph Hellwig wrote:
> When we skip unrecognized options in xfs_fs_remount we should just break
> out of the switch and not return because otherwise we may skip clearing
> the xfs-internal read-only flag.  This will only show up on some
> operations like touch because most read-only checks are done by the VFS
> which things this filesystem is r/w.  Eventually we should replace the
> XFS read-only flag with a helper that always checks the VFS flag to make
> sure they can never get out of sync.
> 
> Bug reported and fix verified by Marcel Beister on #xfs.

Seems reasonable.

I think this is 2.6.27.1 material?

-Eric

> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> 
> Index: linux-2.6-xfs/fs/xfs/linux-2.6/xfs_super.c
> ===================================================================
> --- linux-2.6-xfs.orig/fs/xfs/linux-2.6/xfs_super.c	2008-10-11 00:59:04.000000000 +0200
> +++ linux-2.6-xfs/fs/xfs/linux-2.6/xfs_super.c	2008-10-11 00:59:35.000000000 +0200
> @@ -1218,7 +1218,7 @@ xfs_fs_remount(
>  	"XFS: mount option \"%s\" not supported for remount\n", p);
>  			return -EINVAL;
>  #else
> -			return 0;
> +			break;
>  #endif
>  		}
>  	}
> 
> 
