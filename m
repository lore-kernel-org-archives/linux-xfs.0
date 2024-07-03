Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3883217DA30
	for <linux-xfs@vger.kernel.org>; Wed,  3 Jul 2024 21:13:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720041192; cv=none; b=rjrZvQednqYXwPVYvf/95+TNvQxSQ41tZ4AldFlGVwH/pqESTTuo3SAr5SjGAy22nhNmLtOvKMDKkP1rlLYKRAzz74/UcfXirqJfFAxaaGURbYaNvXqIu41SWCR53J/gMI0eYGZVFOH9Mgnx+kCOilIqBVo/b4JHr/IV3dnEo6Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720041192; c=relaxed/simple;
	bh=gkITlIiAbDmovQ/QmX8bjg5Z1Y/y3OxTS4tEMxeIzpY=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=XGlIdHUEp7s7uUcMY42rLfooiHDzz1JN51+yKDb7ZAn6U3QMgsAMEcMBR5p99n4ykYYgzRYNL8BsQJPFIgN4mJdkbSo9OBcPAKQHVUjo5XXa+cFXPNJV1FBvCyG2SViQnyZemVtHh9+/59njXKPXRle/THCMCHQu9CP5+YV66SE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LvCnxTpF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LvCnxTpF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9970DC2BD10;
	Wed,  3 Jul 2024 21:13:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1720041191;
	bh=gkITlIiAbDmovQ/QmX8bjg5Z1Y/y3OxTS4tEMxeIzpY=;
	h=Date:From:To:Cc:Subject:From;
	b=LvCnxTpF81fN7gkZ2wbEGJoJgf5/JGEXdmqTsUMOPUnYSR3u03jICCNN8s3qoaoBR
	 02dUU1VvK6YWKSqRp/eduQv4jOGywTc4RPmroi6x3ICoRfkRb8X/VObZ6nhfma10we
	 Gj9y1W1y68XG31AM2gNFLrYNPkOU1aTiWT5wmJu18NcKYZ7GPS8sLza7rqT97Sazv/
	 g8aP2HIflT44ujF8xsXO6Yp7IpIi06iCivg09JwfEs451I6UiVAcZEphO55hr0BWJ4
	 IjIhxCpy1iBIIykOO49AHRjx0fykDV7dBgoFnaCHjWKDHDf56ma0T4QXmljAwj8EQZ
	 yDs28VM2GBu7A==
Date: Wed, 3 Jul 2024 14:13:10 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Chandan Babu R <chandanbabu@kernel.org>
Cc: linux-xfs@vger.kernel.org, Christoph Hellwig <hch@infradead.org>
Subject: [GIT PULLBOMB] xfs: log intent item cleanups for 6.11
Message-ID: <20240703211310.GJ612460@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Chandan,

Christoph and I have finished reviewing a large pile of deferred log
item cleanups and think they're ready to be merged for 6.11, so please
accept these pull requests against today's for-next branch.

For anyone following along at home, the xfsprogs patches are here:
https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=mkfs-icreate-cleanups_2024-07-01

--D

