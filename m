Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 286CA5788E
	for <linux-xfs@vger.kernel.org>; Tue, 26 Mar 2024 02:56:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711421763; cv=none; b=b1GqjJmKavhgXwJbDLwnguoFNzvtkTicRQqMXTrkuJYyJVVHIVbr9UVIC2nMTTYt4TERRLhaq/WMrcPjGtMrcpm0Z7nHg26fPHr2Z+30ivzLg2/dWCoDix75zbOwDInfloFoU0HWkABA8MwCO824psEz5paTIVGa5TJeuICZpAs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711421763; c=relaxed/simple;
	bh=9IAv3w2S/Di6CQ0aoDxJRexG3TyRmaKj4XdlHUpePYY=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=phyBKVyyzPQKfg62+amPaDLl36nzWcWpdMln9m55UYagewuyA20nUQ1Z5CUH9XLUcqXOjea8r/CixaI9vQ7c8XyQba4nNl8p16JJHqSaCQH1mCwStmbhk8hb2UR4mP38Ah0/tO4h/k8gBmL4MNHFcQIRhVOjJRfD1mEvU6ptpNY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=G6ydAk3c; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="G6ydAk3c"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9CAA4C433C7;
	Tue, 26 Mar 2024 02:56:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711421762;
	bh=9IAv3w2S/Di6CQ0aoDxJRexG3TyRmaKj4XdlHUpePYY=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=G6ydAk3ckJgMfyAbp67XetDn5N2Fvnn1Ciwt8jkumP8CV87DyvPNdiTRo1I4cyfsn
	 rHTwjMxV7ZozWJy1iT/H/71U0J1kvSWTL00p2XP1glRI/U/mRizjsqtXvytNJlfFKK
	 v6OSoK+JJk5hC8BW58f+ksa9RDRxnM7FNrKDdMbgWCKysVLGdFbapt1yglWrpPquvS
	 CgXOm4Qa2yEqOgD1M0SKr6a+CinsRXfdIsEKVPJHBNu4q9Jki4AQqBvqhY5YFHOwg7
	 Wuww5Jw8ba9erklnh1aFnOM1lrf2XaUtf0POfNgSKUasf6k9urXZ85XdYza7ti6j4G
	 qi1t7+VXpf33w==
Date: Mon, 25 Mar 2024 19:56:02 -0700
Subject: [PATCHSET V2 05/18] xfsprogs: fix log sector size detection
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: Dave Chinner <dchinner@redhat.com>, Christoph Hellwig <hch@lst.de>,
 Pankaj Raghav <p.raghav@samsung.com>, linux-xfs@vger.kernel.org
Message-ID: <171142128939.2214261.1337637583612320969.stgit@frogsfrogsfrogs>
In-Reply-To: <20240326024549.GE6390@frogsfrogsfrogs>
References: <20240326024549.GE6390@frogsfrogsfrogs>
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

From Christoph Hellwig,

this series cleans up the libxfs toplogy code and then fixes detection
of the log sector size in mkfs.xfs, so that it doesn't create smaller
than possible log sectors by default on > 512 byte sector size devices.

Note that this doesn't cleanup the types of the topology members, as
that creeps all the way into platform_findsize.  Which has a lot more
cruft that should be dealth with and is worth it's own series.

Changes since v1:
 - fix a spelling mistake
 - add a few more cleanups

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

This has been running on the djcloud for months with no problems.  Enjoy!
Comments and questions are, as always, welcome.

--D

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=mkfs-fix-log-sector-size
---
Commits in this patchset:
 * libxfs: remove the unused fs_topology_t typedef
 * libxfs: refactor the fs_topology structure
 * libxfs: remove the S_ISREG check from blkid_get_topology
 * libxfs: also query log device topology in get_topology
 * mkfs: use a sensible log sector size default
---
 libxfs/topology.c |  109 ++++++++++++++++++++++++++---------------------------
 libxfs/topology.h |   19 ++++++---
 mkfs/xfs_mkfs.c   |   71 ++++++++++++++++-------------------
 repair/sb.c       |    2 -
 4 files changed, 100 insertions(+), 101 deletions(-)

