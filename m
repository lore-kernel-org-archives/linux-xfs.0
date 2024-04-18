Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F0C16FB0;
	Thu, 18 Apr 2024 15:00:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713452402; cv=none; b=Pd2jbuE1K4LLZK35ufP28GtdtMlxqPQmMfTHmu3xqluyWQ3EgwDRAP4sPsqqquu8I316Ymh3rKS7LeYObK3Wk7aPc/5fUwenzBovNYgJzdIxFm/kk2Yh+GPfv3QO6ikz2RAAAA+zbfRdr3XzbY/WBFZNPHrb9hBa1U6i1mOkzQI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713452402; c=relaxed/simple;
	bh=MiIp5Lvkve/MT9TLOW5GUu25Khd1FUnzu8TlqDCquFQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QlaA3uCVecJ6LtOJVXaQ8Lr0BwmUjvFDM4k1Pfn9kNlBCKib47sm1ebz6nuV+13n4UH5CDSOHotZ7TKJVb5iwogd+1p93GzI3syitvYG9YVU4SttY/b0nBVL6P/IOYR12iPOUxmZbilH3DUGJ+WkjtVJnZ3i0CYBCfRw1hhlItU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ReTErwSs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ReTErwSs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F4185C113CE;
	Thu, 18 Apr 2024 15:00:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713452402;
	bh=MiIp5Lvkve/MT9TLOW5GUu25Khd1FUnzu8TlqDCquFQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ReTErwSs1qC+6c/vklyk8F8+yIheGtxov5f2FP3+M37Mo+TCpm69oo5Jo4cmkbvj4
	 869XD57CwLpqp9OpoA8hehkpZp3PA2EqvynPc/b/7M4Ka5yDg9MX46hFOFXxEfv9K+
	 pzl4396WbKRvc4zeNuPD9czmbm0X5ye53PijyX2gZX/NXQU12PqNt9zI/H+qNDh1+2
	 Dh2NHoGIs1cUd6eT/lKfYYAVjuID5OoKLDpurowukVwqsRXjeXlaDzWME+uj2td861
	 1S3JlYVlRWHJW1/9ZWL7/J/nRBHgH0WK7cV3gRa01QKV3XlqijHSE34MJtHlUb03um
	 tuh1sJvKYmcSA==
Date: Thu, 18 Apr 2024 08:00:01 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Zorro Lang <zlang@kernel.org>, linux-xfs@vger.kernel.org,
	fstests@vger.kernel.org
Subject: Re: [PATCH 4/5] xfs/{158,160}: split out v4 tests
Message-ID: <20240418150001.GI11948@frogsfrogsfrogs>
References: <20240418074046.2326450-1-hch@lst.de>
 <20240418074046.2326450-5-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240418074046.2326450-5-hch@lst.de>

On Thu, Apr 18, 2024 at 09:40:45AM +0200, Christoph Hellwig wrote:
> Move the subtests that check we can't upgrade v4 file systems to a
> separate test.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks good,
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  tests/xfs/158     |  5 -----
>  tests/xfs/158.out |  3 ---
>  tests/xfs/160     |  5 -----
>  tests/xfs/160.out |  3 ---
>  tests/xfs/612     | 32 ++++++++++++++++++++++++++++++++
>  tests/xfs/612.out |  7 +++++++
>  6 files changed, 39 insertions(+), 16 deletions(-)
>  create mode 100755 tests/xfs/612
>  create mode 100644 tests/xfs/612.out
> 
> diff --git a/tests/xfs/158 b/tests/xfs/158
> index 4440adf6e..9f03eb528 100755
> --- a/tests/xfs/158
> +++ b/tests/xfs/158
> @@ -23,11 +23,6 @@ _require_xfs_repair_upgrade inobtcount
>  _scratch_mkfs -m crc=1,inobtcount=1,finobt=0 &> $seqres.full && \
>  	echo "Should not be able to format with inobtcount but not finobt."
>  
> -# Make sure we can't upgrade a V4 filesystem
> -_scratch_mkfs -m crc=0,inobtcount=0,finobt=0 >> $seqres.full
> -_scratch_xfs_admin -O inobtcount=1 2>> $seqres.full
> -_check_scratch_xfs_features INOBTCNT
> -
>  # Make sure we can't upgrade a filesystem to inobtcount without finobt.
>  _scratch_mkfs -m crc=1,inobtcount=0,finobt=0 >> $seqres.full
>  _scratch_xfs_admin -O inobtcount=1 2>> $seqres.full
> diff --git a/tests/xfs/158.out b/tests/xfs/158.out
> index 5461031a3..3bc043e43 100644
> --- a/tests/xfs/158.out
> +++ b/tests/xfs/158.out
> @@ -1,8 +1,5 @@
>  QA output created by 158
>  Running xfs_repair to upgrade filesystem.
> -Inode btree count feature only supported on V5 filesystems.
> -FEATURES: INOBTCNT:NO
> -Running xfs_repair to upgrade filesystem.
>  Inode btree count feature requires free inode btree.
>  FEATURES: INOBTCNT:NO
>  Fail partway through upgrading
> diff --git a/tests/xfs/160 b/tests/xfs/160
> index 399fe4bcf..d11eaba3c 100755
> --- a/tests/xfs/160
> +++ b/tests/xfs/160
> @@ -22,11 +22,6 @@ _require_xfs_repair_upgrade bigtime
>  date --date='Jan 1 00:00:00 UTC 2040' > /dev/null 2>&1 || \
>  	_notrun "Userspace does not support dates past 2038."
>  
> -# Make sure we can't upgrade a V4 filesystem
> -_scratch_mkfs -m crc=0 >> $seqres.full
> -_scratch_xfs_admin -O bigtime=1 2>> $seqres.full
> -_check_scratch_xfs_features BIGTIME
> -
>  # Make sure we're required to specify a feature status
>  _scratch_mkfs -m crc=1,bigtime=0,inobtcount=0 >> $seqres.full
>  _scratch_xfs_admin -O bigtime 2>> $seqres.full
> diff --git a/tests/xfs/160.out b/tests/xfs/160.out
> index 58fdd68da..9a7647f25 100644
> --- a/tests/xfs/160.out
> +++ b/tests/xfs/160.out
> @@ -1,8 +1,5 @@
>  QA output created by 160
>  Running xfs_repair to upgrade filesystem.
> -Large timestamp feature only supported on V5 filesystems.
> -FEATURES: BIGTIME:NO
> -Running xfs_repair to upgrade filesystem.
>  Running xfs_repair to upgrade filesystem.
>  Adding inode btree counts to filesystem.
>  Adding large timestamp support to filesystem.
> diff --git a/tests/xfs/612 b/tests/xfs/612
> new file mode 100755
> index 000000000..4ae4d3977
> --- /dev/null
> +++ b/tests/xfs/612
> @@ -0,0 +1,32 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0-or-later
> +# Copyright (c) 2021 Oracle.  All Rights Reserved.
> +#
> +# FS QA Test No. 612
> +# 
> +# Check that we can upgrade v5 only features on a v4 file system
> +
> +. ./common/preamble
> +_begin_fstest auto quick
> +
> +# Import common functions.
> +. ./common/filter
> +
> +# real QA test starts here
> +_supported_fs xfs
> +_require_scratch_xfs_inobtcount
> +_require_command "$XFS_ADMIN_PROG" "xfs_admin"
> +_require_xfs_repair_upgrade inobtcount
> +
> +# Make sure we can't upgrade to inobt on a V4 filesystem
> +_scratch_mkfs -m crc=0,inobtcount=0,finobt=0 >> $seqres.full
> +_scratch_xfs_admin -O inobtcount=1 2>> $seqres.full
> +_check_scratch_xfs_features INOBTCNT
> +
> +# Make sure we can't upgrade to bigtim on a V4 filesystem
> +_scratch_mkfs -m crc=0 >> $seqres.full
> +_scratch_xfs_admin -O bigtime=1 2>> $seqres.full
> +_check_scratch_xfs_features BIGTIME
> +
> +status=0
> +exit
> diff --git a/tests/xfs/612.out b/tests/xfs/612.out
> new file mode 100644
> index 000000000..6908c15f8
> --- /dev/null
> +++ b/tests/xfs/612.out
> @@ -0,0 +1,7 @@
> +QA output created by 612
> +Running xfs_repair to upgrade filesystem.
> +Inode btree count feature only supported on V5 filesystems.
> +FEATURES: INOBTCNT:NO
> +Running xfs_repair to upgrade filesystem.
> +Large timestamp feature only supported on V5 filesystems.
> +FEATURES: BIGTIME:NO
> -- 
> 2.39.2
> 
> 
