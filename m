Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 191A6C133
	for <linux-xfs@vger.kernel.org>; Tue,  2 Jul 2024 00:51:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719881516; cv=none; b=f216Yd6aqoJzy4Cm87Avkv62HqAvOcYVDdMC8XTuAs7c6dNrZFsO3mpwYI/EdRxU1VoVeS7L6F9mrCmP5kfRVB19a6cRkP67HNx1oR+gmLXcjcU0u38RWhCEdwMESLFhCh5S3aLsqRZRbeNU2h0+d3rdGSM0rUXNMbMoEeaErVQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719881516; c=relaxed/simple;
	bh=IVvA0FT06Ycwx5X+9PjM3x2d4LDl975DQaimPhABe9s=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=SUeA00Ti22x8KIYocgiHF829mYMm3s05pqZ10cv6UVnI21wLhtdAP0JZNFDT/r7CWOJGD6Kdxm01VJRLNTo/eHLq53SV4wTULrD/kFMwsUVe/3q7U9uI2ytB1rlYkhdVlILISEi3hV68zgEa3qu1WOon1A7a9Hqd0gZHMO/gkp0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lTTekMm9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lTTekMm9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F808C116B1;
	Tue,  2 Jul 2024 00:51:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1719881515;
	bh=IVvA0FT06Ycwx5X+9PjM3x2d4LDl975DQaimPhABe9s=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=lTTekMm9Cy/TZbVVQxqwfoM19xT9vNcGp4DCa9Pj+u0odJIfy8gk0ZawoYt7Wdk/t
	 UXLGqWn4TMYt8UoV7VAs/+Ddaop6m5EAi+p4Wo8a5SrpzKKkXp+HheATZ73AiWmfch
	 PGtEG44HfJMV40DkLikXM0OhBYGsGZ+yo/oEvuqSolDSxoeD26n/1jpaxXBefQrKrG
	 9P1pWKyxmzRCUK5oy5TK/8ntdzODWEmWWPd5NghpXviDwcT86aONURsYvO3ivlAXaO
	 dd97XWg8s5027CVC6KsUPOaizXfT87sA5fssq9IEY+8MooHAYD3AGEh/XC7eNeiTlR
	 FH2zs3niE1Zqw==
Date: Mon, 01 Jul 2024 17:51:55 -0700
Subject: [PATCHSET v13.7 10/16] xfsprogs: improve extended attribute
 validation
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Chandan Babu R <chandan.babu@oracle.com>,
 Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <171988120597.2009101.16960117804604964893.stgit@frogsfrogsfrogs>
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

Prior to introducing parent pointer extended attributes, let's spend
some time cleaning up the attr code and strengthening the validation
that it performs on attrs coming in from the disk.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

This has been running on the djcloud for months with no problems.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=improve-attr-validation

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=improve-attr-validation
---
Commits in this patchset:
 * xfs_repair: check free space requirements before allowing upgrades
 * xfs_repair: enforce one namespace bit per extended attribute
 * xfs_repair: check for unknown flags in attr entries
---
 include/libxfs.h         |    1 
 libxfs/libxfs_api_defs.h |    1 
 repair/attr_repair.c     |   30 ++++++++++
 repair/phase2.c          |  134 ++++++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 166 insertions(+)

