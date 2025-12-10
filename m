Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB3691624DF;
	Wed, 10 Dec 2025 16:50:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765385429; cv=none; b=Y0k9+BDogPdmRn6kUI10AB1Qb8GtPTVjnwFu0H7D9b0FkBF9ACqij2zb4FWzY1SrsJf9211XQkTp2miWSWC3bpDLBL5q8pw6oEwgWcfEFpryQJs4wrHjt1tifKKCO7QaKhyQ9iLNq2ZAiN1W0+psxPei+7NlCpPJN698WVYtLOY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765385429; c=relaxed/simple;
	bh=/JTxr8xLaweh+lO17Cu5AY12X/dHP35bA5nKxBJyg+c=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nSoNXKBymEdgkjTI0Ga8j1uqnl+TCVDC2PsizePmUckXHawhf1vChAd+nexRpP/Wg8gy0m2Bc3ZVrp5CXId3FHZkEkQ9aCR/I6troKyXc5+AtYBjc/gRzmbBJUSYkvyyinTzHz9L7L8L4oIGAZ01Sv1/2qpRdttOtkYnJl88tKc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PEboKB4/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PEboKB4/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 375BCC4CEF1;
	Wed, 10 Dec 2025 16:50:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1765385429;
	bh=/JTxr8xLaweh+lO17Cu5AY12X/dHP35bA5nKxBJyg+c=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=PEboKB4/boTejsrnMmyuGK5qxq0Pjthnhrwh7E9NKO9CvCC/Vw8I1Rpi7lVVjn7XC
	 TtdWea48N1UGR2RvH9xVkZzROO6SddzmgmWvUKkaCMw95/kthiShgdsGi33G/b2m4B
	 TXykRQ9WbVA7V1EK1+b+sGOoW/NdUxvFqUVAPxe8yUfc4jIKsaWlUWu0c9sgsdKBlK
	 r8YPGOyoqZl6tCblKZSORAzwGrkvsoBzajCA13UW23Pjo3LQtQMKfWaKFmiqp3J+R4
	 6radI4SD/MYZJwjtaZCrQOq+clSzd78dL7ACyNkveVCvEZKXDIA+cEwjGvwznxZtGn
	 QfKrrUMSZwsLQ==
Date: Wed, 10 Dec 2025 08:50:28 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: zlang@kernel.org, fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: add a test that zoned file systems with rump RTG
 can't be mounted
Message-ID: <20251210165028.GC7725@frogsfrogsfrogs>
References: <20251210142330.3660787-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251210142330.3660787-1-hch@lst.de>

On Wed, Dec 10, 2025 at 03:23:30PM +0100, Christoph Hellwig wrote:
> Garbage collection assumes all zones contain the full amount of blocks.
> Mkfs already ensures this happens, but the kernel mount code did not
> verify this.  Instead such a file system would eventually fail scrub.
> 
> Add a test to verify the new superblock verifier check.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  tests/xfs/651     | 27 +++++++++++++++++++++++++++
>  tests/xfs/651.out |  2 ++
>  2 files changed, 29 insertions(+)
>  create mode 100755 tests/xfs/651
>  create mode 100644 tests/xfs/651.out
> 
> diff --git a/tests/xfs/651 b/tests/xfs/651
> new file mode 100755
> index 000000000000..3aef7a1d016f
> --- /dev/null
> +++ b/tests/xfs/651
> @@ -0,0 +1,27 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (c) 2025 Christoph Hellwig.
> +#
> +# FS QA Test No. 651
> +#
> +# Test that the sb verifier rejects zoned file system with rump RTGs.
> +#
> +. ./common/preamble
> +_begin_fstest auto quick zone
> +
> +. ./common/zoned
> +
> +_require_scratch
> +
> +_scratch_mkfs > /dev/null 2>&1
> +blocks=$(_scratch_xfs_db -c 'sb 0' -c 'print rblocks' | awk '{print $3}')

blocks="$(_scratch_xfs_get_metadata_field rblocks 'sb 0')"

> +blocks=$((blocks - 4096))
> +_scratch_xfs_db -x -c 'sb 0' -c "write -d rblocks $blocks" > /dev/null 2>&1
> +_scratch_xfs_db -x -c 'sb 0' -c "write -d rextents $blocks" > /dev/null 2>&1
> +_try_scratch_mount || _notrun "Can't mount rump RTG file system"

Doesn't the _notrun here cause the test to be "skipped" when in fact it
actually exhibits the behavior that you want (i.e. it passes)?

--D

> +
> +# for non-zoned file systems this can succeed
> +_require_xfs_scratch_zoned
> +
> +status=0
> +exit
> diff --git a/tests/xfs/651.out b/tests/xfs/651.out
> new file mode 100644
> index 000000000000..62617d172811
> --- /dev/null
> +++ b/tests/xfs/651.out
> @@ -0,0 +1,2 @@
> +QA output created by 651
> +Can't mount rump RTG file system
> -- 
> 2.47.3
> 
> 
