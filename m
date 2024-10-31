Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1E47197A87
	for <linux-xfs@vger.kernel.org>; Thu, 31 Oct 2024 23:07:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730416076; cv=none; b=JcBP5Os8gLssKGbPC2bG7sCRJ2CJQ4ggTa2SVH8C5wM/TYHYJjCJX3P391SsHjXsnb0FScEvsDhD0Gp8XNN/Ia+6ZtK0i7yz5Clk674j+IOfB0JeeVL4KP4U78Eqg1iKSpOV8kYCiqcxiogUmYSRNC9NnYZvnO9rjrT0s5W9Y44=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730416076; c=relaxed/simple;
	bh=3c8idNWl98g7ejLZ75yWlayva0mI92f2JclB4OnUHQI=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=IJDFYNmDCtXu3NanOPX2IpGyjY5QSwDiaXGLykEOqlxzSUqRelgDmX9/SEamvr1eS80lC9rd8OztgkxBnss6HdkwoQTGVCiGEZxxaHDyyxuRAteym0Rq8ctq5ZCEE0gAHJkuHNEC8vu5USwzidlUfZ6a7i0EOqDYI6ueGfPMaeY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fc0PvKeE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fc0PvKeE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 620B6C4CEC3;
	Thu, 31 Oct 2024 23:07:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1730416075;
	bh=3c8idNWl98g7ejLZ75yWlayva0mI92f2JclB4OnUHQI=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=fc0PvKeEgCbaD2zCOiQngUZEQLAh82/jPrthn/3qjSpRJpPQgE2cMUuLG7luWCyIA
	 ew6pbd3RC2TMM3N8vCc3grLUBTT2zadKyvz4lb6BPTl8fjr9M1lkCqpfeFHlKM0g5/
	 A43qkEsdo1ch2LHY4NpAE/laGfcREYEeoJaNANOiCMMu0aT7FLSHaGfgMix7aGKcPO
	 5p+EEvanbWptgebUhevVFEXZBaejKwrndK/tSb+LYOopTNUG0aOEQCfUpNXEWKydBX
	 YdOcZs3fcXcWlHQBis2wga52RkKfTaaSTcCx/q40HqS8dhBv7/QUwY1A1PNgg6U/7o
	 2IjZsJdFMBdmw==
Date: Thu, 31 Oct 2024 16:07:54 -0700
Subject: [PATCHSET v5.3 4/7] xfs_metadump: support external devices
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <173041567766.964525.18174530428305698304.stgit@frogsfrogsfrogs>
In-Reply-To: <20241031225721.GC2386201@frogsfrogsfrogs>
References: <20241031225721.GC2386201@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Hi all,

This series augments the xfs_metadump and xfs_mdrestore utilities to
capture the contents of an external log in a metadump, and restore it on
the other end.  This will enable better debugging analysis of broken
filesystems, since it will now be possible to capture external log data.
This is a prequisite for the rt groups feature, since we'll also need to
capture the rt superblocks written to the rt device.

This also means we can capture the contents of external logs for better
analysis by support staff.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

Comments and questions are, as always, welcome.

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=metadump-external-devices-6.12
---
Commits in this patchset:
 * xfs_db: allow setting current address to log blocks
---
 db/block.c        |  103 ++++++++++++++++++++++++++++++++++++++++++++++++++++-
 man/man8/xfs_db.8 |   17 +++++++++
 2 files changed, 119 insertions(+), 1 deletion(-)

