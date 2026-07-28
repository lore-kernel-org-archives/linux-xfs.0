Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88D2E422E23;
	Tue, 28 Jul 2026 10:39:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785235198; cv=none; b=IyECAk8XDzBi5YH59WLtCyGVIBdSeERJnbkGosCZwL28U/0yRB5gSfYRkQv78ZOcAg9iIAstPWC9RxP7zaI/b5vVfUJiMogXC+a9M5q3cK9foU/XWDcw4MSKSsfvhCLDLWt9V5j6YgojbIa6cAZvJi8EkpKtWJeP4NmGSyjVuhA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785235198; c=relaxed/simple;
	bh=m899Sm1pE2TUcyCLrO8FpJ6mBWO1U9g2kJuYJRV10rM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=orL3NWQUt4nyMSfkdsrKQjxCtzMWvE74B6RJYZ9yaTPmktx15nnyyNqxv9n6qxGArRrOeFNSzbXDPiNNed9cKb5HB2nuCV+xZYBp6knftmY6aAhED61zxc7/sP0Ep+RtOOCO5cJTbHNO0vZwlTxTA2yVheuvFyBLgmVinl0v2Qk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gcG/nmls; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gcG/nmls"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 861451F000E9;
	Tue, 28 Jul 2026 10:39:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785235197;
	bh=J8dxLxXh5mtwtRgRjwU5yH3yQxWNmQSjBp37Xslmxc8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=gcG/nmlsUohxFVgfCIReFrnKTFogOOVY89fpWjrGEXGOpWTKZNhnS2d/GxEVKzE6q
	 Z3rElLZtR7096esRdT0YZJcexqh1KaJgRy1RYE85lTYbif7NKp6MKGun0g3TSer5xv
	 It87WDoJdXTBr5PF/RvwBITJZ8ax+SxeDaogg6kPPj36oPLKSR/wbSK36DYM5qpx+q
	 O8MRrOMv0PVKQwh9LQozgfHOlkEWCkfkzzg6UYsdYC3occaOkSJTYNrz0tdToSL9rR
	 eGMV7PhSn5cXLGXoJ4/JtItNI+jU0Xcs+DpppGzB1IgN422x2GOC4nK9MBREMUm7m4
	 Cr/hncwAfXAcA==
Date: Tue, 28 Jul 2026 18:39:51 +0800
From: Zorro Lang <zlang@kernel.org>
To: Donald Douwsma <ddouwsma@redhat.com>
Cc: linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCH v2] xfs: test xfsdump subtree restores
Message-ID: <amiGzsz0KuUrV29o@zlang-mailbox>
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

I think this line is useless now, right? I'll remove it.

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
