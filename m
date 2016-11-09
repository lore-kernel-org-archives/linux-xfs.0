Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:37772 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750792AbcKIIJ1 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 9 Nov 2016 03:09:27 -0500
Date: Wed, 9 Nov 2016 16:09:24 +0800
From: Eryu Guan <eguan@redhat.com>
Subject: Re: [PATCH 8/9] xfs: fuzz every field of every structure
Message-ID: <20161109080924.GT27776@eguan.usersys.redhat.com>
References: <147830503054.1919.4998804611100937975.stgit@birch.djwong.org>
 <147830508036.1919.9626426021774095650.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <147830508036.1919.9626426021774095650.stgit@birch.djwong.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: david@fromorbit.com, linux-xfs@vger.kernel.org, fstests@vger.kernel.org

On Fri, Nov 04, 2016 at 05:18:00PM -0700, Darrick J. Wong wrote:
> Previously, our XFS fuzzing efforts were limited to using the xfs_db
> blocktrash command to scribble garbage all over a block.  This is
> pretty easy to discover; it would be far more interesting if we could
> fuzz individual fields looking for unhandled corner cases.  Since we
> now have an online scrub tool, use it to check for our targeted
> corruptions prior to the usual steps of writing to the FS, taking it
> offline, repairing, and re-checking.
> 
> These tests use the new xfs_db 'fuzz' command to test corner case
> handling of every field.  The 'print' command tells us which fields
> are available, and the fuzz command can write zeroes or ones to the
> field; set the high, middle, or low bit; add or subtract numbers; or
> randomize the field.  We loop through all fields and all fuzz verbs to
> see if we can trip up the kernel.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

The first test gave me a kernel crash :) xfs/1300 crashed your kernel
djwong-devel branch. I appended the console log at the end of this mail
if you have interest to see it.

And another xfs/1300 run gave me this failure message:

    +/mnt/testarea/scratch: Kernel lacks GETFSMAP; scrub will be less efficient. (xfs.c line 661)
    +/mnt/testarea/scratch: Kernel cannot help scrub metadata; scrub will be incomplete. (xfs.c line 661)
    +/mnt/testarea/scratch: Kernel cannot help scrub inodes; scrub will be incomplete. (xfs.c line 661)
    +/mnt/testarea/scratch: Kernel cannot help scrub extent map; scrub will be less efficient. (xfs.c line 661)

Is this known issue or something should be filtered out in the test?

And ext4/1300 generated large .out.bad file (51M), containing something
like:

+/mnt/testarea/scratch/test/68/S_IFREG.FMT_ETREE: extent (1101381632/2469888/4096) ends past end of filesystem at 31457280. (generic.c line 272)
+/mnt/testarea/scratch/test/68/S_IFREG.FMT_ETREE: extent (1101389824/2478080/4096) starts past end of filesystem at 31457280. (generic.c line 264)
+/mnt/testarea/scratch/test/68/S_IFREG.FMT_ETREE: extent (1101389824/2478080/4096) ends past end of filesystem at 31457280. (generic.c line 272)
+/mnt/testarea/scratch/test/68/S_IFREG.FMT_ETREE: extent (1101398016/2486272/4096) starts past end of filesystem at 31457280. (generic.c line 264)
+/mnt/testarea/scratch/test/68/S_IFREG.FMT_ETREE: extent (1101398016/2486272/4096) ends past end of filesystem at 31457280. (generic.c line 272)
+/mnt/testarea/scratch/test/68/S_IFREG.FMT_ETREE: extent (1101406208/2494464/4096) starts past end of filesystem at 31457280. (generic.c line 264)
+/mnt/testarea/scratch/test/68/S_IFREG.FMT_ETREE: extent (1101406208/2494464/4096) ends past end of filesystem at 31457280. (generic.c line 272)
+/mnt/testarea/scratch/test/68/S_IFREG.FMT_ETREE: extent (1101414400/2502656/4096) starts past end of filesystem at 31457280. (generic.c line 264)
+/mnt/testarea/scratch/test/68/S_IFREG.FMT_ETREE: extent (1101414400/2502656/4096) ends past end of filesystem at 31457280. (generic.c line 272)

Seems like scrub found something wrong (real problems) and became very
noisy?

More comments inline below.

> ---
>  common/fuzzy        |   49 ++++++++++++++++++++++++++++++------
>  common/populate     |   10 ++++---
>  common/rc           |   15 +++++++++++
>  tests/ext4/1300     |   60 ++++++++++++++++++++++++++++++++++++++++++++
[snip]
> 
> diff --git a/common/fuzzy b/common/fuzzy
> index 6af47f1..dbff744 100644
> --- a/common/fuzzy
> +++ b/common/fuzzy
> @@ -85,32 +85,47 @@ _scratch_scrub() {
>  # Filter the xfs_db print command's field debug information
>  # into field name and type.
>  __filter_xfs_db_print_fields() {
> +	filter="$1"
> +	if [ -z "${filter}" ] || [ "${filter}" = "nofilter" ]; then
> +		filter='^'
> +	fi
>  	grep ' = ' | while read key equals value; do
> -		fuzzkey="$(echo "${key}" | sed -e 's/\([a-zA-Z0-9_]*\)\[\([0-9]*\)-[0-9]*\]/\1[\2]/g')"
> -		if [[ "${value}" == "["* ]]; then
> +		# Filter out any keys with an array index >= 10, and
> +		# collapse any array range ("[1-195]") to the first item.
> +		fuzzkey="$(echo "${key}" | sed -e '/\([a-z]*\)\[\([0-9][0-9]\+\)\].*/d' -e 's/\([a-zA-Z0-9_]*\)\[\([0-9]*\)-[0-9]*\]/\1[\2]/g')"
> +		if [ -z "${fuzzkey}" ]; then
> +			continue
> +		elif [[ "${value}" == "["* ]]; then
>  			echo "${value}" | sed -e 's/^.//g' -e 's/.$//g' -e 's/,/\n/g' | while read subfield; do
>  				echo "${fuzzkey}.${subfield}"
>  			done
>  		else
>  			echo "${fuzzkey}"
>  		fi
> -	done
> +	done | egrep "${filter}"
>  }
>  
>  # Navigate to some part of the filesystem and print the field info.
> +# The first argument is an egrep filter for the fields
> +# The rest of the arguments are xfs_db commands to locate the metadata.
>  _scratch_xfs_list_metadata_fields() {
> +	filter="$1"
> +	shift
>  	if [ -n "${SCRATCH_XFS_LIST_METADATA_FIELDS}" ]; then
> -		echo "${SCRATCH_XFS_LIST_METADATA_FIELDS}" | sed -e 's/ /\n/g'
> +		echo "${SCRATCH_XFS_LIST_METADATA_FIELDS}" | \
> +			sed -e 's/ /\n/g' | __filter_xfs_db_print_fields "${filter}"
>  		return;
>  	fi
>  
>  	(for arg in "$@"; do
>  		echo "${arg}"
>  	done
> -	echo "print") | _scratch_xfs_db | __filter_xfs_db_print_fields
> +	echo "print") | _scratch_xfs_db | __filter_xfs_db_print_fields "${filter}"
>  }
>  
>  # Get a metadata field
> +# The first arg is the field name
> +# The rest of the arguments are xfs_db commands to find the metadata.
>  _scratch_xfs_get_metadata_field() {
>  	key="$1"
>  	shift
> @@ -124,6 +139,9 @@ _scratch_xfs_get_metadata_field() {
>  }
>  
>  # Set a metadata field
> +# The first arg is the field name
> +# The second arg is the new value
> +# The rest of the arguments are xfs_db commands to find the metadata.
>  _scratch_xfs_set_metadata_field() {
>  	key="$1"
>  	value="$2"
> @@ -136,6 +154,9 @@ _scratch_xfs_set_metadata_field() {
>  }
>  
>  # Fuzz a metadata field
> +# The first arg is the field name
> +# The second arg is the xfs_db fuzz verb
> +# The rest of the arguments are xfs_db commands to find the metadata.
>  _scratch_xfs_fuzz_metadata_field() {
>  	key="$1"
>  	value="$2"
> @@ -263,12 +284,24 @@ _scratch_xfs_list_fuzz_verbs() {
>  		sed -e 's/[,.]//g' -e 's/Verbs: //g' -e 's/ /\n/g'
>  }
>  
> -# Fuzz the fields of some piece of metadata
> -_scratch_xfs_fuzz_fields() {
> -	_scratch_xfs_list_metadata_fields "$@" | while read field; do
> +# Fuzz some of the fields of some piece of metadata
> +# The first argument is an egrep filter
> +# The rest of the arguments are xfs_db commands to locate the metadata.
> +_scratch_xfs_fuzz_some_fields() {
> +	filter="$1"
> +	shift
> +	echo "Fields we propose to fuzz: $@"
> +	_scratch_xfs_list_metadata_fields "${filter}" "$@"
> +	_scratch_xfs_list_metadata_fields "${filter}" "$@" | while read field; do
>  		_scratch_xfs_list_fuzz_verbs | while read fuzzverb; do
>  			__scratch_xfs_fuzz_mdrestore
>  			__scratch_xfs_fuzz_field_test "${field}" "${fuzzverb}" "$@"
>  		done
>  	done
>  }
> +
> +# Fuzz all of the fields of some piece of metadata
> +# All arguments are xfs_db commands to locate the metadata.
> +_scratch_xfs_fuzz_fields() {
> +	_scratch_xfs_fuzz_some_fields '' "$@"
> +}

I think all the fuzz update here should be folded to patch 7/9.

> diff --git a/common/populate b/common/populate
> index 15d68fc..7d103f0 100644
> --- a/common/populate
> +++ b/common/populate
> @@ -180,13 +180,13 @@ _scratch_xfs_populate() {
>  	# FMT_EXTENTS with a remote less-than-a-block value
>  	echo "+ attr extents with a remote less-than-a-block value"
>  	touch "${SCRATCH_MNT}/ATTR.FMT_EXTENTS_REMOTE3K"
> -	$XFS_IO_PROG -f -c "pwrite -S 0x43 0 3k" "${SCRATCH_MNT}/attrvalfile" > /dev/null
> +	$XFS_IO_PROG -f -c "pwrite -S 0x43 0 $((blksz - 300))" "${SCRATCH_MNT}/attrvalfile" > /dev/null
>  	attr -q -s user.remotebtreeattrname "${SCRATCH_MNT}/ATTR.FMT_EXTENTS_REMOTE3K" < "${SCRATCH_MNT}/attrvalfile"
>  
>  	# FMT_EXTENTS with a remote block-size value
>  	echo "+ attr extents with a remote one-block value"
>  	touch "${SCRATCH_MNT}/ATTR.FMT_EXTENTS_REMOTE4K"
> -	$XFS_IO_PROG -f -c "pwrite -S 0x44 0 4k" "${SCRATCH_MNT}/attrvalfile" > /dev/null
> +	$XFS_IO_PROG -f -c "pwrite -S 0x44 0 ${blksz}" "${SCRATCH_MNT}/attrvalfile" > /dev/null
>  	attr -q -s user.remotebtreeattrname "${SCRATCH_MNT}/ATTR.FMT_EXTENTS_REMOTE4K" < "${SCRATCH_MNT}/attrvalfile"
>  	rm -rf "${SCRATCH_MNT}/attrvalfile"
>  
> @@ -482,8 +482,8 @@ _scratch_xfs_populate_check() {
>  	__populate_check_xfs_aformat "${btree_attr}" "btree"
>  	__populate_check_xfs_agbtree_height "bno"
>  	__populate_check_xfs_agbtree_height "cnt"
> -	test -n $is_rmapbt && __populate_check_xfs_agbtree_height "rmap"
> -	test -n $is_reflink && __populate_check_xfs_agbtree_height "refcnt"
> +	test $is_rmapbt -ne 0 && __populate_check_xfs_agbtree_height "rmap"
> +	test $is_reflink -ne 0 && __populate_check_xfs_agbtree_height "refcnt"
>  }

And these folded to patch 1/9?

>  
>  # Check data fork format of ext4 file
> @@ -609,7 +609,7 @@ _scratch_populate_cached() {
>  	rm -rf "$(find "${POPULATE_METADUMP}" -mtime +2 2>/dev/null)"
>  
>  	# Throw away cached image if it doesn't match our spec.
> -	meta_descr="FSTYP ${FSTYP} MKFS_OPTIONS ${MKFS_OPTIONS} ARGS $@"
> +	meta_descr="FSTYP ${FSTYP} MKFS_OPTIONS $(_scratch_mkfs_options) ARGS $@"
>  	cmp -s "${POPULATE_METADUMP_DESCR}" <(echo "${meta_descr}") || rm -rf "${POPULATE_METADUMP}"
>  
>  	# Do we have a cached image?

This to patch 6/9?

Because we usually don't introduce something in patch 1 and fix them in
patch 2, I think :)

> diff --git a/common/rc b/common/rc
> index d904582..ec1f5de 100644
> --- a/common/rc
> +++ b/common/rc
> @@ -1870,6 +1870,21 @@ _require_xfs_finobt()
>  	_scratch_unmount
>  }
>  
> +# Do we have a fre
> +_require_scratch_finobt()
> +{
> +	_require_scratch
> +
> +	if [ $FSTYP != "xfs" ]; then
> +		_notrun "finobt not supported by scratch filesystem type: $FSTYP"
> +		return
> +	fi
> +	_scratch_mkfs > /dev/null
> +	_scratch_mount
> +	xfs_info $SCRATCH_MNT | grep -q 'finobt=1' || _notrun "finobt not supported by scratch filesystem type: $FSTYP"
> +	_scratch_unmount
> +}
> +
>  # this test requires xfs sysfs attribute support
>  #
>  _require_xfs_sysfs()
> diff --git a/tests/ext4/1300 b/tests/ext4/1300
> new file mode 100755
> index 0000000..3f8135e
> --- /dev/null
> +++ b/tests/ext4/1300

[all the tests look fine to me, snip]

> --- a/tests/xfs/group
> +++ b/tests/xfs/group
> @@ -333,3 +333,34 @@
>  345 auto quick clone
>  346 auto quick clone
>  347 auto quick clone
> +1300 dangerous_fuzzers scrub

ext4/1300 is "auto quick scrub", I think xfs/1300 should be in auto
group too?

Thanks,
Eryu

P.S. console log of xfs/1300 crash

[165877.766244] BUG: unable to handle kernel NULL pointer dereference at 0000000000000038
[165877.774197] IP: [<ffffffffa0680c13>] xfs_scrub_get_inode+0xc3/0x1c0 [xfs]
[165877.781162] PGD 179c1b067 [165877.783784] PUD 14d994067
PMD 0 [165877.787130]
[165877.788722] Oops: 0000 [#1] SMP
[165877.791951] Modules linked in: dm_delay dm_zero btrfs xor raid6_pq dm_thin_pool dm_persistent_data dm_bio_prison dm_snapshot dm_bufio loop dm_flakey xfs libcrc32c binfmt_misc ip6t_rpfilter ipt_REJECT nf_reject_ipv4 nf_conntrack_ipv4 nf_defrag_ipv4 ip6t_REJECT nf_reject_ipv6 nf_conntrack_ipv6 nf_defrag_ipv6 xt_conntrack nf_conntrack ip_set nfnetlink ebtable_nat ebtable_broute bridge stp llc ip6table_mangle ip6table_security ip6table_raw iptable_mangle iptable_security iptable_raw ebtable_filter ebtables ip6table_filter ip6_tables iptable_filter coretemp kvm_intel kvm irqbypass crc32_pclmul ghash_clmulni_intel aesni_intel lrw iTCO_wdt gf128mul glue_helper ipmi_devintf cdc_ether iTCO_vendor_support ablk_helper cryptd usbnet i2c_i801 lpc_ich mii pcspkr i2c_smbus sg i7core_edac mfd_core ipmi_si edac_core ipmi_msghandler shpchp ioatdma dca acpi_cpufreq nfsd auth_rpcgss nfs_acl lockd grace sunrpc ip_tables ext4 jbd2 mbcache sr_mod sd_mod cdrom mgag200 i2c_algo_bit drm_kms_helper syscopyarea sysfillrect sysimgblt fb_sys_fops ttm ata_generic pata_acpi drm ata_piix libata crc32c_intel megaraid_sas serio_raw i2c_core bnx2 dm_mirror dm_region_hash dm_log dm_mod [last unloaded: scsi_debug]
[165877.898708] CPU: 5 PID: 26242 Comm: xfs_scrub Tainted: G        W       4.9.0-rc3.djwong+ #16
[165877.907308] Hardware name: IBM System x3550 M3 -[7944OEJ]-/90Y4784     , BIOS -[D6E150CUS-1.11]- 02/08/2011
[165877.917124] task: ffff88017a286a40 task.stack: ffffc9000cca0000
[165877.923126] RIP: 0010:[<ffffffffa0680c13>]  [<ffffffffa0680c13>] xfs_scrub_get_inode+0xc3/0x1c0 [xfs]
[165877.932503] RSP: 0018:ffffc9000cca3ad0  EFLAGS: 00010246
[165877.937898] RAX: 0000000000000000 RBX: fffffffffffffffe RCX: 0000000000000017
[165877.945111] RDX: 0000000000000000 RSI: ffffc9000cca3ce8 RDI: 0000000000001123
[165877.952328] RBP: ffffc9000cca3b20 R08: 0000000000000003 R09: 0000000000000014
[165877.959544] R10: 0000000000000000 R11: 0000000000000000 R12: ffff880278f59680
[165877.966759] R13: ffffc9000cca3ba8 R14: ffffc9000cca3ce8 R15: 0000000000000000
[165877.973976] FS:  00007f3d099f9700(0000) GS:ffff88017bb00000(0000) knlGS:0000000000000000
[165877.982143] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[165877.987969] CR2: 0000000000000038 CR3: 000000016ad2d000 CR4: 00000000000006e0
[165877.995185] Stack:
[165877.997286]  ffff880278f59680 0000000000000000 ffff880220cc5c00 ffff880265190780
[165878.004840]  ffff880101a67800 ffffc9000cca3ba8 ffff880278f59680 ffff88025a9e6000
[165878.012396]  ffffc9000cca3ce8 0000000000000000 ffffc9000cca3b58 ffffffffa0681a61
[165878.019950] Call Trace:
[165878.022551]  [<ffffffffa0681a61>] __xfs_scrub_setup_inode.isra.63+0x81/0x280 [xfs]
[165878.030236]  [<ffffffffa0681c70>] xfs_scrub_setup_inode+0x10/0x20 [xfs]
[165878.036963]  [<ffffffffa068f57f>] xfs_scrub_metadata+0x2ff/0x450 [xfs]
[165878.043607]  [<ffffffffa066aa1d>] xfs_ioc_scrub_metadata+0x4d/0x80 [xfs]
[165878.050424]  [<ffffffffa066d029>] xfs_file_ioctl+0x9c9/0xb10 [xfs]
[165878.056689]  [<ffffffff8110692f>] ? get_futex_key+0x1df/0x360
[165878.062516]  [<ffffffff81106b31>] ? futex_wake+0x81/0x150
[165878.068003]  [<ffffffff812189c6>] do_vfs_ioctl+0x96/0x5b0
[165878.073482]  [<ffffffff81218f59>] SyS_ioctl+0x79/0x90
[165878.078621]  [<ffffffff81003997>] do_syscall_64+0x67/0x180
[165878.084191]  [<ffffffff816a6c2b>] entry_SYSCALL64_slow_path+0x25/0x25
[165878.090714] Code: 8b 14 24 49 8b 75 00 85 c0 41 89 c7 44 0f b6 82 93 00 00 00 44 0f b6 8a 94 00 00 00 0f b6 8a 53 02 00 00 49 8b 55 08 48 8b 7e 08 <4c> 8b 62 38 75 38 48 8b 7d d0 8b 46 10 39 87 98 03 00 00 74 21
[165878.110930] RIP  [<ffffffffa0680c13>] xfs_scrub_get_inode+0xc3/0x1c0 [xfs]
[165878.117938]  RSP <ffffc9000cca3ad0>
[165878.121512] CR2: 0000000000000038
[165878.129219] ---[ end trace d23e56c58f53ccb9 ]---
