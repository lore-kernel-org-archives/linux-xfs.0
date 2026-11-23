Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795461533;
	b=jl2r+c2j/5jfya1WDGQYZ0Zmq5D2wQMSPjmIYh8asRor1B6LJ7WRX0sLXXOmjEdHgtk9
	 7ro+DnDpbFGmZviRF5ZOpWf2IuEVY6+I/NApEcnzNCX1WFvK2o3UTBEP3tOQ4vwWDGdbk
	 5bjF9Aq9Atl2N3Tgb/SUVtTq+VEBu/NiFVKz+8cWW4S4ujxV3RIr85j+xuH8FYgVXJTjp
	 sKn2tYJEzD3fGWlGSglvyCUlFNfWcsuOEgU5SVog4ottBQ5cDZfTL2OOZU61fuKl6WS8R
	 QteO7LapT5oV6Id8UMJ/gEXJIzhfPNqrhJH292d5/iuug1YTwbWvh5lkEqZ/bz4ZqTg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795461533;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 Mail-Followup-To:References:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To;
	bh=/GLZp1BMV/knfxh1EGIGcBPe8IPdbsKAYtyB5Pymdzw=;
	b=qsZ2x4yHDKO7sun9R5ZIDPT8by82TqjvEtsBastUe5KiWWXPUTgRAHtYcPzxuR76FdJr
	 ZtTiRqCgD2a58VlYfDpZITswPvwPU1kEOEFZhtnJoLasnEGIeUB6FBL0VgUIeaPs3O/pY
	 3iZZpqp6gUkKoLhWTH6YzOnyiauBPsN/wT5uPJbr8nJwn4UEJID+bdbxb/0uxYhqOOe82
	 WqNHIQsHxiMhUD7hI18gIY5qYbO8Yb64tirRiS3/37ZI0O2GY4sRsMeDYYfi4xnGV8qOy
	 8vDu8F0zbVnoo5UJaQs9xKZZdlTHGT+UprDRLXcCwx3rVK4Z3531PKpnL7VM7zzzxXg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=PEMxZX2l;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF39E606A686;
	Mon, 23 Nov 2026 19:18:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=PEMxZX2l
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 178051F000EE;
	Mon, 23 Nov 2026 19:18:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795461532;
	bh=/GLZp1BMV/knfxh1EGIGcBPe8IPdbsKAYtyB5Pymdzw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=PEMxZX2lLAmo+0xpH03+7EwrZli3yKCNROivpy/DKjqvU2I8xNWpyDUV3TqDAWgpz
	 ltZrbKxcY1uUsa++BPx7w/1Cio3WhGQRPZ3iao/GLTV0YzQydv4hZto/RPV6vhiYA2
	 z4zSShRvWK4DAxYwSfe6o2HVw7m+MKqvZF9b03W17PlDugn/06uxSIlnO1mMim3xMY
	 eX96HQnIRaV1dSYEcW5midq+ZWsr4zoi39lr2JAdEve9+KeUN+AYE2xssWiqr8RlOu
	 bE7sriTUbficy6rw2nCIn+u9onK3qiCOK3A/KXnRZaA+ksELplTgsxZlezyXW4DIBk
	 gYK44SF7EQOEQ==
Date: Tue, 24 Nov 2026 03:18:43 +0800
From: Zorro Lang <zlang@kernel.org>
To: Anand Jain <asj@kernel.org>
Cc: linux-btrfs@vger.kernel.org, linux-ext4@vger.kernel.org, 
	linux-xfs@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, fstests@vger.kernel.org
Subject: Re: [PATCH 0/21] fstests: tests for cloned filesystem validation and
 f_fsid
Message-ID: <awSPgGGZv7u6_SGM@zlang-mailbox>
Mail-Followup-To: Anand Jain <asj@kernel.org>, linux-btrfs@vger.kernel.org, 
	linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org, 
	linux-f2fs-devel@lists.sourceforge.net, fstests@vger.kernel.org
References: <cover.1791272793.git.asj@kernel.org>
 <768152d1-4215-4f27-a3ca-50252c5b5d9a@kernel.org>
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
In-Reply-To: <768152d1-4215-4f27-a3ca-50252c5b5d9a@kernel.org>

On Mon, Nov 23, 2026 at 10:01:03AM +0800, Anand Jain wrote:
> Zorro,
> 
>  Could we merge the patches in stages? What's your plan?

Hi Anand,

Sorry for the long delay in reviewing v9 since the last round. The review
queue has been getting quite heavy lately, so large patchsets with a lot
of changes often end up getting pushed back. I just did a quick, high-level
review of this series. If you agree to drop the two IMA-related patches from
the next version (and send them separately later), that should help get the
rest of this patchset merged much faster :)

Thanks,
Zorro

> 
> Regards, Anand
> 
> 
> On 6/10/26 16:55, Anand Jain wrote:
> > This series continues the work from the earlier "test coverage for cloned
> > filesystem ids" series (last posted as v8 [1]) and has been tested against
> > the major filesystems: Btrfs, XFS, ext4, and f2fs.
> > 
> > Although this version incorporates the review feedback received on v8, it
> > expands substantially with additional infrastructure helpers, an extra test
> > case to cover the recent regression report, and migration/cleanup of
> > existing generic/744. Because the patch count grew from 13 to 21 patches,
> > disrupting the previous patch numbering and scope, I have reset the
> > versioning and updated the subject line to better reflect the broader
> > validation coverage.
> > 
> > The core motivation remains identical: testing that mounting a block-level
> > cloned filesystem concurrently with the original filesystem behaves
> > correctly across filesystems and VFS subsystems (fanotify, statfs/f_fsid,
> > libblkid resolution, IMA measurement, exportfs file handles, and
> > metadata_uuid handling).
> > 
> > Summary of major changes since v8:
> > - Added 1 new regression test case to verify statfs f_fsid derivation against FS UUID.
> > - Dropped the test case verifying f_fsid persistence across mount cycles on
> >   cloned filesystems, as this assumption is no longer valid following the Btrfs kernel
> >   regression fix [2].
> > - Introduced common helpers:
> >   . _require_security_ima() and _require_metadata_uuid().
> >   . _scratch_mkfs_uuid() and helpers for f_fsid verification.
> > - Migrated generic/744 to utilize the new common clone helpers.
> > - Worked on the review comments.
> > 
> > Details of changes:
> > - _create_cloned_loop_devs():
> >   . Renamed from _loop_image_create_clone() to _create_cloned_loop_devs().
> >   . Relocated backing image files from "$TEST_DIR/${seq}.*" to a dedicated
> >     directory "$TEST_DIR/${seq}/*".
> >   . Added internal call to _require_clone_mount().
> >   . Switched from _create_loop_device() to _create_loop_device_like_bdev()
> >     to guarantee identical logical/physical sector sizes (512 vs 4096)
> >     between the original and cloned loop devices.
> >   . Used an intermediate local setup step to ensure consistent Direct I/O
> >     attributes across both loop devices (preventing the first device from
> >     enabling DIO while the cloned device fell back to buffered mode).
> >   . Added device geometry and DIO attribute dump to $seqres.full for debugging.
> >   . Renamed teardown helper _loop_image_destroy() to _destroy_cloned_loop_devs().
> > - _clone_mount_options():
> >   . Renamed from _clone_mount_option() to _clone_mount_options().
> > - _require_metadata_uuid():
> >   . Factored out prerequisite checks from _change_metadata_uuid() into a new
> >     dedicated helper _require_metadata_uuid() and invoked it accordingly.
> > - _require_clone_mount():
> >   . Introduced new helper to check kernel support for concurrent clone mounts.
> >   . Removed obsolete _require_duplicate_fsid() in favor of _require_clone_mount().
> > - _require_security_ima():
> >   . Introduced new helper to check securityfs and IMA policy availability.
> > - _create_loop_device_like_bdev():
> >   . Removed unused local variable 'dev'.
> > 
> > - Test Cases common update:
> >   - Adjusted test groups: replaced 'clone' with 'tempfsid'.
> >   - Standardized test exits: replaced open-coded "status=0; exit" with "_exit 0".
> >   - Dropped stale "_require_block_device $TEST_DEV" checks left over from before
> >     migrating tests to loop devices.
> >   - Percolated helper renames across all tests:
> >     . _loop_image_create_clone -> _create_cloned_loop_devs
> >     . _loop_image_destroy      -> _destroy_cloned_loop_devs
> >     . _clone_mount_option      -> _clone_mount_options
> >   - Added cleanup of "$TEST_DIR/$seq" in test exit/cleanup handlers.
> > 
> > - Test Cases Individual Updates:
> >   - generic/744:
> >     . Replaced _require_duplicate_fsid with _require_clone_mount().
> >     . Migrated to common _create_cloned_loop_devs() and _clone_mount_options().
> >   - generic/902:
> >     . New regression test case added to verify statfs f_fsid derivation against filesystem UUID.
> >   - generic/903:
> >     . Added --noheadings flag to findmnt queries for cleaner output parsing.
> >   - generic/904:
> >     . Dropped 'auto' and 'quick' from test groups due to runtime and policy requirements.
> >     . Updated referenced kernel commit IDs.
> > 
> > [1] https://lore.kernel.org/fstests/cover.1784949154.git.asj@kernel.org
> > [2] 72de4807ba84 ("btrfs: derive f_fsid with dev_t only when temp_fsid is active")
> > 
> > Anand Jain (21):
> >   fstests: introduce _require_clone_mount() helper
> >   fstests: introduce _create_cloned_loop_devs() helper
> >   fstests: add _clone_mount_options() helper
> >   fstests: add FSNOTIFYWAIT_PROG
> >   fstests: add _require_fanotify_function
> >   fstests: add _require_unique_f_fsid() helper
> >   fstests: add SEMANAGE_PROG
> >   fstests: verify fanotify isolation on cloned filesystems
> >   fstests: introduce helper _scratch_mkfs_uuid()
> >   fstests: add helpers to verify the expected f_fsid
> >   fstests: verify statfs f_fsid is derived from the filesystem UUID
> >   fstests: verify libblkid resolution of duplicate UUIDs
> >   fstests: introduce _require_security_ima() helper
> >   fstests: verify IMA isolation on cloned filesystems
> >   fstests: verify exportfs file handles on cloned filesystems
> >   fstests: introduce _require_metadata_uuid() helper
> >   fstests: add _change_metadata_uuid helper
> >   fstests: test UUID consistency for clones with metadata_uuid
> >   fstests: generic/744: use new helper _require_clone_mount()
> >   fstests: generic/744: migrate to _create_cloned_loop_devs()
> >   fstests: _create_loop_device_like_bdev() remove unused variable
> > 
> >  common/config         |   2 +
> >  common/rc             | 262 +++++++++++++++++++++++++++++++++++++++---
> >  tests/generic/744     |  72 +++++-------
> >  tests/generic/901     | 142 +++++++++++++++++++++++
> >  tests/generic/901.out |   7 ++
> >  tests/generic/902     |  38 ++++++
> >  tests/generic/902.out |   2 +
> >  tests/generic/903     |  71 ++++++++++++
> >  tests/generic/903.out |   6 +
> >  tests/generic/904     | 113 ++++++++++++++++++
> >  tests/generic/904.out |  10 ++
> >  tests/generic/905     |  79 +++++++++++++
> >  tests/generic/905.out |   2 +
> >  tests/generic/906     |  74 ++++++++++++
> >  tests/generic/906.out |   6 +
> >  15 files changed, 827 insertions(+), 59 deletions(-)
> >  create mode 100644 tests/generic/901
> >  create mode 100644 tests/generic/901.out
> >  create mode 100644 tests/generic/902
> >  create mode 100644 tests/generic/902.out
> >  create mode 100644 tests/generic/903
> >  create mode 100644 tests/generic/903.out
> >  create mode 100644 tests/generic/904
> >  create mode 100644 tests/generic/904.out
> >  create mode 100644 tests/generic/905
> >  create mode 100644 tests/generic/905.out
> >  create mode 100644 tests/generic/906
> >  create mode 100644 tests/generic/906.out
> > 
> 
