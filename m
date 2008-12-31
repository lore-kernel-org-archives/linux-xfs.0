Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mBV1xEKg020134 for <xfs@oss.sgi.com>; Tue, 30 Dec 2008 19:59:14 -0600
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 4E1FD54112
	for <xfs@oss.sgi.com>; Tue, 30 Dec 2008 17:59:13 -0800 (PST)
Received: from mail.sandeen.net (sandeen.net [209.173.210.139]) by
	cuda.sgi.com with ESMTP id bMhTmdrF3ugEI7Fc for
	<xfs@oss.sgi.com>; Tue, 30 Dec 2008 17:59:13 -0800 (PST)
Message-ID: <495AD1EF.3080109@sandeen.net>
Date: Tue, 30 Dec 2008 19:59:11 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH 1/5] xfstests: fix compiler warnings
References: <20081230230810.986105000@bombadil.infradead.org>
	<20081230230912.986540000@bombadil.infradead.org>
In-Reply-To: <20081230230912.986540000@bombadil.infradead.org>
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

(hmm we need to teach quilt not to do attachments...)

...

> Index: xfstests/src/looptest.c
> ===================================================================
> --- xfstests/src/looptest.c	2008-12-30 14:51:21.000000000 +0000
> +++ xfstests/src/looptest.c	2008-12-30 14:51:31.000000000 +0000
> @@ -28,8 +28,6 @@
>   
>  /* dxm - 28/2/2 */
>  
> -#define _GNU_SOURCE
> -
>  #include <stdio.h>
>  #include <stdlib.h>
>  #include <malloc.h>

...

Just in case this gets transplanted outside xfstests, where _GNU_SOURCE
may not be defined on the make commandline, would it make sense to just
put this #define inside

#ifndef _GNU_SOURCE?

Just a thought; otherwise looks good to me.

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
