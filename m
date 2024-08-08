Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9F8D18EFD6
	for <linux-xfs@vger.kernel.org>; Thu,  8 Aug 2024 16:51:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723135887; cv=none; b=RdK/WjBHwdOPpJK7WxPSUKQh1rMzBSLrZcyISz44K1VkmvCDpp+vGCzMamr9l9f5J4FEDD1ZbgWl7lR7NpDDrFjE4akQUGoF0INRXIh3U3raQIcnX7f6Z2RLzIyeFmS8WxsASvkrhLC9qdYrMJppAshTMO1V05RTFgBI04zWSvM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723135887; c=relaxed/simple;
	bh=a2k4qD39LaWHx2Fv5IXYtQMmguxYqhxrQrMu6M8oWnM=;
	h=Date:Subject:From:To:Cc:Message-ID:MIME-Version:In-Reply-To:
	 References:Content-Type; b=qHGZ1plbLEs04NLAf96HP8gK+m8UcAlFNFkZznqim3xesH/djnm3aG7efgIKAfAHTUqr1LtDlpCUnPMkvXDHKEblHlB6upo9KWnxCT3+//+NxKhA6G9/+9VJshWCdmfEsQ5wsR/mcDAj6i0LKp/I/riqj2zVOeP35PG3mk+TQ0w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nThWERwj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nThWERwj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 763E5C32782;
	Thu,  8 Aug 2024 16:51:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1723135886;
	bh=a2k4qD39LaWHx2Fv5IXYtQMmguxYqhxrQrMu6M8oWnM=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=nThWERwjRQBTPcssBPMZyzJsRdVrYUztfPuuBhTrGIRfaYy5x+Uw8XMQH5QwNUXTc
	 EX2gWiW8ONOsjwtzjpNiQ7B66pySRpenGVD8F1CeGgBkjj5n8CyY9GvOi87/tUjAiC
	 sHhRfrtAd22pec6lFLaklGRdqGlpX+bvuA6oVYz7RoLxUQmXMLHqCerOrjwTzzs8mA
	 bR0vaUqQZb2SQ/M8A1iQOISbt2VzmEXS2yeYc2aI6BFVfuVTxgeW4psDVQfiJeVgp7
	 FsVgLPfMWeoSKQR3gJk54wKk5G+TRIudnCo5zfaTE1omEiUVuqPwr8r+eZBLnDQ72i
	 wwZhOO2FYipRg==
Date: Thu, 08 Aug 2024 09:51:25 -0700
Subject: [GIT PULL 2/2] debian: enable xfs_scrub_all by default
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <172313566825.2167713.3959755611631508176.stg-ugh@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20240808164615.GP6051@frogsfrogsfrogs>
References: <20240808164615.GP6051@frogsfrogsfrogs>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Hi Carlos,

Please pull this branch with changes for xfsprogs for 6.10-rc1.

As usual, I did a test-merge with the main upstream branch as of a few
minutes ago, and didn't see any conflicts.  Please let me know if you
encounter any problems.

The following changes since commit 7fd2c79b3343e4562b4176728e4dd71b187bbbc9:

mkfs: set autofsck filesystem property (2024-08-08 09:38:48 -0700)

are available in the Git repository at:

https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfsprogs-dev.git tags/debian-autofsck-6.10_2024-08-08

for you to fetch changes up to 45cc055588f4dcc7a2951dd226dd5e64f5e165da:

debian: enable xfs_scrub_all systemd timer services by default (2024-08-08 09:38:48 -0700)

----------------------------------------------------------------
debian: enable xfs_scrub_all by default [v30.11 2/2]

Update our packaging to enable the background xfs_scrub timer by default.
This won't do much unless the sysadmin sets the autofsck fs property or
formats a filesystem with backref metadata.

This has been running on the djcloud for months with no problems.  Enjoy!

Signed-off-by: Darrick J. Wong <djwong@kernel.org>

----------------------------------------------------------------
Darrick J. Wong (1):
debian: enable xfs_scrub_all systemd timer services by default

debian/rules | 2 +-
1 file changed, 1 insertion(+), 1 deletion(-)

