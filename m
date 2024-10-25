Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38C1418C018
	for <linux-xfs@vger.kernel.org>; Fri, 25 Oct 2024 06:31:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729837873; cv=none; b=e4L2INZGAj0gGf7ZCqkecLq1qnylE3WgJEnbhLVx+LDFQi7S9abZVopktnA1FRXVAIlej+5dMVe9G5y+q/U3RHTcWwQDjdbyFhn5z7+nDZFxRooIKRXfopdUe5Ucoo4runxYKsKJoPbL2VEYrHBGZUHXCJZzKVPRvgpn2FtJCSE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729837873; c=relaxed/simple;
	bh=0wiLSOq5cV8MHlRmDPoQfMQqMngPKXNf+zxM0lSbmqA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NgMB7E3Jdsf8BfTCdhaCtynhP8RqE2IzwAaizTU3uJhWmlYABupZQN72oVPIiYiecwBxNbq0fSPJanqgBJOOPTQTsM+2BV14/h+y/skfK5XIngXKwM41PnQkNpWIcR9NYVrvuenI3uygTecQi8kki9ri1N3BzbqtHYHTPNgGqjI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XD2ZBrZC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XD2ZBrZC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7657C4CEC3;
	Fri, 25 Oct 2024 06:31:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1729837872;
	bh=0wiLSOq5cV8MHlRmDPoQfMQqMngPKXNf+zxM0lSbmqA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=XD2ZBrZCC6tfoMvcEkUiBNMZF0o1Cc8xk55n3hdmdP2tDQB7Cl5tz375P+sbTVUzH
	 /kZ5pfs0STCfdh8d7i7uF1QjDgcodx0FStv/mWv4gfb6bIKfI5UICgHhkqwcYLsDAz
	 6mkNtJqdKaP2DY/V752jushwh90dOcTUHx9MP3EgYXraJAJ3AW2aKJO7yoPI/qaADK
	 2i7hukH9qwomd5lufS79OYqhkjmFaTB3QsOkcQXOULlHaTklfaqjVrOylyutkHff2b
	 aS+koRfMkwuURTxFPrJRKbASU2/NTdFHqO0RdUS5Pk352UtOLatwOjW1pKz1JQu8P3
	 aLgzJpLtHVvaw==
Date: Thu, 24 Oct 2024 23:31:12 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Andrey Albershteyn <aalbersh@redhat.com>
Cc: xfs <linux-xfs@vger.kernel.org>, Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCHBOMB] xfsprogs: utility changes for 6.12
Message-ID: <20241025063112.GI2386201@frogsfrogsfrogs>
References: <20241025062602.GH2386201@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241025062602.GH2386201@frogsfrogsfrogs>

On Thu, Oct 24, 2024 at 11:26:02PM -0700, Darrick J. Wong wrote:
> Hi Andrey,
> 
> Here are all the changes to the xfsprogs utilities that I'd like to get
> in for 6.12.  First we add support for the new exchange-range ioctl,
> then wire up xfs_db support for realtime volumes in preparation for
> future rt modernization.  Then there's some refactoring of mkfs, and a
> bug fix for xfs_scrub_all.

And this is commitrange, not exchangerange.  We already did
exchangerange.

> None of these patches are reviewed.

Heh, sending patches too late at night after a too busy week.  Some of
these patches are reviewed; here are the ones that aren't:

[PATCHSET v31.2 1/5] xfsprogs: atomic file content commits
  [PATCH 1/7] man: document file range commit ioctls
  [PATCH 2/7] libfrog: add support for commit range ioctl family
  [PATCH 3/7] libxfs: remove unused xfs_inode fields
  [PATCH 4/7] libxfs: validate inumber in xfs_iget
  [PATCH 5/7] xfs_fsr: port to new file exchange library function
  [PATCH 6/7] xfs_io: add a commitrange option to the exchangerange
  [PATCH 7/7] xfs_io: add atomic file update commands to exercise file
[PATCHSET v2.6 2/5] xfs_db: debug realtime geometry
  [PATCH 1/8] xfs_db: support passing the realtime device to the
  [PATCH 2/8] xfs_db: report the realtime device when associated with
  [PATCH 3/8] xfs_db: make the daddr command target the realtime device
  [PATCH 4/8] xfs_db: access realtime file blocks
  [PATCH 5/8] xfs_db: access arbitrary realtime blocks and extents
  [PATCH 6/8] xfs_db: enable conversion of rt space units
  [PATCH 7/8] xfs_db: convert rtbitmap geometry
  [PATCH 8/8] xfs_db: convert rtsummary geometry
[PATCHSET v2.6 3/5] xfs_metadump: support external devices
  [PATCH 1/1] xfs_db: allow setting current address to log blocks
[PATCHSET v2.6 4/5] mkfs/repair: use new rtbitmap helpers
  [PATCH 1/6] xfs_repair: checking rt free space metadata must happen
[PATCHSET v31.2 5/5] xfs_scrub_all: bug fix for 6.12
  [PATCH 1/1] xfs_scrub_all: wait for services to start activating

--D
