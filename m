Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E6DE27B331
	for <linux-xfs@vger.kernel.org>; Wed, 22 Oct 2025 11:32:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761132771; cv=none; b=t6aMAvdoUIHdoRtbmEqePW1yXZ+7CqPsPnhF5fD9JzvIQem3DW+eEW39HbuBv52JevJaN2zsRr66neYuF+gBCwnPI1do09iaTFmKkGmL0xkFIp3yHmX8/sdaLzZ9aIaxJlziiB4of5oYQ8Y/r8WP+p+hk/UoVDqWbgo+4hkgnhU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761132771; c=relaxed/simple;
	bh=5gX6ShjUQTX5v5Mrjp/0VSzAvQbj1SOJ0ustv3xkEuk=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=uPGWOGQv6f+2Vrt1bHx0LP+fiHQ6DJs2aguHz/x4z2PuxGt5PeIbTKC9c2Z9Z2PlNKw5u7pgRqY9EPmGbAEz/pZlLB4QuqQcn8nVcZyaeoODSNHegvFmb1mp8HPmS59ABvew2sI7yBCakdmwg9mphCSQpGrFRnKISATh8EGDwNw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NrUfOOqz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NrUfOOqz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27818C4CEE7
	for <linux-xfs@vger.kernel.org>; Wed, 22 Oct 2025 11:32:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761132770;
	bh=5gX6ShjUQTX5v5Mrjp/0VSzAvQbj1SOJ0ustv3xkEuk=;
	h=Date:From:To:Subject:From;
	b=NrUfOOqzVeKkMP2zT4uVnVhpTrl5kvfDDfaUwvZrQwrJrHxY6/PLI61ZRcgzQXvS4
	 6y8j3KJJK7Hx3Z+gzxMZBMhujJcUpaMGPGnoJ2e7bkFCYr7/y53VL38KZyZkgA/8oe
	 TkdWx3lI2xpJaJbTryiI5o/amuCZc9GoCKQeZn9Blgssu9XWI8ltVncq9TZYAxSapR
	 gEIkuUvZkFBmcamyDUvZLTe9tTfVkk1lULrWrXIltYy3ZJmg7p9rZR0lWC+5SKXXMj
	 sAuferO56cJQOtiVD2sQzhzJnn4DLOg54nJLvBMA2tFm9wAfRsETOAoDMLq3r8MVdo
	 RctbjcGNpcu/Q==
Date: Wed, 22 Oct 2025 13:32:47 +0200
From: Carlos Maiolino <cem@kernel.org>
To: linux-xfs@vger.kernel.org
Subject: [ANNOUNCE] xfs-linux: for-next updated to f477af0cfa04
Message-ID: <mqkgkexsauhpirljtasyd6c3waksmhwnh4vbbkmaiu54mn724i@upcogtyldmgq>
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

f477af0cfa04 xfs: fix locking in xchk_nlinks_collect_dir

4 new commits:

Darrick J. Wong (4):
      [bd721ec7dedc] xfs: don't set bt_nr_sectors to a negative number
      [630785bfbe12] xfs: always warn about deprecated mount options
      [3e7ec343f066] xfs: loudly complain about defunct mount options
      [f477af0cfa04] xfs: fix locking in xchk_nlinks_collect_dir

Code Diffstat:

 fs/xfs/scrub/nlinks.c | 34 +++++++++++++++++++++++++++++++---
 fs/xfs/xfs_buf.c      |  2 +-
 fs/xfs/xfs_buf.h      |  1 +
 fs/xfs/xfs_super.c    | 45 +++++++++++++++++++++++++++++++++++----------
 4 files changed, 68 insertions(+), 14 deletions(-)
