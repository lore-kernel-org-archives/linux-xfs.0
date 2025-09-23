Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26F111F2380
	for <linux-xfs@vger.kernel.org>; Tue, 23 Sep 2025 13:50:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758635459; cv=none; b=RGZMeGH7BnHkBWa6wxAQXuwfWGXFY5KfOelabMZh+s/E4Iq/0frNZSqx7R1pYAY39pMbFxFHT4KTazcpVkaoU9hqdpcHi+1tNvUb+e3UReLrW56pKDsQaqFH5VNhpOZqEqOqjbRJvult0ghmrtqCIH85rb3NDDszJkrnWsEoGEY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758635459; c=relaxed/simple;
	bh=8p+oFXf3GSgAHHUO2I4lsFZi1V6FNB4IDb7luOjHnJc=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=N9WwTb+mxpB/4MC3VjUG2iAsCg6QVJJ0F5eeERxSUjF/SweNgy/x/SxXhryHRSE7vqgfm0wFbO5cQfFMgZhKD/lIlo8xWA6bPYpCzr9cqDx86HoxwB0yaYorztZ1zNrsXar3wzPfFd9yBptTkkwOyqDIr0sJAT5vv1v1A4FzvBY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Q/PPTWz4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Q/PPTWz4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23833C4CEF5
	for <linux-xfs@vger.kernel.org>; Tue, 23 Sep 2025 13:50:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1758635458;
	bh=8p+oFXf3GSgAHHUO2I4lsFZi1V6FNB4IDb7luOjHnJc=;
	h=Date:From:To:Subject:From;
	b=Q/PPTWz4WIQnPwfwk45dU0XsHEW+aAPTUc7ixcMpEavlCyjIMAdnngP5OeUhawHNm
	 nSHPdyGNZ1Y8JvqKjZdwtqVQIRQRFgerH2DYAqZLNBm5mR2VbfjnibDVeNfuKadvXv
	 0iNfJhJ8BafygTkS+o0U/3pcNAZCtLsdpEk+zuMoB2hzxtrDxxCYUo36q/4aool9v8
	 AIduRnoZhbId0ojds4uwxX4Mt4cOB4H7JwF+OzFZgpA/AZ/YcH53YtbRLs+O11qer6
	 9VzuWCUNXBS1TJJfWg2BPR4eQ1Wr/BNo2MhEfO0KTcEedlf1VgFQXuJ9x5LhbQRG5v
	 +jb4ew048yKVQ==
Date: Tue, 23 Sep 2025 15:50:55 +0200
From: Carlos Maiolino <cem@kernel.org>
To: linux-xfs@vger.kernel.org
Subject: [ANNOUNCE] xfs-linux: for-next updated to c91d38b57f2c
Message-ID: <gzjrwclu3xpi6vy6nf5n6r7h4a4t2t5pon2xgr722yruw4wpw4@e654k4te6cqc>
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

c91d38b57f2c xfs: rework datasync tracking and execution

2 new commits:

Dave Chinner (2):
      [bc7d684fea18] xfs: rearrange code in xfs_inode_item_precommit
      [c91d38b57f2c] xfs: rework datasync tracking and execution

Code Diffstat:

 fs/xfs/xfs_file.c       |  75 +++++++++++++----------------
 fs/xfs/xfs_inode.c      |  25 ++++++----
 fs/xfs/xfs_inode_item.c | 125 ++++++++++++++++++++++++++++++------------------
 fs/xfs/xfs_inode_item.h |  10 +++-
 fs/xfs/xfs_iomap.c      |  15 ++++--
 5 files changed, 151 insertions(+), 99 deletions(-)
