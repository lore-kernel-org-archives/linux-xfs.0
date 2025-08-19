Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E8EC2AE66
	for <linux-xfs@vger.kernel.org>; Tue, 19 Aug 2025 13:10:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755609057; cv=none; b=Nql+rxKsAu1pLDqzt90YtF+0uKZBm9DORB2MQw5F9J/EycrD49d0nJn0ifIptavjtyAkHFaWbl3wykZBKtKdT6EXdGstCRR/m3GaaSP2imbIt8Rgm7x+hqASYUVrBQRaLtmbK5karTTA9Em7eLoMYQvWMvhs2oX2RbkYjD/smPA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755609057; c=relaxed/simple;
	bh=jKPYuhdR4CtotnTq+xeJq41XgIAFUlnwUXCSHkvgdEo=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=jpMCk5suwfw8e2AdmkvtEjlrLXj1vb5cMoWqOxrXT89oSEyKPBEGBWuC1UPr0GbtW8ZOKq80jjv7CHfqsEtkCkAENT2J6KqY3omJnuc+wCS9XlkvfQ2urKmyEfaeS/WfKOuw9JKSdqHlsDr2muaFNVv0p7J/g3iGUQ5zyD9YuBI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HduzeyIT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HduzeyIT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D656C4CEF1
	for <linux-xfs@vger.kernel.org>; Tue, 19 Aug 2025 13:10:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755609056;
	bh=jKPYuhdR4CtotnTq+xeJq41XgIAFUlnwUXCSHkvgdEo=;
	h=Date:From:To:Subject:From;
	b=HduzeyIT1CW3oJVoDK240P7hfhLwsNAKLK2kELt/FN/iZVP3SZgPNoQ/xqChQUceF
	 0Z68pqk0E/8u1rNCwDN9n880lLN8jqm1vI4uzjbCtpyxvFpgbXUFL//25RKHXHWcT4
	 3iSPM2GS5NJJMpIk7KTvfu+tEfrH/cdH8ywXHX8zlDDcePhLYEbsJXrfQyorwPPKr3
	 c9aXdaYeBWrpocKs1BWucdeIN0SiSlMfjHXc1Gl/TGULYtXd478iv2LXam2XnrUZij
	 tpze/tHPg/Ocbw1VLUKdcxaeD2h6+vmtN7NOQi+SHEc9A9sG2xnMqdA7tpvGQ7/D8l
	 RAr9xOYMnLeSw==
Date: Tue, 19 Aug 2025 15:10:53 +0200
From: Carlos Maiolino <cem@kernel.org>
To: linux-xfs@vger.kernel.org
Subject: [ANNOUNCE] xfs-linux: for-next updated to 8e5a2441e186
Message-ID: <esxnoimp2phpyir6nzgj346vazrl3cm2ofxtbtxffl3yvidmbo@47wrf32gello>
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

8e5a2441e186 xfs: reject swapon for inodes on a zoned file system earlier

4 new commits:

Christoph Hellwig (3):
      [d004d70d6cdf] xfs: remove xfs_last_used_zone
      [7d523255f524] xfs: kick off inodegc when failing to reserve zoned blocks
      [8e5a2441e186] xfs: reject swapon for inodes on a zoned file system earlier

Damien Le Moal (1):
      [9ce43caa4b7b] xfs: Default XFS_RT to Y if CONFIG_BLK_DEV_ZONED is enabled

Code Diffstat:

 fs/xfs/Kconfig               |  1 +
 fs/xfs/xfs_aops.c            |  3 +++
 fs/xfs/xfs_zone_alloc.c      | 45 ++------------------------------------------
 fs/xfs/xfs_zone_space_resv.c |  6 ++++++
 4 files changed, 12 insertions(+), 43 deletions(-)
