Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C880E13BADF
	for <linux-xfs@vger.kernel.org>; Wed,  8 Jan 2025 14:12:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736345575; cv=none; b=XdM3EIghkbqd+ISL/lyJMx+fgN8M5i/F81wsIYR1RdyzgeYzyFHC+L8qgIoCOXO8wT10l4/Kd34Lq1B6jrkAVUimVCHgsi9rVqJ8BL0mpLZT5RvdQ6N+7bEW6NFyRJEEXzFoU/+hibD2xH9i+imodVuj6ZlYKsvMAbtNzRC87T4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736345575; c=relaxed/simple;
	bh=RKLW3Znmg5x3eIVL8LBkhY/X7kffPpqim57WSAGA75I=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=YwHvIHJNCrC7DJ0f2x6WOUCTZB81rHRfJfqDJ554wQ/ESL2eOlt8SfKNAOt6L+r+CJZCCg/WQj0TLagiZTmafjjpc5HTKDSYAsyqlot3p8g+CZjvm2t0fZI3aBjmrEwfk8YGhy8WOnS5CCS36Hdf2USkhY7PCr2bI9W6TYnePN4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=G+UHWPWp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="G+UHWPWp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B90AEC4CEDF
	for <linux-xfs@vger.kernel.org>; Wed,  8 Jan 2025 14:12:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1736345575;
	bh=RKLW3Znmg5x3eIVL8LBkhY/X7kffPpqim57WSAGA75I=;
	h=Date:From:To:Subject:From;
	b=G+UHWPWpnxWvU8+ianY+4KBtDdOFA8Ce1nwLclVxi9YeQsR3FN2EtAERblMGDzeyX
	 wCBJ0UlXOj8dyHjkMFoz5fsd3fr/VRkHSq75e9DdLsvOeBO4DNEmIjPKuV2gb0Gvbz
	 zhqR8vpq4x8UqESQshAz9nYR5xa+xMcQWnSGG+NCfVtgshq4cROvyi2D9EsNpvTycs
	 JgYg2Y80NP2h5CWDwTHomV87ORlkQIKapb9nXLmcu6a8IAU5tgyBD3yyy1Mfo63k1C
	 v0DpZYtL4XZ5563K7hkbB5KuX7YTto6Rb9ZTck7dv3ytS68XDIKR1yWvzBn1Q6Decc
	 g+7/A/fWenoBg==
Date: Wed, 8 Jan 2025 15:12:50 +0100
From: Carlos Maiolino <cem@kernel.org>
To: linux-xfs@vger.kernel.org
Subject: [ANNOUNCE] xfs-linux: for-next updated to 7ee7c9b39ed3
Message-ID: <uxartrae4n52wr3fk6phtyz2uwitoarqevytu7inktznhvsffj@elpsizgspdce>
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

7ee7c9b39ed3 xfs: don't return an error from xfs_update_last_rtgroup_size for !XFS_RT

1 new commit:

Christoph Hellwig (1):
      [7ee7c9b39ed3] xfs: don't return an error from xfs_update_last_rtgroup_size for !XFS_RT

Code Diffstat:

 fs/xfs/libxfs/xfs_rtgroup.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)
