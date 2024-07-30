Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5FEB2F44
	for <linux-xfs@vger.kernel.org>; Tue, 30 Jul 2024 00:20:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722298807; cv=none; b=emeyk8iMcmtS8CL/S42ToLHVhm4b5MWF4AN7xZxSbEf4ebrAkxjI30fulEA3gtRizApxkWCL50zB1uO8vtVbd/K1JVWL7x7CRWnedqYjVaHCLYEKO7Xrxpm2n5AWmd9VuKrZH4dtV96McSNUB8TXRn5t5fg6cNsnp/9l2gaISik=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722298807; c=relaxed/simple;
	bh=EAHYTqXnxjpdmgo3AP4RyC7aEMWIgae0PJorRAW4b2A=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=V1JGsycMgItT1/KujU4dHQtVfh64HbrqAkKIouCbKNKP/SOorF0pS1DzmnhvbqiBDoj5LPAgGHEy6yeYGgoVYhqN6LYrDEVaeOdHJEh3O1no3qMjymXp76JHaGXTVNaHFG6AVeB5hZk6CCgC33JvVxxWI0a+C6nvhm/CJlRk8F0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hQCTPQRO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hQCTPQRO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9AA3AC32786;
	Tue, 30 Jul 2024 00:20:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722298807;
	bh=EAHYTqXnxjpdmgo3AP4RyC7aEMWIgae0PJorRAW4b2A=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=hQCTPQROIiCqlQ7KG5wiCR6a7jmhM8egPzIc613isHmoT6NfINbDkP/8FACtfthqo
	 oCJx8QBXKtUURParslklIcA3x/IeMMkqSNJzoqHXnaKa5AhZKdv3WayVA3Y/dtBMt5
	 /cx2CUSjten2GT2iX5V0ctHHbSrZdvjxp1HGKSneYsBbard2AMezDb0zMqia483clA
	 XsZFe0twdzUrVGqfQpBx4dJ3s8obK3HR0uakjGlc6/kP+78BEfXd9YDk5KC4T+3ukZ
	 tb3Xmzo2kPXCAOyt9IUD92EdF0/SOvDbBwVYNw0astdPVuWIxQkEU+RP275Zhe9/Of
	 mN6nSG2V6VpsA==
Date: Mon, 29 Jul 2024 17:20:07 -0700
Subject: [PATCHSET v30.9 14/23] xfs_scrub: tighten security of systemd
 services
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, Helle Vaanzinn <glitsj16@riseup.net>,
 linux-xfs@vger.kernel.org
Message-ID: <172229848851.1349910.300458734867859926.stgit@frogsfrogsfrogs>
In-Reply-To: <20240730001021.GD6352@frogsfrogsfrogs>
References: <20240730001021.GD6352@frogsfrogsfrogs>
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

To reduce the risk of the online fsck service suffering some sort of
catastrophic breach that results in attackers reconfiguring the running
system, I embarked on a security audit of the systemd service files.
The result should be that all elements of the background service
(individual scrub jobs, the scrub_all initiator, and the failure
reporting) run with as few privileges and within as strong of a sandbox
as possible.

Granted, this does nothing about the potential for the /kernel/ screwing
up, but at least we could prevent obvious container escapes.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

This has been running on the djcloud for months with no problems.  Enjoy!
Comments and questions are, as always, welcome.

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=scrub-service-security-6.10
---
Commits in this patchset:
 * xfs_scrub: allow auxiliary pathnames for sandboxing
 * xfs_scrub.service: reduce background CPU usage to less than one core if possible
 * xfs_scrub: use dynamic users when running as a systemd service
 * xfs_scrub: tighten up the security on the background systemd service
 * xfs_scrub_fail: tighten up the security on the background systemd service
 * xfs_scrub_all: tighten up the security on the background systemd service
---
 man/man8/xfs_scrub.8             |    9 +++-
 scrub/Makefile                   |    7 ++-
 scrub/phase1.c                   |    4 +-
 scrub/system-xfs_scrub.slice     |   30 ++++++++++++
 scrub/vfs.c                      |    2 -
 scrub/xfs_scrub.c                |   11 +++-
 scrub/xfs_scrub.h                |    5 ++
 scrub/xfs_scrub@.service.in      |   97 ++++++++++++++++++++++++++++++++++----
 scrub/xfs_scrub_all.service.in   |   66 ++++++++++++++++++++++++++
 scrub/xfs_scrub_fail@.service.in |   59 +++++++++++++++++++++++
 10 files changed, 270 insertions(+), 20 deletions(-)
 create mode 100644 scrub/system-xfs_scrub.slice

