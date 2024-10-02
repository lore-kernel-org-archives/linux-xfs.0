Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7834E7FD
	for <linux-xfs@vger.kernel.org>; Wed,  2 Oct 2024 01:31:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727832702; cv=none; b=CNvFtn6sPb1j2rTw/+7A9y6UrsbSarZPZ46QzWhhI6VYUINn8MAXrmNssrGNLr4LrQ4xQex+ZepTAgNmNvJmOVACK8dn3FVo/D7SqV0gK0SUAvW5bNgHkQOjeCOLIb19TaKXdXOHdXxjSsuFj8/5liQ/e7FvqH08TBxty942Ncw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727832702; c=relaxed/simple;
	bh=NizAN6s2+VqcsOBtCT5UeWrMOGqzBgU7G/aWhmzLOgc=;
	h=Date:Subject:From:To:Cc:Message-ID:MIME-Version:In-Reply-To:
	 References:Content-Type; b=qOQHO8+GBgmlnBHDcrg2nOAjRWeXiNe1B5RASqCIrYKx8kmfxpA7z8fLwM5Eh/35H1Ml+pRDZP1wWFBZl1m5IZAmyDfxzvkXPeL/7LHhGuBBnF7ri8ysTleYpkz5TF72TnQR3SPsOmbMlWFvdGRDvLfxhUATbpJgIhXsNhttmb0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=A6O7nOUN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="A6O7nOUN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DDD85C4CEC6;
	Wed,  2 Oct 2024 01:31:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1727832701;
	bh=NizAN6s2+VqcsOBtCT5UeWrMOGqzBgU7G/aWhmzLOgc=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=A6O7nOUNMfhuc2gsH/XvsOiXEoz5NiASxJ6bjrg7lWU19tA8r2wra9+5th/ZZMPW1
	 1A83iQdLXuLbPIetI2HHXS1mBlEN/LVwg/uK3g4Iy60O5dXOvTueoSVmrK1Q7layEG
	 3cyroirzU5o/UUGrWwo8uMW/MdyhvR606Zqd0H1JuR+s7qlwQa/ONXF/Ut7xHSR0Fk
	 iFgQfE6e+j3YxO7SD1IasUQQmmBbRzI3f4p2g+2zWuqzA8oEtjMKTA1nXf2EIYEdIw
	 R1DKrMRv/QB2lpRMpAI5+h3ExUTjHcyLG8NBj9Fie0fb2fqV3n7nmwecXvdOIs04Qv
	 DHDyAZheAw/Pw==
Date: Tue, 01 Oct 2024 18:31:41 -0700
Subject: [GIT PULL 1/2] xfsprogs: Debian and Ubuntu archive changes
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, cem@kernel.org, djwong@kernel.org
Cc: bage@debian.org, linux-xfs@vger.kernel.org, zixing.liu@canonical.com
Message-ID: <172783264941.4076916.7727313194511938629.stg-ugh@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20241002012922.GZ21853@frogsfrogsfrogs>
References: <20241002012922.GZ21853@frogsfrogsfrogs>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Hi Andrey,

Please pull this branch with changes for xfsprogs for 6.11-rc1.

As usual, I did a test-merge with the main upstream branch as of a few
minutes ago, and didn't see any conflicts.  Please let me know if you
encounter any problems.

The following changes since commit 19dde7fac0f38af2990e367ef4dd8ec512920c12:

fsck.xfs: fix fsck.xfs run by different shells when fsck.mode=force is set (2024-09-16 09:20:51 +0200)

are available in the Git repository at:

https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfsprogs-dev.git tags/debian-modernize-6.11_2024-10-01

for you to fetch changes up to b92bf9bc2da75f3709f5f3a6c09d6c62d0d799ef:

debian: Correct the day-of-week on 2024-09-04 (2024-10-01 17:54:48 -0700)

----------------------------------------------------------------
xfsprogs: Debian and Ubuntu archive changes [01/11]

Hi,

I am forwarding all the changes that are in the Debian and Ubuntu
archives with a major structural change in the debian/rules file,
which gets the package to a more modern dh-based build flavor.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>

----------------------------------------------------------------
Bastian Germann (6):
debian: Update debhelper-compat level
debian: Update public release key
debian: Prevent recreating the orig tarball
debian: Add Build-Depends on pkg with systemd.pc
debian: Modernize build script
debian: Correct the day-of-week on 2024-09-04

debian/changelog                |   2 +-
debian/compat                   |   2 +-
debian/control                  |   2 +-
debian/rules                    |  81 ++++++++++--------------------
debian/upstream/signing-key.asc | 106 +++++++++++++++++-----------------------
5 files changed, 75 insertions(+), 118 deletions(-)

