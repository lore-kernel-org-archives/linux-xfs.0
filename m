Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with SMTP id
	p2AHQqTR113706 for <xfs@oss.sgi.com>; Thu, 10 Mar 2011 11:27:02 -0600
Date: Thu, 10 Mar 2011 12:29:43 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfstests: rework "dmapi" subtree build mechanism
Message-ID: <20110310172943.GD13390@infradead.org>
References: <201103041937.p24Jbk5W004828@stout.americas.sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <201103041937.p24Jbk5W004828@stout.americas.sgi.com>
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
To: Alex Elder <aelder@sgi.com>
Cc: xfs@oss.sgi.com

>  LIB_SUBDIRS = include lib
>  TOOL_SUBDIRS = ltp src m4
> +ifeq ($(HAVE_DMAPI), true)
> +TOOL_SUBDIRS += dmapi
> +endif

Does this work with the way we generate source tarballs on make dist?
In xfsprogs we have special variables for source files that don't get
build.

> @@ -0,0 +1,30 @@
> +#
> +# Copyright (c) 2011 SGI  All Rights Reserved.
> +#

I think a license would be more useful than all rights reserved here.

Except for that the patch looks sane to me, and having a consistent
build system is a good thing.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
