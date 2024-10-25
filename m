Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 672F1170A16
	for <linux-xfs@vger.kernel.org>; Fri, 25 Oct 2024 06:32:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729837948; cv=none; b=BGnv9n0x8DRIkQZ2AcqjAVV65xKnQy3C110t8doInycOGwh0NUzsqr6i6w1c4WE2ocKBk/mIgLNjUo5z25QGp+A48pim8ucKEF9zpzSf5xWSF74SJlxeCZfT8OUrSVXOgOISAJ7neW4Zn6CubGa/JhCJCPyT9ikGzCkhD5BJZG0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729837948; c=relaxed/simple;
	bh=/C5oJOe0qaEB8wnJsCun3Kr7BbmGvZ8465Vdte6LeSk=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=HLvnugNwbYzBD5i/UiPEAPeNP8LM/MZzq8ihFNPaFlXXkVs/nZuXFmb3sUuSa1q45qHdUriJ87OGaEKl1hku+G0x3gZfDpuTDCB3sER2OAAM8Ko2dW4qDFW8gtQ30SoeMlAugL1evU94Hm+Dn/UVL1cvwskPRLt5C7MBar4bjW4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MfK25Npz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MfK25Npz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE02AC4CEE3;
	Fri, 25 Oct 2024 06:32:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1729837947;
	bh=/C5oJOe0qaEB8wnJsCun3Kr7BbmGvZ8465Vdte6LeSk=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=MfK25NpzUeWEpltJo7sXLg9q6cy+DjR2T1N3ghLHfL5L0C8sWxzdERgrslqAfhlV9
	 N3FGbMVjOu55QGTNLtF8R+iMeM3URIO1U00+e/eTj+IKP/C7lMzFbygotC2Iyjz/BN
	 7NHgLAu340xMFIlg7PqHwRIdL0UIHqlOw150uw4WNeHyfWqO2iVUZjFB+0hU3JraAt
	 DG2uOgECMhQsVhRzfb6cxHl0iMPfmAVN2oY+qgQjxZ1Cm1dFjmd+5asd21OZa2+tpz
	 2f+qLhNMSGRzhus2lXBc87cTpmJGOF3scf+g9YTJGXC2AoqN2dRA8cCcozEeFVrsYW
	 AbsBrE4U2mpog==
Date: Thu, 24 Oct 2024 23:32:27 -0700
Subject: [PATCHSET v31.2 5/5] xfs_scrub_all: bug fix for 6.12
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, aalbersh@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <172983774811.3041899.4175728441279480358.stgit@frogsfrogsfrogs>
In-Reply-To: <20241025062602.GH2386201@frogsfrogsfrogs>
References: <20241025062602.GH2386201@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Hi all,

Fix a problem with xfs_scrub_all mistakenly thinking that a service finished
before it really did.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

Comments and questions are, as always, welcome.

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=scrub-fixes-6.12
---
Commits in this patchset:
 * xfs_scrub_all: wait for services to start activating
---
 scrub/xfs_scrub_all.in |   52 ++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 52 insertions(+)

