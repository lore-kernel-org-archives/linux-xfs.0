Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:44956 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751631AbdG1LT2 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 28 Jul 2017 07:19:28 -0400
Date: Fri, 28 Jul 2017 19:19:26 +0800
From: Eryu Guan <eguan@redhat.com>
Subject: Re: [PATCH v2 13/15] common: remove IRIX-specific code
Message-ID: <20170728111926.GE9167@eguan.usersys.redhat.com>
References: <20170721043853.364-1-ebiggers3@gmail.com>
 <20170721043853.364-14-ebiggers3@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170721043853.364-14-ebiggers3@gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Biggers <ebiggers3@gmail.com>
Cc: fstests@vger.kernel.org, linux-xfs@vger.kernel.org, Eric Biggers <ebiggers@google.com>

On Thu, Jul 20, 2017 at 09:38:51PM -0700, Eric Biggers wrote:
> From: Eric Biggers <ebiggers@google.com>
> 
> As xfstests is no longer supported on IRIX, remove IRIX-specific code
> from the common helper scripts.
> 
> Signed-off-by: Eric Biggers <ebiggers@google.com>
> ---
>  common/config      | 12 ------------
>  common/dump        | 39 +++------------------------------------
>  common/filestreams | 43 ++++++-------------------------------------
>  common/log         |  1 -
>  common/rc          | 23 +++--------------------
>  5 files changed, 12 insertions(+), 106 deletions(-)
> 
> diff --git a/common/config b/common/config
> index 5091db9d..80598d06 100644
> --- a/common/config
> +++ b/common/config
> @@ -52,15 +52,10 @@
>  export LANG=C
>  export LC_ALL=C
>  
> -# Warning: don't put freeware before /usr/bsd on IRIX coz you'll
> -#  get the wrong hostname and set your system name to -s  :)
> -[ -d /usr/bsd ] && PATH=$PATH:/usr/bsd
> -[ -d /usr/freeware/bin ] && PATH=$PATH:/usr/freeware/bin
>  PATH=".:$PATH"
>  
>  export HOST=`hostname -s`
>  export HOSTOS=`uname -s`
> -[ "$HOSTOS" = "IRIX64" ] && export HOSTOS="IRIX"
>  
>  export MODULAR=0               # using XFS as a module or not
>  export BOOT="/boot"            # install target for kernels
> @@ -220,13 +215,6 @@ fi
>  export UDEV_SETTLE_PROG
>  
>  case "$HOSTOS" in
> -    IRIX*)
> -        export MKFS_XFS_PROG="`set_prog_path mkfs_xfs`"
> -        export MKFS_UDF_PROG="`set_prog_path mkfs_udf`"
> -        export XFS_FSR_PROG="`set_prog_path /usr/etc/fsr_xfs`"
> -        export MKFS_NFS_PROG="false"
> -        export MKFS_CIFS_PROG="false"
> -        ;;
>      Linux)
>          export MKFS_XFS_PROG="`set_prog_path mkfs.xfs`"
>          export MKFS_EXT4_PROG="`set_prog_path mkfs.ext4`"
> diff --git a/common/dump b/common/dump
> index d6663e0c..b0e4a12f 100644
> --- a/common/dump
> +++ b/common/dump
> @@ -395,8 +395,6 @@ End-of-File
>  
>  _mk_fillconfig_perm()
>  {
> -    # dir_guid: ugo=rwx,g+s on dir is for IRIX chmod(1)
> -
>      cat <<End-of-File >$tmp.config
>  # pathname	size/dir  user group mode
>  #
> @@ -406,7 +404,7 @@ file_sticky	10	$nobody	$nobody	01777
>  file_mix1	10	$nobody	$nobody	761
>  file_mix2	10	$nobody	$nobody	642
>  dir_suid	d	$nobody	$nobody	04777
> -dir_guid	d	$nobody	$nobody	ugo=rwx,g+s
> +dir_guid	d	$nobody	$nobody	02777
>  dir_sticky	d	$nobody	$nobody	01777
>  dir_mix1	d	$nobody	$nobody	761
>  dir_mix2	d	$nobody	$nobody	642
> @@ -798,25 +796,6 @@ _ls_filter()
>    | sed -e 's/total [0-9][0-9]*/total TOTAL/'
>  }
>  
> -#
> -# Filtering of Irix character hwgraph device names
> -# e.g.
> -# chardev: /hw/node/xtalk/15/pci/0/scsi_ctlr/0/target/1/lun/0/disk/partition/4/char
> -# blkdev:  /dev/dsk/dks0d1s4
> -#
> -_filter_devchar()
> -{
> -    $AWK_PROG '
> -	/\/hw\/node/ {
> -	    sub(/\/hw.*scsi_ctlr\//,"/dev/dsk/dks")  # blah blah /dev/dsk/dks0/target/1/....
> -	    sub(/\/target\//,"d")                    # blah blah /dev/dsk/dks0d1/lun/0/disk.....
> -	    sub(/\/lun.*partition\//,"s")            # blah blah /dev/dsk/dks0d1s4/char
> -	    sub(/\/char/,"")			     # blah blah /dev/dsk/dks0d1s4
> -	}
> -	{ print }
> -    '
> -}
> -
>  
>  #
>  # Filter out the non-deterministic dump msgs from
> @@ -824,7 +803,6 @@ _filter_devchar()
>  #
>  _dump_filter_main()
>  {
> -  _filter_devchar |\

I added this _filter_devchar function back as xfs/061 needs it,
otherwise it fails like:

 -xfsrestore: volume: /dev/dsk/dks0d2s1
 +xfsrestore: volume: /hw/node/io/gio/hpc/scsi_ctlr/0/target/2/lun/0/disk/partition/1/char

I think this is the safest and easiest thing to do at this moment.

Thanks,
Eryu
