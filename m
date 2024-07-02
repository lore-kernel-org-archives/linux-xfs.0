Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 811ABBA27
	for <linux-xfs@vger.kernel.org>; Tue,  2 Jul 2024 00:51:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719881484; cv=none; b=QDqb+j8RaqYJwpb8UAXhmpUBRaBuVkbWBgzB6r4tedwfTXbxCJZpLmAunYVTAP7Om0LH2veU+3Tm+urebH00gXHuF8oqvYq6mE/vqdpbWbw56OPl+hc8349yYFrOf31gSsAfv0IxLpdZNf2v4M/oqgJtRzu4y1soWiq1C5mrkyU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719881484; c=relaxed/simple;
	bh=T9igyyJ1RVbBjX6roA06wNxpbajsv0PBCCzJVMmot3Q=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=XWq5DrNLMSr12IrJvU8Q6K5b0lgMVgU41DJSVLmYv0g8D/UWDltHYXVzI3kPXeFRDtYkdQGnRgu2VMxFWCQMbe4djIEk8tdJWJsnY8A0LWOsQVrv5kdBgkKHAQK/Doq2W4Kq/W0GGYOPwfCm2vvywQk0AhQLIATUjCeP2gSBVhg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EAAVo3IN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EAAVo3IN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D955C116B1;
	Tue,  2 Jul 2024 00:51:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1719881484;
	bh=T9igyyJ1RVbBjX6roA06wNxpbajsv0PBCCzJVMmot3Q=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=EAAVo3IN2cBo5yF/ybfVSrBmwGS3RDvFR4ShcLJYEK1G/5IjdOC72S/3iLG6FdSfm
	 EveOdIR8DMTPFGUUAF5DzTzelcyJEqkqKAwJBrJx35g9rTYu/QzeKfq+hyYqkY/V0r
	 EtFSXXAriC3VgcS19nvwGIlryotHnkDwOd5RMKzlPC3T1Cs2iSy3wWlJc0eEqBgwwj
	 vTgS6JlTrUKpBA0WIBZyGe/fWgpbMV5EblA5gGtigpGLr0/9u/JDP6jbqkX1noNPqt
	 9nQkLNi/FxAu0oR3zFmhYKr55bYpX7Jmntussq885WeqzIOEtvC1qwpPIdcPZ9efNs
	 NOJ26v61E2rqA==
Date: Mon, 01 Jul 2024 17:51:23 -0700
Subject: [PATCHSET v30.7 08/16] xfs_scrub_all: improve systemd handling
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <171988119806.2008718.11057954097670233571.stgit@frogsfrogsfrogs>
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



If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

This has been running on the djcloud for months with no problems.  Enjoy!
Comments and questions are, as always, welcome.

--D

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=scrub-all-improve-systemd-handling
---
Commits in this patchset:
 * xfs_scrub_all: encapsulate all the subprocess code in an object
 * xfs_scrub_all: encapsulate all the systemctl code in an object
 * xfs_scrub_all: add CLI option for easier debugging
 * xfs_scrub_all: convert systemctl calls to dbus
 * xfs_scrub_all: implement retry and backoff for dbus calls
---
 debian/control         |    2 
 scrub/xfs_scrub_all.in |  279 ++++++++++++++++++++++++++++++++++++------------
 2 files changed, 209 insertions(+), 72 deletions(-)

