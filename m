Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24C48137748
	for <linux-xfs@vger.kernel.org>; Mon,  3 Jun 2024 19:55:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717444531; cv=none; b=EpxVooA8RWxAqXQzzbCoGNCK39l2YZ8j4tlNbDvY6HF1lL4NfnrvBNm/AU60duQXj7hzXfKEeBba6dhQHzceZmH+3SF1kftyeYa68JRjNf41l3XW0iJPFXravsymocDzgn/Q0lIkLU8GYpjjq7ILoLF2mQgG3+3NMx6KjNAsJak=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717444531; c=relaxed/simple;
	bh=j2Y74+rOZLy4+hu1a6H6SPHElUzqvEsCHCjFPoCN0W4=;
	h=Date:Subject:From:To:Cc:Message-ID:MIME-Version:In-Reply-To:
	 References:Content-Type; b=XqeHRhAqajV2MqcPWSDahn35246AVSEyBHKRbSB0P5DTi9EgeFWXy8Gpi+/tOU8/GYpTZ7EAX7emWonZwfme90wdKA8VJLOviHNtVUg9TVBQ6lgAcw8oXyFGVmWYbjlzzhm3TGKMAL+1/xmgSeO8W/xy5lYfvUuvbZ14JBOlWOU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gfCrJFzP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gfCrJFzP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F06E2C4AF08;
	Mon,  3 Jun 2024 19:55:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1717444531;
	bh=j2Y74+rOZLy4+hu1a6H6SPHElUzqvEsCHCjFPoCN0W4=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=gfCrJFzPQNN0vK2tP9e9753awDL/mK8F9LxMJgZNINW6ye5kDZaWO06tmZkkFMwm9
	 4xKrv36eMWztTHAg8LSdUNl34gv1mL4GLYqXboPZ14uZJaOTGwd52gJTh0N4UzVfNe
	 HZbXV3rKt/13PvmCqTQ33TOl3rjc1h4l0fYt1J+0l+AcbNT0AE8cGrWQjHHUUrfoci
	 sqgbseCR+Izuf7VRinbQCEcKbXI2dQslOcnBX5rCBJa6QBO2OkC7uCs/iVTWdiR8UP
	 +oHrp/UEDqKM+0t5x8DXulg3sngzplYX/N0svhdcXwbnFDSxyiY1J/Fm3Hy9pruhwF
	 MAuYu+3OAnVGw==
Date: Mon, 03 Jun 2024 12:55:30 -0700
Subject: [GIT PULL 04/10] xfsprogs: widen BUI formats to support realtime
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <171744443650.1510943.12114794070776476838.stg-ugh@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20240603195305.GE52987@frogsfrogsfrogs>
References: <20240603195305.GE52987@frogsfrogsfrogs>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Hi Carlos,

Please pull this branch with changes for xfsprogs for 6.6-rc1.

As usual, I did a test-merge with the main upstream branch as of a few
minutes ago, and didn't see any conflicts.  Please let me know if you
encounter any problems.

The following changes since commit 5ac16998a64422509f3123304891aae905e1ff04:

libxfs: add a xattr_entry helper (2024-06-03 11:37:41 -0700)

are available in the Git repository at:

https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfsprogs-dev.git tags/realtime-bmap-intents-6.9_2024-06-03

for you to fetch changes up to a552c62f50207db2346732f8171de992f61ef894:

libxfs: add a realtime flag to the bmap update log redo items (2024-06-03 11:37:41 -0700)

----------------------------------------------------------------
xfsprogs: widen BUI formats to support realtime [v30.5 04/35]

Atomic extent swapping (and later, reverse mapping and reflink) on the
realtime device needs to be able to defer file mapping and extent
freeing work in much the same manner as is required on the data volume.
Make the BUI log items operate on rt extents in preparation for atomic
swapping and realtime rmap.

This has been running on the djcloud for months with no problems.  Enjoy!

Signed-off-by: Darrick J. Wong <djwong@kernel.org>

----------------------------------------------------------------
Darrick J. Wong (1):
libxfs: add a realtime flag to the bmap update log redo items

libxfs/defer_item.c | 8 +++++++-
1 file changed, 7 insertions(+), 1 deletion(-)

