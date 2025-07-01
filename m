Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2B4527E05F
	for <linux-xfs@vger.kernel.org>; Tue,  1 Jul 2025 18:05:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751393108; cv=none; b=kvcqyY//Kb96r4ppSonynB6uYjy2pveytyFIdBF17u6Xy24G53ypi+eEz9JHVHcETuGHkoQXZZZUdbo0JYw79S9Z9K/hvTUoSk7Utk3NlNYNB0tcptBUeu0IjGxFmzdnjkH/phWOAHkR4j7oi1SMkmX+0aU73jrb8tBX7d4gqaA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751393108; c=relaxed/simple;
	bh=gbSRA3DnfFE2/RMUYp6FRGAdkPO7D80oGqBaAWzxnyo=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=AcmDjRsSK4M5jX1AeAVkCAS9PVyw8OtHJAInh0dnbNMS9z5+OfZ+3DYaaXqVmaL2x7KfqyZkpg+4pLB63RaUWQejt+mB/YNhujQSMmiBXZzhd8wnLRAyC5cGPux0mc6YYeT/1YIVNj5qenVnXUDCAz1KR5CEj1cYBlvEcIV2u9M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Vm21ltCR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Vm21ltCR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7BAC6C4CEEB;
	Tue,  1 Jul 2025 18:05:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1751393107;
	bh=gbSRA3DnfFE2/RMUYp6FRGAdkPO7D80oGqBaAWzxnyo=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=Vm21ltCRvTZ/8S4vGaO+2SQ5HoKbPxb9sJHbJ0sAMWlgBCb4gvMkB7kVWc00n6fbf
	 2HKDrGmQV5Y+sW1lNBvEFULDQ+tiqXwvuUAwXh37buvwNDYc3eRPS6LdyuEOZScAoX
	 HRAUcOK0wjEzq+A6j7NQx90bpdvMKOnfQWb6rAha0Jh8TJKD+PaOPP5MZdRUuqsyo9
	 GB6Dt3dOje0c9QFw6GPWQrBNPr5O+j53e653NJwKSghr+Y0qbPPZjRy4yNQA5t05JD
	 6/RnM43nB+dyBaKR4I6msxV65Ejg3vdkrdvh1M63iUUeDVFwwol3pAtd+8eHpwqiQN
	 AdUT6qfuvA5Mw==
Date: Tue, 01 Jul 2025 11:05:06 -0700
Subject: [PATCHSET 2/3] xfsprogs: atomic writes
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: linux-xfs@vger.kernel.org, catherine.hoang@oracle.com,
 john.g.garry@oracle.com, linux-xfs@vger.kernel.org
Message-ID: <175139303809.916168.13664699895415552120.stgit@frogsfrogsfrogs>
In-Reply-To: <20250701180311.GL10009@frogsfrogsfrogs>
References: <20250701180311.GL10009@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Hi all,

Utility updates for dumping atomic writes configuration and formatting
filesystems to take advantage of the new functionality.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

Comments and questions are, as always, welcome.

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=atomic-writes-6.16

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=atomic-writes-6.16
---
Commits in this patchset:
 * libfrog: move statx.h from io/ to libfrog/
 * xfs_db: create an untorn_max subcommand
 * xfs_io: dump new atomic_write_unit_max_opt statx field
 * mkfs: don't complain about overly large auto-detected log stripe units
 * mkfs: autodetect log stripe unit for external log devices
 * mkfs: try to align AG size based on atomic write capabilities
 * mkfs: allow users to configure the desired maximum atomic write size
---
 include/bitops.h         |   12 ++
 include/libxfs.h         |    1 
 libfrog/statx.h          |   23 ++++
 libxfs/libxfs_api_defs.h |    5 +
 libxfs/topology.h        |    6 +
 db/logformat.c           |  129 ++++++++++++++++++++++++
 io/stat.c                |   21 +---
 libfrog/Makefile         |    1 
 libxfs/topology.c        |   36 +++++++
 m4/package_libcdev.m4    |    2 
 man/man8/mkfs.xfs.8.in   |    7 +
 man/man8/xfs_db.8        |   10 ++
 mkfs/xfs_mkfs.c          |  248 +++++++++++++++++++++++++++++++++++++++++++++-
 13 files changed, 472 insertions(+), 29 deletions(-)
 rename io/statx.h => libfrog/statx.h (94%)

