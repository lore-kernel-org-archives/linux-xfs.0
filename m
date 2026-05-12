Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0020A39B978
	for <linux-xfs@vger.kernel.org>; Tue, 12 May 2026 12:09:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778587762; cv=none; b=ais9UsY4s3zp0RT1N2ZtlxmCvj/fCKkopQzNPO6CSwMiQ7/7HkcMgbpsWpXLvXwxBy8Zsx6ZzqJMSh1t51NlRbDv5qpFYEBON/SsOTLDO1vPuqaGQiqME4xaevMiVrainDOVBUTDenFrHfGAwFoaptELxx328SOheCieQ2N2Neg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778587762; c=relaxed/simple;
	bh=E7cTjkD0EuHWM6nhmwxE2F2ek5+6IK9jEzLrGcEhsi4=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=eTNq//aNjTjC7vlyyJnmepFjvoaFx9It6Sxeos0zCBEQjq1Q1y+jfxFQpdKFm77G32mI1WwkTV53bsbxIr10pyETWnEIyznNULzG1iZFkq4ngEgMMcyMtT4R6OCPvx1KiJa4AFN/1go7Mc+KPObG0JDI5P6OVRRp7J2EyWy9/Ck=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jkFLjVnU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jkFLjVnU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2652EC2BCB0
	for <linux-xfs@vger.kernel.org>; Tue, 12 May 2026 12:09:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778587761;
	bh=E7cTjkD0EuHWM6nhmwxE2F2ek5+6IK9jEzLrGcEhsi4=;
	h=Date:From:To:Subject:From;
	b=jkFLjVnUBpLzusXFlLLz5IBvVcanO7VThhHqBI/sCZdChAOu7rmZn3FZgbs1RGJWa
	 LiOgIN8nrnxyrGdKHlI8OBCq8Hgdb8OSw6a0BUpt82n51MIjObYVrJf/N/IpW4Wa6F
	 qaFx9OZq0JkaeHGN6NHRY2gsL1NR0opxnha3+EVXabSGxI6vEmXzlCN4VOCMi1vf/n
	 O34wMXtaqh+WBTsyA5o+ftLN4mg5uscxQef7RfDKG+t8dKpIm5gZkkCcBDpjxUQX78
	 h43/caFQJ1C7dCKJCq8fLDfgG6riZN645nklfqcPPpwRDyDbW1GpYmjnOFDwYZ1G2W
	 7VtAHd6KOy7EQ==
Date: Tue, 12 May 2026 14:09:18 +0200
From: Carlos Maiolino <cem@kernel.org>
To: linux-xfs@vger.kernel.org
Subject: [ANNOUNCE] xfs-linux: for-next updated to 509fdeb3326b
Message-ID: <agMYXfzboNQzP6tx@nidhogg.toxiclabs.cc>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline


Hi folks,

The for-next branch of the xfs-linux repository at:

	git://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git

has just been updated.

Patches often get missed, so please check if your outstanding patches
were in this update. If they have not been in this update, please
resubmit them to linux-xfs@vger.kernel.org so they can be picked up in
the next update.

The new head of the for-next branch is commit:

509fdeb3326b xfs: Fix typo in comment

2 new commits:

Christoph Hellwig (1):
      [5082d8835070] xfs: fix the "limiting open zones" message

Md Shofiqul Islam (1):
      [509fdeb3326b] xfs: Fix typo in comment

Code Diffstat:

 fs/xfs/xfs_notify_failure.c | 2 +-
 fs/xfs/xfs_zone_alloc.c     | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)
