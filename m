Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E76804317E
	for <linux-xfs@vger.kernel.org>; Mon, 22 Apr 2024 09:56:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713779800; cv=none; b=B5+PwaZbUsvuk8aDbY91xzeE3UhBR7VIFk/dHK3HJevFDb09bjwyv8NOEP7UmhmY8rlvN46ZqFvhXX6DPkF+ypGG2CHM6jVSnDhSq9m4A0J59aNTryWi8igRmMa4nMkQpXMcxD1dOsddIZxvj50KeOde1VROKkK9zIw7Obg4Q8M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713779800; c=relaxed/simple;
	bh=AZAPhTvzjNlmBcengopUXoyvoYRKX3XBs/du20E/DOs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=E5u3Myo0xqs/lE7fv+U9GYLnLYYfs0Xz1wBzaVHK7aGna/gn4ThQI71vhq90m6ZHnKhHlOZOhYIyNKKb4s7MiWZxKZueA2+rIeaobeMxjJY+42UKjSzEodVb7tfihI3XVnev/pyyZChWXtM+7WWR8MBdJ5oUBUv32i8q8Lh/QiI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jYscwhL5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jYscwhL5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48304C113CC;
	Mon, 22 Apr 2024 09:56:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713779799;
	bh=AZAPhTvzjNlmBcengopUXoyvoYRKX3XBs/du20E/DOs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=jYscwhL5lk0f/EuPbCAL9eYB3Aqpj+n85C2aQyedkqs0qvWMKny7DrzqwGX/H5O+O
	 ZMXKRFxIVlI6LfmjZkKtfnUp40ymaRRgA6AqRFfOD2Z2eyrKBC1izptlHUwCBeRnI0
	 zu/pOtVHbJCgePfvcRXtCO+OEazS7sTpHWJfsaamx7L4McpexJotqWRDn1kduttq5r
	 eEwbB/50dZUUZuxd7eUSrEZ5RQqAyML4sl1DxaPS9inI65PCNSexuSf+RT/YGpEVAt
	 9PBfva6RNXNnQqKQIxLFu52m0F9hl2hA+XNL1DOArcYF+13sCE2TyfegPTXZsvJSc+
	 DjJavOAgAQE1g==
Date: Mon, 22 Apr 2024 11:56:35 +0200
From: Carlos Maiolino <cem@kernel.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: bodonnel@redhat.com, hch@lst.de, linux-xfs@vger.kernel.org
Subject: Re: [GIT PULL 01/11] xfsprogs: packaging fixes for 6.7
Message-ID: <q4hmf27phzvtywp65mszhllxedznmw7myxkqrsyxe4vrthjgw5@hgbpf6tcai6i>
References: <20240417220440.GB11948@frogsfrogsfrogs>
 <Fq7Kw6V562tpSxV47r0mn2sh-4etwMM_H7no8iXRnyLr5MX_gduiLJfWa4E9y0rsqWdFOJb2mCA5qYWa-rsq5Q==@protonmail.internalid>
 <171339158311.1911630.13437553389622374759.stg-ugh@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <171339158311.1911630.13437553389622374759.stg-ugh@frogsfrogsfrogs>

On Wed, Apr 17, 2024 at 03:07:35PM -0700, Darrick J. Wong wrote:
> Hi Carlos,
> 
> Please pull this branch with changes for xfsprogs for 6.6-rc1.
> 
> As usual, I did a test-merge with the main upstream branch as of a few
> minutes ago, and didn't see any conflicts.  Please let me know if you
> encounter any problems.
> 
> The following changes since commit 09ba6420a1ee2ca4bfc763e498b4ee6be415b131:
> 
> xfsprogs: Release v6.7.0 (2024-04-17 09:55:22 +0200)
> 
> are available in the Git repository at:
> 
> https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfsprogs-dev.git tags/packaging-fixes-6.7_2024-04-17

I'm actually pulling this before 6.8 libxfs-sync, as it fixes the xfs_rtbitmap.h include mistake I
did previous sync, so I can synchronize libxfs with this already fixed.

Carlos

> 
> for you to fetch changes up to d27e715c3081306e1b210e64d21775457c9f087a:
> 
> libxfs: fix incorrect porting to 6.7 (2024-04-17 14:06:22 -0700)
> 
> ----------------------------------------------------------------
> xfsprogs: packaging fixes for 6.7 [01/20]
> 
> This series fixes some bugs that I and others have found in the
> userspace tools.  At this point 6.7 is released, so these target 6.8.
> 
> This has been running on the djcloud for months with no problems.  Enjoy!
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> 
> ----------------------------------------------------------------
> Darrick J. Wong (2):
> debian: fix package configuration after removing platform_defs.h.in
> libxfs: fix incorrect porting to 6.7
> 
> db/check.c            | 1 -
> debian/rules          | 6 ++++--
> include/libxfs.h      | 4 ++++
> libxfs/Makefile       | 1 +
> libxfs/xfs_rtbitmap.c | 2 +-
> libxfs/xfs_rtbitmap.h | 3 ---
> repair/rt.c           | 1 -
> 7 files changed, 10 insertions(+), 8 deletions(-)
> 
> 
