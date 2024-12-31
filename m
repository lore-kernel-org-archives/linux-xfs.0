Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C24F613FD72
	for <linux-xfs@vger.kernel.org>; Tue, 31 Dec 2024 23:33:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735688034; cv=none; b=HUngCqdlaeEBSzS5V34c/oJuRqm8qHL1RMehHKCsWP/SKT5uQnz3orCGrJ5rUVvtClklgf0p7Wxhx3FJxsDaVWulEcXW02yOW1rGgtEg6472Q/So0gWl6xzCbz0kpBgYAN7UdV7K1YEhAAazaXOXYQXkLHtxvQQl5FNmxwxKv2I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735688034; c=relaxed/simple;
	bh=POCdJhoyD6HkYchoSi1jdSVf1zaV3FLbxGCy/FVxAGY=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=fFBpDD0rmWY36oqfQ77FgvxKZO3o0lpQTLXpZMzxaSzGImkBDX+PSsypDiQK5R4t+f/duH/VE1o/zTLqNIF7GFCgCGDLIQQT08fi285p4TCDMO7W2cGsEg5wcaN++N/AGynxP+klgGL+Jp25MUrgjV3FaRuCgIWdJFXYtbLnooM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=n3vzbZsq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="n3vzbZsq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 474C5C4CED2;
	Tue, 31 Dec 2024 23:33:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1735688034;
	bh=POCdJhoyD6HkYchoSi1jdSVf1zaV3FLbxGCy/FVxAGY=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=n3vzbZsqlc3Gf8GGS22cSS9VH2R2eHyHzoN1gNT/8awW0G+XQcjAoeX7qWVbj8q4O
	 lbS3JE6IeRKziVVDc2Fe4Dv7n3RmiMOZNahcwOfQ7f5QK2gd/Gy2tHU5AeYEW1CtLQ
	 iezg/QqDgeFrcRCqMEqJzr3arHNnRJR9i3HpJk7lMJMPwz/8dTbj0E7/lq8QxgMBiw
	 fhlmlUdptixFkGKSnP7nk+u9bv2Gx9JMXQTjwvNEQCgMdut704Rq4FYtQXSc193cC6
	 DTwus4z+HwE1tRwn1skr92n2jvZLiXgAk1foZlJoEgr1nkqkXv2pAKHjj2xtlZsCOu
	 k/GD+/iyPxQuw==
Date: Tue, 31 Dec 2024 15:33:53 -0800
Subject: [PATCHSET 2/5] xfsprogs: report refcount information to userspace
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <173568777448.2709666.9021196629205919934.stgit@frogsfrogsfrogs>
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
 * xfs_io: dump reference count information
---
 io/Makefile                         |    1 
 io/fsrefcounts.c                    |  476 +++++++++++++++++++++++++++++++++++
 io/init.c                           |    1 
 io/io.h                             |    1 
 libxfs/xfs_fs.h                     |   80 ++++++
 man/man2/ioctl_xfs_getfsrefcounts.2 |  237 +++++++++++++++++
 man/man8/xfs_io.8                   |   88 ++++++
 7 files changed, 884 insertions(+)
 create mode 100644 io/fsrefcounts.c
 create mode 100644 man/man2/ioctl_xfs_getfsrefcounts.2

