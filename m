Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D3721F151C
	for <linux-xfs@vger.kernel.org>; Tue,  2 Dec 2025 01:27:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764638844; cv=none; b=lW9gYLKQLifAp7Ov0a55sXzl3cvIodYcIP4g3cF2PYgTI2SQbtmYWAfGhdtpQ2rvZLbtbi3gwuwda98zpzV626YDEIRa9NfwG01iQYArVTvPwIF/rMcuU9T5KuVCw8ILuLFW80/tYuXgIRjMwPOgfz1OgTEd/k3S1i8p+1CaU/I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764638844; c=relaxed/simple;
	bh=YS6SHVgdNPLRxQL+BX1rHru1uPgrjXbbr0kMgknJm9I=;
	h=Date:Subject:From:To:Cc:Message-ID:MIME-Version:Content-Type; b=bwEI6N7xvheLljzGG530rvTH2xQrQCCSE06DKBbcPS1Kna7OU+8mDswIy2Zn/Pui6KTrQ0gVU0tFrHAiLjWIjYemLFHhLIVR+Y7L3w1qOF/oCHO9k5OrCV8bD12dg7b3ER/5OVyNGSe6Crmg9hURPmOLFJTXPAaFeUsmjYOiCbY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DgcyOZJV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DgcyOZJV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DFD46C4CEF1;
	Tue,  2 Dec 2025 01:27:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764638843;
	bh=YS6SHVgdNPLRxQL+BX1rHru1uPgrjXbbr0kMgknJm9I=;
	h=Date:Subject:From:To:Cc:From;
	b=DgcyOZJVijxKV8KaQiFhVe5oamIMGKJrDt1HmrcsY9PkzL6lLpTnd498NkANEqHUr
	 oPJYylR7hJsRO3lu4O8Uiu2xwbDF9gVHKJeHJDZwU7RseVV/up31cM1y5YdrSoEhw5
	 SnTNXTsCucffmnspb12rOS50v6LNZKYbZqbvq/To5kCcUVlFQvprr7XtN350UXiOI6
	 7/TDY1eFhza6h6RV38MW3ait+Nxx7YYcqYhKowt0QK9TwxVp9n1mZT7cZ5hxwoym1r
	 gIIls92U2IbU4xegq9JhRoUI8EiFOb97wOexw83EiQnSEJ2DWWPlP/deyK8lZaOupd
	 swELeDfvHtnkQ==
Date: Mon, 01 Dec 2025 17:27:23 -0800
Subject: [PATCHSET 2/2] xfsprogs: enable new stable features for 6.18
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <176463876373.839908.10273510618759502417.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Hi all,

Enable by default some new features that seem stable now.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

This has been running on the djcloud for months with no problems.  Enjoy!
Comments and questions are, as always, welcome.

--D

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=default-features
---
Commits in this patchset:
 * mkfs: enable new features by default
 * mkfs: add 2025 LTS config file
---
 mkfs/Makefile      |    3 ++-
 mkfs/lts_6.18.conf |   19 +++++++++++++++++++
 mkfs/xfs_mkfs.c    |    5 +++--
 3 files changed, 24 insertions(+), 3 deletions(-)
 create mode 100644 mkfs/lts_6.18.conf

