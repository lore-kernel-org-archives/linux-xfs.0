Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39AFB1946BC
	for <linux-xfs@vger.kernel.org>; Thu, 31 Oct 2024 23:43:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730418239; cv=none; b=m7/bSTJeiv7rX1SP9Lk5Kf0XzvBrhXXM9UkJwvB7cMgc2y8+YJKyjKiNtOxmvQ103pQtbLIrQO/rOChMVVFXkZnXBbWJ47wwLtAo1sorhnWHLLXKtIvMJNE2EOm1hSReNHjwSst70BEX6in6DWjrugcrkqBO15j0K0r0o0M5aSI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730418239; c=relaxed/simple;
	bh=1xUKDGoHNvdzUbFshIJj2M9PARWC24W0xplKsIkvlCw=;
	h=Date:Subject:From:To:Cc:Message-ID:MIME-Version:In-Reply-To:
	 References:Content-Type; b=XE7GTgpqKIskHkwleeDRxGqA0v8AbiHgkd0egA+ZokUy1lyIeAb0wHE585KPVIRcwJHtOwk7wFiqQtvtXXyGuylc4vKKc5Vo0SUaIxZr1Ui2QEGv5j1daRP+swO4wqAScFFkCibi1ZbWlUl8b0fULs60X/q6P9YIEcob+/XM+pQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RS70/gY9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RS70/gY9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4EEEC4CEC3;
	Thu, 31 Oct 2024 23:43:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1730418238;
	bh=1xUKDGoHNvdzUbFshIJj2M9PARWC24W0xplKsIkvlCw=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=RS70/gY9wIRu4pmaR7J5Zkw4ZUumgP6DnHQlb3Hj88Yy19YSB6pUudkJLJM91bX+b
	 LgKJI7VMRISUTk+uMOpCL4fqaztg1RjzAkv2KtIObOnmmo7C1rxFs86NoujnNa2Rin
	 0tQkdPVzDvMgb1FDvHguzefJojljBQ7mC+S4ZrJsKOT0kJZBGJqWoVZIJ8gki/aT//
	 vVi00VlMrNE2cPxL28c+l9V3oa5k/1ufB7/VJXEVFoXee25v99rHUg9Ec2kc9jsNGv
	 t74DNzucLiAg0kRtILU4HCnwFOYd2wwK1k0wnFbCcY1iRbox0Sc6fqRD3Cdf6Eodqf
	 35qUC28DoF52g==
Date: Thu, 31 Oct 2024 16:43:58 -0700
Subject: [GIT PULL 6/7] xfs_scrub_all: bug fix for 6.12
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: <linux-xfs@vger.kernel.org> # v6.10.0, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173041764842.994242.13161959286165075663.stg-ugh@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20241031233336.GD2386201@frogsfrogsfrogs>
References: <20241031233336.GD2386201@frogsfrogsfrogs>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Hi Andrey,

Please pull this branch with changes for xfsprogs for 6.11-rc1.

As usual, I did a test-merge with the main upstream branch as of a few
minutes ago, and didn't see any conflicts.  Please let me know if you
encounter any problems.

The following changes since commit 07c09d46665cfac48256f6faf829897554ec74bf:

xfs_repair: stop preallocating blocks in mk_rbmino and mk_rsumino (2024-10-31 15:45:05 -0700)

are available in the Git repository at:

https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfsprogs-dev.git tags/scrub-fixes-6.12_2024-10-31

for you to fetch changes up to 024f91c02f22a6f1f1256a5b09323bc3b104f839:

xfs_scrub_all: wait for services to start activating (2024-10-31 15:45:05 -0700)

----------------------------------------------------------------
xfs_scrub_all: bug fix for 6.12 [v31.3 6/7]

Fix a problem with xfs_scrub_all mistakenly thinking that a service finished
before it really did.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>

----------------------------------------------------------------
Darrick J. Wong (1):
xfs_scrub_all: wait for services to start activating

scrub/xfs_scrub_all.in | 52 ++++++++++++++++++++++++++++++++++++++++++++++++++
1 file changed, 52 insertions(+)

