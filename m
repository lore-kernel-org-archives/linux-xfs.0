Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 024B67F37
	for <xfs@oss.sgi.com>; Thu, 11 Apr 2013 19:41:37 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 99020AC003
	for <xfs@oss.sgi.com>; Thu, 11 Apr 2013 17:41:33 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	9QWHs2QebdmBg5SW for <xfs@oss.sgi.com>;
	Thu, 11 Apr 2013 17:41:32 -0700 (PDT)
Date: Fri, 12 Apr 2013 10:41:30 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfstests: make install support common/ and tests/ dirs
Message-ID: <20130412004130.GD31207@dastard>
References: <5166BA24.1060809@gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <5166BA24.1060809@gmail.com>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Wang Sheng-Hui <shhuiw@gmail.com>
Cc: xfstests <xfs@oss.sgi.com>, Dave Chinner <dchinner@redhat.com>

On Thu, Apr 11, 2013 at 09:27:00PM +0800, Wang Sheng-Hui wrote:
> xfstests have some change on the organization of the testcases
> and common* files:
>     * The common* scripts have been reorganized into the common/ dir.
>     * The testcases have been reorganized into sub test dirs under tests/.
>     * The run.* scripts have been removed.
> 
> This patch uses the simple way to make install support above changes:
>     Make up one Makefile for each newly created subdirs, which can control
>     'make install' separately.

Thanks for doing this!

Comments below.

> Signed-off-by: Wang Sheng-Hui <shhuiw@gmail.com>
> ---
>  Makefile               | 11 +++++------
>  common/Makefile        | 17 +++++++++++++++++
>  tests/Makefile         | 23 +++++++++++++++++++++++
>  tests/btrfs/Makefile   | 21 +++++++++++++++++++++
>  tests/ext4/Makefile    | 21 +++++++++++++++++++++
>  tests/generic/Makefile | 21 +++++++++++++++++++++
>  tests/shared/Makefile  | 21 +++++++++++++++++++++
>  tests/udf/Makefile     | 21 +++++++++++++++++++++
>  tests/xfs/Makefile     | 21 +++++++++++++++++++++
>  9 files changed, 171 insertions(+), 6 deletions(-)
>  create mode 100644 common/Makefile
>  create mode 100644 tests/Makefile
>  create mode 100644 tests/btrfs/Makefile
>  create mode 100644 tests/ext4/Makefile
>  create mode 100644 tests/generic/Makefile
>  create mode 100644 tests/shared/Makefile
>  create mode 100644 tests/udf/Makefile
>  create mode 100644 tests/xfs/Makefile
> 
> diff --git a/Makefile b/Makefile
> index 6edd55c..95e3e5d 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -52,12 +52,15 @@ LDIRT += $(SRCTAR)
>  endif
> 
>  LIB_SUBDIRS = include lib
> -TOOL_SUBDIRS = ltp src m4
> +TOOL_SUBDIRS = ltp src m4 common
>  ifeq ($(HAVE_DMAPI), true)
>  TOOL_SUBDIRS += dmapi
>  endif
> 
> -SUBDIRS = $(LIB_SUBDIRS) $(TOOL_SUBDIRS)
> +# all the tests have been put into tests/
> +TESTS_SUBDIR = tests

No need for the comment - it's redundant....

> +SUBDIRS = $(LIB_SUBDIRS) $(TOOL_SUBDIRS) $(TESTS_SUBDIR)
> 
>  default: include/builddefs $(DMAPI_MAKEFILE) $(TESTS)
>  ifeq ($(HAVE_BUILDDEFS), no)
> @@ -91,12 +94,8 @@ depend: include/builddefs $(addsuffix -depend,$(SUBDIRS))
>  install: default $(addsuffix -install,$(SUBDIRS))
>  	$(INSTALL) -m 755 -d $(PKG_LIB_DIR)
>  	$(INSTALL) -m 755 check $(PKG_LIB_DIR)
> -	$(INSTALL) -m 755 [0-9]?? $(PKG_LIB_DIR)
> -	$(INSTALL) -m 755 run.* $(PKG_LIB_DIR)
>  	$(INSTALL) -m 644 group $(PKG_LIB_DIR)
>  	$(INSTALL) -m 644 randomize.awk $(PKG_LIB_DIR)
> -	$(INSTALL) -m 644 [0-9]??.* $(PKG_LIB_DIR)
> -	$(INSTALL) -m 644 common* $(PKG_LIB_DIR)
> 
>  # Nothing.
>  install-dev install-lib:
> diff --git a/common/Makefile b/common/Makefile
> new file mode 100644
> index 0000000..649f55f
> --- /dev/null
> +++ b/common/Makefile
> @@ -0,0 +1,17 @@
> +#
> +# Copyright (c) 2003-2006 Silicon Graphics, Inc.  All Rights Reserved.
> +#
> +
> +TOPDIR = ..
> +include $(TOPDIR)/include/builddefs
> +
> +# current ../common dir
> +COMMON_SUBDIR = common

Same, the comment is redundant. Also, it's not a subdir, so:

COMMON_DIR = common

The same changes for all the other makefiles, too.

> +
> +include $(BUILDRULES)
> +
> +install:
> +	$(INSTALL) -m 755 -d $(PKG_LIB_DIR)/$(COMMON_SUBDIR)
> +	$(INSTALL) -m 644 * $(PKG_LIB_DIR)/$(COMMON_SUBDIR)
> +
> +install-dev install-lib:
> diff --git a/tests/Makefile b/tests/Makefile
> new file mode 100644
> index 0000000..50e6bb3
> --- /dev/null
> +++ b/tests/Makefile
> @@ -0,0 +1,23 @@
> +#
> +# Copyright (c) 2003-2005 Silicon Graphics, Inc.  All Rights Reserved.
> +#
> +
> +TOPDIR = ..
> +include $(TOPDIR)/include/builddefs
> +
> +# current ../tests dir
> +TESTS_SUBDIR = tests
> +export TESTS_SUBDIR

Why export that here? why not in the top level makefile?


> +
> +TESTS_SUBDIRS = btrfs ext4 generic shared udf xfs

TESTS_SUBDIR/TESTS_SUBDIRS are way too similar. TESTS_DIR and
TESTS_SUBDIRS are fine, this I don't think you need to specify

Indeed, because this is just iterating sub directories, something
like:

TESTS_SUBDIRS = $(dir $(wildcard $(PKG_LIB_DIR)/$(TESTS_DIR)))

means that we don't need to modify the makefile if we add more
directories at a later date. Or if people want to add their own
custom test directories...

Otherwise it looks ok.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
