Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFF2D1862
	for <linux-xfs@vger.kernel.org>; Thu, 16 Jan 2025 21:38:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737063481; cv=none; b=DEJU3ku0ujFXcIjm29v2eVynD8guvHSBpEBSPTZ3wK8aAzMgCqqqIIYLzdXBRVsIJsSSY2M2Rit1Fc9WF+B9X4DZ4kD1j3lu9KhY+4j6+u37mLmzVTyQoVW42LqDl3nnT3QZcAgeR7iSz7t2XQDkdWM89EgiBjMY+8SDpsm3eD0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737063481; c=relaxed/simple;
	bh=uK7DhkYGtU1FVhI+6mH2rWKFKQf2Uz6lm7HrDYRm96Y=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Rb2233oELXc7v87UOxthRGh31kLwrWCTTTKDoM6Oded/YxQO3jJ8NJZyuAnBZeLelDek1im4r45hrEycXIjKT4+yxrw2P7js2yXHAvEBOznO2/7G9HGB2VEl/7RHCMrgHYqMmSsCeLP0zyeuMUDPMI7wdZnX2eJnMgp/lWlqiI0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=rRCGrw2U; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="rRCGrw2U"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79DF6C4CED6;
	Thu, 16 Jan 2025 21:38:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1737063480;
	bh=uK7DhkYGtU1FVhI+6mH2rWKFKQf2Uz6lm7HrDYRm96Y=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=rRCGrw2UyO2Xe4Zt6fKwj1j0WX9B2LSozXnmASYHhx++O+O84U8qLKHVqprjsdtKZ
	 LU4ffBtQyatqDPsPWPJCZTIcBu3NVtn1yU+AwlsI16QP2q91sNknANFjiRMFmu3GfX
	 NL1vLpxiGwNPB3YSI7P1uplaVdIYuUkDaiKrFW5e5Wxrf/zqfmmwserUC6Mc36Ypft
	 4NUIo9kb83NHCDMkJ4eQoTtRQWltx4GmaXtSgE+XJPFi4F5ibFzIycR+x42sK+rBKN
	 CPFnVi0Xg+NteYIYqY614y9yzBuYhWcRofp3qmUGOmqnSFHm5xd1F8c4J7NeimDLGh
	 317QpiwZZESHA==
Date: Thu, 16 Jan 2025 13:37:59 -0800
Subject: [PATCHSET 1/2] xfsprogs: new libxfs code from kernel 6.13
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: hch@lst.de, bfoster@redhat.com, cem@kernel.org, linux-xfs@vger.kernel.org
Message-ID: <173706331824.1823579.16623323047900629482.stgit@frogsfrogsfrogs>
In-Reply-To: <20250116213334.GB1611770@frogsfrogsfrogs>
References: <20250116213334.GB1611770@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Hi all,

Port kernel libxfs code to userspace.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

Comments and questions are, as always, welcome.

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=libxfs-sync-6.13
---
Commits in this patchset:
 * xfs: don't return an error from xfs_update_last_rtgroup_size for !XFS_RT
---
 libxfs/xfs_rtgroup.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

