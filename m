Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795460651;
	b=asihq/Hqugi9wpl1ogrd92CmaLUD+jgY2T1CqPJp7zT1P3vtHSHHLu5u1tCxupOZv+m/
	 Yok9jVVupp4CkVhtF8f7wbI1rYHYfy1vaUziP2uOLwIVY+KqpD6CNmiEwpxSY2E491WsX
	 YN8ktWAoRcm7PlYrZqt56X5uezKavqjhTR3H7r6sq5MCe7Y+99Pz+nWW8tMwHhiZ4yArx
	 eNCYWbJAbfzVrudXUMzirT84X7p9StQcDkDAzgbcMGRl9qRs+QShmcM39u2OwyAKKyxDp
	 xFw9+D/qxSgu4bwWMdLZWX67PjLQthHeKAi+TKPUKyQPgLHuioT2kVRfQCIyABUva9A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795460651;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 Mail-Followup-To:References:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To;
	bh=NMWwVWVTeHtMwupcRu9IpvymnFnmUx86vHQQ3BkUYBg=;
	b=BbrXhmx07fm0qZTZBbR+NZpHLLtenkSpFA9KL3FBkqlOIScLdY3QY4nmTsyExYCwpTHf
	 /yQ6eNuUIiM7Apn5Fvv2/x+uehTFzxy3T6N8kJd0HkOEZMyHEy/Qy8ihBHBv3YS+uQPmV
	 dFYzt4p5YoPIIF5neK4ncLSH34D4X7KEmHIXGn/VJQkctUFVhx3aVsKTWiq3+nqVMGLEK
	 c4yoW6ksfun39O1g+0JXuOLiF3bec3PBI+MWA5pvGIReO+GJ3Yz2bkBBAds2LdKWhFFd2
	 ZbjsssJrf2Fv/CX/62R+e9DLrEHctiUDBSYmqHiDb/o/GfJhNt7yzswnxk+8KV+37gg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Xnq9a9ZK;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4473C606A31A;
	Mon, 23 Nov 2026 19:04:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Xnq9a9ZK
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A5E51F000CA;
	Mon, 23 Nov 2026 19:04:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795460650;
	bh=NMWwVWVTeHtMwupcRu9IpvymnFnmUx86vHQQ3BkUYBg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Xnq9a9ZK11s0SNmAZ7xgEwO0fh7NeyaapEmNP9kc2H9GMrqUBCMoNs8QWoEmOQJK/
	 i0TBTHJT9x0IcCRDJkZicqbGHLtigw1i8dW2xpBtrjKxQ0SALBOqi2FPMtuydS35bC
	 M+4RDld7/WsryBfUMBbXhAhFdlBGe6FRJTxcVmMFTUwD3foLAAc2ALqA6xXu4Gj+WJ
	 X/xxJdZgNDnxAHeIg87nPZ30q6s2bcJLCHzITep9njS3B04kLVUOUp5Orkqm17a4ks
	 WWKtuD0fSrVxnBY/t3k/ajG//s6uLoTBq7lSOlxjhxVa4vMKtA9lbnPykCMvZ9Tnvk
	 hFP/CHPS8f0Jw==
Date: Tue, 24 Nov 2026 03:04:02 +0800
From: Zorro Lang <zlang@kernel.org>
To: Anand Jain <asj@kernel.org>
Cc: fstests@vger.kernel.org, linux-btrfs@vger.kernel.org, 
	linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org, 
	linux-f2fs-devel@lists.sourceforge.net
Subject: Re: [PATCH 11/21] fstests: verify statfs f_fsid is derived from the
 filesystem UUID
Message-ID: <awSNZ_Zn4tAT-xYS@zlang-mailbox>
Mail-Followup-To: Anand Jain <asj@kernel.org>, fstests@vger.kernel.org, 
	linux-btrfs@vger.kernel.org, linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org, 
	linux-f2fs-devel@lists.sourceforge.net
References: <cover.1791272793.git.asj@kernel.org>
 <98450cf50f0b962f4b6c2b0a16ec10c47362bccd.1791272793.git.asj@kernel.org>
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
In-Reply-To: <98450cf50f0b962f4b6c2b0a16ec10c47362bccd.1791272793.git.asj@kernel.org>

On Tue, Oct 06, 2026 at 04:55:37PM +0800, Anand Jain wrote:
> On btrfs and ext4, statfs f_fsid is computed from the filesystem UUID,
> so a filesystem created with a known UUID must always report the same
> f_fsid. Userspace relies on this, for example fanotify and file handle
> users that identify a filesystem across mounts.
> 
> Guards against f_fsid changing across kernel versions, which would break
> userspace that relies on it.
> 
> Signed-off-by: Anand Jain <asj@kernel.org>
> ---
>  tests/generic/902     | 38 ++++++++++++++++++++++++++++++++++++++
>  tests/generic/902.out |  2 ++
>  2 files changed, 40 insertions(+)
>  create mode 100644 tests/generic/902
>  create mode 100644 tests/generic/902.out
> 
> diff --git a/tests/generic/902 b/tests/generic/902
> new file mode 100644
> index 000000000000..44dd685a887b
> --- /dev/null
> +++ b/tests/generic/902
> @@ -0,0 +1,38 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (c) 2026 Anand Jain <asj@kernel.org>.  All Rights Reserved.
> +#
> +# FS QA Test No. 902
> +#
> +# Verify that statfs f_fsid is derived from the filesystem UUID.
> +# Create a filesystem with a fixed UUID, mount it, and check that f_fsid
> +# matches the expected value. Applies only to filesystems that derive
> +# f_fsid from the UUID (btrfs, ext4).
> +
> +. ./common/preamble
> +
> +_begin_fstest auto quick
> +
> +_require_scratch
> +_require_uuid_based_fsid
    ^^^^^
> +
> +_fixed_by_fs_commit btrfs 72de4807ba84 \
> +	"btrfs: derive f_fsid with dev_t only when temp_fsid is active"
> +
> +_scratch_mkfs_uuid >> $seqres.full 2>&1 || _fail "mkfs failed"
    ^^^^^
I noticed this function supports f2fs, whereas _require_uuid_based_fsid above
doesn't. Since both functions are introduced in this patchset, I'm wondering
if you intend to run this test case on f2fs or not.

> +
> +_scratch_mount
> +
> +blkid $SCRATCH_DEV >> $seqres.full
> +f_fsid=$(stat -f -c "%i" $SCRATCH_MNT)
> +expected=$(_scratch_expected_fsid)
> +
> +echo "f_fsid=$f_fsid expected=$expected" >> $seqres.full
> +
> +[[ $f_fsid == "$expected" ]] || _fail "f_fsid mismatch"
> +
> +_scratch_unmount
> +
> +echo "Silence is golden"
> +
> +_exit 0
> diff --git a/tests/generic/902.out b/tests/generic/902.out
> new file mode 100644
> index 000000000000..e20395365cb5
> --- /dev/null
> +++ b/tests/generic/902.out
> @@ -0,0 +1,2 @@
> +QA output created by 902
> +Silence is golden
> -- 
> 2.43.0
> 
