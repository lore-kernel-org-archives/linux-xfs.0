Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 0666F7F3F
	for <xfs@oss.sgi.com>; Thu, 11 Apr 2013 10:28:33 -0500 (CDT)
Message-ID: <5166D6BE.4050907@sgi.com>
Date: Thu, 11 Apr 2013 10:29:02 -0500
From: Rich Johnston <rjohnston@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH] xfstests: make install support common/ and tests/ dirs
References: <5166BA24.1060809@gmail.com>
In-Reply-To: <5166BA24.1060809@gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Wang Sheng-Hui <shhuiw@gmail.com>
Cc: xfstests <xfs@oss.sgi.com>, Dave Chinner <dchinner@redhat.com>

Wang Sheng-Hui,

The patch to Makefile would not apply.  This is what I used to review.

diff --git a/Makefile b/Makefile
index 6edd55c..73214ab 100644
--- a/Makefile
+++ b/Makefile
@@ -52,12 +52,15 @@ LDIRT += $(SRCTAR)
  endif

  LIB_SUBDIRS = include lib
-TOOL_SUBDIRS = ltp src m4
+TOOL_SUBDIRS = ltp src m4 common
  ifeq ($(HAVE_DMAPI), true)
  TOOL_SUBDIRS += dmapi
  endif

-SUBDIRS = $(LIB_SUBDIRS) $(TOOL_SUBDIRS)
+# all the tests have been put into tests/
+TESTS_SUBDIR = tests
+
+SUBDIRS = $(LIB_SUBDIRS) $(TOOL_SUBDIRS) $(TESTS_SUBDIR)

  default: include/builddefs $(DMAPI_MAKEFILE) $(TESTS)
  ifeq ($(HAVE_BUILDDEFS), no)
@@ -91,12 +94,7 @@ depend: include/builddefs $(addsuffix -depend,$(SUBDIRS))
  install: default $(addsuffix -install,$(SUBDIRS))
         $(INSTALL) -m 755 -d $(PKG_LIB_DIR)
         $(INSTALL) -m 755 check $(PKG_LIB_DIR)
-       $(INSTALL) -m 755 [0-9]?? $(PKG_LIB_DIR)
-       $(INSTALL) -m 755 run.* $(PKG_LIB_DIR)
-       $(INSTALL) -m 644 group $(PKG_LIB_DIR)
         $(INSTALL) -m 644 randomize.awk $(PKG_LIB_DIR)
-       $(INSTALL) -m 644 [0-9]??.* $(PKG_LIB_DIR)
-       $(INSTALL) -m 644 common* $(PKG_LIB_DIR)

  # Nothing.
  install-dev install-lib:

Here is your original:

> diff --git a/Makefile b/Makefile
> index 6edd55c..95e3e5d 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -52,12 +52,15 @@ LDIRT += $(SRCTAR)
>   endif
>
>   LIB_SUBDIRS = include lib
> -TOOL_SUBDIRS = ltp src m4
> +TOOL_SUBDIRS = ltp src m4 common
>   ifeq ($(HAVE_DMAPI), true)
>   TOOL_SUBDIRS += dmapi
>   endif
>
> -SUBDIRS = $(LIB_SUBDIRS) $(TOOL_SUBDIRS)
> +# all the tests have been put into tests/
> +TESTS_SUBDIR = tests
> +
> +SUBDIRS = $(LIB_SUBDIRS) $(TOOL_SUBDIRS) $(TESTS_SUBDIR)
>
>   default: include/builddefs $(DMAPI_MAKEFILE) $(TESTS)
>   ifeq ($(HAVE_BUILDDEFS), no)
> @@ -91,12 +94,8 @@ depend: include/builddefs $(addsuffix
> -depend,$(SUBDIRS))
>   install: default $(addsuffix -install,$(SUBDIRS))
>       $(INSTALL) -m 755 -d $(PKG_LIB_DIR)
>       $(INSTALL) -m 755 check $(PKG_LIB_DIR)
> -    $(INSTALL) -m 755 [0-9]?? $(PKG_LIB_DIR)
> -    $(INSTALL) -m 755 run.* $(PKG_LIB_DIR)
>       $(INSTALL) -m 644 group $(PKG_LIB_DIR)
oops somehow the above line was not deleted
>       $(INSTALL) -m 644 randomize.awk $(PKG_LIB_DIR)
> -    $(INSTALL) -m 644 [0-9]??.* $(PKG_LIB_DIR)
> -    $(INSTALL) -m 644 common* $(PKG_LIB_DIR)
>
>   # Nothing.
>   install-dev install-lib:

The rest of the patch looked good.  If you agree with my slight mod then 
I will put my Reviewed-by and commit it.

Thanks
--Rich

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
