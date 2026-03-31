Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 988563EF0BE;
	Tue, 31 Mar 2026 10:00:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774951242; cv=none; b=na4lZ8/xd/bDZSA2wiuEs4hn6bb0Ycw24jaST7wJQodXtN/ukJTw8/maXO+9ZMKNo20/wzVXMKsHtalNDYcDzjNk3OXJEySl1Za+ecg9gFTcpKSgjoqS6X46kcx4JnwWRvRy1DKyY/clgAZp7QtLhgK6SIMTDKRJgo0/4rQr+kQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774951242; c=relaxed/simple;
	bh=kIfAHdgwqSMiKbfTeZE1/gOwbt4WALA+jcJoJHrTTl0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=fVCZazGtZDQfxR+wpbaE1UzfiCp6ebu27gdHPgPloURi7mw7t6KTI7UVVUhIfY2mptNDHeHYsOVl8Ktp+G1Os4NWWhf/A6UArGQaM/G/034DES18b8lymwajJfkgjyWbIbm3wsGZLXofZqYSXz9DAsyZmxXkqvwjzK62OoDxL4c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BohA6NDm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BohA6NDm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 839BBC2BCB4;
	Tue, 31 Mar 2026 10:00:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774951242;
	bh=kIfAHdgwqSMiKbfTeZE1/gOwbt4WALA+jcJoJHrTTl0=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=BohA6NDmte7p+pXfoMdFF4uY4nKchDGhz7V6XsBXh/uJ4G1NmKP6kvk0tlo3MRoEx
	 X4DWpWk/Bbc8mGaF9XWbjv6Alctu4ouKjgblBbD4qZafFPgHqSNq64TcWzucBoYGF5
	 al/5MltbwduoLwTOliNLW9oVF7RP0YW8NBww5hMYFx43M2XPeHE3+9Lra+xLkDDEm5
	 hm9utjqeQnS0ZmsZqSluVuuPNlwrMHqE9jl9kc18VqrXGT6HU7YZD2/5SSK3INbrJf
	 lfhpaqm8YwybVlFUF1B1WYfT2QXxHyjXQD384yGNsqgiy/E8zhlaXHf6hw0vwL5LNw
	 Fzl5RXkRmaDOQ==
Message-ID: <26debf2c-7b0c-49bc-b2e6-fc9eb3d8bde0@kernel.org>
Date: Tue, 31 Mar 2026 19:00:39 +0900
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] xfs: add a test for number of open zones on conventional
 devices
To: Christoph Hellwig <hch@lst.de>, zlang@kernel.org
Cc: djwong@kernel.org, hans.holmberg@wdc.com, fstests@vger.kernel.org,
 linux-xfs@vger.kernel.org
References: <20260330130029.3902654-1-hch@lst.de>
Content-Language: en-US
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <20260330130029.3902654-1-hch@lst.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 3/30/26 22:00, Christoph Hellwig wrote:
> Test that mounts of zoned file systems on conventional devices don't
> create more open zones than allowed when the last blocks in one or more
> zones have been invalidated.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  tests/xfs/4201     | 65 ++++++++++++++++++++++++++++++++++++++++++++++
>  tests/xfs/4201.out |  1 +
>  2 files changed, 66 insertions(+)
>  create mode 100755 tests/xfs/4201
>  create mode 100644 tests/xfs/4201.out
> 
> diff --git a/tests/xfs/4201 b/tests/xfs/4201
> new file mode 100755
> index 000000000000..a1f30cb7e739
> --- /dev/null
> +++ b/tests/xfs/4201
> @@ -0,0 +1,65 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (c) 2026 Christoph Hellwig.
> +#
> +# FS QA Test No. 4201
> +#
> +# Test that mounts of zoned file systems on conventional devices don't create
> +# more open zones than allowed when the last blocks in one or more zones have
> +# been invalidated.
> +#
> +
> +. ./common/preamble
> +_begin_fstest auto quick zone
> +
> +_require_scratch
> +_require_odirect
> +_require_non_zoned_device $SCRATCH_DEV
> +_require_non_zoned_device $SCRATCH_RTDEV
> +
> +open_zones=5
> +blocks=65536
> +bsize=4096
> +
> +zone_size_mib=$((blocks * bsize / 1024 / 1024))
> +file_size_mib=$((zone_size_mib / 2))
> +nr_files=$((open_zones * 3 - 1))
> +
> +echo "zone size: $zone_size_mib" >>$seqres.full
> +echo "file size: $file_size_mib" >>$seqres.full
> +echo "nr files: $nr_files" >>$seqres.full
> +
> +_scratch_mkfs -b size=${bsize} -r zoned=1,rgsize=${blocks}b \
> +	> "$seqres.full" 2>&1
> +_scratch_mount -o max_open_zones=${open_zones}
> +
> +_require_fs_sysfs zoned/nr_open_zones
> +
> +for i in $(seq 1 $nr_files); do
> +	dd if=/dev/zero of=$SCRATCH_MNT/$i bs=1M count=$file_size_mib \
> +		 oflag=direct > /dev/null 2>&1
> +done
> +
> +rm $SCRATCH_MNT/4
> +rm $SCRATCH_MNT/5
> +rm $SCRATCH_MNT/6
> +rm $SCRATCH_MNT/7

Hmmm. I think you should delete odd numbered files only since they are going to
be written at the end of a zone. Otherwise, you make the zone empty, and it will
thus not be considered as open.

Something like:

for (( i=0; i<$nr_files; i=$(( i + 2 )) )); do
	rm $SCRATCH_MNT/$(( i + 1))
done

should generate enough open zones.

> +
> +_scratch_unmount
> +_scratch_mount -o max_open_zones=${open_zones}
> +
> +max_open=$(_get_fs_sysfs_attr $SCRATCH_DEV zoned/max_open_zones)
> +nr_open=$(_get_fs_sysfs_attr $SCRATCH_DEV zoned/nr_open_zones)
> +
> +if [ ${max_open} -ne $((open_zones - 1)) ]; then
> +	_fail "Test needs adjustments for multiple open GC zones"
> +fi
> +
> +if [ ${nr_open} -gt ${max_open} ]; then
> +	_fail "Too many open zones: $nr_open/$max_open"
> +fi
> +
> +_scratch_unmount
> +
> +status=0
> +exit
> diff --git a/tests/xfs/4201.out b/tests/xfs/4201.out
> new file mode 100644
> index 000000000000..32e395dd4d6d
> --- /dev/null
> +++ b/tests/xfs/4201.out
> @@ -0,0 +1 @@
> +QA output created by 4201


-- 
Damien Le Moal
Western Digital Research
