Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DC441B85FD
	for <linux-xfs@vger.kernel.org>; Tue, 15 Jul 2025 05:16:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752556582; cv=none; b=omZY2Jb+YSWpcZP9Z271NjHnY6bZLMnqbpeqwjv/JjImVlZjrmMm8kokuL8y6GEuEG5vV08MbwnGpWnknbXGmQ+HsDNNKEhMIP9rFsxr3kDKzuYut5KrrwHyt+iJ54GIWRveyGNlTEe0LM4Pd/xyNAqovlYi8N0AVu81HoehnkU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752556582; c=relaxed/simple;
	bh=VCpKA0NS4BSdNI9FovvMfz67t/eOSIyTY7Ws4QfJQyQ=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=IiRqO7jXUlEi0ToR3JozwlYjRW6DX0I/hoHecVkkA4XLs/k0J2I7xwNqdz2NXyetx0YrMcRIw64ZUNDuZdSE1BG9FuCJ03gh4EEXf7QdzSM0FLXtX3ch92jiQdauokgYa2EC9fRkIhY01kY7Tbxcsvn8B/c5Xk6/XmtrSVQiA6Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bQOGgv6d; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bQOGgv6d"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C429C4CEE3;
	Tue, 15 Jul 2025 05:16:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1752556582;
	bh=VCpKA0NS4BSdNI9FovvMfz67t/eOSIyTY7Ws4QfJQyQ=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=bQOGgv6dkPhV9KEdn7x2sXBxzoRS24fvqtB83ilGMqctLYPQn7VlmokkmlCeUHSO8
	 vFaZUkYf1a4EvdYVod69sokCXRnlxQRvw9W/4wODCeMzJCco+ghZq2XyUJDEa9QVZS
	 satmG9UWUvuN4miEztrPGHhFe654iuz5cHr+Sq4/Qa98AuEKjfJMLNG78nWQkYfksb
	 6gwMew3joilL57/k5DC6/VQua9G7kflQ17mQPqGIquat0rXpAE/Vg/C5C2psA2cxlw
	 9vqMevqQp6C4A3w6fnvXgWsb1UvyvrNSgdEmEdmF28ebknmRpV7S4EoFHwud2JGsOm
	 +j88ti+usszAg==
Date: Mon, 14 Jul 2025 22:16:22 -0700
Subject: [PATCHSET 3/3] xfs_scrub: drop EXPERIMENTAL warning
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <175255652747.1831318.4673191938278804524.stgit@frogsfrogsfrogs>
In-Reply-To: <20250715051328.GL2672049@frogsfrogsfrogs>
References: <20250715051328.GL2672049@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Hi all,

Drop the EXPERIMENTAL warning on xfs_scrub now that we've done so for the
kernel.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

Comments and questions are, as always, welcome.

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=scrub-6.16
---
Commits in this patchset:
 * xfs_scrub: remove EXPERIMENTAL warnings
---
 man/man8/xfs_scrub.8 |    6 ------
 scrub/xfs_scrub.c    |    3 ---
 2 files changed, 9 deletions(-)

