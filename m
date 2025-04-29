Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E08E813D52F
	for <linux-xfs@vger.kernel.org>; Tue, 29 Apr 2025 09:33:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745919226; cv=none; b=oaq5hRSZQgkyxQKXMHFzxQujyH1DNkdd8cmZ8Yt474UQTsdfcDEj8JMPRFDqx+zaLpwETWORNXSYSnQtmoAqMdvA/HZXbi0CNQSTuBPYOxQHu1oi3dkV+tdJaTkHwY7N95BkcuN8vdLtHzF6j18P7gc9TlInXp8bE37fO6HYc1A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745919226; c=relaxed/simple;
	bh=OonNPUbRYo1xYWM8CFEYz16qTnjqIBd1+Xv2dgPv3lA=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=ZwccyYpSWm5ppIxyeNQM2nBaV6heXOkFGBn5fw90+3Cu7mIGh/Z0JXR2QMFYIi7aqvDa+OC/GP9FbzChQFPg+jZXE062G1n8a4IOlab5LUG+DnX+AdI7n+OyD99lXH/YQD6x1USYYiqj9HKQFV8Qz6TRGqiM2WRtNRB9Ex/3848=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IUo6IfCg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IUo6IfCg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7A5EC4CEED
	for <linux-xfs@vger.kernel.org>; Tue, 29 Apr 2025 09:33:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1745919225;
	bh=OonNPUbRYo1xYWM8CFEYz16qTnjqIBd1+Xv2dgPv3lA=;
	h=Date:From:To:Subject:From;
	b=IUo6IfCg5E1Vc1izjM6C/mGvqGV8sXD/K3NFRxgddmY9YR3/dpdBrElZH0jO723EY
	 vq7ptLM3v/iR6UBOiQwgTkBpSVyK2vq2CUoRtU9lUYKoTfdaiNj8RQ4JhDIRSQIjqi
	 yPDGkm6UT6k3eaAcfaiDCxykmLavnT2oGPU7BcDrYb6VKIKcllC4QroCwhn9OE/7kt
	 3DCboxjc1qvaZrH8wVMyhABcJbtlbyOsZxFhUvjD1XDVK7k5m8brRE6Ildn4ezserE
	 tK6OnvmK6NorN+u+M7arsKWKU2OXWjxDR4TCOcMepLe/Lup+d+zuzL7iKSzjjZQCv5
	 aKsEuV8hX9DjQ==
Date: Tue, 29 Apr 2025 11:33:40 +0200
From: Carlos Maiolino <cem@kernel.org>
To: linux-xfs@vger.kernel.org
Subject: [ANNOUNCE] xfs-linux: for-next updated to 5088aad3d32c
Message-ID: <4jkqcniznsgabiknw5z3fa56ksgwzrad2titz546gjym4s2avk@6xhdz736mrby>
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

5088aad3d32c xfs: stop using set_blocksize

56 new commits:

Darrick J. Wong (1):
      [5088aad3d32c] xfs: stop using set_blocksize

Code Diffstat:

 fs/xfs/xfs_buf.c | 15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

