Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67ACD19049B;
	Fri,  4 Sep 2026 06:25:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788503158; cv=none; b=eY1TGAVlXC5FazyXnB1gxgx5zuurI6OebI9FLFhpZk14q8P6WEFKSytOZ+xr8hgGptZ7r+J45TITaYJ3N2KGGWt0uiV+UCI1UWptuW9GuvZEMdPT1Dm6dANoNM+8NECs1FIztrnb7bmVTXUFd/hSGBJC+SxxkjY6Zfz913WE/fI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788503158; c=relaxed/simple;
	bh=JDG4tJ3Q3YdoOoNeTt+HXP2MmqStTXKcx0FiJvY2SPY=;
	h=Date:Subject:From:To:Cc:Message-ID:MIME-Version:Content-Type; b=eumrtLmRCqBx7IwGkzxl7ziWv8D8Lydg0WpdkrBucwIYmA6GYg1++lm4gQ361uXW8y8c2eWPvQMfcjam4wMD1j+gwSggrMZcvKAtoRAC7n7fsv8+AQWCTPTzLWUyd3OHozffyAXZAuaaMsIpxIj0B3crUz+/eXOG+NZXvaDtlZw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=P+6vX3BK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="P+6vX3BK"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id DCAC31F00A3D;
	Fri,  4 Sep 2026 06:25:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788503157;
	bh=kkpvFFFtuUjS6DM1M9pl2zRaBgvSuXkTaQs94dcMjAU=;
	h=Date:Subject:From:To:Cc;
	b=P+6vX3BKvArhV8VLpinlyLKPdEG+nQ2S+oK+sxvoa0GkRCtp4ax4J1DZVLkHbXf8A
	 PD3dCY5NX0zIXaUCUZOtn/HkGgHz28qnIwfhPR2uxRAPkVhEWAQGemZ/VX+tU8hBlX
	 Fo/V0k9fB2VYHUKmTJoY4KRZsbRh7XJIcs9+TU6ZhdbMkjaeXGqoMsm1G+WhmAvJNr
	 QXwBvdD6grilepEBdb2MIlPnNdFjjDoIfHvFawfhLBJ3hgR3p8jbyDFUGnORaUe72H
	 PJScG3PgehX/LUt7KsvcWSHwytD6wKjq3t95beY+0nUKSEk/F9hXDXiWqlaEyBDDq4
	 rmtEG2+Fz6pgw==
Date: Thu, 03 Sep 2026 23:25:56 -0700
Subject: [PATCHSET] xfs: LLM-inspired bug fixes, part 11
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, hch@lst.de, djwong@kernel.org
Cc: stable@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <178850312462.1198660.3332635535003842521.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Hi all,

Here's an eleventh batch of xfs fixes resulting from a LLaMma.  Mwa mwa
mwa...

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

With a bit of luck, this should all go splendidly.
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=llm-fixes-11
---
Commits in this patchset:
 * xfs: snapshot scrub stats when rendering them
 * xfs: report healthy filesystem events in scrub stats
 * xfs: report runtime failures in scrub
 * xfs: remove redundant function declaration
 * xfs: snapshot old AGFL before rewriting it
 * xfs: bail out on bitmap errors in xrep_agfl_fill
---
 fs/xfs/scrub/dabtree.h         |    2 --
 fs/xfs/scrub/agheader_repair.c |   41 ++++++++++++++++++++++++++----------
 fs/xfs/scrub/stats.c           |   45 ++++++++++++++++++++++++++--------------
 3 files changed, 58 insertions(+), 30 deletions(-)

