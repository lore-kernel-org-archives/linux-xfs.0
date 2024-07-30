Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2D5A1854
	for <linux-xfs@vger.kernel.org>; Tue, 30 Jul 2024 03:19:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722309552; cv=none; b=AXEZ4cbbwdBX5+p5HZjp6F+uW/0MgSyCuHLaAfM6SLVuUUqmOEsH2so3ohx49hUd/DCe/pfBfBNWBeQzb+124vD+DRsQaJlnt7f+ZBjBh/Sco9oAxcdBcRnwu39As2O+D34ohzpQ/UBPo1nFZEXBIfMeZhc49jIbiGQP3/BQW8w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722309552; c=relaxed/simple;
	bh=zDN5VkAUL9Q0TR7fXWt/dWNxeCgMceygRuIO54t7Vko=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=mZDBhRxMc5Z6oxbnSakVb1FWiVL+rIpABVKZsqpa/Oaea+2/22oFwyGSaT2df+LEYbNwc5IE1PlvfJuzAj/x3yQRUP5fUREmYpEkGFgA56ULhewZGMNJ7PSMI2CZ8bTslGgmirX10Cn1HCAs2cS/Bz66jotQWcsGtSJBSgODnRA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YgEUJtHP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YgEUJtHP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8BBB2C32786;
	Tue, 30 Jul 2024 03:19:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722309552;
	bh=zDN5VkAUL9Q0TR7fXWt/dWNxeCgMceygRuIO54t7Vko=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=YgEUJtHP/bKn8NyPpq4tggjG+PtKTqP7yREJHFh8jNUhWlM/8KSeIKTm6gIUN/QuZ
	 ADmUWPAbzu4OUr7dy77k+yPJyDWxZsnsXlXRZyuo1aAKWmJ7+xrsNAH08Eziw10aww
	 uGXC1Kst8tH34S3WGgUO262aj0u7F57d32XQFKamOCPSc1qM2QN4lb59Hpy57W+4pC
	 7hYuhGH6KlUQY/BnFUwRQNLlPw6CXINsq+gxfKPhU6i8H6Ongq6+1A4jmPmuMxb2t+
	 c+xPtHZ8alUm69eHHsg3Yr1e59N49rq2q75gl3gk458CZZ2x8/ijdT+b8uIezAa5cV
	 G/WhONksHK7AA==
Date: Mon, 29 Jul 2024 20:19:12 -0700
Subject: [PATCHSET v30.9 2/3] xfs_scrub: control of autonomous self healing
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <172230940983.1544039.13001736803793260744.stgit@frogsfrogsfrogs>
In-Reply-To: <20240730031030.GA6333@frogsfrogsfrogs>
References: <20240730031030.GA6333@frogsfrogsfrogs>
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

Now that we have the ability to set per-filesystem properties, teach the
background xfs_scrub service to pick up advice from the filesystem that it
wants to examine, and pick a mode from that.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

This has been running on the djcloud for months with no problems.  Enjoy!
Comments and questions are, as always, welcome.

--D

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=self-healing
---
Commits in this patchset:
 * libfrog: define a self_healing filesystem property
 * xfs_scrub: allow sysadmin to control background scrubs
 * mkfs: set self_healing property
---
 libfrog/fsproperties.c |   38 +++++++++++++++
 libfrog/fsproperties.h |   13 +++++
 man/man8/mkfs.xfs.8.in |    6 ++
 man/man8/xfs_scrub.8   |   44 +++++++++++++++++
 mkfs/lts_4.19.conf     |    1 
 mkfs/lts_5.10.conf     |    1 
 mkfs/lts_5.15.conf     |    1 
 mkfs/lts_5.4.conf      |    1 
 mkfs/lts_6.1.conf      |    1 
 mkfs/lts_6.6.conf      |    1 
 mkfs/xfs_mkfs.c        |  122 ++++++++++++++++++++++++++++++++++++++++++++++++
 scrub/phase1.c         |   81 ++++++++++++++++++++++++++++++++
 scrub/xfs_scrub.c      |   14 ++++++
 scrub/xfs_scrub.h      |    7 +++
 14 files changed, 330 insertions(+), 1 deletion(-)

