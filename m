Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A890017E006
	for <linux-xfs@vger.kernel.org>; Thu, 22 Aug 2024 23:57:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724371048; cv=none; b=Sb9s2rXVr86PIMi65uhDQ4DSChPFUXMIkpPgxj+CM3j8e6F2FHWDWv6DtdrtWpXlYyWE6aowRQuiT053fzUU7B3KYiPYuP5ycsrOevOAQqzrAnoc8w1jZxMXglkosqTu2RJQjOt15Yx5hPzAFAMkowLvaAE3XiCRs88aPO3Wo8o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724371048; c=relaxed/simple;
	bh=nROqhroadig1JPxzJpWBPvjxD8hhHKckim22KcaYtC4=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=pS1BLH27Y0tvco9n/LmuT0qqPhPsfq8kTmk/QNHViTIjTrgUqfpPzre8T/wF6EZYJP/aZSlte2mvYt1Cf9m4xnJ6z1gLXvMLvyNuV4TuKv0pCZWHKyJdqPSLLjhUwI+s5GtbS4UkWWldsA1qonyC63ag8E9rLtFXIp0IePyAbkA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=K/M/Dpt4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="K/M/Dpt4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7BC0CC32782;
	Thu, 22 Aug 2024 23:57:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1724371048;
	bh=nROqhroadig1JPxzJpWBPvjxD8hhHKckim22KcaYtC4=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=K/M/Dpt4fJZ7dnQCKhM/5sQ2FL5UTykFh20Gg60Ixojp/yHoaSf+emikq/t4qvaTM
	 F7xDtTmIYT1Uui32ODtGI5AkyjMQYvVi/ogvQ3e4My87deqRDEFresa5vV/Y5Qajgu
	 9l/IL4VMiBRceZleOWJ+DSwCmlB1o2GKgLCjPf+xxdOPwxDZX/9JYVeX8ExHkrEAry
	 lT0g7hamrIRgClh2aOGFDiUmHA1ist2Ea9F3H7GyHFTRDIBR9g0pirAvTUhPRqwCxy
	 FM6EN1EQ4XoqVn3jbnRKTwDG8L081ImEiw6QCOlapzKEAnBur1dZQtq/THaycYhFJ/
	 NTqKOufWHMz9g==
Date: Thu, 22 Aug 2024 16:57:28 -0700
Subject: [PATCHSET v4.0 05/10] xfs: clean up the rtbitmap code
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <172437085987.58604.7735951538617329546.stgit@frogsfrogsfrogs>
In-Reply-To: <20240822235230.GJ6043@frogsfrogsfrogs>
References: <20240822235230.GJ6043@frogsfrogsfrogs>
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

Here are some cleanups and reorganization of the realtime bitmap code to share
more of that code between userspace and the kernel.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

This has been running on the djcloud for months with no problems.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=rtbitmap-cleanups

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=rtbitmap-cleanups
---
Commits in this patchset:
 * xfs: remove xfs_validate_rtextents
 * xfs: factor out a xfs_validate_rt_geometry helper
 * xfs: make the RT rsum_cache mandatory
 * xfs: remove the limit argument to xfs_rtfind_back
 * xfs: assert a valid limit in xfs_rtfind_forw
 * xfs: add bounds checking to xfs_rt{bitmap,summary}_read_buf
 * xfs: cleanup the calling convention for xfs_rtpick_extent
 * xfs: push the calls to xfs_rtallocate_range out to xfs_bmap_rtalloc
 * xfs: factor out a xfs_growfs_rt_bmblock helper
 * xfs: factor out a xfs_last_rt_bmblock helper
 * xfs: factor out rtbitmap/summary initialization helpers
 * xfs: push transaction join out of xfs_rtbitmap_lock and xfs_rtgroup_lock
---
 fs/xfs/libxfs/xfs_bmap.c     |    3 
 fs/xfs/libxfs/xfs_rtbitmap.c |  192 ++++++++++++++-
 fs/xfs/libxfs/xfs_rtbitmap.h |   33 +--
 fs/xfs/libxfs/xfs_sb.c       |   64 +++--
 fs/xfs/libxfs/xfs_sb.h       |    1 
 fs/xfs/libxfs/xfs_types.h    |   12 -
 fs/xfs/xfs_rtalloc.c         |  535 +++++++++++++++++-------------------------
 7 files changed, 438 insertions(+), 402 deletions(-)

