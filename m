Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:50408 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750974AbdJZGnP (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 26 Oct 2017 02:43:15 -0400
Date: Thu, 26 Oct 2017 14:43:13 +0800
From: Eryu Guan <eguan@redhat.com>
Subject: Re: [PATCH 5/6] misc: add module reloading helpers
Message-ID: <20171026064313.GJ3235@eguan.usersys.redhat.com>
References: <150899709935.18389.17266737014565285073.stgit@magnolia>
 <150899712429.18389.5159489339127196469.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <150899712429.18389.5159489339127196469.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org, fstests@vger.kernel.org

On Wed, Oct 25, 2017 at 10:52:04PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Add some helper functions to require that we can reload a given module,
> and add a helper to actually do that.  Refactor the existing users to
> use the generics.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  common/btrfs    |   12 ------------
>  common/rc       |   15 +++++++++++++++
>  tests/btrfs/124 |    9 +++------
>  tests/btrfs/125 |    9 +++------
>  4 files changed, 21 insertions(+), 24 deletions(-)
> 
> 
> diff --git a/common/btrfs b/common/btrfs
> index fd762ef..c09206c 100644
> --- a/common/btrfs
> +++ b/common/btrfs
> @@ -349,18 +349,6 @@ _btrfs_qgroup_units()
>  	$BTRFS_UTIL_PROG qgroup show --help 2>&1 | grep -q -- --raw && echo "--raw"
>  }
>  
> -_require_btrfs_loadable()
> -{
> -	modprobe -r btrfs || _notrun "btrfs unloadable"
> -	modprobe btrfs || _notrun "Can't load btrfs"
> -}
> -
> -_reload_btrfs_ko()
> -{
> -	modprobe -r btrfs || _fail "btrfs unload failed"
> -	modprobe btrfs || _fail "btrfs load failed"
> -}
> -
>  _btrfs_compression_algos()
>  {
>  	echo zlib
> diff --git a/common/rc b/common/rc
> index 83aaced..5375f7b 100644
> --- a/common/rc
> +++ b/common/rc
> @@ -3580,6 +3580,21 @@ _require_scratch_feature()
>  	esac
>  }
>  
> +# Check that we have a module that can be loaded.
> +_require_loadable_module()
> +{
> +	module="$1"
> +	modinfo "$module" > /dev/null 2>&1 || _notrun "${module}: must be a module."

I think we should try to unload the given module too to see if we really
could unload it, otherwise a later _reload_module() still fails if
rootfs is mounted as $module type, even if we already umounted TEST_DEV
and SCRATCH_DEV.

> +}
> +
> +# Reload a particular module.
> +_reload_module()
> +{
> +	module="$1"
> +
> +	modprobe -r "${module}" || _fail "${module} unload failed"
> +	modprobe "${module}" || _fail "${module} load failed"
> +}
>  
>  init_rc
>  
> diff --git a/tests/btrfs/124 b/tests/btrfs/124
> index 7206094..1b6cb24 100755
> --- a/tests/btrfs/124
> +++ b/tests/btrfs/124
> @@ -64,10 +64,7 @@ rm -f $seqres.full
>  _supported_fs btrfs
>  _supported_os Linux
>  _require_scratch_dev_pool 2
> -
> -# the mounted test dir prevent btrfs unload, we need to unmount
> -_test_unmount
> -_require_btrfs_loadable
> +_require_loadable_module "btrfs"

Then keep the above comments and _test_unmount?

Thanks,
Eryu

>  
>  _scratch_dev_pool_get 2
>  
> @@ -102,7 +99,7 @@ echo "clean btrfs ko" >> $seqres.full
>  _scratch_unmount
>  
>  # un-scan the btrfs devices
> -_reload_btrfs_ko
> +_reload_module "btrfs"
>  
>  echo >> $seqres.full
>  echo "-----Write degraded mount fill upto $max_fs_sz bytes-----" >> $seqres.full
> @@ -141,7 +138,7 @@ echo
>  echo "Mount degraded with the other dev"
>  _scratch_unmount
>  # un-scan the btrfs devices
> -_reload_btrfs_ko
> +_reload_module "btrfs"
>  _mount -o degraded $dev2 $SCRATCH_MNT >>$seqres.full 2>&1
>  _run_btrfs_util_prog filesystem show
>  checkpoint3=`md5sum $SCRATCH_MNT/tf2`
> diff --git a/tests/btrfs/125 b/tests/btrfs/125
> index 91aa8d8..dbb226c 100755
> --- a/tests/btrfs/125
> +++ b/tests/btrfs/125
> @@ -63,10 +63,7 @@ rm -f $seqres.full
>  _supported_fs btrfs
>  _supported_os Linux
>  _require_scratch_dev_pool 3
> -
> -# we need btrfs to unload, need test dir unmounted
> -_test_unmount
> -_require_btrfs_loadable
> +_require_loadable_module "btrfs"
>  
>  _scratch_dev_pool_get 3
>  
> @@ -118,7 +115,7 @@ echo "unmount" >> $seqres.full
>  _scratch_unmount
>  echo "clean btrfs ko" >> $seqres.full
>  # un-scan the btrfs devices
> -_reload_btrfs_ko
> +_reload_module "btrfs"
>  _mount -o degraded,device=$dev2 $dev1 $SCRATCH_MNT >>$seqres.full 2>&1
>  dd if=/dev/zero of="$SCRATCH_MNT"/tf2 bs=$bs count=$count \
>  					>>$seqres.full 2>&1
> @@ -154,7 +151,7 @@ echo "Mount degraded but with other dev"
>  
>  _scratch_unmount
>  # un-scan the btrfs devices
> -_reload_btrfs_ko
> +_reload_module "btrfs"
>  
>  _mount -o degraded,device=${dev2} $dev3 $SCRATCH_MNT >>$seqres.full 2>&1
>  
> 
