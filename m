Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF698128387
	for <linux-xfs@vger.kernel.org>; Tue, 26 Mar 2024 02:58:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711421904; cv=none; b=LPgtitPUhnB/PyeSAUwk8VNux1poEOc1VHixJ5MJK6oInOcDjxv1LMzyFOyi9gKmcGVUC2mR0HnepqzTo2Fs93wB9L3AWj9f4HF3DvTkhx4ekPFUsmrvMBotQJkUBq+W1hKGjb7Y/h/quUy4lQesmtTgNPdWVBKvd/dA79VxHaM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711421904; c=relaxed/simple;
	bh=EV8HY2HRkotlbQs84VDt11BfSmgC4aFEyBUZ76WwBRY=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=C6QuqRvFe4wc0ygAnr9JX9/2/mlgkKQvTvk9nPkUPftYOC9mKrXJr9EN3hxK8JVIFjUlr5VBtYRRUaVqInU0xoBq76ACMkBp9gCpjFtkUsSJU42j/GjtcP+lvncq0W0jA4zey2iwrzkuJhADwyrflQIggq9s9+N/Ck2GMKV6AV4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KOVmRgaV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KOVmRgaV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8725C433F1;
	Tue, 26 Mar 2024 02:58:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711421903;
	bh=EV8HY2HRkotlbQs84VDt11BfSmgC4aFEyBUZ76WwBRY=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=KOVmRgaVvRCYS5PB/j/TUuNC2JMYsy5KwExLyYtwQ3YETydite0qHMM9+bNnRZewj
	 KjMjWs5LRZC5BYikfODgCzbm3iSHQ9FURkFpGZ5y1vSKozg2/ZySBwhBADNE6I9+p4
	 X6WB4F+YNHdEvpNb9cJpxHVbVrRRd1JkbJHDHbRjB5wtcFNgOxnDACPax4LOynAp0t
	 z4x/jEi6TXtNcxMXHtthuDVV4DeYyy4EZS80VtSo545z0mnZrjz8rNellfUMsb64wW
	 0Xv0gSvJY5FlQ4tIKJlEHQBMDgQyOUaVu48bu128Z/9LX+dU7hlngZ5phBjB1ed8QF
	 0J9dQ9AzBMhNg==
Date: Mon, 25 Mar 2024 19:58:23 -0700
Subject: [PATCHSET v29.4 14/18] xfs_spaceman: updates for 6.9
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <171142133977.2218093.3413240563781218051.stgit@frogsfrogsfrogs>
In-Reply-To: <20240326024549.GE6390@frogsfrogsfrogs>
References: <20240326024549.GE6390@frogsfrogsfrogs>
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

Update xfs_spaceman to handle the new health reporting code that was
merged in 6.9.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

This has been running on the djcloud for months with no problems.  Enjoy!
Comments and questions are, as always, welcome.

--D

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=spaceman-6.9-updates
---
Commits in this patchset:
 * xfs_spaceman: report the health of quota counts
 * xfs_spaceman: report health of inode link counts
---
 man/man2/ioctl_xfs_fsgeometry.2 |    3 +++
 spaceman/health.c               |    8 ++++++++
 2 files changed, 11 insertions(+)

