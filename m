Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A38A1879
	for <linux-xfs@vger.kernel.org>; Tue, 16 Apr 2024 00:58:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713229115; cv=none; b=VGd9QXfxkanQtIFgB0CDX+BkFEL65S+kVKnuoNbsx2cc1FzTLgUHtBL8Pm4fd9WwgzWtf4ru14dJJADx+6LvtUC5R0KAJhaW0PMVrF1E+rjGvhWFDSh6s3/c/G0Ba1rtqXItxxKYvxCeENk6MWFdUyDv073wm3AflPiCdWlIzSg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713229115; c=relaxed/simple;
	bh=lBEKbyelm+ve4yXOwLVjQ9/cf+miBkZZrK/NcDtFqlk=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Kl2sHs6eKLltRUGbNdDiY1w6P1f8OCWNtz1EHVfMEhmHXNZuNByfKPeAya2xge5fPtgKGHqT9q0jKKXzJYbnTwp9GUqaJXwXix1q9qPHKTYxPbIusPNiwU4lp4szWVyvahdw4cD3xkSFNdWRUWRLoThGMuKSFzlaQj8ROS+P5i4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CShXVQyl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CShXVQyl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C73BC113CC;
	Tue, 16 Apr 2024 00:58:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713229114;
	bh=lBEKbyelm+ve4yXOwLVjQ9/cf+miBkZZrK/NcDtFqlk=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=CShXVQylli3xJ0rDCWiYGlv8RJqO3L9Fu5cAuo9uQBeccUPdpVsDhyKSW5fK/7xph
	 ClS4NqLWnaXbMFDwrCHxE1hQHZyy2b3GNoSRNcCS36buslbHSMd7uMxIvjXIjrDK+d
	 l3NmIl09SRDVTQM4yBIYGib7ajJgJT+0HdSlpj25rX0rvGLrR/MVrxDcSWGV8/SIiw
	 BLtwJ4pa4htTRGRfLLYWgzijI63AJ0aQ1e9LiKDWMvrYG6n4VAspFpyqWcx66WkhEO
	 u993XrTnfLh+4sL2YJpIYMLYy+2Br7hX+sRQ+9kfFc6cmmujSbLHZa6Ru9rN9cJlu6
	 XRmV2BG99Abfw==
Date: Mon, 15 Apr 2024 17:58:34 -0700
Subject: [PATCHSET v30.3 4/4] xfs_repair: minor fixes
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: cmaiolino@redhat.com, linux-xfs@vger.kernel.org, hch@infradead.org
Message-ID: <171322884439.214909.5121967705551682559.stgit@frogsfrogsfrogs>
In-Reply-To: <20240416005120.GF11948@frogsfrogsfrogs>
References: <20240416005120.GF11948@frogsfrogsfrogs>
User-Agent: StGit/0.19
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Hi all,

Fix some random minor problems in xfs_repair.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

This has been running on the djcloud for months with no problems.  Enjoy!
Comments and questions are, as always, welcome.

--D

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=repair-fixes
---
Commits in this patchset:
 * xfs_repair: check num before bplist[num]
---
 repair/prefetch.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

