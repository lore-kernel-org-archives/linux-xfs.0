Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7C791F7569;
	Fri, 19 Dec 2025 02:12:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766110355; cv=none; b=q6BzDnTDgMXmGFAJESRDm10uYk8/jXYOH4JoPL7Qmg5F75uCyFStkTPE0uxtSCly3vtPFIPGSIFFLmpGtSK6n5kyYzucSm9hvpIm9K8UQeLz3xRd6rimYlrKQGJHC/YPzNc8o/phN+p7XfZPe/dpN5RSrttD5a4snhITqJqTIEk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766110355; c=relaxed/simple;
	bh=0ctNJhmp0LNmO9SGc4CC5odslRfahlKWcYvZYBv+1QQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rv3BPoCldRQgj6NOZwevyyF5rU9uCSDH38apA+SOj2Qyt7b41l2hJGImgk+HY7FZRec0PHWB7bqwV+RoKjOoV+ZE1pFp1P/c3KHqRtrswSKJ+tbq7YjshxiGMIsx9/9BfWmqvWIKEc8lrG9zGHLfr8GWYtIThmgBeGOWw1JafBU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=prdncJ26; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="prdncJ26"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3714DC4CEFB;
	Fri, 19 Dec 2025 02:12:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1766110355;
	bh=0ctNJhmp0LNmO9SGc4CC5odslRfahlKWcYvZYBv+1QQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=prdncJ26GQuWeeHQpSQCxBRyDpyDeCrohWD5Dn/xptUGithwKE+RvVpmWpzpcwsZD
	 HKeL7M8Aepfrx4ocN4Sf7W3FZ/7BM+sWrOnfXrQ6yWYXq7CcxVLnaRMR8SxrfIC8Rv
	 e9OeaoukoSr7EUwB898F0wkin5f45l11LBK/jFg0L2oiJ+q7z8LlC6vgzvuO2stapc
	 ZwUEzO7+BW6xuqigPL8bpxQgY+aIxCCdX/A1C24coiO8EhSjx2+5Gkie9OKgfbfNWU
	 MFHmQ8U9Y2iA0b+wCrKRH7IiXuok7R4ytlJrEbfaeTFve3/PfTx9Aodd1hfzSFle6l
	 0eSskFk9BlGog==
Date: Thu, 18 Dec 2025 18:12:34 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Zorro Lang <zlang@kernel.org>, Damien Le Moal <dlemoal@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>, fstests@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/3] xfs: add a test that zoned file systems with rump
 RTG can't be mounted
Message-ID: <20251219021234.GB7725@frogsfrogsfrogs>
References: <20251218161045.1652741-1-hch@lst.de>
 <20251218161045.1652741-2-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251218161045.1652741-2-hch@lst.de>

On Thu, Dec 18, 2025 at 05:10:16PM +0100, Christoph Hellwig wrote:
> Garbage collection assumes all zones contain the full amount of blocks.
> Mkfs already ensures this happens, but the kernel mount code did not
> verify this.  Instead such a file system would eventually fail scrub.
> 
> Add a test to verify the new superblock verifier check.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  tests/xfs/651     | 33 +++++++++++++++++++++++++++++++++
>  tests/xfs/651.out |  2 ++
>  2 files changed, 35 insertions(+)
>  create mode 100755 tests/xfs/651
>  create mode 100644 tests/xfs/651.out
> 
> diff --git a/tests/xfs/651 b/tests/xfs/651
> new file mode 100755
> index 000000000000..1e36fec408ff
> --- /dev/null
> +++ b/tests/xfs/651
> @@ -0,0 +1,33 @@
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
> +# we intentionally corrupt the superblock
> +_require_scratch_nocheck
> +
> +_try_scratch_mkfs_xfs -r zoned=1 >> $seqres.full 2>&1 || \
> +	_notrun "Can't create zoned file system"
> +
> +# adjust rblocks/rextents to not be zone aligned
> +blocks=$(_scratch_xfs_get_sb_field rblocks)
> +blocks=$((blocks - 4096))
> +_scratch_xfs_set_sb_field rblocks ${blocks} >> $seqres.full 2>&1
> +_scratch_xfs_set_sb_field rextents ${blocks} >> $seqres.full 2>&1
> +
> +if _try_scratch_mount >/dev/null 2>&1; then
> +	echo "Mounted rump RTG file system (bad)"
> +fi
> +
> +echo "Can't mount rump RTG file system (good)"

In theory this should be in an else clause, but as extra lines in the
golden output is enough to fail the test, this code flow is correct.

Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> +
> +status=0
> +exit
> diff --git a/tests/xfs/651.out b/tests/xfs/651.out
> new file mode 100644
> index 000000000000..5d491b1894ea
> --- /dev/null
> +++ b/tests/xfs/651.out
> @@ -0,0 +1,2 @@
> +QA output created by 651
> +Can't mount rump RTG file system (good)
> -- 
> 2.47.3
> 
> 
