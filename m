Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 797B530E0F3
	for <linux-xfs@vger.kernel.org>; Mon, 24 Nov 2025 15:11:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763997062; cv=none; b=pWHiRi8Bo9ArNcl36AJ2lTMh1edUu8ppmrGaFyb7AEObUBgYBvPh8zfYqF/9TCpBrKckbFRkYMxK5nN51UkDAYAR8T9qwp+W3k78EWGBdboLQXqHTMvCDQuf6en/TTAL67IvFB5Vh5SjYZ7oAWqNNB9SDpRsP1fT3U67GnDjY4A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763997062; c=relaxed/simple;
	bh=ThKFf+BnqL1Qt2Dx+Q8EkHHc546T8EG90EoMQezPDtk=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=FAIruT2ihXVy6VvCBSjFb1vgXtzPeGC/GoN3denWtOEkDv59PAqH8V+4RVLwmpYt2IWWbrlN9q+PuTvmO+hwugo3uHHgbzawWZTbB+2Oj1JQX0qjEP0x26CCeayTdERifCyuJEDuS4p2HcAlgC3zOdp4X8SBiSj+fOAwnOvUQSA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dvCgmzNt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dvCgmzNt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6AE71C116C6
	for <linux-xfs@vger.kernel.org>; Mon, 24 Nov 2025 15:11:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763997062;
	bh=ThKFf+BnqL1Qt2Dx+Q8EkHHc546T8EG90EoMQezPDtk=;
	h=Date:From:To:Subject:From;
	b=dvCgmzNtqULnBKJNWRqUW/yTC+s//PROOg+lBMQRCnvtymIeQBAP/vusODEb8MMBu
	 xASO6EYS3JoyM/ml2+EXE1JWCUBr00+7Y0ZZ+QVKoqu/dDr+0sfPcKitIS4N42kv/m
	 lzr1jpPiLXFffFzyVN9T4/ApG+QQNLrQ2/Eyq3OG/1om0nKR95K8O1kL7/rG01yTIW
	 a5Bu5YV/pw5I4kjNlmq5ECFlYzah3qTB0bH3iKOz6vE5DJSMi+fiikmJopWLQX1xtv
	 zABPCC3p7LaM9jMoNSU4EDakeKAORSl6Jg3Dj+OqPqJwqqbzEAcfGOTxSmz/zdLuOW
	 GjUY60PMc/Z1Q==
Date: Mon, 24 Nov 2025 16:10:58 +0100
From: Carlos Maiolino <cem@kernel.org>
To: linux-xfs@vger.kernel.org
Subject: [ANNOUNCE] xfs-linux: for-next updated to b8a1a633a863
Message-ID: <wioyeveymfna4hcmzgxdl5igxh3mbdlxngn6xxob53ovhc7teh@w26adbv5qiv7>
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

b8a1a633a863 Merge branch 'xfs-6.19-merge' into for-next

12 new commits:

Carlos Maiolino (1):
      [b8a1a633a863] Merge branch 'xfs-6.19-merge' into for-next

Christoph Hellwig (11):
      [5a231381e5e8] xfs: add a xlog_write_one_vec helper
      [74f645212e0d] xfs: set lv_bytes in xlog_write_one_vec
      [406fa5a5a9c3] xfs: improve the ->iop_format interface
      [d09aeba6ce6e] xfs: move struct xfs_log_iovec to xfs_log_priv.h
      [9ff5678846f2] xfs: move struct xfs_log_vec to xfs_log_priv.h
      [4d139d3aebef] xfs: regularize iclog space accounting in xlog_write_partial
      [c11b2834d0b2] xfs: improve the calling convention for the xlog_write helpers
      [4eb6609e629b] xfs: add a xlog_write_space_left helper
      [9c3fead7ccd4] xfs: improve the iclog space assert in xlog_write_iovec
      [f66ea030a783] xfs: factor out a xlog_write_space_advance helper
      [64f73000bb3c] xfs: move some code out of xfs_iget_recycle

Code Diffstat:

 fs/xfs/libxfs/xfs_log_format.h |   7 -
 fs/xfs/xfs_attr_item.c         |  27 ++--
 fs/xfs/xfs_bmap_item.c         |  10 +-
 fs/xfs/xfs_buf_item.c          |  19 +--
 fs/xfs/xfs_dquot_item.c        |   9 +-
 fs/xfs/xfs_exchmaps_item.c     |  11 +-
 fs/xfs/xfs_extfree_item.c      |  10 +-
 fs/xfs/xfs_icache.c            |  31 ++---
 fs/xfs/xfs_icreate_item.c      |   6 +-
 fs/xfs/xfs_inode_item.c        |  49 ++++---
 fs/xfs/xfs_log.c               | 292 ++++++++++++++++-------------------------
 fs/xfs/xfs_log.h               |  65 ++-------
 fs/xfs/xfs_log_cil.c           | 111 ++++++++++++++--
 fs/xfs/xfs_log_priv.h          |  20 +++
 fs/xfs/xfs_refcount_item.c     |  10 +-
 fs/xfs/xfs_rmap_item.c         |  10 +-
 fs/xfs/xfs_trans.h             |   4 +-
 17 files changed, 326 insertions(+), 365 deletions(-)
