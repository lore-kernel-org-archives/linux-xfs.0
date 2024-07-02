Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09AC5D50F
	for <linux-xfs@vger.kernel.org>; Tue,  2 Jul 2024 00:53:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719881610; cv=none; b=lcRgVSMY/p1O7sPKFxqgfOTioeGOaEs5QZpXroSNqY7dXZiw9OHD6tBqEM3cvRgQnBMGQmFyCuHckYfRtf2l1qU4XEVccc1ldUc/4X+tY9ak/5/ORd2ciH6Fwdqqt/J6+ClJ++9fVMmaoBPke53EUALMlXAUdOjFqfIueziH/Yo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719881610; c=relaxed/simple;
	bh=gsLOgsogGoaRKaxaqVG56bohta7sgJTqEfhE4i8UiQQ=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=DBN+ansa/7ytSut+tC+QhY9WFgq9VCIocyYvGOF7EkU6WS4rAy7StKNYRm1JVha4UEy5x1wAdlf/x6DJ0FAyhzKAGRQO3GzYhfDXcx6rumN85Un7LWxAo00JLM+//YB2Ckgxyu3E1szkpIBlsbgjaFmwQfRAdEEgHNfmgdxDvGE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MtuvsksP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MtuvsksP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8FFBDC116B1;
	Tue,  2 Jul 2024 00:53:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1719881609;
	bh=gsLOgsogGoaRKaxaqVG56bohta7sgJTqEfhE4i8UiQQ=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=MtuvsksPTtQhZiW2DSVa1+nvIX1WILYx57bV3mC+Of7zzsvfgcXdlUdu6QBK/03d0
	 MTADxFCnzGq4cVHZloJ6w88NmD6qnHHvBjm+4Jzz84ZClKzlH9en6zkrjCv5ewPglC
	 L2hpnPlAiXSTi98+UVC/gQhVqog8TQuX3N5TExHkOcvoe7wn6PBEe6yo/PQ0xgg1AY
	 OmerXFwesvFakmo3pIZbsL5OSiGqPL3JQTw3Y1N1KVB8UGn4KggZlyngOF6m0FetnO
	 r6YBoTHQF6TFPRMhLX+1qOHtN6dUFmwFOsuCuu4pbpgNE2yuUKBoHf3wO9vclYWmzF
	 YJbZ3DQnYbHKg==
Date: Mon, 01 Jul 2024 17:53:29 -0700
Subject: [PATCHSET v30.7 16/16] xfs_repair: small remote symlinks are ok
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <171988123583.2012930.12584359346392356391.stgit@frogsfrogsfrogs>
In-Reply-To: <20240702004322.GJ612460@frogsfrogsfrogs>
References: <20240702004322.GJ612460@frogsfrogsfrogs>
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

Fix some incorrect validation problems in xfs_repair where it would flag
a symlink with a target that is small enough to fit inside the inode but
is in extents format anyway.  The kernel has written out filesystems
this way for a long time and used to be ok with reading such things, so
repair must not flag that as corruption.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

This has been running on the djcloud for months with no problems.  Enjoy!
Comments and questions are, as always, welcome.

--D

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=repair-symlink-fixes
---
Commits in this patchset:
 * xfs_repair: allow symlinks with short remote targets
---
 repair/dinode.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

