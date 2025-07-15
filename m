Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 465871B85FD
	for <linux-xfs@vger.kernel.org>; Tue, 15 Jul 2025 05:16:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752556567; cv=none; b=opDn4uW13ONRt7qlzJtPMyA7ksWZx2Vc9xQpIv26KGH9OJBXDQggoPs01k7yRqwq6gGnF8e98b6Zr9SpL8wonWC/kkc6jWYOnNwYzC+l2RpInsXh/W+GJ1FrgZza8Kj+Y6LE9KsB8xKJc4kUl1JQxPOv1o/oX9UlgmpkAooAKCA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752556567; c=relaxed/simple;
	bh=CCOFiQcIQ3leLbcW6v21DXqK3J2CX4uWUnqBHeIXSlQ=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=jWUQChK7hI71lbqMkljFo+Kxodx3UfqWxY6BNZtEAxUMlNCLReX18ye3482AXLtdoYgfB9bXDW9xCSA0AiDBjvRJ74FcMqBhTM2J02UgbPEbbWGCE4QyYB3xRjMFbBOtZIJny2Cd72kZhfufXMvJihTef4Us0v7W7+MIWkrxclE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=oaHTLX/o; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oaHTLX/o"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C57CBC4CEE3;
	Tue, 15 Jul 2025 05:16:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1752556566;
	bh=CCOFiQcIQ3leLbcW6v21DXqK3J2CX4uWUnqBHeIXSlQ=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=oaHTLX/oq0TEnBOiLeRcXzy+uVZZtFyyiXXBMiLkXKtZ0chNwV6CYH79Orwo03plN
	 uYvycohw4mWkKXTfzUFOEcVLyAIHBwoMOG8tQcKk83W++GIzDvowbmdjRSRtgovvDZ
	 Ii/x/8eCi66a1jXHoTaTE/vDe3L+NvNlHdvpgoy/TYv7a1KQIYX5MfSBVyGWgJGS3D
	 gL/ZUbOSE9rNZLLjRYa2wrFw87UQcnTlvaIwrtG+HKDRlTxvpD00ubkhPNtzaCBaBe
	 Be4ZCA/PkJPAqlXG1QpyYDQIlCXm4wswuJH+w8pk4bAVz1UFDfsGOMd7oHQsx699zp
	 kl82kCq5Y/m3w==
Date: Mon, 14 Jul 2025 22:16:06 -0700
Subject: [PATCHSET 2/3] xfsprogs: atomic writes
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: john.g.garry@oracle.com, linux-xfs@vger.kernel.org,
 catherine.hoang@oracle.com, john.g.garry@oracle.com,
 linux-xfs@vger.kernel.org
Message-ID: <175255652424.1831001.9800800142745344742.stgit@frogsfrogsfrogs>
In-Reply-To: <20250715051328.GL2672049@frogsfrogsfrogs>
References: <20250715051328.GL2672049@frogsfrogsfrogs>
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
 mkfs/xfs_mkfs.c          |  251 +++++++++++++++++++++++++++++++++++++++++++++-
 13 files changed, 474 insertions(+), 30 deletions(-)
 rename io/statx.h => libfrog/statx.h (94%)

