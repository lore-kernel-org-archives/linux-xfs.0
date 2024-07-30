Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08AC7645
	for <linux-xfs@vger.kernel.org>; Tue, 30 Jul 2024 00:16:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722298604; cv=none; b=purzYUgWf1ifvFNB55YTdT0uAd5HcqT/Sw1VdYMH6TKrkwEAxRqFYnB8KX9RTIsJRzORrCkLJIU6PcaIzKQ8ep5bVP3hpbbckHfjwr2aXucXSSM97RYUTFsHrtxdP/g7r4KI5IEG1QoG5JJHDmqbUdDz3/yleoSi0WCCHBloD+U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722298604; c=relaxed/simple;
	bh=4gvsttEpav2m2eEMCHuaej73iSfMU/jDz7e97i2Oa7Y=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=jvopbjGuEN0HUa1ZRI4sQ7dYyS1MPF6DxR7mV7Vm4KjmcVmNpj0iEPeKL+8eW/dGmlOZXzFyDEZf65f2taesBXdhmUNaKWejD5uc9kUl/XYUyW7k03NQmI4gevyzRHDAiw8s1EKXFy9TPnxxZZAMuwDJNfJ2QsorXIXGqVZSoDQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IaTsGzI6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IaTsGzI6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9618CC4AF07;
	Tue, 30 Jul 2024 00:16:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722298603;
	bh=4gvsttEpav2m2eEMCHuaej73iSfMU/jDz7e97i2Oa7Y=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=IaTsGzI66xXp5Jn24L51oPp4IKSeO0HLHVZayK/dfgYgjSTQ3Rn5dKKQ7buR5YDrT
	 bjW7e6t1OuCz2kR3eNQ+y7Ot5BJauJtgv0RJ5YI5qoPzppx+u1fK8qRjqDu6jeMj5A
	 QFG5azbS5L3HOtbwSeIhK4pKQHQnzE5lkBZHulKuORwJYQoIq5SfZKm5Bln+2XuXuU
	 6/RqaFQzvm3+h3cvKzHA/LMyrUmHyKHojXIJadrMVMtIsh2cj9CMPvLTPmkKaOlqdr
	 UR4u7/+k56jQWS9JhaByuwCbm9so6QLODkJypBSTvBXInLZgRxhAk9QK/TXlLnFMCm
	 bKQ0Yd/m45mMQ==
Date: Mon, 29 Jul 2024 17:16:42 -0700
Subject: [PATCHSET 01/23] libxfs: fixes for 6.9
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Carlos Maiolino <cmaiolino@redhat.com>, Christoph Hellwig <hch@lst.de>,
 Chris Hofstaedtler <zeha@debian.org>,
 Santiago Kraus <santiago_kraus@yahoo.com>, linux-xfs@vger.kernel.org
Message-ID: <172229841874.1338302.4791739002907908995.stgit@frogsfrogsfrogs>
In-Reply-To: <20240730001021.GD6352@frogsfrogsfrogs>
References: <20240730001021.GD6352@frogsfrogsfrogs>
User-Agent: StGit/0.19
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Hi all,

A couple more last minute fixes for 6.9.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

This has been running on the djcloud for months with no problems.  Enjoy!
Comments and questions are, as always, welcome.

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=libxfs-6.9-fixes
---
Commits in this patchset:
 * [PATCH v3] Remove support for split-/usr installs
 * repair: btree blocks are never on the RT subvolume
 * xfile: fix missing error unlock in xfile_fcb_find
 * xfs_repair: don't leak the rootdir inode when orphanage already exists
 * xfs_repair: don't crash on -vv
---
 configure.ac                |   21 ---------------------
 debian/Makefile             |    4 ++--
 debian/local/initramfs.hook |    2 +-
 debian/rules                |    5 ++---
 fsck/Makefile               |    4 ++--
 include/builddefs.in        |    2 --
 include/buildmacros         |   20 ++++++++++----------
 libxfs/xfile.c              |    6 +++---
 mkfs/Makefile               |    4 ++--
 repair/Makefile             |    4 ++--
 repair/phase6.c             |    7 +++++--
 repair/progress.c           |    2 +-
 repair/scan.c               |   21 +++++----------------
 repair/xfs_repair.c         |    2 +-
 14 files changed, 36 insertions(+), 68 deletions(-)

