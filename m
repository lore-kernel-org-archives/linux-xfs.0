Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D31423E3C67;
	Tue, 12 May 2026 05:37:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778564232; cv=none; b=Fy3gKF+UmSxEww/9wtWkI6CKqwM/gEbHafQLh9jvv2sG8ZkWnxMJiCnrI1/1DBI15TIRhoakVB51qJOmUpROIgtjR7FxqyX8AQTglBebrIH5NECNtJlgDplHTlHLMajdNuPVI49kt4UlkI5+eLhlVtvjudSoOysbC/sYoDGUqcw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778564232; c=relaxed/simple;
	bh=JIzMF6ANC/fHGOAg368IhurwkPreLfP3HVZFfSqtQcw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ponBrHbiH+CxXln5qXGAIVzG4aNunn3c/tBI9XFwkBtBvgm/1zOEZMrYw/V0jcK8mWwjhHl4eP4zKkKMMP453HRIWd6PPdB+ve/DJYXgQ0kifSX8OGskYx11nnGr3mTPIm0DqBhNoXEb5S6k/O6GCzAfNG6vnIaVIsRvwQm8C9M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=xL5t2Gir; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="xL5t2Gir"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=qwCG4FOJTnYJsHofLN4IMsOnIzBcYHj6K/VBAU+hORk=; b=xL5t2GirYAcFxfHvmgEgYWUehl
	QudjXr7hEcUT32I4/WbeAckx+qaf9IbDsU9/XT6TGOrCNb0kBjn2MOAWs5FBd9skH8rSaVAIlM+h4
	+BY6F+RL4mSFE31FqpbjIeFYn75kBoFuvHDlgTK07QxJdnhGUUwkmEHG2GA+MzEFgmtM+5CUpUGit
	sntvNkTZWSZiOTRUTBwqdgfSEu/0uFk+RLDO0ARlDrTsoeeWqdtc4ZuCrOQdh6Mx96oiq2ugO6Wuo
	XpAsjUqF7iOJ6xpLIE2Rs9HMIY0Y2bmNGWAWpB6WNkv/kKMlrhZB1H07wHVja+XqawszGCaqmT8+r
	c40fwWhw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wMfnl-0000000FfLy-2XMv;
	Tue, 12 May 2026 05:37:05 +0000
Date: Mon, 11 May 2026 22:37:05 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Anand Jain <asj@kernel.org>
Cc: fstests@vger.kernel.org, linux-btrfs@vger.kernel.org,
	linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org,
	linux-f2fs@vger.kernel.org, amir73il@gmail.com, zlang@redhat.com,
	hch@infradead.org
Subject: Re: [PATCH v4 0/9] fstests: add test coverage for cloned filesystem
 ids
Message-ID: <agK8gc2niqpTuHHt@infradead.org>
References: <cover.1777357320.git.asj@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1777357320.git.asj@kernel.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

This is missing a real cover letter saying what this series is trying
to archive.

On Tue, Apr 28, 2026 at 02:42:50PM +0800, Anand Jain wrote:
> v4:
>   In _loop_image_create_clone() (Patch 1/9):
>     . Added _require_fs_space $TEST_DIR $((size * 1024)).
>     . Switched to the _create_file_sized() helper.
>     . Used the loop device in mkfs instead of the image file directly.
>     . Added a sync on the loop device before copying to ensure consistency.
>   For test cases (Patches 3/9 to 9/9):
>     . Added _require_block_device $TEST_DEV.
>   For test case (Patch 4/9):
>     . Removed the ext4 patch reference in _fixed_by_kernel_commit since
>       that part of the plan was dropped.
> 
> v3:
>   https://lore.kernel.org/fstests/cover.1777281778.git.asj@kernel.org
> 
> Anand Jain (9):
>   fstests: add _loop_image_create_clone() helper
>   fstests: add _clone_mount_option() helper
>   fstests: add test for inotify isolation on cloned devices
>   fstests: verify fanotify isolation on cloned filesystems
>   fstests: verify f_fsid for cloned filesystems
>   fstests: verify libblkid resolution of duplicate UUIDs
>   fstests: verify IMA isolation on cloned filesystems
>   fstests: verify exportfs file handles on cloned filesystems
>   fstests: btrfs: test UUID consistency for clones with metadata_uuid
> 
>  common/config         |   2 +
>  common/rc             |  61 +++++++++++++++++++++++
>  tests/btrfs/348       |  92 ++++++++++++++++++++++++++++++++++
>  tests/btrfs/348.out   |  19 +++++++
>  tests/generic/800     |  89 +++++++++++++++++++++++++++++++++
>  tests/generic/800.out |   7 +++
>  tests/generic/801     | 113 ++++++++++++++++++++++++++++++++++++++++++
>  tests/generic/801.out |   7 +++
>  tests/generic/802     |  62 +++++++++++++++++++++++
>  tests/generic/802.out |   7 +++
>  tests/generic/803     |  76 ++++++++++++++++++++++++++++
>  tests/generic/803.out |  19 +++++++
>  tests/generic/804     | 103 ++++++++++++++++++++++++++++++++++++++
>  tests/generic/804.out |  10 ++++
>  tests/generic/805     |  73 +++++++++++++++++++++++++++
>  tests/generic/805.out |   2 +
>  16 files changed, 742 insertions(+)
>  create mode 100644 tests/btrfs/348
>  create mode 100644 tests/btrfs/348.out
>  create mode 100644 tests/generic/800
>  create mode 100644 tests/generic/800.out
>  create mode 100644 tests/generic/801
>  create mode 100644 tests/generic/801.out
>  create mode 100644 tests/generic/802
>  create mode 100644 tests/generic/802.out
>  create mode 100644 tests/generic/803
>  create mode 100644 tests/generic/803.out
>  create mode 100644 tests/generic/804
>  create mode 100644 tests/generic/804.out
>  create mode 100644 tests/generic/805
>  create mode 100644 tests/generic/805.out
> 
> -- 
> 2.43.0
> 
---end quoted text---
