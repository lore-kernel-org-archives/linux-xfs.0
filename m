Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id A3B5B7F3F
	for <xfs@oss.sgi.com>; Mon, 28 Oct 2013 11:02:13 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 22B11AC029
	for <xfs@oss.sgi.com>; Mon, 28 Oct 2013 09:02:10 -0700 (PDT)
Received: from dkim2.fusionio.com (dkim2.fusionio.com [66.114.96.54]) by
	cuda.sgi.com with ESMTP id aBUsLDt3mTQHx94R (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 28 Oct 2013 09:02:07 -0700 (PDT)
Received: from mx2.fusionio.com (unknown [10.101.1.160])
	by dkim2.fusionio.com (Postfix) with ESMTP id 69B7E9A069B
	for <xfs@oss.sgi.com>; Mon, 28 Oct 2013 10:02:07 -0600 (MDT)
Date: Mon, 28 Oct 2013 12:02:04 -0400
From: Josef Bacik <jbacik@fusionio.com>
Subject: Re: [patch 3/3] [PATCH 3/3] xfstests: add tests for new feature
	ioctl and sysfs interfaces
Message-ID: <20131028160204.GE4543@localhost.localdomain>
References: <20131025205246.269327744@suse.com>
	<20131025205559.867539656@suse.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20131025205559.867539656@suse.com>
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
To: Jeff Mahoney <jeffm@suse.com>
Cc: linux-btrfs@vger.kernel.org, Josef Bacik <jbacik@fusionio.com>, xfs@oss.sgi.com

On Fri, Oct 25, 2013 at 04:52:49PM -0400, Jeff Mahoney wrote:
> This tests the exporting of feature information from the kernel via
> sysfs and ioctl. The first test works whether the sysfs permissions
> are correct, if the information exported via sysfs matches
> what the ioctls are reporting, and if they both match the on-disk
> superblock's version of the feature sets. The second and third tests
> test online setting and clearing of feature bits via the sysfs and
> ioctl interfaces, checking whether they match the on-disk super on
> each cycle.
> 
> In every case, if the features are not present, it is not considered
> a failure and a message indicating that will be dumped to the $num.full
> file.
> 
> Signed-off-by: Jeff Mahoney <jeffm@suse.com>
> ---
>  src/btrfs_ioctl_helper.c |  93 +++++++++++++++++
>  tests/btrfs/102          | 263 +++++++++++++++++++++++++++++++++++++++++++++++
>  tests/btrfs/102.out      |   2 +
>  tests/btrfs/103          | 188 +++++++++++++++++++++++++++++++++
>  tests/btrfs/103.out      |   2 +
>  tests/btrfs/104          | 186 +++++++++++++++++++++++++++++++++
>  tests/btrfs/104.out      |   2 +
>  7 files changed, 736 insertions(+)
>  create mode 100755 tests/btrfs/102
>  create mode 100644 tests/btrfs/102.out
>  create mode 100755 tests/btrfs/103
>  create mode 100644 tests/btrfs/103.out
>  create mode 100755 tests/btrfs/104
>  create mode 100644 tests/btrfs/104.out
> 
> diff --git a/src/btrfs_ioctl_helper.c b/src/btrfs_ioctl_helper.c
> index a88b7b5..73cfa60 100644
> --- a/src/btrfs_ioctl_helper.c
> +++ b/src/btrfs_ioctl_helper.c
> @@ -5,6 +5,7 @@
>  #include <string.h>
>  #include <stdint.h>
>  #include <unistd.h>
> +#include <stdlib.h>
>  
>  #ifndef BTRFS_IOCTL_MAGIC
>  #define BTRFS_IOCTL_MAGIC 0x94
> @@ -14,6 +15,21 @@
>  #define BTRFS_IOC_GLOBAL_RSV _IOR(BTRFS_IOCTL_MAGIC, 20, uint64_t)
>  #endif
>  
> +#ifndef BTRFS_IOC_GET_FEATURES
> +struct btrfs_ioctl_feature_flags {
> +	uint64_t compat_flags;
> +	uint64_t compat_ro_flags;
> +	uint64_t incompat_flags;
> +};
> +
> +#define BTRFS_IOC_GET_FEATURES _IOR(BTRFS_IOCTL_MAGIC, 57, \
> +                                   struct btrfs_ioctl_feature_flags)
> +#define BTRFS_IOC_SET_FEATURES _IOW(BTRFS_IOCTL_MAGIC, 57, \
> +                                   struct btrfs_ioctl_feature_flags[2])
> +#define BTRFS_IOC_GET_SUPPORTED_FEATURES _IOR(BTRFS_IOCTL_MAGIC, 57, \
> +                                   struct btrfs_ioctl_feature_flags[3])
> +#endif
> +
>  static int global_rsv_ioctl(int fd, int argc, char *argv[])
>  {
>  	uint64_t reserved;
> @@ -25,6 +41,80 @@ static int global_rsv_ioctl(int fd, int argc, char *argv[])
>  	return 0;
>  }
>  
> +static int get_features_ioctl(int fd, int argc, char *argv[])
> +{
> +	struct btrfs_ioctl_feature_flags flags;
> +	int ret = ioctl(fd, BTRFS_IOC_GET_FEATURES, &flags);
> +	if (ret)
> +		return -errno;
> +
> +	printf("0x%llx 0x%llx 0x%llx\n",
> +	       (unsigned long long)flags.compat_flags,
> +	       (unsigned long long)flags.compat_ro_flags,
> +	       (unsigned long long)flags.incompat_flags);
> +	return 0;
> +}
> +
> +static int set_features_ioctl(int fd, int argc, char *argv[])
> +{
> +	struct btrfs_ioctl_feature_flags flags[2];
> +	uint64_t bit, *bits, *mask;
> +	if (argc != 3)
> +		goto usage;
> +
> +	memset(flags, 0, sizeof(flags));
> +
> +	errno = 0;
> +	bit = strtoull(argv[2], NULL, 10);
> +	if (errno)
> +		goto usage;
> +
> +	if (strcmp(argv[1], "compat") == 0) {
> +		mask = &flags[0].compat_flags;
> +		bits = &flags[1].compat_flags;
> +	} else if (strcmp(argv[1], "compat_ro") == 0) {
> +		mask = &flags[0].compat_ro_flags;
> +		bits = &flags[1].compat_ro_flags;
> +	} else if (strcmp(argv[1], "incompat") == 0) {
> +		mask = &flags[0].incompat_flags;
> +		bits = &flags[1].incompat_flags;
> +	} else
> +		goto usage;
> +
> +	*mask |= bit;
> +
> +	if (strcmp(argv[0], "set") == 0)
> +		*bits |= bit;
> +
> +	return ioctl(fd, BTRFS_IOC_SET_FEATURES, &flags);
> +usage:
> +	fprintf(stderr, "usage: SET_FEATURES <set|clear> <compat|compat_ro|incompat> <base-10 bitmask>\n");
> +	return -EINVAL;
> +}
> +
> +static int get_supported_features_ioctl(int fd, int argc, char *argv[])
> +{
> +	struct btrfs_ioctl_feature_flags flags[3];
> +	int ret;
> +	int i;
> +
> +	ret = ioctl(fd, BTRFS_IOC_GET_SUPPORTED_FEATURES, &flags);
> +	if (ret)
> +		return -errno;
> +
> +	for (i = 0; i < 3; i++)
> +		printf("0x%llx 0x%llx 0x%llx ",
> +		       (unsigned long long)flags[i].compat_flags,
> +		       (unsigned long long)flags[i].compat_ro_flags,
> +		       (unsigned long long)flags[i].incompat_flags);
> +
> +	printf("\n");
> +	return 0;
> +usage:
> +	fprintf(stderr,
> +		"usage: GET_SUPPORTED_FEATURES <supported|settable|clearable>\n");
> +	return -EINVAL;
> +}
>  #define IOCTL_TABLE_ENTRY(_ioctl_name, _handler) \
>  	{ .name = #_ioctl_name, .ioctl_cmd = BTRFS_IOC_##_ioctl_name, \
>  	  .handler = _handler, }
> @@ -37,6 +127,9 @@ struct ioctl_table_entry {
>  
>  static struct ioctl_table_entry ioctls[] = {
>  	IOCTL_TABLE_ENTRY(GLOBAL_RSV, global_rsv_ioctl),
> +	IOCTL_TABLE_ENTRY(GET_FEATURES, get_features_ioctl),
> +	IOCTL_TABLE_ENTRY(SET_FEATURES, set_features_ioctl),
> +	IOCTL_TABLE_ENTRY(GET_SUPPORTED_FEATURES, get_supported_features_ioctl),
>  };
>  
>  int
> diff --git a/tests/btrfs/102 b/tests/btrfs/102
> new file mode 100755
> index 0000000..77f2162
> --- /dev/null
> +++ b/tests/btrfs/102
> @@ -0,0 +1,263 @@
> +#!/bin/bash
> +# FA QA Test No. 102
> +#
> +# Test online feature publishing
> +# This test doesn't test the changing of features. It does test that
> +# the proper publishing bits and permissions match up with
> +# the expected values.
> +#
> +#-----------------------------------------------------------------------
> +# Copyright (c) 2013 SUSE, All Rights Reserved.
> +#
> +# This program is free software; you can redistribute it and/or
> +# modify it under the terms of the GNU General Public License as
> +# published by the Free Software Foundation.
> +#
> +# This program is distributed in the hope that it would be useful,
> +# but WITHOUT ANY WARRANTY; without even the implied warranty of
> +# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> +# GNU General Public License for more details.
> +#
> +# You should have received a copy of the GNU General Public License
> +# along with this program; if not, write the Free Software Foundation,
> +# Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
> +#-----------------------------------------------------------------------
> +
> +seq=$(basename $0)
> +seqres=$RESULT_DIR/$seq
> +echo "== QA output created by $seq"
> +
> +here=$(pwd)
> +tmp=/tmp/$$
> +status=1
> +
> +# get standard environment, filters and checks
> +. ./common/rc
> +. ./common/filter.btrfs
> +
> +_supported_fs btrfs
> +_supported_os Linux
> +_require_scratch
> +_require_command $BTRFS_SHOW_SUPER_PROG btrfs-show-super

You don't need the extra btrfs-show-super here, the var should be good enough.

> +
> +_scratch_mkfs > /dev/null 2>&1
> +_scratch_mount
> +
> +fsid() {
> +	$BTRFS_UTIL_PROG filesystem show $1|awk '/uuid:/ {print $NF}'
> +}
> +
> +check_features() {
> +	reserved="$2"
> +	method="$3"
> +	if [ "$1" != 0 ]; then
> +		echo "$method: failed: $reserved"
> +		exit 1
> +	fi
> +}
> +
> +error=false
> +
> +# test -w will always return true if root is making the call.
> +# This would be true in most cases, but for sysfs files, the permissions
> +# are enforced even for root.
> +is_writeable() {
> +	local file=$1
> +	mode=$(stat -c "0%a" "$file")
> +	mode=$(( $mode & 0200 ))
> +
> +	[ "$mode" -eq 0 ] && return 1
> +	return 0
> +}
> +
> +# ioctl
> +read -a features < <(src/btrfs_ioctl_helper $SCRATCH_MNT GET_FEATURES 2>&1)
> +check_features $? "$features" "GET_FEATURES"
> +
> +read -a supp_features < <(src/btrfs_ioctl_helper $SCRATCH_MNT GET_SUPPORTED_FEATURES 2>&1)
> +check_features $? "$features" "GET_SUPPORTED_FEATURES"
> +
> +# Sysfs checks
> +fsid=$(fsid $SCRATCH_DEV)
> +sysfs_base="/sys/fs/btrfs"
> +
> +# TODO Add tool to enable and test unknown feature bits
> +get_feature_mask() {
> +	class=""
> +	case "$attr" in
> +	mixed_backref)	class=incompat; bit=0x1 ;;
> +	default_subvol)	class=incompat; bit=0x2 ;;
> +	mixed_groups)	class=incompat; bit=0x4 ;;
> +	compress_lzo)	class=incompat; bit=0x8 ;;
> +	compress_lsov2)	class=incompat; bit=0x10 ;;
> +	big_metadata)	class=incompat; bit=0x20 ;;
> +	extended_iref)	class=incompat; bit=0x40 ;;
> +	raid56)		class=incompat; bit=0x80 ;;
> +	skinny_metadata)class=incompat; bit=0x100 ;;
> +	compat:*)	class=compat; bit=${attr##compat:} ;;
> +	compat_ro:*)	class=compat_ro; bit=${attr##compat_ro:} ;;
> +	incompat:*)	class=incompat; bit=${attr##incompat:} ;;
> +	esac
> +	if [ -z "$class" ]; then
> +		echo "Unknown feature name $attr. xfstests needs updating." \
> +		     " Skipping the test of sysfs values to superblock values" \
> +		     >> $seqres.full
> +		return
> +	fi
> +
> +	echo "$class $bit"
> +}
> +
> +get_changeable_mask() {
> +	local class=$1
> +	local index=0
> +	if [ "$class" = "compat" ]; then
> +		index=0
> +	elif [ "$class" = "compat_ro" ]; then
> +		index=1
> +	elif [ "$class" = "incompat" ]; then
> +		index=2
> +	fi
> +	local set_index=$(( $index + 3 ))
> +	local clear_index=$(( $index + 6 ))
> +
> +	local mask=$(( ${supp_features[$set_index]} | \
> +		       ${supp_features[$clear_index]} ))
> +
> +	echo $mask
> +}
> +
> +# Check enabled features in sysfs vs what the superblock claims
> +sysfs_features=(0 0 0)
> +for file in $sysfs_base/$fsid/features/*; do
> +	attr=$(basename $file)
> +	val=$(cat $file)
> +	read class bit < <(get_feature_mask $attr)
> +
> +	# A file that exists but has a 0 value means that it's changeable
> +	if [ "$val" -eq 0 ]; then
> +		if [ ! -e "$sysfs_base/features/$attr" ]; then
> +			echo "$fsid/$attr exists with a 0 value but" \
> +			     "features/$attr doesn't exist."
> +			error=true
> +			continue
> +		elif ! is_writeable "$file"; then
> +			echo "$attr is not writable but exists and has a" \
> +			     "0 value."
> +			error=true
> +		fi
> +
> +		mask=$(get_changeable_mask $class)
> +		if [ "$(( $bit & ~$mask ))" -ne 0 ]; then
> +			echo "$attr is writable but GET_SUPPORTED_FEATURES" \
> +			     "ioctl claims it shouldn't be."
> +			error=true
> +		fi
> +
> +		continue
> +	fi
> +	if [ "$class" = "compat" ]; then
> +		sysfs_features[0]=$(( ${sysfs_features[0]} | $bit ))
> +	elif [ "$class" = "compat_ro" ]; then
> +		sysfs_features[1]=$(( ${sysfs_features[1]} | $bit ))
> +	elif [ "$class" = "incompat" ]; then
> +		sysfs_features[2]=$(( ${sysfs_features[2]} | $bit ))
> +	else
> +		# We will end up with a bit set in the superblock that
> +		# doesn't have a matching bit here. The feature-bit to name
> +		# mapping must be kept up-to-date for this test to succeed.
> +		echo "Unknown feature name $attr. xfstests needs updating." \
> +		     "Skipping the test of sysfs values to superblock values" \
> +		      >> $seqres.full
> +		skip_sysfs_super_check=true
> +	fi
> +done
> +
> +for file in $sysfs_base/features/*; do
> +	attr=$(basename $file)
> +	val=$(cat $file)
> +	if [ "$val" -gt 0 ]; then
> +		if [ ! -e "$sysfs_base/$fsid/features/$attr" ]; then
> +			echo "features/$attr has a nonzero value ($val)" \
> +			     "but $fsid/features/$attr doesn't exist"
> +			error=true
> +			continue
> +		fi
> +		if ! is_writeable "$sysfs_base/$fsid/features/$attr"; then
> +			echo "features/$attr has a nonzero value ($val)" \
> +			     "but $fsid/features/$attr is not writable"
> +			error=true
> +			continue
> +		fi
> +		continue
> +	fi
> +
> +	[ ! -e "$sysfs_base/$fsid/features/$attr" ] && continue
> +
> +	if is_writeable "$sysfs_base/$fsid/features/$attr"; then
> +		echo "features/$attr has a zero value but" \
> +		     "$fsid/features/$attr is writable."
> +		error=true
> +		continue
> +	fi
> +
> +	read class bit < <(get_feature_mask $attr)
> +	mask=$(get_changeable_mask $class)
> +	if [ "$(( $bit & $mask ))" -ne 0 ]; then
> +		echo "$attr isn't writable but GET_SUPPORTED_FEATURES" \
> +		     "ioctl claims it should be."
> +		error=true
> +		continue
> +	fi
> +done
> +
> +umount $SCRATCH_MNT > /dev/null 2>&1
> +
> +fields=("compat" "compat_ro" "incompat")
> +declare -a disk_flags
> +get_disk_flags() {
> +	local index=$1
> +
> +	# Grab the flags from the superblock directly to compare
> +	disk_flags[$index]=$($BTRFS_SHOW_SUPER_PROG $SCRATCH_DEV | \
> +		     grep "^${fields[$index]}_flags"|awk '{print $NF}')
> +}
> +
> +check_ioctl_flags() {
> +	local index=$1
> +	local flags=${features[$index]}
> +
> +	if [ "$flags" != "${disk_flags[$index]}" ]; then
> +		echo "ioctl returned different ${fields[$index]} flags" \
> +		     "($flags) than those contained in superblock" \
> +		     "(${disk_flags[$index]})"
> +		error=true
> +	fi
> +}
> +
> +check_sysfs_flags() {
> +	local index=$1
> +	$skip_sysfs_super_check || return
> +
> +	flags=$(printf "0x%llx" ${sysfs_features[$index]})
> +	if [ "$flags" != "${disk_flags[$index]}" ]; then
> +		echo "sysfs returned different ${fields[$index]}" \
> +		     "flags ($flags) than those contained in" \
> +		     "superblock (${disk_flags[$index]})"
> +		error=true
> +	fi
> +}
> +
> +
> +for index in $(seq 0 2); do
> +	get_disk_flags "$index"
> +	check_ioctl_flags "$index"
> +	check_sysfs_flags "$index"
> +done
> +
> +$error && exit 1
> +
> +#
> +echo "Silence is golden"
> +status=0
> +exit
> diff --git a/tests/btrfs/102.out b/tests/btrfs/102.out
> new file mode 100644
> index 0000000..28b7182
> --- /dev/null
> +++ b/tests/btrfs/102.out
> @@ -0,0 +1,2 @@
> +== QA output created by 102
> +Silence is golden
> diff --git a/tests/btrfs/103 b/tests/btrfs/103
> new file mode 100755
> index 0000000..ff083c7
> --- /dev/null
> +++ b/tests/btrfs/103
> @@ -0,0 +1,188 @@
> +#!/bin/bash
> +# FA QA Test No. 103
> +#
> +# Test online feature changing via ioctl
> +#
> +#-----------------------------------------------------------------------
> +# Copyright (c) 2013 SUSE, All Rights Reserved.
> +#
> +# This program is free software; you can redistribute it and/or
> +# modify it under the terms of the GNU General Public License as
> +# published by the Free Software Foundation.
> +#
> +# This program is distributed in the hope that it would be useful,
> +# but WITHOUT ANY WARRANTY; without even the implied warranty of
> +# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> +# GNU General Public License for more details.
> +#
> +# You should have received a copy of the GNU General Public License
> +# along with this program; if not, write the Free Software Foundation,
> +# Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
> +#-----------------------------------------------------------------------
> +
> +seq=$(basename $0)
> +seqres=$RESULT_DIR/$seq
> +echo "== QA output created by $seq"
> +
> +here=$(pwd)
> +tmp=/tmp/$$
> +status=1
> +
> +# get standard environment, filters and checks
> +. ./common/rc
> +. ./common/filter.btrfs
> +
> +_supported_fs btrfs
> +_supported_os Linux
> +_require_scratch
> +_require_command $BTRFS_SHOW_SUPER_PROG btrfs-show-super
> +

Same here.

> +IOCTL=src/btrfs_ioctl_helper
> +
> +check_features() {
> +	reserved="$2"
> +	method="$3"
> +	if [ "$1" != 0 ]; then
> +		echo "$method: failed: $reserved"
> +		exit 1
> +	fi
> +	if [ "$reserved" = "Not implemented." ]; then
> +		echo "Skipping ioctl $method test. Not implemented." \
> +		     >> $seqres.full
> +		echo "Silence is golden."
> +		exit 0
> +	fi
> +}
> +
> +# 3 values, one for each each of the fields
> +update_features() {
> +	read -a features < <($IOCTL $SCRATCH_MNT GET_FEATURES 2>&1)
> +	check_features $? "${features[@]}" "GET_FEATURES"
> +}
> +
> +set_feature() {
> +	local field=$1
> +	local bits=$2
> +	local class=${fields[$field]}
> +	local old=${features[$field]}
> +	msg=$($IOCTL $SCRATCH_MNT SET_FEATURES set $class $bits)
> +	check_features $? "$msg" "SET_FEATURES"
> +	update_features
> +	local new=${features[$field]}
> +
> +	if [ "$old" = "$new" ]; then
> +		echo "Feature setting failed"
> +		exit 1
> +	fi
> +	expected=$(( $old | $bits ))
> +	new=$(( $new ))
> +	if [ "$expected" -ne "$new" ]; then
> +		echo "Feature setting failed; Got $new, expected $expected"
> +		exit 1
> +	fi
> +	echo $new
> +}
> +
> +clear_feature() {
> +	local field=$1
> +	local bits=$2
> +	local class=${fields[$field]}
> +	local old=${features[$field]}
> +	msg=$($IOCTL $SCRATCH_MNT SET_FEATURES clear $class $bits)
> +	check_features $? "$msg" "SET_FEATURES"
> +	update_features
> +	local new="${features[$field]}"
> +
> +	if [ "$old" = "$new" ]; then
> +		echo "Feature clearing failed"
> +		exit 1
> +	fi
> +	expected=$(( $old & ~$bits ))
> +	new=$(( $new ))
> +	if [ "$expected" -ne "$new" ]; then
> +		echo "Feature clearing failed; Got $new, expected $expected"
> +		exit 1
> +	fi
> +}
> +
> +get_disk_flags () {
> +	local index=$1
> +	$BTRFS_SHOW_SUPER_PROG $SCRATCH_DEV | grep ^${fields[$index]}_flags | \
> +	awk '{print $NF}'
> +}
> +
> +check_flags() {
> +	local index=$1
> +	local expected=$(( $2 ))
> +	disk_flags="$(( $(get_disk_flags $index) ))"
> +	if [ "$disk_flags" -ne "$expected" ]; then
> +		echo "mismatch: $disk_flags-$expected"
> +		error=true
> +	fi
> +}
> +
> +error=false
> +fields=("compat" "compat_ro" "incompat")
> +
> +_scratch_mkfs > /dev/null 2>&1
> +_scratch_mount
> +
> +update_features
> +
> +# 9 values; 3 each for supported, settable, and clearable
> +read -a supp_features < <($IOCTL $SCRATCH_MNT GET_SUPPORTED_FEATURES 2>&1)
> +check_features $? "$supp_features" "GET_SUPPORTED_FEATURES"
> +
> +# Cycle through settable features.
> +# Set the feature
> +# Reload ioctl version and test against expected new value
> +# Unmount and test against expected new value
> +# Reount
> +settable() {
> +	echo "${supp_features[$(( $1 + 3 ))]}"
> +}
> +did_set=false
> +for field in $(seq 0 2); do
> +	fset="$(settable $field)"
> +	for n in $(seq 0 63); do
> +		old="${features[$field]}"
> +		v="$(( $fset & (1 << $n) ))"
> +		[ "$v" -eq 0 ] && continue
> +		new="$(set_feature $field $v)"
> +		umount $SCRATCH_MNT > /dev/null 2>&1
> +		expected="$(( $old | $v ))"
> +		check_flags "$field" "$expected"
> +		_scratch_mount
> +		did_set=true
> +	done
> +done
> +$did_set || echo "No online-settable features to test." >> $seqres.full
> +
> +# Repeat with clearing features
> +clearable() {
> +	echo "${supp_features[$(( $1 + 6 ))]}"
> +}
> +did_clear=false
> +for field in $(seq 0 2); do
> +	fclear="$(clearable $field)"
> +	for n in $(seq 0 63); do
> +		v="$(( $fclear & (1 << $n) ))"
> +		[ "$v" -eq 0 ] && continue
> +
> +		new="$(clear_feature $field $v)"
> +		umount $SCRATCH_MNT > /dev/null 2>&1
> +		expected=$(( $old &~ $v ))
> +		check_flags $field $expected
> +		_scratch_mount
> +		did_clear=true
> +	done
> +done
> +$did_clear || echo "No online-clearable features to test." >> $seqres.full
> +
> +umount $SCRATCH_MNT > /dev/null 2>&1
> +
> +$error && exit 1
> +
> +echo "Silence is golden"
> +status=0
> +exit
> diff --git a/tests/btrfs/103.out b/tests/btrfs/103.out
> new file mode 100644
> index 0000000..aa66c3b
> --- /dev/null
> +++ b/tests/btrfs/103.out
> @@ -0,0 +1,2 @@
> +== QA output created by 103
> +Silence is golden
> diff --git a/tests/btrfs/104 b/tests/btrfs/104
> new file mode 100755
> index 0000000..3ac4040
> --- /dev/null
> +++ b/tests/btrfs/104
> @@ -0,0 +1,186 @@
> +#!/bin/bash
> +# FA QA Test No. 104
> +#
> +# Test online feature changing via sysfs
> +#
> +#-----------------------------------------------------------------------
> +# Copyright (c) 2013 SUSE, All Rights Reserved.
> +#
> +# This program is free software; you can redistribute it and/or
> +# modify it under the terms of the GNU General Public License as
> +# published by the Free Software Foundation.
> +#
> +# This program is distributed in the hope that it would be useful,
> +# but WITHOUT ANY WARRANTY; without even the implied warranty of
> +# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> +# GNU General Public License for more details.
> +#
> +# You should have received a copy of the GNU General Public License
> +# along with this program; if not, write the Free Software Foundation,
> +# Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
> +#-----------------------------------------------------------------------
> +
> +seq=$(basename $0)
> +seqres=$RESULT_DIR/$seq
> +echo "== QA output created by $seq"
> +
> +here=$(pwd)
> +tmp=/tmp/$$
> +status=1
> +
> +# get standard environment, filters and checks
> +. ./common/rc
> +. ./common/filter.btrfs
> +
> +_supported_fs btrfs
> +_supported_os Linux
> +_require_scratch
> +_require_command $BTRFS_SHOW_SUPER_PROG btrfs-show-super
> +

And here.  Thanks,

Josef

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
