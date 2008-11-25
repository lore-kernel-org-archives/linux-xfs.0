Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mAPG2GGT020206 for <xfs@oss.sgi.com>; Tue, 25 Nov 2008 10:02:16 -0600
Received: from mx2.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 129481B8A075
	for <xfs@oss.sgi.com>; Tue, 25 Nov 2008 08:02:15 -0800 (PST)
Received: from mx2.redhat.com (mx2.redhat.com [66.187.237.31]) by cuda.sgi.com
	with ESMTP id cdgkFjOhKN6X32wC for <xfs@oss.sgi.com>;
	Tue, 25 Nov 2008 08:02:15 -0800 (PST)
Message-ID: <492C213D.6090401@sandeen.net>
Date: Tue, 25 Nov 2008 10:01:01 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH] xfsdump: don't redeclare offsetoff
References: <20081125105519.GA21288@infradead.org>
In-Reply-To: <20081125105519.GA21288@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

Christoph Hellwig wrote:
> Don't redeclare offsetof, we already include <stddef.h> to get it and
> modern gcc will complain about the redeclaration.
> 
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> 
> Index: xfs-cmds/xfsdump/common/getdents.c
> ===================================================================
> --- xfs-cmds.orig/xfsdump/common/getdents.c	2008-11-13 18:45:11.000000000 +0100
> +++ xfs-cmds/xfsdump/common/getdents.c	2008-11-13 18:45:18.000000000 +0100
> @@ -72,8 +72,6 @@ extern int __have_no_getdents64;
>  # endif
>  #endif
>  
> -#define offsetof(TYPE, MEMBER) ((size_t) &((TYPE *)0)->MEMBER)
> -

ACK.  I'd noticed this too, thanks.

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
