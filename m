Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DCCB28368B
	for <linux-xfs@vger.kernel.org>; Tue, 22 Apr 2025 14:08:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745330938; cv=none; b=KSN+eYZ08AT8qCVWJWeVelSvwG8FWMH3XquISsSQmyzLQDS0cZnJSyTy6Cq5b/19qq/FWk/4oe/8sQKnJSPlqb1dCDGmtlLqnF7qvOZTisFG1uPC6USMZ0uv/RsLsmGJiZ9j62ZrDAlgZMyC7X8oypVIqkMMI3kI0rQ7GHWvsL4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745330938; c=relaxed/simple;
	bh=m5lrbSn3KIt1lrNUoPRQuo0ePkADqQKdYT2uNdtcnpg=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=ehJvBMnR0KVxL0VNnNDtJcodDzuWlXNcEc4/rPPlFVfILsrEm4K+7HSOPP3A/UKh+3dq0LA4JbV3yPFlE/NiCtzyq++8A4h7U18ZeHV+aR2uUCyf7YE4mhiN6LU/R2NbzqgBnSLyrCLXA7DM+uAretLVL/jZRuCxl3QReNNBycQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=pa64w6/P; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="pa64w6/P"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C86AC4CEE9
	for <linux-xfs@vger.kernel.org>; Tue, 22 Apr 2025 14:08:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1745330936;
	bh=m5lrbSn3KIt1lrNUoPRQuo0ePkADqQKdYT2uNdtcnpg=;
	h=Date:From:To:Subject:From;
	b=pa64w6/PsywfNtYzKEI+ZVkZge/KPa7kYNoL/9AdY4pSQGPbjq1X4gr66Qjjc+iTe
	 yDB/H8ibQtGY0Dcc2LntEItveBVpNbqzKDOOXhEDfeV02NjCyJR5cAWe6LxiKVXKR6
	 rp/tO3DLkyFExtHcerdqZp3L9B8hOb3BcQ4rt6Zj6kubJxPBqVhky2tZVi8OxOP2Pb
	 O8GysbXCiSDPBIFkPlyPH0KwAlS2lDM0kcrH2DvbQ1m8754er8YZ2+2hVgl91ZsyGz
	 KaA/HRjo+XHevHGuzvgN36jKoGlVjRZEoiFotiW7jdgwlkwhxKLBI6uKP4JHL8ZjUS
	 GsHhJW9DKYA/w==
Date: Tue, 22 Apr 2025 16:08:50 +0200
From: Carlos Maiolino <cem@kernel.org>
To: linux-xfs@vger.kernel.org
Subject: [ANNOUNCE] xfs-linux: for-next updated to f0447f80aec8
Message-ID: <lny533azxmcarhbib3bmkzk2jrpzlmj4i5ziy4k4macgggbqy3@uubaveftjqtd>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline


Hi folks,

The for-next branch of the xfs-linux repository at:

	git://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git

has just been updated.

Patches often get missed, so please check if your outstanding patches
were in this update. If they have not been in this update, please
resubmit them to linux-xfs@vger.kernel.org so they can be picked up in
the next update.

The new head of the for-next branch is commit:

f0447f80aec8 xfs: remove duplicate Zoned Filesystems sections in admin-guide

2 new commits:

Carlos Maiolino (1):
      [bd7c19331913] XFS: fix zoned gc threshold math for 32-bit arches

Hans Holmberg (1):
      [f0447f80aec8] xfs: remove duplicate Zoned Filesystems sections in admin-guide

Code Diffstat:

 Documentation/admin-guide/xfs.rst | 29 ++++++++---------------------
 fs/xfs/xfs_zone_gc.c              | 10 ++++++++--
 2 files changed, 16 insertions(+), 23 deletions(-)
