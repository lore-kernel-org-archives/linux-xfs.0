Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 581A5347B4
	for <linux-xfs@vger.kernel.org>; Tue, 19 Aug 2025 13:11:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755609065; cv=none; b=OytICcoYQG8itNUR1pGjXEEBFBc8uwpZq87bqNVO6PqPHuxW/7eF3UXGUJoOLfHB71NVYHXL3xNML6tMG8033Jc3U+hgHzvytNRFq6BH3m9aSlzFDysT22zedw4OYMtgI0FoH4/M3TorssPDNU+BBMDFKAnzAjcNnOAwGVVs5/M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755609065; c=relaxed/simple;
	bh=MTN6+mma6AqcoRxaa2e+hsXc47RMSN2XdJRNjSS69CY=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=dvBYhudhHZJvLDo9U5JGpeATfeZVduY3bbeITMCWJWwaSTEBY7BIDaJnEVnrnSJbW8+WwR/n/IKZFx7V4p1oKMyxkY1f7Z6N0d8EbVZnmK+RXWPZ3VwdlBsAj/Eufm9Uq5tlGs/+qRyIWhocJmWbut206sdQZ3wfGZGFyzBQoMc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cJ1Y5ezj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cJ1Y5ezj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0092C113D0;
	Tue, 19 Aug 2025 13:11:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755609064;
	bh=MTN6+mma6AqcoRxaa2e+hsXc47RMSN2XdJRNjSS69CY=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date:From;
	b=cJ1Y5ezjqHtuGRPmfUhWR3eCSwSmRSsFh6d/t7Pb3KHeLr/hYmd+r0LUbu9OvAjL2
	 yey9qSay5HW4bwueP5yVUHkBXs+j07+2pr6eJJJJY+LDlcr/7XgvDgTaDGGpOojIlW
	 gbtxuTPEdMOvMoJ4VQoQhwaOEw6AdqxVFXyz+Hi3PGV0xIh6cPZQpsch2Bk4m9AZHf
	 XxW+3GeFI/NH5SAXKmQNJbajU4amYGkens0zx4r/YOK09zTuXJ8MdYkgNr/ispX8gN
	 a5qxWhkXiMmhl6zzK+c8OcNkdzNz94XJZmKtNqmvbPmkicspq8fbk5qjXfYkgwgT+S
	 6eUs6zs6+yNVw==
From: Carlos Maiolino <cem@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Hans Holmberg <hans.holmberg@wdc.com>, 
 "Darrick J. Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org
In-Reply-To: <20250818050716.1485521-1-hch@lst.de>
References: <20250818050716.1485521-1-hch@lst.de>
Subject: Re: zoned allocator fixes
Message-Id: <175560906362.126210.6099614142114027904.b4-ty@kernel.org>
Date: Tue, 19 Aug 2025 15:11:03 +0200
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.2

On Mon, 18 Aug 2025 07:06:42 +0200, Christoph Hellwig wrote:
> this has fixes for the zoned allocator.  One removes my original version
> of the inode zone affinity, which turned to be worse than the more
> general version later added by Hans.  The second one ensures we run
> inodegc when out of space just like for the normal write path, and the
> third one rejects swapon directly instead of going into a rat hole
> iterating all extents first.
> 
> [...]

Applied to for-next, thanks!

[1/3] xfs: remove xfs_last_used_zone
      commit: d004d70d6cdf03928da0d05c8c15c2ccc15657cd
[2/3] xfs: kick off inodegc when failing to reserve zoned blocks
      commit: 7d523255f524c95208cefef4edaed149615ff96c
[3/3] xfs: reject swapon for inodes on a zoned file system earlier
      commit: 8e5a2441e18640fb22a25fd097368957bf5cab91

Best regards,
-- 
Carlos Maiolino <cem@kernel.org>

