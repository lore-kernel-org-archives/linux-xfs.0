Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795459617;
	b=Djagi0q4htJiq2tP2W7eG370AyuWAEzx8apJ6BOPYjVHl0SsKeF/heGWHnBCzQ+Bnw7w
	 qMDT+I2iT1EHIxX7MIUMpxJ79TewrqS+x2jhO0KoEPEBOkUs5uZRD+0iqfHBSUNH6Xo6g
	 8jLzbX7jGIN/NxKwKd4U2KDy7f0hIDhCHyCPHsudjN3xZcruOTigM5/tMYdnvn/uWwVmh
	 6PhDyHThIFLUQ6HqGH5SL5jEnQoxMxJ/ZCsy1FxMnC/IdPa6DZRAuqVJP0XtsHRBUt/hL
	 ym4VRicEE3pDVFGJkdWssiPVQvUpzusjBY7qXJbC6/9s25ckd+/qhna6ngYlwdiNTGg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795459617;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 Mail-Followup-To:References:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To;
	bh=jEgTy2gI/IlCDectbC/WzfFgVpdI3lObRhjlmOoXpHw=;
	b=blRNf0NHWcoghDrc5Uxh3jKOr85BBBKlQHhW/J6d0IpIzCkAN9bi9nPQq8aTeR4lLcfn
	 XGrRLTzv7Dw9JNtSV4ZcahWcEIEOq7qDhi6KPyi2YIRH5VHMu09AYDZRx58vKoyFCOqL+
	 /qZGALYwnC7qhule52xNekBIcrd99FZmYHnffMzyrzbQkfBjod/vt2ZGQvkGvkAzFs86r
	 rHMrwANffSfo0judvDTBQtXL5lfxxUM+9KICrNr9Smd/dRe8Y9hgNnJ2K7oqS6lEYRMFr
	 M6L2fDNP2Phelr3QbExvgOCWahqoHN8WuLAZYZ1MDO6xQbv1/30i3benw6qtAqO5ipA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=GzvswWaE;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CAE0606A31A;
	Mon, 23 Nov 2026 18:46:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=GzvswWaE
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5D621F000C4;
	Mon, 23 Nov 2026 18:46:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795459616;
	bh=jEgTy2gI/IlCDectbC/WzfFgVpdI3lObRhjlmOoXpHw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=GzvswWaElhQlroSK2fjY7vkgFjL0BjMCQz9a96B9OOTuABcrMrbDQ4MbJQkoCyUb+
	 XI5K/xaybbNy1Tw07I+9swqdUJJyQ2lFoK86+qNQuZmGsL2vH/Yng0+8YCXkjTS2F4
	 2riLyDzHPE6CaMAoEnoWOPntBxpkC5D+zfO4j1thB54c2Xn8GE+OyD7EmUsSKWTuGr
	 4KjXY8OoIdRodDXngaqAFoP4KFcfODgMPbvtN+F5JJ+fU2e4djuvYKucMdjGhS0uQ8
	 BOkcdFbwhSfz6c9bZwfjrLPiEIJm/vAvnbkPT7S7w4Ov05OPRU0qS6LT0qhilUlnMM
	 bItVF/PAXBpaQ==
Date: Tue, 24 Nov 2026 02:46:47 +0800
From: Zorro Lang <zlang@kernel.org>
To: Anand Jain <asj@kernel.org>
Cc: fstests@vger.kernel.org, linux-btrfs@vger.kernel.org, 
	linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org, 
	linux-f2fs-devel@lists.sourceforge.net
Subject: Re: [PATCH 11/21] fstests: verify statfs f_fsid is derived from the
 filesystem UUID
Message-ID: <awSJ4nnsW6m7_J7H@zlang-mailbox>
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

Reviewed-by: Zorro Lang <zlang@kernel.org>

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
> +
> +_fixed_by_fs_commit btrfs 72de4807ba84 \
> +	"btrfs: derive f_fsid with dev_t only when temp_fsid is active"
> +
> +_scratch_mkfs_uuid >> $seqres.full 2>&1 || _fail "mkfs failed"
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
