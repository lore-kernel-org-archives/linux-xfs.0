Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFF272C08BC
	for <linux-xfs@vger.kernel.org>; Thu, 27 Nov 2025 16:09:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764259761; cv=none; b=QI4mjGCvIFD0sNqec+PGzmZWxppp04nf1IIb2NMuKDOseGS4uTf94uv2HrpDv0GKiHxTU30HmpUSY0c8DYR+DFAQiFNpOHottDdj7qP5ZvQM6s4DTbe8MXM6ww4Hba3v3msmFSdB0UDO2Dw+VCMRONOvN+tjNelPMToz+W30KPw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764259761; c=relaxed/simple;
	bh=+vFEYU0uXkqd9r67F3kyByvcrHIr5Ovc+lzcH+GUsr8=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=Ac/6yMwcWFJdsTwoMrzMpr97wHj1Df8yNBPfU8dYFFBIw8l2AdvuOS3DfwVM9VLnAw2682af7pNqgHEf+ohLHtIQdpyMeY9JqTYP/ISzjBNhgtuwW5MX93CcHq1tQyi1xBPGJ4B1PjtN65w6oWFNFfDRr8V1qWIeDhrv8aSiswo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=b89FZS8/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="b89FZS8/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B48D8C4CEF8
	for <linux-xfs@vger.kernel.org>; Thu, 27 Nov 2025 16:09:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764259761;
	bh=+vFEYU0uXkqd9r67F3kyByvcrHIr5Ovc+lzcH+GUsr8=;
	h=Date:From:To:Subject:From;
	b=b89FZS8/oaGKCEqN0PAR0vPl0mgnbSNV2Q1UvFvp582zUc/1508Y2tIK/DdWWL12Y
	 LZrJXLe2HKosrTb/c6AOC+UmyN1FsSo/wgHw91FXq01pf18bT6asIbCpUuDa4SfRwB
	 aw94DynHq+tbRfvtyL5VamFaxGtbRVkkPsYCEXtIne7axHWrao7IWulUfl1ARGZB37
	 E2fKmU3f4CZnTxKfZAz3W2nLum8PSo0NgzqmQEuB+JtGxB4enYin8ZiOUr5ps9fN6V
	 FzY2RIllvL1355Tg1tDR6IBajwK0PASmPQy2aoeI5Kyl8Zdy1VLEdeMFJix30EdLaW
	 cIPvnyaQ4uguA==
Date: Thu, 27 Nov 2025 17:09:17 +0100
From: Carlos Maiolino <cem@kernel.org>
To: linux-xfs@vger.kernel.org
Subject: [ANNOUNCE] xfs-linux: for-next updated to 79c47bc68efb
Message-ID: <k72mugbwy3w6uiqq4usjyrtp63ham7r2gk45j5cukya7b5pms5@5cdr5duzfmzc>
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

79c47bc68efb Merge branch 'xfs-6.19-merge' into for-next

2 new commits:

Carlos Maiolino (1):
      [79c47bc68efb] Merge branch 'xfs-6.19-merge' into for-next

Darrick J. Wong (1):
      [69ceb8a2d666] docs: remove obsolete links in the xfs online repair documentation

Code Diffstat:

 .../filesystems/xfs/xfs-online-fsck-design.rst     | 236 +--------------------
 1 file changed, 6 insertions(+), 230 deletions(-)
