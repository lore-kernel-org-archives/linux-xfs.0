Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3DEB38F229
	for <linux-xfs@vger.kernel.org>; Wed, 25 Feb 2026 09:38:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772012323; cv=none; b=hZJEsZvi+BVjY9MDysD1lE0E1sg6yZQP1aahhrm/LL1wrOiQQd0AULM5SWCIsTiaCvA1m6tXtacFnS3uYVDgIFCh8tETrccb+WTKm+laiaFG0epIin4IfWoI2fZNCb3zaK7jOWekwW/FWVc6gn963lO8rT0f9zI+9EC2OeMf5Ik=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772012323; c=relaxed/simple;
	bh=AMgB3skLdM++EV1np7ZtKgm+U8tcK0+DPiRRpoNsTKk=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=gFAQcyjoR4lnBc1f3Vg4cxDRbnQCFk/jbmsrn8WDCWVEUsS2kLzu/v/03C46myxALDOqxIlntggJIZIKB7yfFYTz+FJ7h8ZamNIAzxZLSkxeG9WYy1HgoYDxR8UATH3skYtV5vLb9PofgbrlyV/I58RBnCxQYfZO82X1aLFs6ss=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Nh+GaU2f; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Nh+GaU2f"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F4F3C2BC86;
	Wed, 25 Feb 2026 09:38:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772012323;
	bh=AMgB3skLdM++EV1np7ZtKgm+U8tcK0+DPiRRpoNsTKk=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date:From;
	b=Nh+GaU2foTzSpob0qaRsuqb6ZmTlMXaNWU0n0CELA9xCbwJG3TJ0hWG5mgUTdQSAj
	 OPLgjZl+MIMp9R37gQ24VZAqxvXCGAl+a1STEgy4K8KclBvJArlysIAk/Ih0iV0FiF
	 6OxUTGWvdgurG7ufe5WlIJWriOxqC8ilJem8U+Rz3MAlApnASAMWr1WPlzFeFq2iCl
	 /+Zfd654xvWzvXo4/WPtlMKhKPy7W7H0OEMTMx0TC92Z1MVWieP9uz3FdHavtkXe2+
	 huyf6x0/MTgTOFRjAWckYS2UpEAbDdxxkexStvayw3M4RH5x+vspA9v+LSOLY1tDOJ
	 7R/2hxzCFjRtA==
From: Carlos Maiolino <cem@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: "Darrick J. Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org
In-Reply-To: <20260202141502.378973-1-hch@lst.de>
References: <20260202141502.378973-1-hch@lst.de>
Subject: Re: fix inode stats with lots of metafiles
Message-Id: <177201232232.40354.4121467011038461510.b4-ty@kernel.org>
Date: Wed, 25 Feb 2026 10:38:42 +0100
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.2

On Mon, 02 Feb 2026 15:14:30 +0100, Christoph Hellwig wrote:
> the second patch fixes the active inode/vnode count on file systems with
> lots of metafiles, i.e. on SMR hard disks.
> 
> The first patch cleans up the counters a bit to prepare for that.
> 
> Subject:
>  libxfs/xfs_inode_buf.c |    4 ++++
>  libxfs/xfs_metafile.c  |    5 +++++
>  xfs_icache.c           |    9 ++++++---
>  xfs_stats.c            |   17 +++++++++++------
>  xfs_stats.h            |   19 ++++++++++---------
>  xfs_super.c            |    4 ++--
>  6 files changed, 38 insertions(+), 20 deletions(-)
> 
> [...]

Applied to for-next, thanks!

[1/2] xfs: cleanup inode counter stats
      commit: 810e363df769b096bfc9546b1c43fae803492cde
[2/2] xfs: remove metafile inodes from the active inode stat
      commit: 428980f6202be859428afd9887cb122028de00d5

Best regards,
-- 
Carlos Maiolino <cem@kernel.org>

