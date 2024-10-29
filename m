Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCFCC1990C9
	for <linux-xfs@vger.kernel.org>; Tue, 29 Oct 2024 15:47:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730216861; cv=none; b=lEPpA92ByqLimlfk6tqYBMgUStLaZ+mcOdjmLCy88jSnD/MCeSAxUHoGU/3Y1WFzbsi3FJJ5kmnj9jWJ8fY8hZWcJSyF13Fz/SYISDCL9pljcvXAe6KziQXNFkPoheIJlsnZjFNso63w+ZpewaycT0S5cLODoNbJpBnqS8LIWO4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730216861; c=relaxed/simple;
	bh=C8gSNYWlfslg9Asb4qqcZq0K94euwlKdFjnSovukh4c=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=KgYQqjWnGjWh4EuEAcdxfqiI6ze13q8qlDo29NMqIe/62E73THvcES4yn1WgqFSlyYzPGSknIrtphhnXUK26iSqAEKjQGyuAFSTSWyElwHJ31J6SyAGGRRfHf39lWuTsqRVYIrjCWr/gj8Tt1X+ZKLwB7LWZ8F++BEgn+Wtrnik=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QV5aYCUg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QV5aYCUg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45147C4CEEF;
	Tue, 29 Oct 2024 15:47:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1730216861;
	bh=C8gSNYWlfslg9Asb4qqcZq0K94euwlKdFjnSovukh4c=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=QV5aYCUgsv85CstPfkfkuXBo42kPFwsQSyfdJX9n8nC1N5pe1kjzeJhlKbdmumK1L
	 7EaVOsuBaRXa2WPBsE1wdaquvfkt5lVsqjr3wWiDBWFnw/efS/5q337q5vQWi4YX3u
	 Q9oyCNYnzoMvCIhFMWdqAWaV86AIgVq4WWFqH2zzwCPtcG/8d/s7uV78JedR0RiTaq
	 fS17139KQYUyxB2xpfdJWrSxbwdWqpp3J2v0BvLCXMyxKg6cdR1BkUDy/slQEZlzLD
	 aoOfmm+8sE/Vo9tOJNw094KxoAjcux+5zQQ4TIbeEV/gEx2g2bCqpE7uB1+5yfOhzB
	 RUdIvtS5+czZw==
Date: Tue, 29 Oct 2024 08:47:40 -0700
Subject: [PATCHSET 2/2] mkfs: new config file for 6.12 LTS
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, cem@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <173021673665.3129044.1694990541450985907.stgit@frogsfrogsfrogs>
In-Reply-To: <20241029154457.GT2386201@frogsfrogsfrogs>
References: <20241029154457.GT2386201@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Hi all,

New mkfs config file for 6.12 LTS.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

Comments and questions are, as always, welcome.

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=mkfs-configs-6.12
---
Commits in this patchset:
 * mkfs: add a config file for 6.12 LTS kernels
---
 mkfs/Makefile      |    3 ++-
 mkfs/lts_6.12.conf |   19 +++++++++++++++++++
 2 files changed, 21 insertions(+), 1 deletion(-)
 create mode 100644 mkfs/lts_6.12.conf

