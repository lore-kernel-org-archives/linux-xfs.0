Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34D4035C190;
	Sun, 27 Sep 2026 04:41:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790484112; cv=none; b=gVXcyec0gLozsU1b1j5ExthVxbmwbuVSZ1W59j9peznJ0rLFUtiOatie5ATBtZJ9NnT+1VJPCRHNpmGJPSce2QUeMde1nC//WXxohap3mmPOgtFn/5qRznu+OuVcrp36pyZQBFOeFBaiGeGnRHRNUfsYolLl3mF+xFLrWiQQTmE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790484112; c=relaxed/simple;
	bh=BCmvmIPycufiDbqYRFd7agbH7SezLZIUFfJ6aBXnTe0=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:Cc:From:
	 In-Reply-To:Content-Type; b=gvzqT5GMMxXqhn+v+Dr2Vktyz3N+x+i4EhBquqCZ9Hyc4VE7sVXntcoyAj4YHGxw49CojFJ8rxx/RY1oRuiLSi7EEyCgS9HCHm4FJFD0ns18Io0ZshZV6NQQPPKi5lOxuY75hjfBzZVpiGLRr8BLZHTDMHHQ9BTEPInoo/Aj1vQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FmEWgzZu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FmEWgzZu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09BAE1F000FF;
	Sun, 27 Sep 2026 04:41:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790484110;
	bh=CwYGQ6//XvmoC9XXOlg9N3vwNJXULVBDjUKZ/NR5Jik=;
	h=Date:Subject:To:References:Cc:From:In-Reply-To;
	b=FmEWgzZu2iIqHudbnY7s4EIyHISO/RClDFhQxQNZXtJ4pl/jt2aDYBEGk4FK9GM3L
	 ErcYKpXKJIIFSVE/7kLMOlXNhU2TRD+39u2uZ1qWtTzRyYgxOhQFIUcTVm8rKDlu4/
	 mNpkOz/jakDzEH+WbC782JF0UrZzFPy42s472izsL9WAqBGbvuBt/JKC9+MlrziDCR
	 jkpzzrofJI2seTLjHBZ0rJtKvQiDAzAZ8BZuEuk9KT0jq3fYM+0bSv47u1KHh08XsS
	 M+PJx2hviLaPjYf8e7CTnrPIPi7zDEOiRFuuqbRnBTDfW9zkfOclwASFFtE+II8Rwj
	 QME1smLnzWHAg==
Message-ID: <ea5b61d4-0cba-4afc-b5e0-8720d4717872@kernel.org>
Date: Sun, 27 Sep 2026 12:41:46 +0800
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 13/13] fstests: test UUID consistency for clones with
 metadata_uuid
To: Zorro Lang <zlang@kernel.org>
References: <cover.1784949154.git.asj@kernel.org>
 <905a961a3bb2ec345285f056053e3016ad3bef6e.1784949155.git.asj@kernel.org>
 <apc5PMJFYtrUyG8U@zlang-mailbox>
Content-Language: en-US
Cc: fstests@vger.kernel.org, linux-btrfs@vger.kernel.org,
 linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
 linux-xfs@vger.kernel.org, djwong@kernel.org
From: Anand Suveer Jain <asj@kernel.org>
In-Reply-To: <apc5PMJFYtrUyG8U@zlang-mailbox>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 2/9/26 04:51, Zorro Lang wrote:
> On Sat, Jul 25, 2026 at 03:39:10PM +0800, Anand Jain wrote:
>> Btrfs and xfs uses the metadata_uuid superblock feature to change the
>> on-disk UUID without rewriting every block header. This patch adds a
>> sanity check to ensure UUID consistency when a filesystem with
>> metadata_uuid enabled is cloned.
>>
>> Signed-off-by: Anand Jain <asj@kernel.org>
>> ---
>>  tests/generic/806     | 74 +++++++++++++++++++++++++++++++++++++++++++
>>  tests/generic/806.out |  6 ++++
>>  2 files changed, 80 insertions(+)
>>  create mode 100644 tests/generic/806
>>  create mode 100644 tests/generic/806.out
>>
>> diff --git a/tests/generic/806 b/tests/generic/806
>> new file mode 100644
>> index 000000000000..6d3166491006
>> --- /dev/null
>> +++ b/tests/generic/806
>> @@ -0,0 +1,74 @@
>> +#! /bin/bash
>> +# SPDX-License-Identifier: GPL-2.0
>> +# Copyright (c) 2026 Anand Jain <asj@kernel.org>.  All Rights Reserved.
>> +#
>> +# FS QA Test 806
>> +#
>> +# Verify that the cloned filesystem UUID remains consistent, even when the
>> +# `metadata_uuid` feature is enabled.
>> +#
>> +
>> +. ./common/preamble
>> +. ./common/filter
>> +
>> +_begin_fstest auto quick mount clone
>> +
>> +_require_test
>> +_require_block_device $TEST_DEV
>> +_require_loop
>> +
>> +_cleanup()
>> +{
>> +	cd /
>> +	rm -r -f $tmp.*
>> +	umount $mnt1 $mnt2 2>/dev/null
>> +	_loop_image_destroy "${devs[@]}" 2> /dev/null
>> +}
>> +
>> +filter_pool()
>> +{
>> +	sed -e "s|${devs[0]}|DEV1|g" -e "s|${mnt1}|MNT1|g" \
>> +	    -e "s|${devs[1]}|DEV2|g" -e "s|${mnt2}|MNT2|g" | _filter_spaces
>> +}
>> +


>> +# Create base loop device and its clone, applying the metadata_uuid tuning
>> +# callback to the base filesystem before the copy occurs.
>> +devs=()
>> +_loop_image_create_clone devs _change_metadata_uuid
> 
> Should we have and run a _require_metadata_uuid before changing it?
> As I know, btrfs can do `_require_btrfs_fs_feature metadata_uuid`.
> 

_require_metadata_uuid() is better than doing the same thing within
_change_metadata_uuid(). Now _change_metadata_uuid() calls
_require_metadata_uuid(), as shown below.


_require_metdata_uuid()
{
        case $FSTYP in
        xfs)
                _require_command "$XFS_ADMIN_PROG" "xfs_admin"
                ;;
        btrfs)
                _require_btrfs_fs_feature "metadata_uuid"
                _require_command "$BTRFS_TUNE_PROG" "btrfstune"
                ;;
        *)
                _notrun "Require filesystem with metadata_uuid feature"
                ;;
        esac
}


_change_metadata_uuid()
{
        local dev=$1

        _require_metdata_uuid

        case $FSTYP in
        xfs)
                $XFS_ADMIN_PROG -U generate $dev >> $seqres.full
                ;;
        btrfs)
                $BTRFS_TUNE_PROG -m $dev
                ;;
        esac
}



>> +mkdir -p $TEST_DIR/$seq
>> +mnt1=$TEST_DIR/$seq/mnt1
>> +mnt2=$TEST_DIR/$seq/mnt2
>> +mkdir -p $mnt1
>> +mkdir -p $mnt2
>> +
>> +# Get the uuid from the source device
>> +fsuuid=$(blkid -s UUID -o value ${devs[0]})
>> +
>> +# Mount both clone and baseline
>> +_mount $(_common_dev_mount_options) $(_clone_mount_option) ${devs[0]} $mnt1 || \
>> +						_fail "Failed to mount dev1"
>> +_mount $(_common_dev_mount_options) $(_clone_mount_option) ${devs[1]} $mnt2 || \
>> +						_fail "Failed to mount dev2"
>> +
>> +findmnt -o SOURCE,TARGET,UUID "${devs[0]}" | tail -n +2 | \
>> +				sed -e "s/${fsuuid}/FSUUID/g" | filter_pool
>> +findmnt -o SOURCE,TARGET,UUID "${devs[1]}" | tail -n +2 | \
>> +				sed -e "s/${fsuuid}/FSUUID/g" | filter_pool
>> +
>> +# Cycle mounts and reverse the initialization order to ensure UUID tracking
>> +# doesn't mismatch or flip when metadata_uuid optimization is active.
>> +echo "**** mount cycle ****"
>> +_unmount $mnt1
>> +_unmount $mnt2
>> +_mount $(_common_dev_mount_options) $(_clone_mount_option) ${devs[1]} $mnt2 || \
>> +						_fail "Failed to mount dev2"
>> +_mount $(_common_dev_mount_options) $(_clone_mount_option) ${devs[0]} $mnt1 || \
>> +						_fail "Failed to mount dev1"
>> +
>> +findmnt -o SOURCE,TARGET,UUID "${devs[0]}" | tail -n +2 | \
>> +				sed -e "s/${fsuuid}/FSUUID/g" | filter_pool
>> +findmnt -o SOURCE,TARGET,UUID "${devs[1]}" | tail -n +2 | \
>> +				sed -e "s/${fsuuid}/FSUUID/g" | filter_pool
>> +
>> +status=0
>> +exit
>> diff --git a/tests/generic/806.out b/tests/generic/806.out
>> new file mode 100644
>> index 000000000000..918f422ecddf
>> --- /dev/null
>> +++ b/tests/generic/806.out
>> @@ -0,0 +1,6 @@
>> +QA output created by 806
>> +DEV1 MNT1 FSUUID
>> +DEV2 MNT2 FSUUID
>> +**** mount cycle ****
>> +DEV1 MNT1 FSUUID
>> +DEV2 MNT2 FSUUID
>> -- 
>> 2.43.0
>>

