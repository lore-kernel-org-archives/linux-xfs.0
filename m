Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795399268;
	b=YUz9GkMbE5Ipv2rihyqAAwWFufPAgIMuBCo8KQ8JW9/jS1oi9L45ugkAKxR9D3JTSDYC
	 N+GKibVc5k4jER7dm7TjtMbcP3LAXGZVys/7KtaiKx65Lr1kO6bvSm8EQpvtz1uUkyX/B
	 wdpn8LsVEbsNYpuZXRkKhggMNiVRLmGk7DdB6u5nwsD7H4rtK0ozABcMd6D47xHPgPNAb
	 yG0B5EsNGkyGVvw2fem/owIFFZaYgOyP+cOkDpVzI0h6UuHV8HKpJTERleSRwJLI4uHIP
	 +4U62tmgLIQw8tU93YBJA4Uu5A7MeJtU3vHjDhkLKJ/+s29N16Zutl2LXUssej1IzeA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795399268;
	h=Received:DKIM-Signature:Message-ID:Date:MIME-Version:User-Agent:
	 Subject:From:To:Cc:References:Content-Language:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding;
	bh=m+gc+znZc0DYq0MzYS52FeXlxJDAFGgMkyRwnibnHlM=;
	b=ompSdCHXV+j7pVNlQlX66opwsC0DCgBmIbbm6w4DvgyOHR8yO15uKx+8PihRus36wkDF
	 QowoShNWD03Y00sR4gjowrtJqKK+KZKNdG9ws3DnRk9g54WeXw+mvQwdjqsPUGcx9RqbE
	 qDHtrOXhe28xoXsFEfogYm0C8PFmYZXkInrqj+jXkromcCItnW7FamaS/FkfHD31gvY9i
	 0SlJbAVvsP0Csu5J7SCSR/7RCtXl+unCHVXb83KtB8HLNxhOHgXaJjyrAz4Fb/iUBY/5G
	 cShysmaTMAyraT/5bYk6T6QiQyyHZ/U3d42mJBxF17QkZ5aeDgMlZVigwc4lufC5irA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ObsSb+Cv;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AC7D606A31A;
	Mon, 23 Nov 2026 02:01:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ObsSb+Cv
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E04E1F000C6;
	Mon, 23 Nov 2026 02:01:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795399267;
	bh=m+gc+znZc0DYq0MzYS52FeXlxJDAFGgMkyRwnibnHlM=;
	h=Date:Subject:From:To:Cc:References:In-Reply-To;
	b=ObsSb+CvUC53o2tazBghu01uT+J9yR3VLwZ7GmvcOhHzyytJOMGBcUGOrB4OFcZJq
	 ZkgqXr8f0jqSOAjLJpLZpjT1YBe8iRJNCelplysa/Ms4+s5NuN8yUUr5ZcASBPhHwU
	 oTOtousKWDJg2UuxResC1TSNneVFiF3TYcdTSxGiNnjVkbw2JplywdCMfXCGaPyWIn
	 CUegc3EfUoCaMnrKD4ctPfONutriIHzcBO9IvQK38Ri+qEFFvZfXuSdQ29EbeT5xSc
	 DMM9ST3EpwWicTrN20MgfifP9+e6B0g88x04Jv/aq1uT7UUDCJbocSM5mOXPhGIXlF
	 xoTGENrztTEOw==
Message-ID: <768152d1-4215-4f27-a3ca-50252c5b5d9a@kernel.org>
Date: Mon, 23 Nov 2026 10:01:03 +0800
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/21] fstests: tests for cloned filesystem validation and
 f_fsid
From: Anand Jain <asj@kernel.org>
To: zlang@kernel.org
Cc: linux-btrfs@vger.kernel.org, linux-ext4@vger.kernel.org,
 linux-xfs@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
 fstests@vger.kernel.org
References: <cover.1791272793.git.asj@kernel.org>
Content-Language: en-US
In-Reply-To: <cover.1791272793.git.asj@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Zorro,

 Could we merge the patches in stages? What's your plan?

Regards, Anand


On 6/10/26 16:55, Anand Jain wrote:
> This series continues the work from the earlier "test coverage for cloned
> filesystem ids" series (last posted as v8 [1]) and has been tested against
> the major filesystems: Btrfs, XFS, ext4, and f2fs.
> 
> Although this version incorporates the review feedback received on v8, it
> expands substantially with additional infrastructure helpers, an extra test
> case to cover the recent regression report, and migration/cleanup of
> existing generic/744. Because the patch count grew from 13 to 21 patches,
> disrupting the previous patch numbering and scope, I have reset the
> versioning and updated the subject line to better reflect the broader
> validation coverage.
> 
> The core motivation remains identical: testing that mounting a block-level
> cloned filesystem concurrently with the original filesystem behaves
> correctly across filesystems and VFS subsystems (fanotify, statfs/f_fsid,
> libblkid resolution, IMA measurement, exportfs file handles, and
> metadata_uuid handling).
> 
> Summary of major changes since v8:
> - Added 1 new regression test case to verify statfs f_fsid derivation against FS UUID.
> - Dropped the test case verifying f_fsid persistence across mount cycles on
>   cloned filesystems, as this assumption is no longer valid following the Btrfs kernel
>   regression fix [2].
> - Introduced common helpers:
>   . _require_security_ima() and _require_metadata_uuid().
>   . _scratch_mkfs_uuid() and helpers for f_fsid verification.
> - Migrated generic/744 to utilize the new common clone helpers.
> - Worked on the review comments.
> 
> Details of changes:
> - _create_cloned_loop_devs():
>   . Renamed from _loop_image_create_clone() to _create_cloned_loop_devs().
>   . Relocated backing image files from "$TEST_DIR/${seq}.*" to a dedicated
>     directory "$TEST_DIR/${seq}/*".
>   . Added internal call to _require_clone_mount().
>   . Switched from _create_loop_device() to _create_loop_device_like_bdev()
>     to guarantee identical logical/physical sector sizes (512 vs 4096)
>     between the original and cloned loop devices.
>   . Used an intermediate local setup step to ensure consistent Direct I/O
>     attributes across both loop devices (preventing the first device from
>     enabling DIO while the cloned device fell back to buffered mode).
>   . Added device geometry and DIO attribute dump to $seqres.full for debugging.
>   . Renamed teardown helper _loop_image_destroy() to _destroy_cloned_loop_devs().
> - _clone_mount_options():
>   . Renamed from _clone_mount_option() to _clone_mount_options().
> - _require_metadata_uuid():
>   . Factored out prerequisite checks from _change_metadata_uuid() into a new
>     dedicated helper _require_metadata_uuid() and invoked it accordingly.
> - _require_clone_mount():
>   . Introduced new helper to check kernel support for concurrent clone mounts.
>   . Removed obsolete _require_duplicate_fsid() in favor of _require_clone_mount().
> - _require_security_ima():
>   . Introduced new helper to check securityfs and IMA policy availability.
> - _create_loop_device_like_bdev():
>   . Removed unused local variable 'dev'.
> 
> - Test Cases common update:
>   - Adjusted test groups: replaced 'clone' with 'tempfsid'.
>   - Standardized test exits: replaced open-coded "status=0; exit" with "_exit 0".
>   - Dropped stale "_require_block_device $TEST_DEV" checks left over from before
>     migrating tests to loop devices.
>   - Percolated helper renames across all tests:
>     . _loop_image_create_clone -> _create_cloned_loop_devs
>     . _loop_image_destroy      -> _destroy_cloned_loop_devs
>     . _clone_mount_option      -> _clone_mount_options
>   - Added cleanup of "$TEST_DIR/$seq" in test exit/cleanup handlers.
> 
> - Test Cases Individual Updates:
>   - generic/744:
>     . Replaced _require_duplicate_fsid with _require_clone_mount().
>     . Migrated to common _create_cloned_loop_devs() and _clone_mount_options().
>   - generic/902:
>     . New regression test case added to verify statfs f_fsid derivation against filesystem UUID.
>   - generic/903:
>     . Added --noheadings flag to findmnt queries for cleaner output parsing.
>   - generic/904:
>     . Dropped 'auto' and 'quick' from test groups due to runtime and policy requirements.
>     . Updated referenced kernel commit IDs.
> 
> [1] https://lore.kernel.org/fstests/cover.1784949154.git.asj@kernel.org
> [2] 72de4807ba84 ("btrfs: derive f_fsid with dev_t only when temp_fsid is active")
> 
> Anand Jain (21):
>   fstests: introduce _require_clone_mount() helper
>   fstests: introduce _create_cloned_loop_devs() helper
>   fstests: add _clone_mount_options() helper
>   fstests: add FSNOTIFYWAIT_PROG
>   fstests: add _require_fanotify_function
>   fstests: add _require_unique_f_fsid() helper
>   fstests: add SEMANAGE_PROG
>   fstests: verify fanotify isolation on cloned filesystems
>   fstests: introduce helper _scratch_mkfs_uuid()
>   fstests: add helpers to verify the expected f_fsid
>   fstests: verify statfs f_fsid is derived from the filesystem UUID
>   fstests: verify libblkid resolution of duplicate UUIDs
>   fstests: introduce _require_security_ima() helper
>   fstests: verify IMA isolation on cloned filesystems
>   fstests: verify exportfs file handles on cloned filesystems
>   fstests: introduce _require_metadata_uuid() helper
>   fstests: add _change_metadata_uuid helper
>   fstests: test UUID consistency for clones with metadata_uuid
>   fstests: generic/744: use new helper _require_clone_mount()
>   fstests: generic/744: migrate to _create_cloned_loop_devs()
>   fstests: _create_loop_device_like_bdev() remove unused variable
> 
>  common/config         |   2 +
>  common/rc             | 262 +++++++++++++++++++++++++++++++++++++++---
>  tests/generic/744     |  72 +++++-------
>  tests/generic/901     | 142 +++++++++++++++++++++++
>  tests/generic/901.out |   7 ++
>  tests/generic/902     |  38 ++++++
>  tests/generic/902.out |   2 +
>  tests/generic/903     |  71 ++++++++++++
>  tests/generic/903.out |   6 +
>  tests/generic/904     | 113 ++++++++++++++++++
>  tests/generic/904.out |  10 ++
>  tests/generic/905     |  79 +++++++++++++
>  tests/generic/905.out |   2 +
>  tests/generic/906     |  74 ++++++++++++
>  tests/generic/906.out |   6 +
>  15 files changed, 827 insertions(+), 59 deletions(-)
>  create mode 100644 tests/generic/901
>  create mode 100644 tests/generic/901.out
>  create mode 100644 tests/generic/902
>  create mode 100644 tests/generic/902.out
>  create mode 100644 tests/generic/903
>  create mode 100644 tests/generic/903.out
>  create mode 100644 tests/generic/904
>  create mode 100644 tests/generic/904.out
>  create mode 100644 tests/generic/905
>  create mode 100644 tests/generic/905.out
>  create mode 100644 tests/generic/906
>  create mode 100644 tests/generic/906.out
> 

