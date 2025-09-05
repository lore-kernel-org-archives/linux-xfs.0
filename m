Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E444D22B8CB
	for <linux-xfs@vger.kernel.org>; Fri,  5 Sep 2025 09:17:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757063825; cv=none; b=g/N2CCIcilf9j6GlFrB5O79W5WX8xGaqlf0lz/hkIswNhR5gG0BatYdAIRJf2gxF5wVNVk/XF0jsKCjWOq0Xh2FO1v7Un7VXS2uIfCpdYxKFGu2hj3ySpbGbrWTQBAEIgctDTY5rG9Q1N64CzuWBsKsf2WW/qLaJ6/4+YtLydn0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757063825; c=relaxed/simple;
	bh=Iu+YzqGsKIGbr6+sK2Woon7ESsbDsGJIUKc7ZIn+gH0=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=DL7RI5JPggGn0yGznRpsotbqguqSlPe3kPvAdAZi7tcJi9esQL6qVADpuPhGw+8Y4mQg6PTgABrrRTxQBj4fS2oNBU4xeDyf7HGUpmW+IL1ZvG5z91Vps7we0VVsdIlIx4Y9yYkYuBgxX/3LxtxXtFLEzSRe0izBO4Snq2XcIiI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jI6UeqRU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jI6UeqRU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7D84C4CEF1
	for <linux-xfs@vger.kernel.org>; Fri,  5 Sep 2025 09:17:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1757063824;
	bh=Iu+YzqGsKIGbr6+sK2Woon7ESsbDsGJIUKc7ZIn+gH0=;
	h=Date:From:To:Subject:From;
	b=jI6UeqRUspcT61+QxLb4pNeCrt5nJYa//h0mr7yCk7bvvVWJFkmxCsm29TACaKCJ6
	 D9DKUt3tKRLHR5YIHn+uI2DjCM7YhVnUxZc0vDMxThuzXM9PLvSLtm5b2YxvVWYOt6
	 h0a+9VQ9xNa8QrblKsPFX3LPbworAiyzKxmSehc2rLV5SMtCQ27i9P6gobw2/FFMfC
	 Cf/KMAlEQS//MK0xi9fRDEFilvblKtGolBsuWKvYXfzy3p3YoHNyjrAYKhp5jfrVLT
	 id7kAFPQoBPBhtiEQPhGX1RUjMJHSInH9zNMR5YZNNv/aFXjx6t5Qnxm0uSysCMhvW
	 b1hlSmHtTldqw==
Date: Fri, 5 Sep 2025 11:17:01 +0200
From: Carlos Maiolino <cem@kernel.org>
To: linux-xfs@vger.kernel.org
Subject: [ANNOUNCE] xfs-linux: for-next updated to 33ddc796ecbd
Message-ID: <je5rsfydotcevargjmvo2iy7xzrxhujvhvwz3mqvjc65nc3stu@opcp23gzn2oy>
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

33ddc796ecbd xfs: Replace strncpy with memcpy

1 new commit:

Marcelo Moreira (1):
      [33ddc796ecbd] xfs: Replace strncpy with memcpy

Code Diffstat:

 fs/xfs/scrub/symlink_repair.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)
