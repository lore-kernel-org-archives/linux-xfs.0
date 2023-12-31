Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9573BE556
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 22:09:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DGyV4T6B"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5FDB2C433C8;
	Sun, 31 Dec 2023 22:09:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704060576;
	bh=JSBAVuj0vsnDlokIiSZOlGcjWSAoPs+cV/TlJ5FnCII=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=DGyV4T6BBsL8FrK3Q3pAKRfYcDcI2+kn+dHoML5Rkl2RsepbBW38j0UNNoLGXm7fC
	 Noreasxf+LQ5EtQgBRZJWOipXOrnlHIish1pGVVaLaZkGqIN4h+1dqtTZryMYv5fbq
	 KGArKumoytA6oWbNU4jcE9T74b6U0mfT4jemVN9oprsI2FnwC/YkzdfmOzmU5Mbkys
	 IXZTZqFshNwbGVH1HVi6AflZJ0Ir5TDwZtRdLmr5qSfp1sYvhygdLi89LZyBthCVWi
	 gkIYY3aptLaaJmc335ugMvh8e227Hx1PD0ZiFkS/miVoxSjAmt3YGFht3UxGcotV/+
	 goJt2xqFOLepg==
Date: Sun, 31 Dec 2023 14:09:35 -0800
Subject: [PATCH 5/8] xfs_repair: clean up lock resources
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: "Darrick J. Wong" <djwong@djwong.org>, linux-xfs@vger.kernel.org
Message-ID: <170404991204.1793698.8075904044230831659.stgit@frogsfrogsfrogs>
In-Reply-To: <170404991133.1793698.11944872908755383201.stgit@frogsfrogsfrogs>
References: <170404991133.1793698.11944872908755383201.stgit@frogsfrogsfrogs>
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
---
 repair/incore.c |    9 +++++++++
 1 file changed, 9 insertions(+)


diff --git a/repair/incore.c b/repair/incore.c
index 2ed37a105ca..06edaf0d605 100644
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
 

