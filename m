Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DBF3262815
	for <linux-xfs@vger.kernel.org>; Sat,  1 Nov 2025 09:15:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761988515; cv=none; b=qtm0czs9m//HpSKrtnswgeahxFzeNDuFUbotRobZ0Z9cLQlnoLJwX7c6di6FBtluJWEWAeRlLtBbIjAtB9iGFtY/tgE1Q0ywj5LJ1A2Y03IHDYrttu4E9TXr15e5dQTj+Z4Hmvf8t+V9JZ+bWs9s8ODCH3v7wChAL1s4+9UuARM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761988515; c=relaxed/simple;
	bh=r/6sA7fTRPjGhsVqxFWfSUp1nCJ99hiLoaZL+cRhSSU=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=kkqdqJ2WzHXL5Rt3Qrppx1dpv3cEKFug0XP5+36zbsv/gHQRPbTSLCCftK7p3V/dJC4r8Fw0fskD6L5MDDUc0nIlLUZ5iS+uctPcGwzPjsTpAK6lQiTEGPz+cJasUExLNioPI9b1eiNXuxBWmYwQMhlgbSCqWnbhvxthkxpYFus=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LZFqlS9M; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LZFqlS9M"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4566C113D0;
	Sat,  1 Nov 2025 09:15:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761988514;
	bh=r/6sA7fTRPjGhsVqxFWfSUp1nCJ99hiLoaZL+cRhSSU=;
	h=Date:From:To:Cc:Subject:From;
	b=LZFqlS9Mp1iFdgbAfa+M1ieDSkOQ9QhAE9bfx07CKckLK52NbNeTIq0e9eegWTAPS
	 eessyNxdBxLoxeGuv0woTUV5mPyzQWRNtageEcSomU9ZahZWc7YDG0scuawN0F8b4/
	 cqmJhVaFJ0cg4RNUhXjBuETyxA7EtOVGKMD2qLDdBY16RmqaH3dtRUfYSOfz12ql32
	 9hxmuDcuuvnisH2s/yz/phqiOTffkSdjC9GhFyZg7AjsLW2Rfrafmuy5AkJQk7N4eh
	 g0VLD6fY1ZLwx7Vv+9nLEPmEMwZ6oHxLxKl3yOHt+cy+skSbCVdKhSLvrpryhCdKof
	 VOE4MoglZGrWw==
Date: Sat, 1 Nov 2025 10:15:10 +0100
From: Carlos Maiolino <cem@kernel.org>
To: torvalds@linux-foundation.org
Cc: linux-xfs@vger.kernel.org
Subject: [GIT PULL] XFS: fixes for v6.18-rc4
Message-ID: <gq4gdpaijznzx3syhbpipjsdlcladlv6wain5y7fjqgct2zkpy@dnbipiq2yb46>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hello Linus,

Could you please pull patches included in the tag below?

There is just a bug fix in this series and the documentation.
Please note that I'm sending this before leaving it cooking enough time
in linux-next. The reason is that we have users hitting this issue
often, impacting workloads.

An attempt merge against your current TOT has been successful.

The following changes since commit f477af0cfa0487eddec66ffe10fd9df628ba6f52:

  xfs: fix locking in xchk_nlinks_collect_dir (2025-10-22 10:04:39 +0200)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git tags/xfs-fixes-6.18-rc4

for you to fetch changes up to 0db22d7ee462c42c1284e98d47840932792c1adb:

  xfs: document another racy GC case in xfs_zoned_map_extent (2025-10-31 12:06:03 +0100)

----------------------------------------------------------------
xfs: fixes for v6.18-rc4

Signed-off-by: Carlos Maiolino <cem@kernel.org>

----------------------------------------------------------------
Christoph Hellwig (2):
      xfs: prevent gc from picking the same zone twice
      xfs: document another racy GC case in xfs_zoned_map_extent

 fs/xfs/libxfs/xfs_rtgroup.h |  6 ++++++
 fs/xfs/xfs_zone_alloc.c     |  8 ++++++++
 fs/xfs/xfs_zone_gc.c        | 27 +++++++++++++++++++++++++++
 3 files changed, 41 insertions(+)

