Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19C5C13FD72
	for <linux-xfs@vger.kernel.org>; Tue, 31 Dec 2024 23:32:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735687972; cv=none; b=ApEtIXGimLsz1+CI1VRVC1V8Zh/3RNxJW1qkfIaHFCsh3NL/XKoUbAqJ2hw0ClF0EGWHIPl4dOqJl4q63gQrfV1qL052VN+JQEMQPOoyX1tr+gtwGVsuYgnAyMFI8T18UELUksuJcsrbfYCWFrcRoGRhIi64XTrRIJEQx7wTkSs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735687972; c=relaxed/simple;
	bh=eEXyqiI9Y8kqQSikeTFBpHwZ6BvbpBSyWBSxBMjRwd4=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=H4KoHB2kUTa+itswwILHSI0mS15r0ysRgi4GGRPIuLL2vVGtskx350VzlyWyJ5uMYqRP96jTI16VGCADnxY7U681xR0Gg2d+NKmqpg6k8+qF0OXKCHH6WxIMIBRyyLOtWMOL0ROVSMS0j8i8wi0gqxSASX1Tcq5F+aJUogY19sU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=o7CM7HkH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="o7CM7HkH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F9ABC4CED2;
	Tue, 31 Dec 2024 23:32:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1735687971;
	bh=eEXyqiI9Y8kqQSikeTFBpHwZ6BvbpBSyWBSxBMjRwd4=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=o7CM7HkHPIhk4AU5kXnCYA38qPS0m3ZbYWtze1xGFPcTJDik+rdo18Eh95ckWHBMQ
	 fRXoDZEYEOh4iifY3LEDF6IiEKN35P+HPjjsybwsmQ2vGeEfVjyTMJ/THKYPDZmD0U
	 u0b7RmXIWIff1rx/bumki9rsoqEL/Csdn5YBvWCwG78p//SI3fEud5myBwlWv7P4vd
	 TP/5pFACwWDZdhoPKgLwN4LuR33xiB32ws8PmN9zLuoU/eodIkYb74It5BHUqDo1n+
	 wAT9hsg0vdbCNm6vOqTv1sMaVkneX54FVYMezQbHdVl+gyu8eysa9t9IKhbOEi+HlU
	 hkfheCPCEVNrg==
Date: Tue, 31 Dec 2024 15:32:51 -0800
Subject: [PATCHSET 3/5] xfs: report refcount information to userspace
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <173568753792.2704623.934064284628202618.stgit@frogsfrogsfrogs>
In-Reply-To: <20241231232503.GU6174@frogsfrogsfrogs>
References: <20241231232503.GU6174@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Hi all,

Create a new ioctl to report the number of owners of each disk block so
that reflink-aware defraggers can make better decisions about which
extents to target.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

This has been running on the djcloud for months with no problems.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=report-refcounts

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=report-refcounts

fstests git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=report-refcounts
---
Commits in this patchset:
 * xfs: export reference count information to userspace
---
 fs/xfs/Makefile        |    1 
 fs/xfs/libxfs/xfs_fs.h |   80 +++++
 fs/xfs/xfs_fsrefs.c    |  777 ++++++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_fsrefs.h    |   45 +++
 fs/xfs/xfs_ioctl.c     |    4 
 fs/xfs/xfs_trace.c     |    1 
 fs/xfs/xfs_trace.h     |  125 ++++++++
 7 files changed, 1033 insertions(+)
 create mode 100644 fs/xfs/xfs_fsrefs.c
 create mode 100644 fs/xfs/xfs_fsrefs.h

