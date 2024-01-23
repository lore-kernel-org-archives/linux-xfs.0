Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38DE05BADB
	for <linux-xfs@vger.kernel.org>; Tue, 23 Jan 2024 10:24:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706005461; cv=none; b=dq6t3SuLoHr5OghFTr+5oP5vazoJisU2YAeaNdsItI0dTwhWE4W731bwOk6JigTTSCfRPMZ8T8Z5xXVPnsuuKCo/THviG96bjUAvPK/OdOymq/Y2MW5CFo/K3sngT9Pu4qlFnPwDXK9nhAy7dEs1GBZqwWQfM35MptcS9rBIPTY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706005461; c=relaxed/simple;
	bh=RzBNfhGdL7RmHjZj1LPNSUSmgzZCrDk6gQyG2MIW/MI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rw8dA8UqpA2niTQvWmfOu7qLUJrSaFjoDGHUjoLgnsnVPxRQ+G2ovAfXRrJe/k3rCdW0a3ncWe6vdXo8VKDWRSmvMIQSPjA6EXa2syVI3JSjPN91oJFI7Qf3ZFtP9e0GP0ErjLOK4JPhIW5Y0XH/tNVK9l6Eq6CLaMis7IhBO+Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZojQqNmi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZojQqNmi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C02CC433C7;
	Tue, 23 Jan 2024 10:24:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1706005460;
	bh=RzBNfhGdL7RmHjZj1LPNSUSmgzZCrDk6gQyG2MIW/MI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ZojQqNmicib976wSrLd5c9mRNCIyi8i80qQAQ+/9zQjGgXy0+7lvsMddrrsPkioC0
	 HncuO1Q5PIT/vEItGUm9GMKKDIHeJqHs0Dp3BmUQz5Bvw6uT6ktbPIK1yYZXNDBsb1
	 TiQ7JZLCYijriz24HM46FwA2qYnI0noIDOLqheYgZax+EvR+M4/MOGIXt7qcfamGs3
	 yVKBezYqlyqXJ898STVNxtkn0gzsZSv8VtZIGIsmwzzjzYofesK5Q7HL+3gq+YKhkp
	 Qlw2iLOBK0P0pW9e6EWB/p10ksHkowXszxwk/cqmWKy0Qg+fuTQjN8N8NTpF+8LXyi
	 PyxctydQEayxg==
Date: Tue, 23 Jan 2024 11:24:15 +0100
From: Carlos Maiolino <cem@kernel.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: chandanbabu@kernel.org, hch@lst.de, linux-xfs@vger.kernel.org
Subject: Re: [GIT PULL 1/4] xfsprogs: various bug fixes for 6.6
Message-ID: <egc52fom4p26nzmjlckmseld3nq7hdpmyy3zztqnnu775djynu@6amz5yaljaiv>
References: <TJAUF10YmnRMF984wAms4Of2JTNAyZbCYR6ZAtbW4px4CoG_sLUYTE-bwR7dPzQcolxUHVV8MBdolSz-ei6kLQ==@protonmail.internalid>
 <170321220608.2974519.4401807541250057118.stg-ugh@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <170321220608.2974519.4401807541250057118.stg-ugh@frogsfrogsfrogs>

On Thu, Dec 21, 2023 at 06:31:09PM -0800, Darrick J. Wong wrote:
> Hi Carlos,
> 
> Please pull this branch with changes for xfsprogs for 6.6-rc1.
> 
> As usual, I did a test-merge with the main upstream branch as of a few
> minutes ago, and didn't see any conflicts.  Please let me know if you
> encounter any problems.
> 
> The following changes since commit fc83c7574b1fb2258c9403461e55b0cb091c670c:
> 
> libxfs: split out a libxfs_dev structure from struct libxfs_init (2023-12-18 14:57:50 +0100)
> 
> are available in the Git repository at:
> 
> https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfsprogs-dev.git tags/xfsprogs-fixes-6.6_2023-12-21
> 
> for you to fetch changes up to 1665923a8302088744a69403ff60a1709f5d24ed:
> 
> xfs_db: report the device associated with each io cursor (2023-12-21 18:29:14 -0800)
> 

Pulled. Thanks, should be in the next for-next push

Carlos

> ----------------------------------------------------------------
> xfsprogs: various bug fixes for 6.6 [1/8]
> 
> This series fixes a couple of bugs that I found in the userspace support
> libraries.
> 
> This has been running on the djcloud for months with no problems.  Enjoy!
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> 
> ----------------------------------------------------------------
> Darrick J. Wong (5):
> libfrog: move 64-bit division wrappers to libfrog
> libxfs: don't UAF a requeued EFI
> xfs_copy: distinguish short writes to EOD from runtime errors
> xfs_copy: actually do directio writes to block devices
> xfs_db: report the device associated with each io cursor
> 
> copy/xfs_copy.c      | 24 +++++++++----
> db/block.c           | 14 +++++++-
> db/io.c              | 35 +++++++++++++++++--
> db/io.h              |  3 ++
> include/libxfs.h     |  1 +
> libfrog/Makefile     |  1 +
> libfrog/div64.h      | 96 ++++++++++++++++++++++++++++++++++++++++++++++++++++
> libxfs/defer_item.c  |  7 ++++
> libxfs/libxfs_priv.h | 77 +----------------------------------------
> 9 files changed, 171 insertions(+), 87 deletions(-)
> create mode 100644 libfrog/div64.h
> 
