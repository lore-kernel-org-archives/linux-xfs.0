Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B746C18C008
	for <linux-xfs@vger.kernel.org>; Tue, 29 Oct 2024 15:44:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730216698; cv=none; b=sUf8SH3Rpmpfz+YPgh274Y9lZYRBkKGAh0ShpO+bzLc5Jan7ArkhquqrtyRRy213O4UTPdFKLlT6XDSrvh0aVPtmQ4OldUHds6tBVy/Hkw+JbkBG3PxdRwp7VActM5oHSHAmN2W23S4rThR0xtbJ9llMbROK96EhGs9FMnsomVo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730216698; c=relaxed/simple;
	bh=lIhqutUvVz88TX22ixUZ/ak97zuWPu4KJIfDDYJLshk=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=kzKBhtRh6hXyxRuKSsdDbnpWw8aPwlpxL9hNcZ5Wl0O61uSnRW+hQTnovQKTMC4GU9F6DtaoSa4JKDzA7j9hN5M7GE5sCDd1pB5oyw/lISOq61u4Q/UVtfKR9VNehkQsXL1JRRnK1HWYC6z/UZNQGjeVJXWL3kNPc9Z9coA4UaQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ENfUvdiy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ENfUvdiy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5889AC4CECD;
	Tue, 29 Oct 2024 15:44:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1730216698;
	bh=lIhqutUvVz88TX22ixUZ/ak97zuWPu4KJIfDDYJLshk=;
	h=Date:From:To:Cc:Subject:From;
	b=ENfUvdiyY6z5Z+Tb7WkVcGq4WRujxcZgYuM+Dn3OsGSxQKnfukZ26O/whAytY6pOW
	 LGQa9YiHF1C1BZkd7g6C84FlRAc2gqDVSWtk8NSgL0WeyJjNIpV6OUlNa2fWBiki1L
	 jE/BhaVzDN9pZHIqSM4KC1M19PY8Ogy6nn4mTAWTlR/6vT4TIEriq0EYmr/SVtKj3P
	 L5cXa+wxplsiXFurrnc8hc0F1LjRYc1rRy3Rk79g3hdqzNThMDJwDk2dPVFiRbwZZ7
	 zri9p0y/TGvh9Jzqiq0OpIRQxnchHXTLBVpxCMjpLwNiJsI2EMlt7dGS6GzPtp6vcx
	 pQfUSqPcH1kIw==
Date: Tue, 29 Oct 2024 08:44:57 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Andrey Albershteyn <aalbersh@redhat.com>
Cc: xfs <linux-xfs@vger.kernel.org>, Christoph Hellwig <hch@infradead.org>
Subject: [PATCHBOMB v2] xfsprogs: utility changes for 6.12
Message-ID: <20241029154457.GT2386201@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Andrey/Christoph,

Here are all the unreviewed changes to the xfsprogs utilities that I'd
like to get in for 6.12.  I'll send a pull request with all the reviewed
patches separately; this resend is just to get RVBs for wiring up xfs_db
support for realtime volumes in preparation for future rt modernization,
and a new patch to add a mkfs config file for 6.12 LTS kernels.

[PATCHSET v5.2 1/2] xfs_db: debug realtime geometry
  [PATCH 4/8] xfs_db: access realtime file blocks
  [PATCH 5/8] xfs_db: access arbitrary realtime blocks and extents
  [PATCH 6/8] xfs_db: enable conversion of rt space units
[PATCHSET 2/2] mkfs: new config file for 6.12 LTS
  [PATCH 1/1] mkfs: add a config file for 6.12 LTS kernels

--D
