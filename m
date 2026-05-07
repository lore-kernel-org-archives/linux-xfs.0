Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F69C3168EB;
	Thu,  7 May 2026 16:59:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778173172; cv=none; b=nAcowvgCFxvFfrtaZrAX2tZCyIdQGfxHR44RGoMZykDficalqW68TW6G8/1E6XCDWjM6ocEfzFgAV3pFHZaNRDCb/40sEDRcg8OOfUpnLoasuMY8T2O8on+BaIcu+nqUshKVufe2PX5n/3Q3EhwaaMy4lhpCfCLof580HVQZbnA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778173172; c=relaxed/simple;
	bh=ek/Md6JzFPfBZoqQU5pjBss6iHzzAzSSXUnzvfGAxDg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XuqUdFYBFfqBg3T5PWun0u47CBV4e1YkUS4XheSIcDUiFZRKnHo/XAJFsDplVjGA+5tVcc0R8gHNTQeAqstl4vqsop8lgzQ3DowFuuk/b7jPWbcurpufiIu48lwpJfGz46kPknAYqFLI8MXctowIp0borPDQoE1o7pPV8Lo1Uo8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MdeO8zoZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MdeO8zoZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9CE52C2BCB2;
	Thu,  7 May 2026 16:59:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778173171;
	bh=ek/Md6JzFPfBZoqQU5pjBss6iHzzAzSSXUnzvfGAxDg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=MdeO8zoZNxRs7i6JQ827p8jQrfR7In/sG2gqunF4zyWetq8Y23meB41sbK6R4IcfV
	 zFhWFp9FqYYJWo8SrNBg967CMwLXvVPSxD+FL3BuF1aMgzjIiXd4qxgfdV0txFMcYT
	 PxsBnDiYmtk7Qm3uEE+jvbL/S/gt35s9si/Km+VGw7aIMAaLTFKYv7maaVAJfx8gtc
	 agAssArxPZtpAX9uO2PwNDoO9irFyOd783cV27R7kh6kpuKa1bGjT03Ptio5+zbdAA
	 PlmzIzCRM0L63teKTyF9AVkuSMizv/LVy7KAc+8vcdSa3vFiJ4oHMW2k+dWyyiOg/3
	 6lJdIDbOi/WTw==
Date: Fri, 8 May 2026 00:59:23 +0800
From: Zorro Lang <zlang@kernel.org>
To: Donald Douwsma <ddouwsma@redhat.com>
Cc: fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: test xfsdump subtree restores
Message-ID: <afy-9iJYNqDdXgml@zlang-mailbox>
Mail-Followup-To: Donald Douwsma <ddouwsma@redhat.com>, 
	fstests@vger.kernel.org, linux-xfs@vger.kernel.org
References: <20260326025443.1569874-1-ddouwsma@redhat.com>
 <20260326030012.1571545-1-ddouwsma@redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260326030012.1571545-1-ddouwsma@redhat.com>

On Thu, Mar 26, 2026 at 02:00:12PM +1100, Donald Douwsma wrote:
> Regression test for cumulative restores where a directory has been
> renamed outside of the subtree being restored triggering the assert:
> 
>   xfsrestore: tree.c:1421: noref_elim_recurse: Assertion 'isrealpr' failed
> 
> Signed-off-by: Donald Douwsma <ddouwsma@redhat.com>
> ---
>  tests/xfs/995     | 51 +++++++++++++++++++++++++++++++++++++++++++++++
>  tests/xfs/995.out |  2 ++
>  2 files changed, 53 insertions(+)
>  create mode 100755 tests/xfs/995
>  create mode 100644 tests/xfs/995.out
> 
> diff --git a/tests/xfs/995 b/tests/xfs/995
> new file mode 100755
> index 00000000..54172572
> --- /dev/null
> +++ b/tests/xfs/995
> @@ -0,0 +1,51 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (c) 2026 Red Hat.  All Rights Reserved.
> +#
> +# FS QA Test 995
> +#
> +# Regression test for cumulative restores where a directory has been
> +# renamed outside of the subtree being restored resulting in
> +#
> +#   xfsrestore: tree.c:1421: noref_elim_recurse: Assertion 'isrealpr' failed
> +#
> +. ./common/preamble
> +_begin_fstest auto dump
> +
> +_fixed_by_git_commit xfsdump XXXXXXX \
> +	"xfsrestore: only process subtrees that are selected"
> +
> +# Override the default cleanup function.
> +_cleanup()
> +{
> +	_cleanup_dump
> +	cd /
> +	rm -r -f $tmp.*
> +}
> +
> +# Import common functions.
> +. ./common/dump
> +
> +# Modify as appropriate.
> +_require_scratch
> +_scratch_mkfs_xfs >>$seqres.full
> +_scratch_mount
> +
> +mkdir -p $SCRATCH_MNT/a/b/c/d/e/f/g
> +mkdir -p $SCRATCH_MNT/restore_me/B/C/D/E/F/G
> +
> +_do "$XFSDUMP_PROG -L "lab_l0" -M "test" -l0 -f $tmp.dump.l0 $SCRATCH_MNT"
> +
> +mv $SCRATCH_MNT/a/b/c $SCRATCH_MNT/1
> +
> +_do "$XFSDUMP_PROG -L "lab_l2" -M "test" -l2 -f $tmp.dump.l2 $SCRATCH_MNT"
> +
> +dir=$(mktemp -d $SCRATCH_MNT/restore_XXX)
> +_do "$XFSRESTORE_PROG -f $tmp.dump.l0 -r -s restore_me $dir"
> +_do "$XFSRESTORE_PROG -f $tmp.dump.l2 -r $dir"

Hi Donald,

I almost forgot we had this _do helper :)

I think your test target is the 2nd xfsrestore command line (about incremental
changes), a comment might be good.

I saw used four _do calls here. I just checked the logic of the _do helper, I
suspect your current usage might prevent the test from catching command failures,
allowing it to 'successfully' continue...

A simple fix would be adding a "note" as a first argument to each _do helper call,
e.g:
  _do "Full dump" "$XFSDUMP_PROG ..."
Once all four calls are updated this way, we can remove the "test $? -ne 0 && exit"
lines too, and rely on golden image matching to detect any failures. What do you
think?

Thanks,
Zorro

> +
> +test $? -ne 0 && exit
> +
> +echo Silence is golden
> +# success, all done
> +_exit 0
> diff --git a/tests/xfs/995.out b/tests/xfs/995.out
> new file mode 100644
> index 00000000..776fa6f2
> --- /dev/null
> +++ b/tests/xfs/995.out
> @@ -0,0 +1,2 @@
> +QA output created by 995
> +Silence is golden
> -- 
> 2.47.3
> 
> 
