Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D57A3A9615
	for <linux-xfs@vger.kernel.org>; Tue, 19 May 2026 10:22:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779186151; cv=none; b=tmF/frhnNb+ST1+dlUDVZ62tJsu2RwYE/bdZmz5czXH1a06TGE/27UJJw4FsrHPas7OPxryxQgSpofUyeYAZXsZEBS7/uQyToe0JPjkfxpFxgsDdWiFINoNuY2CyyQmcbPu7assztGWVRGuq3fqeLOG4RYnrEMC3M43kN5u++S4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779186151; c=relaxed/simple;
	bh=XIK+LlLdCnbi+R5ks4wrehxy1V0w+HCMS7J/DRe6SI4=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=cf3eJcLmRzAoof2GZjvV0dXDatv0HF6mzJpCuFxh6yufcpkRiRgD/aikF0hk6ehLpNrdCFsnyO8C8SdhWP8oRO8IqVcWuD/j3nhdwrtk7gdGGRaMsk/PknM8K1BF40xe5v3J/UjEv3dhnEXK5dauJjm5bwTox4YUbAymzFau1XE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=uTo70t7P; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="uTo70t7P"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05D0EC2BCC6;
	Tue, 19 May 2026 10:22:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1779186151;
	bh=XIK+LlLdCnbi+R5ks4wrehxy1V0w+HCMS7J/DRe6SI4=;
	h=Date:From:To:Cc:Subject:From;
	b=uTo70t7PTYkfw9hSVBMrnJ7WB8NLU2Cjho9dFl6D3F/rx12z3QwWXLWpph5gxXV29
	 wasLQF2uEPtnd0uSnnSfKUCZfJYrCh75u3MinahESRZHeYTyWlXkDfgFF0ZDm+NV6Q
	 xrIa0iB6/25UVLMeioh1E5Hxvd5Bdc7PeXTUF3e4/ZaZMrWUI3lvSUPZtFWxiH342p
	 phnwG7CrfpeRZoUvBiJgUQMJW5HeCQcwyzLfIkQBmS7KlbGM0npw/yDugxqxs3pC5g
	 KKuOwg+1gSwByWnqypOj3cRs/vamcouPm7Dcvy0KyayA5/w/vb5a4O2vDj/0Ow2nIV
	 DBu3mOag62wcg==
Date: Tue, 19 May 2026 12:22:27 +0200
From: Andrey Albershteyn <aalbersh@kernel.org>
To: linux-xfs@vger.kernel.org
Cc: aalbersh@kernel.org, djwong@kernel.org, hch@lst.de
Subject: [ANNOUNCE] xfsprogs: for-next updated to ba267fe516d8
Message-ID: <wv62s7b5hohd45ew7frfbbqyaf6yo4rjuuezl2ytdlxsquih66@lklzpbthdm36>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi folks,

The xfsprogs for-next branch in repository at:

	git://git.kernel.org/pub/scm/fs/xfs/xfsprogs-dev.git

has just been updated.

Patches often get missed, so if your outstanding patches are properly reviewed
on the list and not included in this update, please let me know.

The new head of the for-next branch is commit:

ba267fe516d8fbdcd314b3fe7ff1ff948426d297

New commits:

Darrick J. Wong (1):
      [ba267fe516d8] xfs_healer: fix missing HAVE_LISTMOUNT flag and stubs

Code Diffstat:

 healer/Makefile     | 4 ++++
 libfrog/statmount.h | 6 ++++--
 2 files changed, 8 insertions(+), 2 deletions(-)

-- 
- Andrey
