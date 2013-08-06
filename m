Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id C17F87F37
	for <xfs@oss.sgi.com>; Tue,  6 Aug 2013 15:42:33 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id AEBDE8F80A3
	for <xfs@oss.sgi.com>; Tue,  6 Aug 2013 13:42:30 -0700 (PDT)
Received: from dkim2.fusionio.com (dkim2.fusionio.com [66.114.96.54]) by
	cuda.sgi.com with ESMTP id BLe4cRsqD68wx6Ca (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 06 Aug 2013 13:42:28 -0700 (PDT)
Received: from mx2.fusionio.com (unknown [10.101.1.160])
	by dkim2.fusionio.com (Postfix) with ESMTP id 6A0459A06A2
	for <xfs@oss.sgi.com>; Tue,  6 Aug 2013 14:42:27 -0600 (MDT)
Date: Tue, 6 Aug 2013 16:42:25 -0400
From: Josef Bacik <jbacik@fusionio.com>
Subject: Re: [PATCH v2 1/2] xfstests: add fssum tool
Message-ID: <20130806204225.GA2397@localhost.localdomain>
References: <1374678449-21780-1-git-send-email-list.xfs@jan-o-sch.net>
	<1374678449-21780-2-git-send-email-list.xfs@jan-o-sch.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1374678449-21780-2-git-send-email-list.xfs@jan-o-sch.net>
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
Cc: sbehrens@giantdisaster.de, linux-btrfs@vger.kernel.org, xfs@oss.sgi.com

On Wed, Jul 24, 2013 at 05:07:28PM +0200, Jan Schmidt wrote:
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
> +
>  export PS_ALL_FLAGS="-ef"
>  
>  export DF_PROG="`set_prog_path df`"
> diff --git a/src/Makefile b/src/Makefile
> index cc679e8..a840669 100644
> --- a/src/Makefile
> +++ b/src/Makefile
> @@ -20,10 +20,14 @@ LINUX_TARGETS = xfsctl bstat t_mtab getdevicesize preallo_rw_pattern_reader \
>  	stale_handle pwrite_mmap_blocked t_dir_offset2 seek_sanity_test \
>  	seek_copy_test t_readdir_1 t_readdir_2 fsync-tester
>  
> +OPT_TARGETS = fssum
> +
>  SUBDIRS =
>  
>  LLDLIBS = $(LIBATTR) $(LIBHANDLE) $(LIBACL)
>  
> +OPT_LDLIBS = -lssl
> +

I had to add -lcrypto here for this to build, and I checked my copy of far-progs
and it looks like I'm not just crazy that you guys actually do -lcrypto in
far-progs as well, so looks like you missed it.  Thanks,

Josef

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
