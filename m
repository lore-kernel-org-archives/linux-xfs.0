Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o0LE07Yi075674 for <xfs@oss.sgi.com>; Thu, 21 Jan 2010 08:00:07 -0600
Content-class: urn:content-classes:message
MIME-Version: 1.0
Subject: RE: [PATCH] xfstests: simplify build of
	preallo_rw_pattern_reader/writer
Date: Thu, 21 Jan 2010 08:00:14 -0600
Message-ID: <1AB9A794DBDDF54A8A81BE2296F7BDFE012A69AA@cf--amer001e--3.americas.sgi.com>
In-Reply-To: <20100121113250.GA3580@infradead.org>
From: "Alex Elder" <aelder@sgi.com>
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

Christoph Hellwig wrote:
> Instead of having complicated build system hacks just create two two-line
> source files defining READ/WRITE and including iopat.c

Kind of a coin toss which is better...   But this is simpler.

> Signed-off-by: Christoph Hellwig <hch@lst.de>

Reviewed-by: Alex Elder <aelder@sgi.com>

> Index: xfstests-dev/src/Makefile
> ===================================================================
> --- xfstests-dev.orig/src/Makefile	2010-01-21 11:24:43.000000000 +0000
> +++ xfstests-dev/src/Makefile	2010-01-21 11:26:09.000000000 +0000
> @@ -51,19 +51,9 @@ LDIRT = $(TARGETS)
> 
>  default: $(TARGETS) $(SUBDIRS)
> 
> -PREALLO_TARGETS = preallo_rw_pattern_reader preallo_rw_pattern_writer
> -
>  include $(BUILDRULES)
> 
> -preallo_rw_pattern_reader:
> -	@echo "    [CC]    $@"
> -	$(Q)$(LTLINK) iopat.c -DREAD -o $@ $(CFLAGS) $(LDFLAGS) $(LDLIBS) $(LIBTEST)
> -
> -preallo_rw_pattern_writer:
> -	@echo "    [CC]    $@"
> -	$(Q)$(LTLINK) iopat.c -DWRITE -o $@ $(CFLAGS) $(LDFLAGS) $(LDLIBS) $(LIBTEST)
> -
> -$(filter-out $(PREALLO_TARGETS), $(TARGETS)): $(LIBTEST)
> +$(TARGETS): $(LIBTEST)
>  	@echo "    [CC]    $@"
>  	$(Q)$(LTLINK) $@.c -o $@ $(CFLAGS) $(LDFLAGS) $(LDLIBS) $(LIBTEST)
> 
> Index: xfstests-dev/src/preallo_rw_pattern_reader.c
> ===================================================================
> --- /dev/null	1970-01-01 00:00:00.000000000 +0000
> +++ xfstests-dev/src/preallo_rw_pattern_reader.c	2010-01-21 11:24:19.000000000 +0000
> @@ -0,0 +1,2 @@
> +#define READ
> +#include "iopat.c"
> Index: xfstests-dev/src/preallo_rw_pattern_writer.c
> ===================================================================
> --- /dev/null	1970-01-01 00:00:00.000000000 +0000
> +++ xfstests-dev/src/preallo_rw_pattern_writer.c	2010-01-21 11:24:30.000000000 +0000
> @@ -0,0 +1,2 @@
> +#define WRITE
> +#include "iopat.c"
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
