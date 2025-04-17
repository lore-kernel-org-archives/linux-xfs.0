Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A33551E1DE8
	for <linux-xfs@vger.kernel.org>; Thu, 17 Apr 2025 06:24:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744871097; cv=none; b=YDgmBdH/dmC5yHu1zuzd90i0oeP8neNzsbP2cwiuvv4E1CoaPMYCjAHSTdaKR9C+59bhtb7sO3ldLC8k3uTr01plyBpiYJ7pGuIVnzq2mrupbL/8W0t3OQnP8O9VXnSAE9n3QVRm7av9w3h4gleJJhfcBk8huVLrWuQ4TXwCdNQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744871097; c=relaxed/simple;
	bh=oZjcXTJwbm7GboJYZclI3KBMzW/wdq+UoyX6CzQBVpY=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=Qel45ugwhjEHB80qUfaDxKoHQFzRIErFB3kSMvmJkmVsdiZUS6s4zD7Xae5r8xhQCa4oQ3nnUIQzxoPodh+5MNal7BI8koOYauHOOo4vTXX5y6vb3AXsu7HNoxM+X8WCNDI+JwNVwjDqCscYkG2RKGUfhf5mOKEf3PVdufGAEfM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MbgW2pGa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MbgW2pGa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64370C4CEE4
	for <linux-xfs@vger.kernel.org>; Thu, 17 Apr 2025 06:24:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1744871097;
	bh=oZjcXTJwbm7GboJYZclI3KBMzW/wdq+UoyX6CzQBVpY=;
	h=Date:From:To:Subject:From;
	b=MbgW2pGaa19+LCHKNRdmi+aWJND31il5Er453bfV1wPo6ScAK8Kx682zKnkQvdLDp
	 E/zgewmuAOdY27qfGh8d8meuL4qKQvAmxk6B4cUuJD/muepfkqhOB22OEw4BjNEDSc
	 XVDVHT2Ylf3XA4l8Pj1E0c2QTbtBs5ZHEPXnH86v8aiBG4oq4R70rdUr8skGMFZ+Wf
	 bI/8r1BgfBe88AaGdmaqr419H3ro8WoOmqCwg22kql3adA46J3WPDXBDFzq7wKU84p
	 vwsTsQ1MZ0bb5oUfDdf7TR4sxGA66y4izsrUWQHv5n3n1KBFpnhhuu+xx+YnaXT958
	 /YuMS2DFF/FGw==
Date: Thu, 17 Apr 2025 08:24:53 +0200
From: Carlos Maiolino <cem@kernel.org>
To: linux-xfs@vger.kernel.org
Subject: [ANNOUNCE] xfs-linux: for-next updated to c7b67ddc3c99
Message-ID: <q3uhofvkn2tykw3zaufd4sdlomy5ezctza5k75oijwrbnhzox3@j6roxm3jb7ra>
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

c7b67ddc3c99 xfs: document zoned rt specifics in admin-guide

2 new commits:

Darrick J. Wong (1):
      [c6f1401b1d5f] xfs: fix fsmap for internal zoned devices

Hans Holmberg (1):
      [c7b67ddc3c99] xfs: document zoned rt specifics in admin-guide

Code Diffstat:

 Documentation/admin-guide/xfs.rst | 29 ++++++++++++++++++++++
 fs/xfs/xfs_fsmap.c                | 51 +++++++++++++++++++++++++--------------
 2 files changed, 62 insertions(+), 18 deletions(-)
