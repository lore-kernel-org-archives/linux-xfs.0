Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73517653
	for <linux-xfs@vger.kernel.org>; Tue, 30 Jul 2024 00:20:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722298839; cv=none; b=Ezqtlld2L4RwCvLkAPNiK8a64KtthIyuCZ5lsBhvNGALo2KLZ3w39oykoDrFOUP0CEP6hBILQh2lvrWnQPDAIiuqhxv4dDc9ykApUwmi0rENJcwUU7Rgax0DWOFhlDx4iPYSxU7x63HE3H6xiSbMbfs29I0E3/IQddJAzfqFibc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722298839; c=relaxed/simple;
	bh=/HWNdKEw6G+iaQ3sJyEbYAe+azBM47ak0Blm3Ux1b5Q=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Tv5Ll7Uah5SlbkWUc4s3V6Ns9U/vNr8q3MuAnHFye8H8ugTl0iwsjIVHkhSXHKRy0i0Gnnu5jrB1uIIehqwda6u1Jp16fme7FAf9I6tVh2vwv+AcyPbesfZvEa/dOzNd00XE94eCoaSHfnAq2J9Jmw9Qb9m73AEbNKBrgsY1oEQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UILPB7Fq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UILPB7Fq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 020C3C32786;
	Tue, 30 Jul 2024 00:20:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722298839;
	bh=/HWNdKEw6G+iaQ3sJyEbYAe+azBM47ak0Blm3Ux1b5Q=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=UILPB7Fq93Fc/dZXrz0raQI+GKr+bH5PxsrUh2cMUce3AdIz8tPAN02Tdk5GTvlmP
	 Cn+iHqPm7ezbNOZ4Fo1Wi0XXRtId/8AGg5KrjQMDPcTvh8mUICW/Y6IqeptIO/kY3X
	 HCT8tGk8ZmAvhvIHUCPlQjIYS3cwhQ1IjTXK6uNknn1sQr3/NTCG2FXCrXyfA/m3G4
	 VuI/J0vqV3czGe63V6/LXvFfNe5Z6RU+wtihT02b0pQg9j90U89PCkhSJ4SMuniblp
	 oMIPM+Rtg2ldFCxGZIGzCV8bm6nRSibTVhiunwPSsdpqtGDAuNLxp35EMLpdPO3k1Y
	 a2KbvjYElEbQg==
Date: Mon, 29 Jul 2024 17:20:38 -0700
Subject: [PATCHSET v30.9 16/23] xfs_scrub_all: improve systemd handling
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <172229849638.1350420.756131243612881227.stgit@frogsfrogsfrogs>
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



If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

This has been running on the djcloud for months with no problems.  Enjoy!
Comments and questions are, as always, welcome.

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=scrub-all-improve-systemd-handling-6.10
---
Commits in this patchset:
 * xfs_scrub_all: encapsulate all the subprocess code in an object
 * xfs_scrub_all: encapsulate all the systemctl code in an object
 * xfs_scrub_all: add CLI option for easier debugging
 * xfs_scrub_all: convert systemctl calls to dbus
 * xfs_scrub_all: implement retry and backoff for dbus calls
---
 debian/control         |    2 
 scrub/xfs_scrub_all.in |  284 ++++++++++++++++++++++++++++++++++++------------
 2 files changed, 213 insertions(+), 73 deletions(-)

