Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id CDEC929E03
	for <xfs@oss.sgi.com>; Mon, 15 Apr 2013 08:00:24 -0500 (CDT)
Message-ID: <516BFA10.6020102@sgi.com>
Date: Mon, 15 Apr 2013 08:01:04 -0500
From: Rich Johnston <rjohnston@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH v3] xfstests: make install support common/ and tests/ dirs
References: <516937F9.1020101@gmail.com>
In-Reply-To: <516937F9.1020101@gmail.com>
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

On 04/13/2013 05:48 AM, Wang Sheng-Hui wrote:

> diff --git a/Makefile b/Makefile
> index 6edd55c..611b36d 100644
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
> +TESTS_DIR = tests
> +export TESTS_DIR
> +
> +SUBDIRS = $(LIB_SUBDIRS) $(TOOL_SUBDIRS) $(TESTS_DIR)
>
>   default: include/builddefs $(DMAPI_MAKEFILE) $(TESTS)
>   ifeq ($(HAVE_BUILDDEFS), no)
> @@ -91,12 +94,7 @@ depend: include/builddefs $(addsuffix
> -depend,$(SUBDIRS))
>   install: default $(addsuffix -install,$(SUBDIRS))
>       $(INSTALL) -m 755 -d $(PKG_LIB_DIR)
>       $(INSTALL) -m 755 check $(PKG_LIB_DIR)
> -    $(INSTALL) -m 755 [0-9]?? $(PKG_LIB_DIR)
> -    $(INSTALL) -m 755 run.* $(PKG_LIB_DIR)
> -    $(INSTALL) -m 644 group $(PKG_LIB_DIR)
>       $(INSTALL) -m 644 randomize.awk $(PKG_LIB_DIR)
> -    $(INSTALL) -m 644 [0-9]??.* $(PKG_LIB_DIR)
> -    $(INSTALL) -m 644 common* $(PKG_LIB_DIR)
>
>   # Nothing.
>   install-dev install-lib:


Not sure why Makefile above would not apply. I did the following:

git reset --hard 2bfce6d3 # Revert to commit before v2 of this patch.

Attemted to apply patch

Applying patch v3-xfstests-make-install-support-common-and-tests-dirs.patch
patching file Makefile
Hunk #1 FAILED at 52.
Hunk #2 FAILED at 94.
2 out of 2 hunks FAILED -- rejects in file Makefile

So I replaced your Makefile patch with

  > diff --git a/Makefile b/Makefile
> index 6edd55c..b01491e 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -52,12 +52,14 @@ LDIRT += $(SRCTAR)
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
> +TESTS_DIR = tests
> +export TESTS_DIR
> +SUBDIRS = $(LIB_SUBDIRS) $(TOOL_SUBDIRS) $(TESTS_DIR)
>
>  default: include/builddefs $(DMAPI_MAKEFILE) $(TESTS)
>  ifeq ($(HAVE_BUILDDEFS), no)
> @@ -91,12 +93,7 @@ depend: include/builddefs $(addsuffix -depend,$(SUBDIRS))
>  install: default $(addsuffix -install,$(SUBDIRS))
>  	$(INSTALL) -m 755 -d $(PKG_LIB_DIR)
>  	$(INSTALL) -m 755 check $(PKG_LIB_DIR)
> -	$(INSTALL) -m 755 [0-9]?? $(PKG_LIB_DIR)
> -	$(INSTALL) -m 755 run.* $(PKG_LIB_DIR)
> -	$(INSTALL) -m 644 group $(PKG_LIB_DIR)
>  	$(INSTALL) -m 644 randomize.awk $(PKG_LIB_DIR)
> -	$(INSTALL) -m 644 [0-9]??.* $(PKG_LIB_DIR)
> -	$(INSTALL) -m 644 common* $(PKG_LIB_DIR)
>
>  # Nothing.
>  install-dev install-lib:

Will revert v2 (git revert 2519a97d) and commit with this minor change 
is Dave agrees to your latest version.

Thanks
--Rich


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
