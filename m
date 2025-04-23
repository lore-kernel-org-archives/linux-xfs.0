Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E1D0190472
	for <linux-xfs@vger.kernel.org>; Wed, 23 Apr 2025 20:03:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745438596; cv=none; b=uAwR0rgPFoSfNwVgwVr9ra+rUs9icbMkUJ4OzG6Dah95Cv/lYuyZe+nK8LSXFu9v1xeydBnHpKDciz3Jfi9JHG4Wq6aciPlpnPUz+Qsop9J0a9vEnnjtUuddPrCRqlY6/gVAQcAQx9YW7m9AuhEqfe9Damk4mKxAWcrNIhG223s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745438596; c=relaxed/simple;
	bh=qDXxUr3jeJggpm7HwjeX54HSaRuCsDJ0W0Sdh5y8ifQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=eqfY7tKJKCtAALFxDZCuVMFE4FYRAwGKBk051zTDm9tABcJoc0iYbueqagV6ZrGVhrl53XnhmapjFGT4HggZ6qe7Etx6mEAtFNkozm0+c/f+xa4hjS0mzfR4d8IDZR3quIsuulRyfxj+7z9yG5hwEdsoBY4ljZ5ka9Azom3zk2g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LFIkzUHr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LFIkzUHr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 950A4C4CEE2;
	Wed, 23 Apr 2025 20:03:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1745438594;
	bh=qDXxUr3jeJggpm7HwjeX54HSaRuCsDJ0W0Sdh5y8ifQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=LFIkzUHr7lmCtUJ9+orfhyHVJT7Qnyx50GsP0ybLdhByWpY6McujhvWExWPLQLQOd
	 7c6/bV9hVltNQ88MUoSLgejUBRruxcQA9Tll6UQn8zrgwaP5Z1hsnmRbo7RtLDtoFK
	 6hdQwF+f/UnKhgL4suwTzpzRTwy88Wxu0vq2w8AH+p4saFTepixpsDfu8te5yKXAmb
	 204j5KFx4bdellNXX7w/yu2V/Vmf/Yw4Jnq1aPY9ZT2qeldNnaSq8W8yXIV8jVJAP3
	 jZyMdYymmVVuZfCAWlGd85JgiXoW+tKUsB3F8InJchVHmp26qOb8FMhXrdfv1ANnSz
	 LTZ6eMDBNsIEQ==
Date: Wed, 23 Apr 2025 13:03:14 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Luca Di Maio <luca.dimaio1@gmail.com>
Cc: linux-xfs@vger.kernel.org, dimitri.ledkov@chainguard.dev,
	smoser@chainguard.dev, hch@infradead.org
Subject: Re: [PATCH v6 0/4] mkfs: add ability to populate filesystem from
 directory
Message-ID: <20250423200314.GG25675@frogsfrogsfrogs>
References: <20250423160319.810025-1-luca.dimaio1@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250423160319.810025-1-luca.dimaio1@gmail.com>

On Wed, Apr 23, 2025 at 06:03:15PM +0200, Luca Di Maio wrote:
> Currently the only way to pre populate an XFS partition is via the
> prototype file. While it works it has some limitations like:
>   - not allowed spaces in file names
>   - not preserving timestamps of original inodes
> 
> This series adds a new -P option to mkfs.xfs that allows users to
> populate a newly created filesystem directly from an existing directory.
> While similar to the prototype functionality, this doesn't require
> writing a prototype file.
> The implementation preserves file and directory attributes (ownership,
> permissions, timestamps) from the source directory when copying content
> to the new filesystem.
> 
> [v1] -> [v2]
>   remove changes to protofile spec
>   ensure backward compatibility
> [v2] -> [v3]
>   use inode_set_[acm]time() as suggested
>   avoid copying atime and ctime
>   they are often problematic for reproducibility, and
>   mtime is the important information to preserve anyway
> [v3] -> [v4]
>   rewrite functionality to populate directly from an input directory
>   this is similar to mkfs.ext4 option.
> [v4] -> [v5]
>   reorder patch to make it easier to review
>   reflow to keep code below 80 chars
>   use _() macro in prints
>   add SPDX headers to new files
>   fix comment styling
>   move from typedef to structs
>   move direntry handling to own function
> [v5] -> [v6]
>   rebase on 6.14

Urrrk, one revision per day, please.

--D

> Luca Di Maio (4):
>   proto: expose more functions from proto
>   populate: add ability to populate a filesystem from a directory
>   mkfs: add -P flag to populate a filesystem from a directory
>   man: document -P flag to populate a filesystem from a directory
> 
>  man/man8/mkfs.xfs.8.in |   7 +
>  mkfs/Makefile          |   2 +-
>  mkfs/populate.c        | 313 +++++++++++++++++++++++++++++++++++++++++
>  mkfs/populate.h        |  10 ++
>  mkfs/proto.c           |  33 ++---
>  mkfs/proto.h           |  22 +++
>  mkfs/xfs_mkfs.c        |  23 ++-
>  7 files changed, 385 insertions(+), 25 deletions(-)
>  create mode 100644 mkfs/populate.c
>  create mode 100644 mkfs/populate.h
> 
> Signed-off-by: Luca Di Maio <luca.dimaio1@gmail.com>
> 
> --
> 2.49.0
> 
