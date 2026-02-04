Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1737B2C3745
	for <linux-xfs@vger.kernel.org>; Wed,  4 Feb 2026 11:52:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770205959; cv=none; b=Xktvcmo9CUQr/oeiFTSqBQtf/m6r7yne27L3oFbmq17l0oGRAw0TB8NX6wywfIMZAjqfC9OSJmOxghpQ8+O2fYxgeLjV+dD8r74Ut+j5MTeCM+jbb2YsPUnE6P0aaShm3D9/FKBJgU9xOjQrg+J8FVcU9nfsNWtKKqfjkA9Ztps=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770205959; c=relaxed/simple;
	bh=yn0EPxbz8MU9IeoF4PR0ujbf5bhIWt3HQnNSw7Ta1vE=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=MUH71iAS8X/pBYwvPl0EnnEY++nb5fm6o5kMxIIq6SYwjnb+f0bc4YBNE60RkD3TlXpYd0IWQKg+3yZ+itac1l2jGvKKOcpVWJBS1N/t+gjrTH5A+nd4MMWJuhtiM2JRG38nQ3QrOxQ0lWh9Mlh0Hh6uBTD0mnAZtaa2U5epTuM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PkJr3x64; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PkJr3x64"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B3F1C4CEF7;
	Wed,  4 Feb 2026 11:52:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770205959;
	bh=yn0EPxbz8MU9IeoF4PR0ujbf5bhIWt3HQnNSw7Ta1vE=;
	h=Date:From:To:Cc:Subject:From;
	b=PkJr3x64p+hatQmp20oKi7HEAbHH1Mg3j+lrQD1spqRUd2EgqvhZRdm8PETGGPi1o
	 RVq/Hrk4WeG/J5NDJBe225OK4f/dwre6ACTirsR3ChkjSnOjtJDJqpqnliECDo1JEI
	 VyEIWob7W94hp9MYCnfruDbp6RJlL7tMSh8qTeJWL7hUH926SSPDK6a7hGXCzMScq9
	 S6oI1n4mGqppDg2q1YlClKVVG/V99llTrHKmOkeZx63ezR9voGNJZzRChZmp6x2AJ5
	 5xP8nJuiRth8OSUOkNcBMcVLmdTj/AlPFxCOCqNNnSLJ3H9wq7GYAeALNba9u026Kv
	 qOFVYip0bKKIw==
Date: Wed, 4 Feb 2026 12:52:35 +0100
From: Andrey Albershteyn <aalbersh@kernel.org>
To: linux-xfs@vger.kernel.org
Cc: axboe@kernel.dk, djwong@kernel.org, dlemoal@kernel.org, hch@lst.de, 
	linux-xfs@vger.kernel.org, martin.petersen@oracle.com
Subject: [ANNOUNCE] xfsprogs: for-next updated to 783268546e98
Message-ID: <hyshlc7so2py75vufouvw7vnqywgkk5akg3dnlp65wkzpxkwq3@jix7drme64yo>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi folks,

The xfsprogs for-next branch in repository at:

	git://git.kernel.org/pub/scm/fs/xfs/xfsprogs-dev.git

has just been updated.

Patches often get missed, so if your outstanding patches are properly reviewed
on the list and not included in this update, please let me know.

The for-next branch has also been updated to match the state of master.

The new head of the for-next branch is commit:

783268546e983c78454ce635a902ec54cd6f75b1

New commits:

Christoph Hellwig (2):
      [c7a07fadf4ff] include blkzoned.h in platform_defs.h
      [b7c900385985] libfrog: enable cached report zones

Damien Le Moal (3):
      [b3d17aa18f73] xfs: use blkdev_report_zones_cached()
      [453b0e8be7ef] mkfs: remove unnecessary return value affectation
      [e2a429986eb9] libfrog: lift common zone reporting code from mkfs and repair

Darrick J. Wong (6):
      [81bedc02de7d] mkfs: set rtstart from user-specified dblocks
      [9547c3f44e64] xfs_logprint: print log data to the screen in host-endian order
      [026ebbb7ef9d] mkfs: quiet down warning about insufficient write zones
      [49157d0df63a] xfs_mdrestore: fix restoration on filesystems with 4k sectors
      [609a3154ba08] debian: don't explicitly reload systemd from postinst
      [783268546e98] xfs_scrub_all: fix non-service-mode arguments to xfs_scrub

Code Diffstat:

 debian/postinst           |  3 --
 include/platform_defs.h   | 15 ++++++++
 libfrog/Makefile          |  6 ++-
 libfrog/zones.c           | 59 ++++++++++++++++++++++++++++++
 libfrog/zones.h           | 16 ++++++++
 libxfs/xfs_zones.c        |  2 +-
 logprint/log_print_all.c  |  5 ++-
 logprint/logprint.c       |  5 +++
 logprint/logprint.h       |  1 +
 man/man8/xfs_logprint.8   |  4 ++
 mdrestore/xfs_mdrestore.c | 17 ++++++---
 mkfs/xfs_mkfs.c           | 93 ++++++++++++++++++++++++-----------------------
 repair/zoned.c            | 36 ++++++------------
 scrub/Makefile            |  2 +-
 scrub/xfs_scrub_all.py.in |  3 +-
 15 files changed, 181 insertions(+), 86 deletions(-)
 create mode 100644 libfrog/zones.c
 create mode 100644 libfrog/zones.h

-- 
- Andrey
