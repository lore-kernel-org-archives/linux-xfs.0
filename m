Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9DAE556B97
	for <linux-xfs@vger.kernel.org>; Tue,  8 Sep 2026 14:54:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788879279; cv=none; b=KcEueTa+FwJj15U//FK+8NSqWgP2AzPbonXsuZzTw0urS91hkkNK9By80DtodyPxNSWP/cPibO342Qkl2vovOYcl0hB33JcLKAURh96Cj6JvPas1cyqtvBPpAvQHwzeoLBjrDbSg942yJeMDjwwb9JDYwegCY5nBumbA5EFrbTQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788879279; c=relaxed/simple;
	bh=mbvCJpQ2srnd2mA8AYrrDuthAWyY52Dvkb00q/PlYEg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=qdxI4ySK0Naho45WM+W0zMsVILL2pSXr7kVra2cvKUTa3f6x6yk08Yc47nRsbz2v3NbMn8V4GCh0JkUJDt2Y/YEKV8Iy12g61bcY+TnjxZjy717A4eZSPHEmfU3yWiIaN47Y+whFmlWu1ba321GejUlqYfay8mqfrwiVej88aik=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HXrdBqvc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HXrdBqvc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E7391F00A3D;
	Tue,  8 Sep 2026 14:54:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788879267;
	bh=UWarCYPKaWdenjuEeqwlwytWH3LBzBFTRcnFt4aqhio=;
	h=From:To:Cc:Subject:Date;
	b=HXrdBqvcYg5MUG5fWYYQnAmrTYwaklnaDgiiQfwweHsDn/XD7t/EZllli7ZIy0xQb
	 UJBFszy7kaLWU4IslKvSEHM1O7BgaynkicpPIGr7w5LBda/T39+rQxVr67PEnyhUgS
	 TR47hqFlakvZSGR19qFy5MQYsjvKZUAaaOTDhheWy+wrQTZ5O9MybkNzOfz06npxKZ
	 yM49Qzlb/swQ5W8z2ihqSP4mjvTl6LR3OhRiNgLCzAORsa3A0FPnVjZmWEXhDQ7SgV
	 DqOC2I3O/hpcqBPkK1jd413VjyzIBDZKBBRLddo0Mlhs5BfyZwjpUeTnNWWAzS2a2Z
	 PP0VpBOh/PA4Q==
From: cem@kernel.org
To: cem@kernel.org
Cc: hch@lst.de,
	djwong@kernel.org,
	linux-xfs@vger.kernel.org
Subject: [PATCH 0/3] Enable xfs error reporting to print out error codes
Date: Tue,  8 Sep 2026 16:54:13 +0200
Message-ID: <20260908145422.232985-1-cem@kernel.org>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Carlos Maiolino <cem@kernel.org>

Hello.

This is the first 'formal' version of this series after a round of
RFC...

The goal remains the same, enabling us to easily find what error
caused a transaction to be cancelled. But the infra-structure is usable
for remaining error cases.

The main updates regarding the RFC version is xfs_error_report now
uses errname() to print out the error.

Also gets rid of the unneeded extern modifier from it.

Instead of a variadic function uses a couple different macros to select
between with/without error. I named it xfs_trans_cancel_error() because
it sounded clear to me than the _with() suffix. I'd not join an argument
to defent one or another though if you guys are unhappy with _error,
I'll change back to _with().

Last patch is simple enough and I kept Darrick's review on it as there
is not much change in there other than setting up the right macro.

Cheers.

Carlos Maiolino (3):
  xfs: add xfs_error_report the ability to display an error code
  xfs: enable xfs_trans_cancel() to report and error code
  xfs: make xfs_iomap_write_direct() report an error to xfs_trans_cancel

 fs/xfs/xfs_error.c         | 13 ++++++++++---
 fs/xfs/xfs_error.h         | 10 +++++-----
 fs/xfs/xfs_exchmaps_item.c |  9 ++++++---
 fs/xfs/xfs_inode_item.c    |  3 ++-
 fs/xfs/xfs_iomap.c         |  2 +-
 fs/xfs/xfs_log_recover.c   |  3 ++-
 fs/xfs/xfs_trans.c         |  8 +++++---
 fs/xfs/xfs_trans.h         |  6 +++++-
 8 files changed, 36 insertions(+), 18 deletions(-)

-- 
2.55.0

