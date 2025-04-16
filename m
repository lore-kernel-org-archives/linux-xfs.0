Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E7E722FAF4
	for <linux-xfs@vger.kernel.org>; Wed, 16 Apr 2025 08:47:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744793266; cv=none; b=JjpqUtefDHkt/5GcbnjeGtB2Vj8ExmWHTZ1cwnqUfReJnbFmwqtkxn9fxSw+NYE1F0OUwyZj8f/Oyt/Es80pGZiNCAffF0MCs1+oyQ627bW0CxTVJy+KfnF23ZhMipZkMx0/CIKRtcLX8U5fEDH+G8JXHZQdeadTvu5IbCMIFrY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744793266; c=relaxed/simple;
	bh=fbI9Ngq6knMcNJZiM2id70XMUVGCI+AECNW4omOhlls=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=OM5D5Am1ASL3Mc/89V49mgumrYPjEr9Kj7LxVjaztWAMPHDS/vnKsBYPrzPjdcCzB8SFMLIrGuoLKiITvBE3xUVVuQ41Z6Jg1BPateUV/ZErTjIBTJqwOHLW7qe2UcEG/vbgPiyJzpOYrgvGB1K2yAbJ/zkTI8qZXvPxc6XjfiM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=pfnxhhGx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="pfnxhhGx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B0A6C4CEE2
	for <linux-xfs@vger.kernel.org>; Wed, 16 Apr 2025 08:47:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1744793265;
	bh=fbI9Ngq6knMcNJZiM2id70XMUVGCI+AECNW4omOhlls=;
	h=Date:From:To:Subject:From;
	b=pfnxhhGxxADkjjVkYAtmTogn77sk/xQ/1zecTWVRTCcIe30uTO9Ni/MgOmze/SmsK
	 ls5fnqEcO5qzSQZG87k46U23G7lNWriKDWEj90SH4qJdjA2ovT4S/8gGa/7wJ2SAzM
	 ZbtPRXRezemYBlrHjRMWjvCWuZ6yH9sAUU6x/7yqMNjv2DAdTADypV/Yd1SL9pG9hw
	 pQhtvNvhtdv6hc4Ud7SMB2nzJ4mdFFu3BhzCjAb+Cuo4LfhjSUcKHhqja3XEkKZ1K6
	 RqHRUqj5D+dmz3NVaRHpGvv6cD1/xYvS1BQiR/wFsgBD6hJsknTDha7yggSzHSA2B9
	 WOAIHWUz8MSwg==
Date: Wed, 16 Apr 2025 10:47:42 +0200
From: Carlos Maiolino <cem@kernel.org>
To: linux-xfs@vger.kernel.org
Subject: [ANNOUNCE] xfs-linux: for-next updated to 1c406526bd84
Message-ID: <lslxyc6gayrlfb6ixpqjueujytqbpw2almqjpoatzk522bohug@dc37kd5de3ft>
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

1c406526bd84 xfs: Fix spelling mistake "drity" -> "dirty"

5 new commits:

Christoph Hellwig (2):
      [b73e05281cd9] xfs: remove the leftover xfs_{set,clear}_li_failed infrastructure
      [a1a56f541a8f] xfs: mark xfs_buf_free as might_sleep()

Darrick J. Wong (1):
      [a37b3b9c3cc5] xfs: compute buffer address correctly in xmbuf_map_backing_mem

Hans Holmberg (1):
      [845abeb1f06a] xfs: add tunable threshold parameter for triggering zone GC

Zhang Xianwei (1):
      [1c406526bd84] xfs: Fix spelling mistake "drity" -> "dirty"

Code Diffstat:

 fs/xfs/xfs_buf.c        |  1 +
 fs/xfs/xfs_buf_mem.c    |  2 +-
 fs/xfs/xfs_dquot.c      |  3 +--
 fs/xfs/xfs_inode_item.c |  6 ------
 fs/xfs/xfs_log.c        |  2 +-
 fs/xfs/xfs_mount.h      |  1 +
 fs/xfs/xfs_sysfs.c      | 32 ++++++++++++++++++++++++++++++++
 fs/xfs/xfs_trans_ail.c  |  5 ++---
 fs/xfs/xfs_trans_priv.h | 28 ----------------------------
 fs/xfs/xfs_zone_alloc.c |  7 +++++++
 fs/xfs/xfs_zone_gc.c    | 16 ++++++++++++++--
 11 files changed, 60 insertions(+), 43 deletions(-)
