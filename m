Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09D7E8627C
	for <linux-xfs@vger.kernel.org>; Wed, 24 Apr 2024 03:30:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713929419; cv=none; b=l+dAObtEywGNc1EVwJxEKs8CH2IvL8SWEC3DBd+aHAWqvnLEr8oW7m2PJIhcmQSj10zp1+7uh3QXDuDRuKj7buLmahvXsp/jWzsAIqb+zqqoQryI9sJKM7PT0GOTW4CiG3dguFO8q1O6pkf5MazEir4bgtv9f+gMTiRP+LPx+/E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713929419; c=relaxed/simple;
	bh=PY7DtCjyIhpciZtxjVaVHcklsc0ClFm192bKDYbTE8I=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=TLcbFbvmk1X9ToqcZ6OkMhuA//IoeKSCFn9XMAOoYZFJV3Tuk9phnjCxBgklBCFSxY4OV/XYdrbyNEkmI9Nmb9huTDqbs5zkYV9mbmizcSiVt6aWg4hJyUj9O+MDy5uYp/W9u7/07Fcvpda3BkS07/Q0TpM8BBv7bGyhA3aD3C8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FV/Tb7qM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FV/Tb7qM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3AAEC116B1;
	Wed, 24 Apr 2024 03:30:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713929418;
	bh=PY7DtCjyIhpciZtxjVaVHcklsc0ClFm192bKDYbTE8I=;
	h=Date:From:To:Cc:Subject:From;
	b=FV/Tb7qMpQEwGCi4xFbs4zbV+zA8Kvz4z0UdKj6Ue8S84jjHO90cOoOiEDj9NBX/8
	 72LTodWkWNFm/sYAutc+3rj0lagxrJlTzgZYeki8ElAsUAt+lenagR4UGmOIrsxqyp
	 VlLAQvuiJODxfU8Ofzk+wA83lcNZLbGu6t98lnKTNPyIoKfL6SlgUCNEJwNeoaBRMu
	 sZQyNIjCVW5xHCklTeB/iOdKrKa1hSmBqS6YISr5ZqndWMM3/M/2ivw2ySRQj0GW1X
	 xQrIA9no20UlWgerlENsMDnKVzKn/UBwbaeS3en7Eo2LYZ5MeK0z+mvbRfq+RS2xVK
	 fYh1wx96VR4ZQ==
Date: Tue, 23 Apr 2024 20:30:18 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Chandan Babu R <chandanbabu@kernel.org>
Cc: linux-xfs@vger.kernel.org, Christoph Hellwig <hch@infradead.org>
Subject: [GIT PULLBOMB v13.4] xfs: directory parent pointers
Message-ID: <20240424033018.GB360940@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Chandan,

Christoph and I have finished reviewing parent pointers and think it's
ready to be merged, so please accept these pull requests against today's
for-next branch.

For anyone following along at home, the xfsprogs patches are here:
https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=vectorized-scrub-6.10_2024-04-23

--D
