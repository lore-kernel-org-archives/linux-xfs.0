Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34FB3375F93
	for <linux-xfs@vger.kernel.org>; Fri,  6 Mar 2026 08:40:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772786428; cv=none; b=Hm7zBdElr5j/tG/CyZHnoGZDXuJhP2xL2IIL0O0cne1O1VNcuy38YlFAf3Jx6qRaqZsSHZiiH/HPpbuhnLQ/hUemaK9ih9VIbBona6MLeJLbxX561Abf6WJ31kESbHakNyvdhr6hxoOKj+dOCMLjz2LMKHjyD0qQNJ/Y3XPwkVc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772786428; c=relaxed/simple;
	bh=TRayLG2bwV5gdK/mDASfian6+htgQOcxEv1t9JawhaM=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=rmWaOclxBb3lhmykZyhU8vO602ZbTMd/AKdSOE6c06hyja0v527rhXqIfa02n6CsMtbEVwqJs1DjWFc/E9/kWuIdBJHG0hz46u8R1ENVs5BXwY804kXBhIWXpZGTBbjL+5B47VTzOnZ0wwNFMn2D4yk7PvQH6feOVCmL8o0cSrw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VDWRVOUV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VDWRVOUV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 313C2C4CEF7
	for <linux-xfs@vger.kernel.org>; Fri,  6 Mar 2026 08:40:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772786427;
	bh=TRayLG2bwV5gdK/mDASfian6+htgQOcxEv1t9JawhaM=;
	h=Date:From:To:Subject:From;
	b=VDWRVOUV/WlJSNTu9h1YxMzMz/fQT7tj+znsu09/2EfnWRQX8jtdp2i9F6B53dHuZ
	 aaXZTf0Lc7RtRRZ4/LjlT7GGsCOX3Zs0lUDQEU22q4QkDt07TR/3FNdH4zm0Wk0nEF
	 UPyH//amdUfE6iGQaC71MRwaSXiXTvYed76Hgld3w1S5v7NqjaNEkhV2U7tmcxgG8c
	 4VzVMoAH0rl4jJ/YIK9JXodQKh7R8R7Tw8yrydmxb2rzqjkdcS0lc8fldqHYMZJ34m
	 lGIyx5lU/CdBPb6to2G/dkTbsdkAp9uArz+0JkSZIDdVN9VQw6ktuscZ96m9OKCB/A
	 O4HFtZrbSRl0w==
Date: Fri, 6 Mar 2026 09:40:24 +0100
From: Carlos Maiolino <cem@kernel.org>
To: linux-xfs@vger.kernel.org
Subject: [ANNOUNCE] xfs-linux: for-next *REBASED* to 54fcd2f95f8d
Message-ID: <aaqSFIIiqxKkLa7k@nidhogg.toxiclabs.cc>
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

has just been *REBASED*.

A patch previously added started a discussion upstream, so it needed
to be removed from the current.

Patches often get missed, so please check if your outstanding patches
were in this update. If they have not been in this update, please
resubmit them to linux-xfs@vger.kernel.org so they can be picked up in
the next update.

The new head of the for-next branch is commit:

54fcd2f95f8d xfs: fix returned valued from xfs_defer_can_append

4 new commits:

Carlos Maiolino (1):
      [54fcd2f95f8d] xfs: fix returned valued from xfs_defer_can_append

Damien Le Moal (1):
      [6270b8ac2f41] xfs: remove scratch field from struct xfs_gc_bio

Darrick J. Wong (1):
      [0ca1a8331c0f] xfs: fix race between healthmon unmount and read_iter

hongao (1):
      [281cb17787d4] xfs: Remove redundant NULL check after __GFP_NOFAIL

Code Diffstat:

 fs/xfs/libxfs/xfs_da_btree.c |  8 ++------
 fs/xfs/libxfs/xfs_defer.c    |  2 +-
 fs/xfs/xfs_healthmon.c       | 17 ++++++++++-------
 fs/xfs/xfs_zone_gc.c         |  2 --
 4 files changed, 13 insertions(+), 16 deletions(-)
