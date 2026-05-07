Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83745344DB5
	for <linux-xfs@vger.kernel.org>; Thu,  7 May 2026 22:11:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778191882; cv=none; b=aYpgynUatufSl31FooTr0FUJVG9d9Qgd0+Hhe32njYbJSNYv276uDF26NEm/4bHZgkoREjbpvC/KWW+27d2RjyII/x0xM/uyc3YJaQDOBu91Mm1TM1LvNAgLsnP+1EuzPCROqPG1PV2LcXk00XpWG6rJbEQdn/jd/n56A0Z4IrA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778191882; c=relaxed/simple;
	bh=K9yUlSULdjzFCQcvd/veeGOGkGxDnFpOKaClo5d08ko=;
	h=Date:Subject:From:To:Cc:Message-ID:MIME-Version:Content-Type; b=f2PgaO971ON3eBEAeob3uJ49IS9Gk1SyYTL9+drHQdE90sZaN6weVaG7vsOICCVHV767q6XtR4XACau8SDFJtzvGOIbwmggP9WbJgmtOQX9oG8ZcMg+UNYsgRCQuhme66H5HXPOtqdgBhzpbqOOJEu9mXwyXN5cCzTl6Vs6OpfU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JhkhlRxy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JhkhlRxy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5530FC2BCB2;
	Thu,  7 May 2026 22:11:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778191882;
	bh=K9yUlSULdjzFCQcvd/veeGOGkGxDnFpOKaClo5d08ko=;
	h=Date:Subject:From:To:Cc:From;
	b=JhkhlRxyCK8lXm60RXLJKR1oFHUoba6mqNHvjku76zg/N4ZKoJuUQ20c41EP7PB8u
	 RGk38eFhChpmjgTLqF3VmprvvVAwbPlNFM/8g+PuzIPKViBJp8h7h+zBzAVF5vPB2p
	 /9C2yORBjozuDzwdwOtvmQkxoVJ7E9paQJGj+5ZWshYWvD6NVQR04YAyHolAwCv+jW
	 tkuejTmqdIQimOJqZKAC+lrm7hVZ+8L7Kh/KdmH4i1AevBXzmi3duCCTaeaJwxcH9g
	 b13Zb2jwPe/yYuYLIL8UFUBbiGFtoeyC5vI6/Sq/az1UdxMi7V8m18UhnsSQkaBPkh
	 DmZj1103oWFGw==
Date: Thu, 07 May 2026 15:11:21 -0700
Subject: [PATCHSET 2/2] xfsprogs: new libxfs code from kernel 7.1
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: hch@lst.de, syzbot+0391d34e801643e2809b@syzkaller.appspotmail.com,
 bfoster@redhat.com, cem@kernel.org, wilfred.mallawa@wdc.com,
 linux-xfs@vger.kernel.org
Message-ID: <177819182887.3486206.18149824043863236840.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Hi all,

This series ports kernel libxfs code to userspace from 7.1-rc2.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

With a bit of luck, this should all go splendidly.
Comments and questions are, as always, welcome.

--D

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=libxfs-7.1-sync
---
Commits in this patchset:
 * xfs: add write pointer to xfs_rtgroup_geometry
 * xfs: switch (back) to a per-buftarg buffer hash
---
 libxfs/xfs_ag.h |    2 --
 libxfs/xfs_fs.h |    5 ++++-
 libxfs/xfs_ag.c |   13 ++-----------
 3 files changed, 6 insertions(+), 14 deletions(-)

