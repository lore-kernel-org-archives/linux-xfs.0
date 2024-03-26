Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E94E1292F2
	for <linux-xfs@vger.kernel.org>; Tue, 26 Mar 2024 03:31:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711423908; cv=none; b=EMw9a3A8QptfyphIPOoJMKigDfOxfvBsuSGbfczLykXO42pNB2ng9GDBt0QDL7aYUt0koEVbo3C+Z9IusQdE8p5VOP4nmQObJ9FvSoZ9W7G29TG+y20zs6VgjTOdgzA/nGGGU/darPVYhpFCHhWKLmsagu/0GoUsAUhSopo5cGQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711423908; c=relaxed/simple;
	bh=VcAqkA+DuY2ibWKhyzWtL96VktAaUU97DJQSXOkRfIo=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=lGVIMHBXu9FiRDjISQkAZpoCJzjoveZ4DA9uN0Fu4Xk3zAw5AcUiHqzmXlO9zAEIuDsWR5h7rfS2M09WzD9cpga7rxC17fin+wFTT94rPDqIshrkN3L4+6/JXRsLHl+WoG6W8I/y88n/peVloH4B7koqKZSmySyjGk1bItWoZk4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YjgcMBkT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YjgcMBkT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51A8EC433F1;
	Tue, 26 Mar 2024 03:31:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711423908;
	bh=VcAqkA+DuY2ibWKhyzWtL96VktAaUU97DJQSXOkRfIo=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=YjgcMBkTNu0fbdGgp4UBE06z0zwnjDXq2jrZ8dJmdavBQZUV1LgXC2MwrCx7jUqB4
	 h8o/1brjW1FvQiIRQuHPPvCovjHF0INASK/p5tegbHeJ2mGgIH+J8WotNHqXvZo5MR
	 UTpvlDBWkUdLxi6R9JTCDzsm+qBkrCIQ4vd4lhQs4K2MLLkPgdVX4Jx5O6d0AV5LVP
	 qZaYDRe+K4CVI30jAWOJHN4zPXj53N6oqxTTtkvjnti5lujfzObJZopeFufcLdk/TR
	 4eIRyP/z5B3XXTCjPcAd0Abt3TX4AResqbAWKAUI23WxblZ/Z1VlqFsif+FZE8n03e
	 N0KX/8MuSjGsg==
Date: Mon, 25 Mar 2024 20:31:47 -0700
Subject: [PATCH 013/110] xfs: implement live quotacheck inode scan
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <171142131573.2215168.15888257018946505811.stgit@frogsfrogsfrogs>
In-Reply-To: <171142131228.2215168.2795743548791967397.stgit@frogsfrogsfrogs>
References: <171142131228.2215168.2795743548791967397.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Source kernel commit: 48dd9117a34fe9a34a6be0b1dba5694e0f19cbd4

Create a new trio of scrub functions to check quota counters.  While the
dquots themselves are filesystem metadata and should be checked early,
the dquot counter values are computed from other metadata and are
therefore summary counters.  We don't plug these into the scrub dispatch
just yet, because we still need to be able to watch quota updates while
doing our scan.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 libxfs/xfs_fs.h |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)


diff --git a/libxfs/xfs_fs.h b/libxfs/xfs_fs.h
index 711e0fc7efab..07acbed9235c 100644
--- a/libxfs/xfs_fs.h
+++ b/libxfs/xfs_fs.h
@@ -710,9 +710,10 @@ struct xfs_scrub_metadata {
 #define XFS_SCRUB_TYPE_GQUOTA	22	/* group quotas */
 #define XFS_SCRUB_TYPE_PQUOTA	23	/* project quotas */
 #define XFS_SCRUB_TYPE_FSCOUNTERS 24	/* fs summary counters */
+#define XFS_SCRUB_TYPE_QUOTACHECK 25	/* quota counters */
 
 /* Number of scrub subcommands. */
-#define XFS_SCRUB_TYPE_NR	25
+#define XFS_SCRUB_TYPE_NR	26
 
 /* i: Repair this metadata. */
 #define XFS_SCRUB_IFLAG_REPAIR		(1u << 0)

