Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D445F41F34B;
	Tue, 28 Jul 2026 10:29:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785234580; cv=none; b=p0Pi9VRKMlODc5lCG/wacMctgTDggFWUYRe3OFBFXXxiIrZjioxn9qD0ObxMWk1TbuRZYnsvhisiiiLaxHvZDkEBMyTmrYncLn+MkB0H8yeNeg8hdOxTLC+2fnpOF+p0fw7oq7btDFUjqrB5DIEEehOqk6TQduAxd6u9B4u+NqU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785234580; c=relaxed/simple;
	bh=dWmkL5VtX8QU+x/aXoMMfGWLozW4cDRaSW0/aYnvUcM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=aBLQ2QRoLBPaUKYMt/mhj31zGBOXbysMw+g6hS33fA7L3ZS8cTfUoNWJqwuZmHwB4ESp01V9DihwH0KgLs3Q8i0cfiQ1iQVOdC4lxjOydqFC/dJdEBJYEjBKFa188mbv3tN1UXsI62KD8WMvaprXEKdJLr85jYqbmZzyRILrWi8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MKiYCYTD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MKiYCYTD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9DAC1F000E9;
	Tue, 28 Jul 2026 10:29:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785234579;
	bh=gPjsV3DS6/bJU8RKMga/6Yuq2Wnmr/HvPwTaTgrLhAU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=MKiYCYTDn8bFIyiSidM+BjqntqF0pkSfZN5egcI9lSwPzipkLwYXl8vriHMGNyUkJ
	 UM9qGlcsy0WQQaKE4Oy3vg2wD/hJ5qDcVDX3JM8V2MHf+erLMApGGuu+YNOngHHIKx
	 QqLyL4ECIhULV//cwFYIo1leLgx523Pu7nomiM9GYVk5poKRAi/7AhQSGxJM9Vbrik
	 zxNBGCStWWLiw26OvfqxNzRBdcJs/5fZ4Bjv5aOAKspiHGAs7FfEi0nJgKTJp5iVI1
	 Ky/luUwwvEj1dH3hasTNqmOMqSHuFTjBxrjyxRYlpnoTFbTSsMxyFQd6SY9KXPJDup
	 VOWSIxAlKxb7Q==
Date: Tue, 28 Jul 2026 18:29:34 +0800
From: Zorro Lang <zlang@kernel.org>
To: Donald Douwsma <ddouwsma@redhat.com>
Cc: linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCH v2] xfs: test xfsdump subtree restores
Message-ID: <amiEFW7iEi6kpfp2@zlang-mailbox>
Mail-Followup-To: Donald Douwsma <ddouwsma@redhat.com>, 
	linux-xfs@vger.kernel.org, fstests@vger.kernel.org
References: <20260723062617.424905-1-ddouwsma@redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260723062617.424905-1-ddouwsma@redhat.com>

On Thu, Jul 23, 2026 at 04:26:17PM +1000, Donald Douwsma wrote:
> Regression test for cumulative restores where a directory has been
> renamed outside of the subtree being restored triggering the assert:
> 
>   xfsrestore: tree.c:1421: noref_elim_recurse: Assertion 'isrealpr' failed
> 
> Signed-off-by: Donald Douwsma <ddouwsma@redhat.com>
> ---
> Changes since v1
> - Fix use of _do, including label quoting
> - Update test output
> - Add tests for additional edge cases

Hi Donald, This version is good to me now.

Reviewed-by: Zorro Lang <zlang@kernel.org>

> ---
>  tests/xfs/995     | 58 +++++++++++++++++++++++++++++++++++++++++++++++
>  tests/xfs/995.out |  8 +++++++
>  2 files changed, 66 insertions(+)
>  create mode 100755 tests/xfs/995
>  create mode 100644 tests/xfs/995.out
> 
> diff --git a/tests/xfs/995 b/tests/xfs/995
> new file mode 100755
> index 000000000..bba0bcd52
> --- /dev/null
> +++ b/tests/xfs/995
> @@ -0,0 +1,58 @@
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
> +_do_die_on_error="always"
> +
> +_fixed_by_git_commit xfsdump dd63de5 \
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
> +_do "Creating l0 dump" "$XFSDUMP_PROG -L lab_l0 -M test -l0 -f $tmp.dump.l0 $SCRATCH_MNT"
> +
> +mv $SCRATCH_MNT/a/b/c $SCRATCH_MNT/1
> +
> +_do "Creating l2 dump" "$XFSDUMP_PROG -L lab_l2.0 -M test -l2 -f $tmp.dump.l2.0 $SCRATCH_MNT"
> +
> +dir=$(mktemp -d $SCRATCH_MNT/restore_XXX)
> +_do "Cumulative restore l0" "$XFSRESTORE_PROG -f $tmp.dump.l0 -r $dir"
> +_do "Cumulative restore l2" "$XFSRESTORE_PROG -f $tmp.dump.l2.0 -r $dir"
> +
> +dir=$(mktemp -d $SCRATCH_MNT/restore_XXX)
> +_do "Cumulative subtree restore l0" "$XFSRESTORE_PROG -f $tmp.dump.l0 -r -s restore_me $dir"
> +# The next command core dumps prior to xfsdump v3.3.0 when noref_elim_recurse attempts to
> +# rename directories outside of the subtree when their parent has not been created.
> +_do "Cumulative subtree restore l2" "$XFSRESTORE_PROG -f $tmp.dump.l2.0 -r $dir"
> +
> +dir=$(mktemp -d $SCRATCH_MNT/restore_XXX)
> +_do "Restore l2 on its own" "$XFSRESTORE_PROG -f $tmp.dump.l0 -r -s restore_me $dir"
> +
> +# success, all done
> +_exit 0
> diff --git a/tests/xfs/995.out b/tests/xfs/995.out
> new file mode 100644
> index 000000000..9a620eb31
> --- /dev/null
> +++ b/tests/xfs/995.out
> @@ -0,0 +1,8 @@
> +QA output created by 995
> +Creating l0 dump... done
> +Creating l2 dump... done
> +Cumulative restore l0... done
> +Cumulative restore l2... done
> +Cumulative subtree restore l0... done
> +Cumulative subtree restore l2... done
> +Restore l2 on its own... done
> -- 
> 2.52.0
> 
> 
