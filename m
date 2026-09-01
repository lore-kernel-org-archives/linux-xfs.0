Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C28C44A3F2;
	Tue,  1 Sep 2026 19:58:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788292692; cv=none; b=Rm414w4MI0KfBPDCr0iPRkQKb6Jzf7KwUCVbZPbwXN/lL90S3EgbARhYkXQaunHGW2YkYUoxNWfjquPbborJZRVP/7AboTiuCUoZMmO8+fkMZnx5jg+2pJJEohqV7pOJrKFcHSTgWjHFLBztBL7BD99olUhi/XD/2kkThqPyBIs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788292692; c=relaxed/simple;
	bh=jxIoMKgQKfTuXZhf/++xAJxD/vHSt4GYcTSNajG1MqY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Q1xFjxQMMgDx/9gA/1E6kLFDBE7k7zrYaDYRbR7FvhIPvy9EK8/bJ2/N4hiAEiziJLonlFo2QtBX2EmRI2/U+8o9FZJfrCtUc+WJeVteb/0gwYOaFs1S0RE/vGE//hQ+SACq8n5Wi+2EKOIQiPFDZjQsLznsSaxzq9uP3q8OuE8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ocFAwi15; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ocFAwi15"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C09D1F000E9;
	Tue,  1 Sep 2026 19:58:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788292691;
	bh=ij+RaZuUIWRiCjL0nI/h+7wKgnRZp1L6f1CjhNM5zVo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=ocFAwi156ylXQHivyB1T53VDvxvIaFeaUjBs7XcD+8upgoyQwDbSJZkeej9aBhTvx
	 EmjaopP1sXWKoE3aMjKZltjlmt2kBrvtt24+d+2ucRBqYuxHuj07Klkt8kYffbwEf+
	 aH17rX7se1WYrWmg3pT+Bo2pgWEDwtv6w0k2l0rQFH9rFkQI0SGwqTZegyPg35INOi
	 nkShNIIr1gO8uIDK2cNtXhavHe1shssbFX0mK11PkuwmtWsqRCXIldN4ZJvq7Ko2xi
	 OnoXmaxOrTKJ/jm6ZwE7Omg++i/b8Ds0UaM5cl57CGWo16zlADnAmwTx1djH7iizRQ
	 5dlu1NunEP6NA==
Date: Wed, 2 Sep 2026 03:58:04 +0800
From: Zorro Lang <zlang@kernel.org>
To: Anand Jain <asj@kernel.org>
Cc: fstests@vger.kernel.org, linux-btrfs@vger.kernel.org, 
	linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org, 
	linux-f2fs-devel@lists.sourceforge.net, djwong@kernel.org
Subject: Re: [PATCH v8 10/13] fstests: verify IMA isolation on cloned
 filesystems
Message-ID: <apcmEu9jmi3wljdW@zlang-mailbox>
Mail-Followup-To: Anand Jain <asj@kernel.org>, fstests@vger.kernel.org, 
	linux-btrfs@vger.kernel.org, linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org, 
	linux-f2fs-devel@lists.sourceforge.net, djwong@kernel.org
References: <cover.1784949154.git.asj@kernel.org>
 <e2ba3b5cf7e17bf87e7e832222d72bcbf8b904f8.1784949155.git.asj@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e2ba3b5cf7e17bf87e7e832222d72bcbf8b904f8.1784949155.git.asj@kernel.org>

On Sat, Jul 25, 2026 at 03:39:07PM +0800, Anand Jain wrote:
> Add testcase to verify IMA measurement isolation when multiple devices
> share the same FSUUID.
> 
> Signed-off-by: Anand Jain <asj@kernel.org>
> ---
>  tests/generic/804     | 108 ++++++++++++++++++++++++++++++++++++++++++
>  tests/generic/804.out |  10 ++++
>  2 files changed, 118 insertions(+)
>  create mode 100644 tests/generic/804
>  create mode 100644 tests/generic/804.out
> 
> diff --git a/tests/generic/804 b/tests/generic/804
> new file mode 100644
> index 000000000000..ced32e6d79dd
> --- /dev/null
> +++ b/tests/generic/804
> @@ -0,0 +1,108 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (c) 2026 Anand Jain <asj@kernel.org>.  All Rights Reserved.
> +#
> +# FS QA Test 804
> +# Verify IMA isolation on cloned filesystems:
> +# . Mount two devices sharing the same FSUUID (cloned).
> +# . Apply an IMA policy to measure files based on that FSUUID.
> +# . Create unique files on each mount point to trigger measurements.
> +# . Confirm the IMA log correctly attributes events to the respective mounts.
> +
> +. ./common/preamble
> +. ./common/filter
> +
> +_begin_fstest auto quick clone
> +
> +_require_test
> +_require_block_device $TEST_DEV
> +_require_loop
> +
> +_fixed_by_fs_commit btrfs xxxxxxxxxxxx \
> +	"btrfs: use on-disk uuid for s_uuid in temp_fsid mounts"
> +_fixed_by_fs_commit btrfs xxxxxxxxxxxx \
> +	"btrfs: derive f_fsid from on-disk fsuuid and dev_t"
> +
> +_cleanup()
> +{
> +	cd /
> +	rm -r -f $tmp.*
> +	_unmount $mnt1 2>/dev/null
> +	_unmount $mnt2 2>/dev/null
> +	_loop_image_destroy "${devs[@]}" 2> /dev/null
> +}
> +
> +# Normalize device names and mount points
> +filter_pool()
> +{
> +	sed -e "s|${devs[0]}|DEV1|g" -e "s|$mnt1|MNT1|g" \
> +	    -e "s|${devs[1]}|DEV2|g" -e "s|$mnt2|MNT2|g" | _filter_spaces
> +}
> +
> +# Core helper to set IMA policy and check measurement logs
> +do_ima()
> +{
> +	local ima_policy="/sys/kernel/security/ima/policy"
> +	local ima_log="/sys/kernel/security/ima/ascii_runtime_measurements"
> +	local fsuuid
> +	local mnt=$1
> +	local enable=$2
> +
> +	# Since the in-memory IMA audit log is only cleared upon reboot,
> +	# use unique random filenames to avoid log collisions.
> +	local foofile=$(mktemp --dry-run foobar_XXXXX)
> +
> +	echo $mnt $enable | filter_pool
> +
> +	[ -w "$ima_policy" ] || _notrun "IMA policy not writable"

How about a _require_security_ima to make sure there's securityfs
and IMA supporting in current kernel.

> +
> +	fsuuid=$(blkid -s UUID -o value ${devs[0]})
> +
> +	# Load IMA policy to measure file access specifically for this
> +	# filesystem UUID.
> +	if [[ $enable -eq 1 ]]; then
> +		echo "measure func=FILE_CHECK fsuuid=$fsuuid" > "$ima_policy" || \

I'm not sure if we should have this test, especially add it into
auto and quick group. Once an IMA policy is loaded, there is no way to
clear or roll it back, and I am concerned it might potentially interfere
with subsequent tests.

Hmm... how about use `unshare` command to rewrite the do_ima as do_ima_in_ns?
For example:
do_ima_in_ns()
{
	...

    unshare -U -m -p --fork --map-root-user bash <<EOF
		mount -t securityfs securityfs /sys/kernel/security
        ima_policy="/sys/kernel/security/ima/policy"
        ima_log="/sys/kernel/security/ima/ascii_runtime_measurements"
        echo "measure func=FILE_CHECK fsuuid=$uuid" > "\$ima_policy" || exit 1
        ...
EOF
    ret=$?
}

Thanks,
Zorro

> +			_notrun "Policy rejected"
> +	fi
> +
> +	# Create a file to trigger measurement and verify its entry in
> +	# the IMA log.
> +	echo "test_data" > $mnt/$foofile
> +
> +	# IMA log extract
> +	grep $foofile "$ima_log" | awk '{ print $5 }' | filter_pool | \
> +						sed "s/$foofile/FOOBAR_FILE/"
> +
> +	echo "dbg: $mnt $fsuuid $foofile" >> $seqres.full
> +	cat $ima_log | tail -1 >> $seqres.full
> +	echo >> $seqres.full
> +}
> +
> +# Initialize loop base and cloned instances
> +devs=()
> +_loop_image_create_clone devs
> +mnt1=$TEST_DIR/$seq/mnt1
> +mnt2=$TEST_DIR/$seq/mnt2
> +mkdir -p $mnt1
> +mkdir -p $mnt2
> +
> +# Concurrently mount both clones
> +_mount $(_common_dev_mount_options) $(_clone_mount_option) ${devs[0]} $mnt1 || \
> +						_fail "Failed to mount dev1"
> +_mount $(_common_dev_mount_options) $(_clone_mount_option) ${devs[1]} $mnt2 || \
> +						_fail "Failed to mount dev2"
> +
> +#  IMA response on baseline and clone configuration
> +do_ima $mnt1 1
> +do_ima $mnt2 0
> +
> +# Cycle mount on the second device.
> +echo mount cycle
> +_unmount $mnt2
> +_mount $mount_opts ${devs[1]} $mnt2 || _fail "Failed to mount dev2"
> +
> +do_ima $mnt1 0
> +do_ima $mnt2 0
> +
> +status=0
> +exit
> diff --git a/tests/generic/804.out b/tests/generic/804.out
> new file mode 100644
> index 000000000000..9804181d6c17
> --- /dev/null
> +++ b/tests/generic/804.out
> @@ -0,0 +1,10 @@
> +QA output created by 804
> +MNT1 1
> +MNT1/FOOBAR_FILE
> +MNT2 0
> +MNT2/FOOBAR_FILE
> +mount cycle
> +MNT1 0
> +MNT1/FOOBAR_FILE
> +MNT2 0
> +MNT2/FOOBAR_FILE
> -- 
> 2.43.0
> 
