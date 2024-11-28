Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD604144D1A
	for <linux-xfs@vger.kernel.org>; Thu, 28 Nov 2024 12:18:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732796335; cv=none; b=piGmqJ4bCJYpD7RLgtgyWeVB9DED5cvSVbhwMy6Mhd8GVDKpEQ8mNpAPqaFkoMo46P0HC5ssf2rN0MVs2NnhS9K8odrBkBnIyKs07pc6hHeqgPezbEva18xn5ytpHijULE9PDOUEkzOxtV2YHMz7Mo52YJIvP2LpDDde3sE/Sjw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732796335; c=relaxed/simple;
	bh=sG37FtAmgJZ76bKKt9MLYZVBEUO/gbZToiY20KlhY0c=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=vDTntSOpxwomCbS7AEOwZTNEb9I1Jv9Np9rbiVMxFPBPC3hjvtQ8HwdzmvtCPj25emsTlMQVjTV++VLAupcjgFffsKA2FGk90ru71CP2KHDBZjVqqmnMVyf+i6RoVm0mk9D8hzRh+rsR6fo0IkaeRJTKVWX+BNG0qEErI/6Uxms=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UyXEoMby; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UyXEoMby"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F92FC4CECE
	for <linux-xfs@vger.kernel.org>; Thu, 28 Nov 2024 12:18:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1732796335;
	bh=sG37FtAmgJZ76bKKt9MLYZVBEUO/gbZToiY20KlhY0c=;
	h=Date:From:To:Subject:From;
	b=UyXEoMbyMHq1G+Wi5nFC6o7GX77cX8vz3fozaiurfQI06rnxYGdM7AuP8bzHbcE7o
	 AFXBR2mKKviwS6PsZTRwPD2MAOxFMpPdhQaXZ/PyZdm3ObkMr99xEfs1CGySdPJwPE
	 2oF7cdDaDp3SMaYaZ1PwypiOLh5yXb11zVQCOgSbCN5y6c23f0v/xA3bOxOLCHXsx2
	 3RKmxSKJGocpEfSPO+blw+IHuB70sonrciJ/2GInEGxhDFPhMWSv6RWB1ectcLqlNK
	 CkpfOLE3HFvUAf5Mx05h00EooEsZ+w4sM9I9GJmKbcd7RDbjj6ebtVy5UDIFNHSDE/
	 MZ4voYifugRMA==
Date: Thu, 28 Nov 2024 13:18:51 +0100
From: Carlos Maiolino <cem@kernel.org>
To: linux-xfs@vger.kernel.org
Subject: [ANNOUNCE] xfs-linux: for-next updated to cc2dba08cc33
Message-ID: <e727xexxruxrs7ut7f76wmaiodoc7r6wa3sqr7jfaknoveab6o@wav7rmgmkvtv>
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

cc2dba08cc33 xfs: don't call xfs_bmap_same_rtgroup in xfs_bmap_add_extent_hole_delay

2 new commits:

Christoph Hellwig (1):
      [cc2dba08cc33] xfs: don't call xfs_bmap_same_rtgroup in xfs_bmap_add_extent_hole_delay

Uros Bizjak (1):
      [214093534f3c] xfs: Use xchg() in xlog_cil_insert_pcp_aggregate()

Code Diffstat:

 fs/xfs/libxfs/xfs_bmap.c | 6 ++----
 fs/xfs/xfs_log_cil.c     | 5 +----
 2 files changed, 3 insertions(+), 8 deletions(-)
