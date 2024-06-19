Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7791B1E495;
	Wed, 19 Jun 2024 06:24:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718778266; cv=none; b=FvFbSlw3qyhlc9QPyVj/6XoH8sDG1ELnO20OlE7M/6KBSqiHAbnD0T7t6BP5yr2giomnwHB1FttHx/bnnGIAvEkuPRPfhUJoCchEEdQCn46UhmHs4GlTRgUPsu7qJI9Ubdqi5yK/yAv/q0chApoz2Uu2NsnAOkgk0ry/cBR7s94=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718778266; c=relaxed/simple;
	bh=zxS4N+sQUIdupWgSmzaQugrkcM9+2KrxI8Edhcnnc1g=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qNhphzYwn6rCBSPmbqH1V6Xto5+vc74wpKxyTKpsck/iF/W1rJi2IaxqvI6J0mGVNY1dSWSvXbS/GOc0QcGfg8JY/TD4FqpvrMH+bAaKqmMPTPmmNn1g0LLkFs5IAJzP3PwY4BZPGtzxSIJZ8w9t87R+n3Jcgkka6CYtc5YiGGs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=jJTgLaiA; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="jJTgLaiA"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=gSDQhjjCvQHbOByyro/lJt3CcErPaYMvOBarEbYt4cM=; b=jJTgLaiADM/ij77CPn3CeoM8Jz
	Eqtxb0A83FOdL2lLy/MqsPICVo8vFC/JRvlXDJElgp1kl38DN4bgDbpjceam40sZaDUjOkm2lRklV
	KbA7+iP0Xwc7Tq2idYyVZAAaYkhg9R9MEsQ3tlOV3h/qy4p8CN/IfhaFP5XJDcN5csp64hlvXnkh4
	nRfs5NW3ybehPvOtq4UdIRb9JbYOZtugMKYVabgkoeu3zAZk/lxGtSybrJvTNvj32Nec1hj5xEtji
	SYThxGMjpdVRC0YOIrOrQ7mbpbVAMjdBOlfzNBWwigHolRWIk3JNEPiLPPOw1t2+XJvKCbnXV3AK/
	d/hm6qvQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sJok5-0000000032x-0Mco;
	Wed, 19 Jun 2024 06:24:25 +0000
Date: Tue, 18 Jun 2024 23:24:25 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: zlang@redhat.com, fstests@vger.kernel.org, guan@eryu.me,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/1] xfs: test scaling of the mkfs concurrency options
Message-ID: <ZnJ5mfiqfnur5lFc@infradead.org>
References: <171867144916.793370.13284581064185044269.stgit@frogsfrogsfrogs>
 <171867144932.793370.9007901197841846249.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <171867144932.793370.9007901197841846249.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Mon, Jun 17, 2024 at 05:46:45PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Make sure that the AG count and log size scale up with the new
> concurrency options to mkfs.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  tests/xfs/1842             |   55 ++++++++++++++
>  tests/xfs/1842.cfg         |    4 +
>  tests/xfs/1842.out.lba1024 |  177 ++++++++++++++++++++++++++++++++++++++++++++
>  tests/xfs/1842.out.lba2048 |  177 ++++++++++++++++++++++++++++++++++++++++++++
>  tests/xfs/1842.out.lba4096 |  177 ++++++++++++++++++++++++++++++++++++++++++++
>  tests/xfs/1842.out.lba512  |  177 ++++++++++++++++++++++++++++++++++++++++++++
>  6 files changed, 767 insertions(+)
>  create mode 100755 tests/xfs/1842
>  create mode 100644 tests/xfs/1842.cfg
>  create mode 100644 tests/xfs/1842.out.lba1024
>  create mode 100644 tests/xfs/1842.out.lba2048
>  create mode 100644 tests/xfs/1842.out.lba4096
>  create mode 100644 tests/xfs/1842.out.lba512
> 
> 
> diff --git a/tests/xfs/1842 b/tests/xfs/1842
> new file mode 100755
> index 0000000000..8180ca7a6e
> --- /dev/null
> +++ b/tests/xfs/1842
> @@ -0,0 +1,55 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (c) 2022-2024 Oracle.  All Rights Reserved.
> +#
> +# FS QA Test No. 1842
> +#
> +# mkfs concurrency test - ensure the log and agsize scaling works for various
> +# concurrency= parameters
> +#
> +. ./common/preamble
> +_begin_fstest log metadata auto quick
> +
> +# Import common functions.
> +. ./common/filter
> +. ./common/reflink
> +
> +_cleanup()
> +{
> +	cd /
> +	rm -r -f $tmp.* $loop_file
> +}
> +
> +# real QA test starts here
> +_supported_fs xfs
> +
> +_require_test
> +_require_loop
> +$MKFS_XFS_PROG 2>&1 | grep -q concurrency || \
> +	_notrun "mkfs does not support concurrency options"
> +
> +test_dev_lbasize=$(blockdev --getss $TEST_DEV)
> +seqfull=$0
> +_link_out_file "lba${test_dev_lbasize}"

This should probably check for an lba size that doesn't have valid
golden output instead of having a weird failure case?  Not really
an issue right now, but it will be one with the large lba size work.

