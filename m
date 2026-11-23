Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795460188;
	b=vz3UvQ0nwIIp5B73SK6FyRqbotFkZJi1XK/+wKodrxjJkQLSz9wQJGJhlMdcrLU1DzvO
	 zqM8O4/MugfG5FitsYHm5VbLABnwxipI8KiqcWWxSOsG46QjES1S91pccX366K7nSqXbx
	 COWfmc1i02/qF2Tps4X4dE3Mg+ZF9OgfASknMPS0G4IgrqshenpSuF9+W2YtcQSy8vvKX
	 LA8QULGjwQzm2FxM2YpiAhaDf6Kvl1EQs4e7z0ZvyvlAL1bHdx5UzHBQILzVTNSL0HMXg
	 XIq0FLhSynI3mhGfWjIgOsOhEXAKhepobgIDMa48CriWoNtH5frsfI2O+fWP+9MkPTw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795460188;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 Mail-Followup-To:References:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To;
	bh=W843qhYFyVrdU+PtZ2yKDlnLUyTuEyPwzJ4NhBbmx9g=;
	b=iDJKLESfW1b/a6HvS4CZkLPOxJKbzGQtwNlZi1KwD4CwHQ3YF1jVN0aNQQEeqAGJg8Mm
	 1Hi9hzQ512q5jlKAsBXouaJ5cT+uZqgEJ5S032/MHUVaR48TW0mXcZA+fnkN4Qt7ZbcHS
	 t3kC4RikM/ryNorltlDAF46El7flFhZZzr7tsAq5KZ4qmBK8+5xQLhkyuNX3n9mE0S082
	 CkVlkLfnQXXHNU+hzYfCof10O49nFrGbDY1JlcwFW9Mx7LRPgcJ7mDVWf8UFBDJbvKjHd
	 N44/rbiX5iiPIhT+6U+xZ/2DbDk6m24T0Yx/Xvro8Ypxs6up7Vd6bih/oF8S4Z1RS3Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Bo4+HgPQ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE4B5606A31A;
	Mon, 23 Nov 2026 18:56:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Bo4+HgPQ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9CEA1F000CA;
	Mon, 23 Nov 2026 18:56:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795460188;
	bh=W843qhYFyVrdU+PtZ2yKDlnLUyTuEyPwzJ4NhBbmx9g=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Bo4+HgPQ2bW4OmWwC5qp1hehI5W6L0H1BvsP+nUaw4np6xYqVpvr7ke+jJdQcvmt4
	 LcmAGQ38zwZNlImDI6gRNoeKurokwIL9IN10OXq656UWcpf+XJ/XpRzWR05Zjh1yev
	 GxLtclDcGg7/nXOXbJCxjOLO9qeyx9S41n5v092uoAn0ErIWbdDRVSztqcSysc8vwh
	 twYJd4H9af4ECwIIk2WRgpRJuVF9sOXpiRxHo5PipNrIYt+0itDSV7Rfo84EaNY6D/
	 gmHqEolg/hX4sX29l73g8qpUaj52GG/NuJchi0wy1N06oZ8YNvQAgkFi/XXEloL88B
	 6bGhqAYfzMvPQ==
Date: Tue, 24 Nov 2026 02:56:19 +0800
From: Zorro Lang <zlang@kernel.org>
To: Anand Jain <asj@kernel.org>
Cc: fstests@vger.kernel.org, linux-btrfs@vger.kernel.org, 
	linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org, 
	linux-f2fs-devel@lists.sourceforge.net
Subject: Re: [PATCH 14/21] fstests: verify IMA isolation on cloned filesystems
Message-ID: <awSK8y1srBdq2eds@zlang-mailbox>
Mail-Followup-To: Anand Jain <asj@kernel.org>, fstests@vger.kernel.org, 
	linux-btrfs@vger.kernel.org, linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org, 
	linux-f2fs-devel@lists.sourceforge.net
References: <cover.1791272793.git.asj@kernel.org>
 <ed4b48e156ccad10cff02f17ece3c624cc9dd749.1791272793.git.asj@kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ed4b48e156ccad10cff02f17ece3c624cc9dd749.1791272793.git.asj@kernel.org>

On Tue, Oct 06, 2026 at 04:55:40PM +0800, Anand Jain wrote:
> Add testcase to verify IMA measurement isolation when multiple devices
> share the same FSUUID.
> 
> Signed-off-by: Anand Jain <asj@kernel.org>
> ---

Regarding this IMA test, I still have some concerns about the fact that it
modifies system settings irreversibly. If you want to get the rest of this
patchset merged faster, I suggest splitting this patch (along with the
previous patch it depends on) out of the series, and sending this test case
separately for further review once the main patchset is merged.

This will also help speed up the merging of the rest of this patchset :)

Thanks,
Zorro

>  tests/generic/904     | 113 ++++++++++++++++++++++++++++++++++++++++++
>  tests/generic/904.out |  10 ++++
>  2 files changed, 123 insertions(+)
>  create mode 100644 tests/generic/904
>  create mode 100644 tests/generic/904.out
> 
> diff --git a/tests/generic/904 b/tests/generic/904
> new file mode 100644
> index 000000000000..d8412d0bc402
> --- /dev/null
> +++ b/tests/generic/904
> @@ -0,0 +1,113 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (c) 2026 Anand Jain <asj@kernel.org>.  All Rights Reserved.
> +#
> +# FS QA Test No. 904
> +# Verify IMA isolation on cloned filesystems:
> +# . Mount two devices sharing the same FSUUID (cloned).
> +# . Apply an IMA policy to measure files based on that FSUUID.
> +# . Create unique files on each mount point to trigger measurements.
> +# . Confirm the IMA log correctly attributes events to the respective mounts.
> +
> +. ./common/preamble
> +. ./common/filter
> +
> +_begin_fstest tempfsid
> +
> +_require_test
> +_require_loop
> +_require_security_ima
> +
> +_fixed_by_fs_commit btrfs df84f6c77377 \
> +	"btrfs: use on-disk uuid for s_uuid in temp_fsid mounts"
> +_fixed_by_fs_commit btrfs c2a74ed0494c \
> +	"btrfs: derive f_fsid from on-disk fsuuid and dev_t"
> +_fixed_by_fs_commit btrfs 72de4807ba84 \
> +	"btrfs: derive f_fsid with dev_t only when temp_fsid is active"
> +
> +_cleanup()
> +{
> +	cd /
> +	rm -r -f $tmp.*
> +	_unmount $mnt1 2>/dev/null
> +	_unmount $mnt2 2>/dev/null
> +	_destroy_cloned_loop_devs "${devs[@]}" 2> /dev/null
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
> +	fsuuid=$(blkid -s UUID -o value ${devs[0]})
> +
> +	# Load IMA policy to measure file access specifically for this
> +	# filesystem UUID.
> +	if [[ $enable -eq 1 ]]; then
> +		echo "measure func=FILE_CHECK fsuuid=$fsuuid" > "$ima_policy" || \
> +			_fail "Policy rejected"
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
> +	tail -1 "$ima_log" >> $seqres.full
> +	echo >> $seqres.full
> +}
> +
> +# Core helper to set IMA policy and check measurement logs
> +
> +rm -rf $TEST_DIR/$seq 2>/dev/null
> +mkdir -p $TEST_DIR/$seq
> +
> +# Initialize loop base and cloned instances
> +devs=()
> +_create_cloned_loop_devs devs
> +mnt1=$TEST_DIR/$seq/mnt1
> +mnt2=$TEST_DIR/$seq/mnt2
> +mkdir -p $mnt1
> +mkdir -p $mnt2
> +
> +# Concurrently mount both clones
> +_mount $(_common_dev_mount_options) $(_clone_mount_options) ${devs[0]} $mnt1 || \
> +						_fail "Failed to mount dev1"
> +_mount $(_common_dev_mount_options) $(_clone_mount_options) ${devs[1]} $mnt2 || \
> +						_fail "Failed to mount dev2"
> +
> +#  IMA response on baseline and clone configuration
> +do_ima $mnt1 1
> +do_ima $mnt2 0
> +
> +# Cycle mount on the second device.
> +echo mount cycle
> +_unmount $mnt2
> +_mount $(_common_dev_mount_options) $(_clone_mount_options) ${devs[1]} $mnt2 || \
> +						_fail "Failed to mount dev2"
> +
> +do_ima $mnt1 0
> +do_ima $mnt2 0
> +
> +_exit 0
> diff --git a/tests/generic/904.out b/tests/generic/904.out
> new file mode 100644
> index 000000000000..22340f236a45
> --- /dev/null
> +++ b/tests/generic/904.out
> @@ -0,0 +1,10 @@
> +QA output created by 904
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
