Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id E40947F37
	for <xfs@oss.sgi.com>; Thu,  8 Aug 2013 12:40:58 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id BD74F304053
	for <xfs@oss.sgi.com>; Thu,  8 Aug 2013 10:40:58 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id gvjTEQaddhHrDHZt for <xfs@oss.sgi.com>;
	Thu, 08 Aug 2013 10:40:57 -0700 (PDT)
Message-ID: <5203D827.3050909@sandeen.net>
Date: Thu, 08 Aug 2013 12:40:55 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH v3 1/2] xfstests: add fssum tool
References: <1375949833-1104-1-git-send-email-list.xfs@jan-o-sch.net>
	<1375949833-1104-2-git-send-email-list.xfs@jan-o-sch.net>
In-Reply-To: <1375949833-1104-2-git-send-email-list.xfs@jan-o-sch.net>
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
To: Jan Schmidt <list.xfs@jan-o-sch.net>
Cc: linux-btrfs@vger.kernel.org, sbehrens@giantdisaster.de, xfs@oss.sgi.com

On 8/8/13 3:17 AM, Jan Schmidt wrote:
> fssum is a tool to build a recursive checksum for a file system. The home
> repository of fssum is
> 
>     git://git.kernel.org/pub/scm/linux/kernel/git/arne/far-progs.git
> 
> It is added as an optional target, because it depends on glibc >= 2.15 for
> SEEK_HOLE / SEEK_DATA. The test to be added using fssum will just be skipped
> if fssum wasn't built.
> 
> Signed-off-by: Jan Schmidt <list.xfs@jan-o-sch.net>
> ---
>  .gitignore    |    1 +
>  common/config |    2 +
>  src/Makefile  |   11 +-
>  src/fssum.c   |  819 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++
>  4 files changed, 832 insertions(+), 1 deletions(-)
>  create mode 100644 src/fssum.c
> 
> diff --git a/.gitignore b/.gitignore
> index 11594aa..c2fc6e3 100644
> --- a/.gitignore
> +++ b/.gitignore
> @@ -45,6 +45,7 @@
>  /src/fill
>  /src/fill2
>  /src/fs_perms
> +/src/fssum
>  /src/fstest
>  /src/fsync-tester
>  /src/ftrunc
> diff --git a/common/config b/common/config
> index 67c1498..c8bee29 100644
> --- a/common/config
> +++ b/common/config
> @@ -146,6 +146,8 @@ export SED_PROG="`set_prog_path sed`"
>  export BC_PROG="`set_prog_path bc`"
>  [ "$BC_PROG" = "" ] && _fatal "bc not found"
>  
> +export FSSUM_PROG="`set_prog_path fssum $here/src/fssum`"

So this will pick up a local copy of fssum if it exists;
is that really desired?  (If there's any difference in
behavior, then the one in src/ presumably would need to
be fixed...)

> +
>  export PS_ALL_FLAGS="-ef"
>  
>  export DF_PROG="`set_prog_path df`"
> diff --git a/src/Makefile b/src/Makefile
> index cc679e8..10a4d3c 100644
> --- a/src/Makefile
> +++ b/src/Makefile
> @@ -20,10 +20,14 @@ LINUX_TARGETS = xfsctl bstat t_mtab getdevicesize preallo_rw_pattern_reader \
>  	stale_handle pwrite_mmap_blocked t_dir_offset2 seek_sanity_test \
>  	seek_copy_test t_readdir_1 t_readdir_2 fsync-tester
>  
> +OPT_TARGETS = fssum
> +

I'm not sure how this helps . . .

>  SUBDIRS =
>  
>  LLDLIBS = $(LIBATTR) $(LIBHANDLE) $(LIBACL)
>  
> +OPT_LDLIBS = -lssl -lcrypto

Hm, new deps.  I guess it's not a huge problem, these should always
be available, right?

>  ifeq ($(HAVE_XLOG_ASSIGN_LSN), true)
>  LINUX_TARGETS += loggen
>  endif
> @@ -60,7 +64,7 @@ CFILES = $(TARGETS:=.c)
>  LDIRT = $(TARGETS)
>  
>  
> -default: depend $(TARGETS) $(SUBDIRS)
> +default: depend $(TARGETS) $(OPT_TARGETS) $(SUBDIRS)

Anyway, OPT_TARGETS isn't optional, because you still build it by default.  :)

>  depend: .dep
>  
> @@ -70,11 +74,16 @@ $(TARGETS): $(LIBTEST)
>  	@echo "    [CC]    $@"
>  	$(Q)$(LTLINK) $@.c -o $@ $(CFLAGS) $(LDFLAGS) $(LDLIBS) $(LIBTEST)
>  
> +$(OPT_TARGETS): $(LIBTEST)
> +	@echo "    [CC]    $@"
> +	-$(Q)$(LTLINK) $@.c -o $@ $(CFLAGS) $(LDFLAGS) $(LDLIBS) $(OPT_LDLIBS) $(LIBTEST)

Oh, I see, you ignore the error.  Well, that's still pretty ugly.
I'd really rather you just add the #defines as I suggested in my
reply to [PATCH 0/2], so it'll build for everyone.

Thanks,
-Eric

> +
>  LINKTEST = $(LTLINK) $@.c -o $@ $(CFLAGS) $(LDFLAGS)
>  
>  install: default $(addsuffix -install,$(SUBDIRS))
>  	$(INSTALL) -m 755 -d $(PKG_LIB_DIR)/src
>  	$(LTINSTALL) -m 755 $(TARGETS) $(PKG_LIB_DIR)/src
> +	-$(LTINSTALL) -m 755 $(OPT_TARGETS) $(PKG_LIB_DIR)/src
>  	$(LTINSTALL) -m 755 fill2attr fill2fs fill2fs_check scaleread.sh $(PKG_LIB_DIR)/src
>  	$(LTINSTALL) -m 644 dumpfile $(PKG_LIB_DIR)/src
>  

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
