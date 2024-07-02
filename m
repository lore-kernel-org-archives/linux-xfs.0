Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 314F8BA27
	for <linux-xfs@vger.kernel.org>; Tue,  2 Jul 2024 00:51:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719881500; cv=none; b=PbE4BzA0QVBJJOg5sISKQdr4HP+qURrtyerUC0D5/t17lv1gBeZasFUhKWxO3/OHyt9U0jDst7J01p9qd/IrU7Zm18u4nntreZz4Z/hX3WVY6T86D5SeFk/8oWEOB/vWnm8V9zweDhBWkXToZeTxdStKX+9ckKtpPBgq9kJ/lNY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719881500; c=relaxed/simple;
	bh=b4eDMHDb0zHT0q0payWfHwzp55aRWxSyb6psV4Jk3nI=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=XPw2a5sQNv2vspNTNlUZYCMHXEYa17x3uPCiXcgdCJUvIwsxpjRfPx0zeQaj6t2eSKbpD9lNyljrivPyL9h8P4zxLTB5Lue2vV3oXGMPJoV6MsfZMKf1fhsxUmw6fkztIS7XJgQ8pRGo8444OTjqIfmzxVc+t1ymuZ+s56tAEks=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dfU6B005; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dfU6B005"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F38D5C116B1;
	Tue,  2 Jul 2024 00:51:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1719881500;
	bh=b4eDMHDb0zHT0q0payWfHwzp55aRWxSyb6psV4Jk3nI=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=dfU6B005intPow3N5gn+vNSU2VktzjqgNbRNIijgYQfFatltaBIQ2ipy2iqkKu6iM
	 HUCJKxxTp6Rqsmb6Lt4BOSBLTuTwJf0DDqTbabMBwmJ7DHRupbpp8sPHXCEPave29R
	 8c0x97dVhZzPRQaNGMlDsLjUCvpU7pzk+U1tkgsCcHFyK/Pi69ExqvPip/xo3puj+O
	 UtUuT/22xO0tGuurgCva3rAjjRaEBHse4X7EvAGXFGcA04zMa2UTSy5PVRXIWol0We
	 i2qQHd/hZ9btbitJPduDcQ0alcWN0Io6noa8BI2dFpTG+VfFwcuMRH7a9KJu5sGxTS
	 UpYmAjnvx1EOw==
Date: Mon, 01 Jul 2024 17:51:39 -0700
Subject: [PATCHSET v30.7 09/16] xfs_scrub: automatic optimization by default
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <171988120209.2008941.9839121054654380693.stgit@frogsfrogsfrogs>
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

This final patchset in the online fsck series enables the background
service to optimize filesystems by default.  This is the first step
towards enabling repairs by default.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

This has been running on the djcloud for months with no problems.  Enjoy!
Comments and questions are, as always, welcome.

--D

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=scrub-optimize-by-default

fstests git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=scrub-optimize-by-default
---
Commits in this patchset:
 * xfs_scrub: automatic downgrades to dry-run mode in service mode
 * xfs_scrub: add an optimization-only mode
 * debian: enable xfs_scrub_all systemd timer services by default
---
 debian/rules         |    2 +-
 man/man8/xfs_scrub.8 |    6 +++++-
 scrub/Makefile       |    2 +-
 scrub/phase1.c       |   13 +++++++++++++
 scrub/phase4.c       |    6 ++++++
 scrub/repair.c       |   37 ++++++++++++++++++++++++++++++++++++-
 scrub/repair.h       |    2 ++
 scrub/scrub.c        |    4 ++--
 scrub/xfs_scrub.c    |   21 +++++++++++++++++++--
 scrub/xfs_scrub.h    |    1 +
 10 files changed, 86 insertions(+), 8 deletions(-)

