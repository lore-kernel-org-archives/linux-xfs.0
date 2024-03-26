Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 543A4128816
	for <linux-xfs@vger.kernel.org>; Tue, 26 Mar 2024 03:26:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711423611; cv=none; b=HKWgU+gKbGJYYqUMGrgSgAhM6qw/EIvCW4y09Q/KyJFEmg4yjSZDv2hnpUCrMe6JiLSHqymVrQHsmejQ0MSuaKD4Vwyq4g0pz6ne4DrFf8oQVBgY4+fS53P0pF+fJV6fqZVQ/TrXpCKSeByrRVbAZ07dgaZ68FHNegTprd5rI6U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711423611; c=relaxed/simple;
	bh=Tb8tIRCjTINr0XN5jaJ63q/tjSxsU5JEI0Frvp0+wb4=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Rlo2xQY3Is2SgZJZLxNskcH5Gcyq/33xjErXewDmJkR4HncRIxCl3U0c2PjmgkyAe0ZAZ/LAWBTkdG2/rqvi8xbtyw67ghxEMP5Z5vzaJoSIqkon6GsRFOwhj9sOX1POEcYCDswCIJZHBL+5scl4W6EAlQ0Ax/Z57DpK0f8MooE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Sx7Xh/tr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Sx7Xh/tr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30BA7C433F1;
	Tue, 26 Mar 2024 03:26:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711423611;
	bh=Tb8tIRCjTINr0XN5jaJ63q/tjSxsU5JEI0Frvp0+wb4=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=Sx7Xh/triMFLqJmtOmvGfWkcw3ezpqw8PURYYOcTeKWWkX2FW1zVqRHtn62bl7dAU
	 f4g1m0gsviLyyhpkHHveu0kzF/zu5sFPpucptj8DViBW9TYMG8vmrPAqIL26YGn+QG
	 V2qBCpPbRL4zX4rrKzbVgnnJ0THj1z1z1/As08/7x6I2t8jQooujMAgfsEfh2STzN7
	 Dvh7xR0VqMNGnrmibsfumVPVonSZLKHxFrML/2YhAj+lfIuLYwoA58Emlx+iPZweja
	 yIzqQk/W3M/7P8hlmXnAuqZpZ9v7X6CKGti+8nku2vsPJ7o68XBgnmNCIcBjw6EDtx
	 LLghXX71lrilg==
Date: Mon, 25 Mar 2024 20:26:50 -0700
Subject: [PATCH 5/8] xfs_repair: clean up lock resources
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: "Darrick J. Wong" <djwong@djwong.org>, Christoph Hellwig <hch@lst.de>,
 linux-xfs@vger.kernel.org
Message-ID: <171142130427.2214793.2036648192387219923.stgit@frogsfrogsfrogs>
In-Reply-To: <171142130345.2214793.404306215329902244.stgit@frogsfrogsfrogs>
References: <171142130345.2214793.404306215329902244.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@djwong.org>

When we free all the incore block mapping data, be sure to free the
locks too.

Signed-off-by: Darrick J. Wong <djwong@djwong.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 repair/incore.c |    9 +++++++++
 1 file changed, 9 insertions(+)


diff --git a/repair/incore.c b/repair/incore.c
index 2ed37a105ca7..06edaf0d6052 100644
--- a/repair/incore.c
+++ b/repair/incore.c
@@ -301,8 +301,17 @@ free_bmaps(xfs_mount_t *mp)
 {
 	xfs_agnumber_t i;
 
+	pthread_mutex_destroy(&rt_lock.lock);
+
+	for (i = 0; i < mp->m_sb.sb_agcount; i++)
+		pthread_mutex_destroy(&ag_locks[i].lock);
+
+	free(ag_locks);
+	ag_locks = NULL;
+
 	for (i = 0; i < mp->m_sb.sb_agcount; i++)
 		btree_destroy(ag_bmap[i]);
+
 	free(ag_bmap);
 	ag_bmap = NULL;
 

