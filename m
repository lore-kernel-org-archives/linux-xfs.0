Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBDCD136E18
	for <linux-xfs@vger.kernel.org>; Fri, 23 Aug 2024 00:00:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724371251; cv=none; b=p7vFchQILhKpy8xO/QvT/wzoqE9qjrFEHWd7zysC4sbMBabk0xFs4Cviz7TzqdZHapj66GQsx0zfHDrBzSvHgk8f9bMssBPbVwPwSrPrFTc5CCV3mSrmfGkgrvIc1DKcAOX/v6A51qWwiDBGFef7AF7Fbe2g4BSFDizfCT40le0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724371251; c=relaxed/simple;
	bh=gdzLASllC+NZzkNTGOMdUaAonuS/A7B0v9ZgPTj2t6M=;
	h=Date:Subject:From:To:Cc:Message-ID:MIME-Version:Content-Type; b=iCMuB8FZAWo9pgaAJoMG9DpMq4FfcmETxSdNlqochm8HRXXG+4dP4vOEtAfmVMw8tX+vppBJ6tgqntk8HEwkW6aIKG34c6QtZA0q07jmxJYXBlqqoBxAEbOHOR3kLivRjFEcGiyjuIWpZFyiUMvI+c0+n/e9l3n+tlzren9fo+w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LTELc0k3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LTELc0k3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C56A6C4AF09;
	Fri, 23 Aug 2024 00:00:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1724371250;
	bh=gdzLASllC+NZzkNTGOMdUaAonuS/A7B0v9ZgPTj2t6M=;
	h=Date:Subject:From:To:Cc:From;
	b=LTELc0k3RycdZXKRpAyWnGIcL31FRKMXNJKrSlMe+t28/ETlnDg3zt0R+mBR9B/a8
	 kvfcQ4xVf5p910MnVVXxWI5UKCtjZ4Rbt9xgCgrt9xE2u0aA6d2MOZDk6kEcUbda+3
	 kHpeS74oQcweDNzgarcCCmVY5PWCenfzYeglsW+ueIj/dAdKFWKdOC87uyqHt9a+HG
	 dM/6KQFkL5YbkYQjZBtq971pa2A6y9roZCQoAmlRRsaO9DtaBRSu+SPAu7MYwucQOQ
	 JNY6dj1hqY+Umvm1APNP9rGJWCuCroa3RKxTq01ctWfWG8ebXihwGzj98MbQg54kvi
	 AfazocslA1Oog==
Date: Thu, 22 Aug 2024 17:00:50 -0700
Subject: [GIT PULL] xfs-documentation: updates for 6.10
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: chandanbabu@kernel.org, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <172437123097.69950.15314243064882413124.stg-ugh@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Hi Darrick,

Please pull this branch with changes.

As usual, I did a test-merge with the main upstream branch as of a few
minutes ago, and didn't see any conflicts.  Please let me know if you
encounter any problems.

The following changes since commit 858b0667d5643eb9250a6037a3ab20024f700321:

design: document extended attribute log item changes (2023-02-16 13:56:07 -0800)

are available in the Git repository at:

git://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfs-documentation.git tags/xfsdocs-6.10-updates_2024-08-22

for you to fetch changes up to 3ecf3b36dd08cef08d7cb247a0ca911d4d457e56:

design: fix the changelog to reflect the new changes (2024-08-22 16:58:06 -0700)

----------------------------------------------------------------
xfs-documentation: updates for 6.10 [1/5]

Here's a pile of updates detailing the changes made during 2023 and 2024 for
kernel 6.10.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>

----------------------------------------------------------------
Darrick J. Wong (5):
design: document atomic file mapping exchange log intent structures
design: document new logged parent pointer attribute variants
design: document the parent pointer ondisk format
design: document the metadump v2 format
design: fix the changelog to reflect the new changes

.../allocation_groups.asciidoc                     |  14 ++
design/XFS_Filesystem_Structure/docinfo.xml        |  32 ++++
.../extended_attributes.asciidoc                   |  95 +++++++++++
.../journaling_log.asciidoc                        | 177 ++++++++++++++++++++-
design/XFS_Filesystem_Structure/magic.asciidoc     |   2 +
design/XFS_Filesystem_Structure/metadump.asciidoc  | 112 ++++++++++++-
6 files changed, 423 insertions(+), 9 deletions(-)

