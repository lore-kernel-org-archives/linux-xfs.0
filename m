Received: from buxtehude.debian.org (buxtehude.debian.org [209.87.16.39])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32CE1535FA3
	for <linux-xfs@vger.kernel.org>; Thu,  1 Oct 2026 14:53:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.87.16.39
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790866384; cv=none; b=T7j7u2m8C6u6FqQ8K1+I1Z2ZjI7XxplmeE4PfyKjJW/iifkNsGGMMPnNJ37EAx5KHJAcuHQjiNSidZAUSc4IUXPD0gpFMtapNd9L9YdblCk1B2zkVdl73R76kegD2reZgDphL1Uk9EeflNob60UlgAe9hGQBEQrayUG6NXZKsCU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790866384; c=relaxed/simple;
	bh=02ycDkwoPsG/bt2iNBw4mY3EnJQBVFI5ezaihxrf3c0=;
	h=Subject:References:Date:From:To:Cc:Message-ID:MIME-Version:
	 Content-Type; b=PgktVG1fs4u2UtM9hNNxzAy+9gebCHeH1AOqZtW3kWsM1VfqrcE/G2I7QD4R6bVUGVME4DTZN8RstG/RhRHQ7iTClCRvmu5fhwUmkpeby5RgOmk46wnF+/U8YBt4v6ckU9Z8hMH5YssTH5sikSRmhTNUXBzkIfqa5K1EeJIkYkM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=kernel.org; spf=pass smtp.mailfrom=buxtehude.debian.org; dkim=fail (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NIIz/kK1 reason="signature verification failed"; arc=none smtp.client-ip=209.87.16.39
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=buxtehude.debian.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NIIz/kK1"
Received: from debbugs by buxtehude.debian.org with local (Exim 4.96)
	(envelope-from <debbugs@buxtehude.debian.org>)
	id 1xCI9e-000Crc-2W;
	Thu, 01 Oct 2026 14:53:02 +0000
X-Loop: owner@bugs.debian.org
Subject: Bug#1149571: [PATCHSET v2] xfs_healer: fix a user-reported bug
Reply-To: "Darrick J. Wong" <djwong@kernel.org>, 1149571@bugs.debian.org
Resent-From: "Darrick J. Wong" <djwong@kernel.org>
Resent-To: debian-bugs-dist@lists.debian.org
Resent-CC: linux-xfs@vger.kernel.org
X-Loop: owner@bugs.debian.org
Resent-Date: Thu, 01 Oct 2026 14:53:02 +0000
Resent-Message-ID: <handler.1149571.B1149571.179086624448596@bugs.debian.org>
X-Debian-PR-Message: followup 1149571
X-Debian-PR-Package: xfsprogs
X-Debian-PR-Keywords: 
References: <179080491253.7201.8697529754428195540.reportbug@mars>
X-Debian-PR-Source: xfsprogs
Received: via spool by 1149571-submit@bugs.debian.org id=B1149571.179086624448596
          (code B ref 1149571); Thu, 01 Oct 2026 14:53:02 +0000
Received: (at 1149571) by bugs.debian.org; 1 Oct 2026 14:50:44 +0000
X-Spam-Level: 
X-Spam-Bayes: score:0.0000 Tokens: new, 21; hammy, 136; neutral, 22; spammy,
	0. spammytokens: hammytokens:0.000-+--UD:kernel.org,
	0.000-+--UD:git.kernel.org, 0.000-+--git.kernel.org,
	0.000-+--gitkernelorg, 0.000-+--HCc:D*kernel.org
Received: from sea.source.kernel.org ([2600:3c0a:e001:78e:0:1991:8:25]:33834)
	by buxtehude.debian.org with utf8esmtps (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <djwong@kernel.org>)
	id 1xCI7P-000Cdc-31
	for 1149571@bugs.debian.org;
	Thu, 01 Oct 2026 14:50:44 +0000
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with UTF8SMTP id DE91A402B7;
	Thu,  1 Oct 2026 14:50:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id B221B1F000FF;
	Thu,  1 Oct 2026 14:50:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790866242;
	bh=M8VVMDcC0bVeQitq1VzUA/8JFx/2Z9/gKvtdjru6L94=;
	h=Date:Subject:From:To:Cc;
	b=NIIz/kK1b9kN5jWH+wBW/thBPc0odiyu7pPstejjj65bYPseU5tBx0VuKiubYndzb
	 CWvYq9BfygRJ7eyiKcz/H8ZT+oyImt1MS3RZg5dgYbWE8m7Ady5VWtgDIWDtFAlQW6
	 35NL1m1EeFMfpK9SbLyGLcfJckuZ56fKbCFxW9UE5+FQjLeXFAAN7kwzwVXg+xtn/b
	 aIeIK1YvP8nUUwGsBEmpmVzJ4chOO3tml/6htNLAYjNqGQoLhCvDW/LtUB625lhiWd
	 YjYwnC5EJJV/keD9qPB4Yr8u/FpctWDFNah3e41Y7RbRMbXDdWMSvu1TR9lEIm6bPb
	 WDxRkiXOtNBww==
Date: Thu, 01 Oct 2026 07:50:42 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, 1149571@bugs.debian.org, biebl@debian.org,
 hch@infradead.org, linux-xfs@vger.kernel.org
Message-ID: <179086618105.2606256.7314766956448729435.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-ID: <20261001145042.00l7w7nYd7LJSQ_pfl4vkd-oiQG_hh2Zl9ZEfGKkPw0@z>

Hi all,

This bugfix series corrects a couple of problems in xfs_healer that
were found by a Debian user.

v2: fix xfd_open callsite's use of error return values in addition to
    fixing the reported problem, per maintainer

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

With a bit of luck, this should all go splendidly.
Comments and questions are, as always, welcome.

--D

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=healer-fixes
---
Commits in this patchset:
 * xfs_healer: correct xfd_ API usage
 * xfs_healer: fail earlier on non-xfs filesystems
---
 healer/xfs_healer.c |   14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)
