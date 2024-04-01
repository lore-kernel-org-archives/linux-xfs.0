Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9387D41232;
	Mon,  1 Apr 2024 16:51:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711990303; cv=none; b=ZYISnV2I6M5IKaf/n3fA96lwS0BhPK8qWTc+fvu/Ywu63bYn5fMYXUmtkD2zVlht8wUBRzWfG3xhKm8pAfuiwbRrwzaAcgnZZcN1myX3Dm9KK0KxxWfDDgaMEUUe2fS9yZ3FZa+zIIZTUUmBKQVscb4dv0FoZk4MQ4mS748O4Z8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711990303; c=relaxed/simple;
	bh=e603Jd+vGH25Sg0SJewTyCinvPDkr+H6C74rbQkHoRc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WWlCO3ewOMQyApMJMyWM/sRymc9urk/4Zcp49m5NfCiaPTpcZlIN5Q1aP/ekuRzzcPTiZ4OrAC9r0QOPGFHC4JaUDI6q2Yi91MvQTy5nBconxaOe4SxTAljpEvqdng5Y7suCnyjOK17IlUOI9as9VKR0sjREN1EsBhkHh/WrR6s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qoz/b9tf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qoz/b9tf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A308C433F1;
	Mon,  1 Apr 2024 16:51:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711990303;
	bh=e603Jd+vGH25Sg0SJewTyCinvPDkr+H6C74rbQkHoRc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qoz/b9tf4JUZvpVsgnCqhMnXxzZqZ7F5Ijgmb1IryMfe/2xhpYO7T0dfmHKniPFTK
	 roSjlxNitlSW0BMAmVelWk8TxrPwArOXZeHKf1+mkAl6p9dgrE/TYB3grC5E/XVUmn
	 FaPT6NpokMW3QljTg9Aisihv/lJ7dsHg/Q7OrG0w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	linux-xfs@vger.kernel.org,
	Long Li <leo.lilong@huawei.com>,
	Christoph Hellwig <hch@lst.de>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Chandan Babu R <chandanbabu@kernel.org>,
	Catherine Hoang <catherine.hoang@oracle.com>
Subject: [PATCH 6.6 271/396] xfs: add lock protection when remove perag from radix tree
Date: Mon,  1 Apr 2024 17:45:20 +0200
Message-ID: <20240401152555.992420168@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152547.867452742@linuxfoundation.org>
References: <20240401152547.867452742@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Long Li <leo.lilong@huawei.com>

commit 07afd3173d0c6d24a47441839a835955ec6cf0d4 upstream.

Take mp->m_perag_lock for deletions from the perag radix tree in
xfs_initialize_perag to prevent racing with tagging operations.
Lookups are fine - they are RCU protected so already deal with the
tree changing shape underneath the lookup - but tagging operations
require the tree to be stable while the tags are propagated back up
to the root.

Right now there's nothing stopping radix tree tagging from operating
while a growfs operation is progress and adding/removing new entries
into the radix tree.

Hence we can have traversals that require a stable tree occurring at
the same time we are removing unused entries from the radix tree which
causes the shape of the tree to change.

Likely this hasn't caused a problem in the past because we are only
doing append addition and removal so the active AG part of the tree
is not changing shape, but that doesn't mean it is safe. Just making
the radix tree modifications serialise against each other is obviously
correct.

Signed-off-by: Long Li <leo.lilong@huawei.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandanbabu@kernel.org>
Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/libxfs/xfs_ag.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/fs/xfs/libxfs/xfs_ag.c
+++ b/fs/xfs/libxfs/xfs_ag.c
@@ -424,13 +424,17 @@ xfs_initialize_perag(
 
 out_remove_pag:
 	xfs_defer_drain_free(&pag->pag_intents_drain);
+	spin_lock(&mp->m_perag_lock);
 	radix_tree_delete(&mp->m_perag_tree, index);
+	spin_unlock(&mp->m_perag_lock);
 out_free_pag:
 	kmem_free(pag);
 out_unwind_new_pags:
 	/* unwind any prior newly initialized pags */
 	for (index = first_initialised; index < agcount; index++) {
+		spin_lock(&mp->m_perag_lock);
 		pag = radix_tree_delete(&mp->m_perag_tree, index);
+		spin_unlock(&mp->m_perag_lock);
 		if (!pag)
 			break;
 		xfs_buf_hash_destroy(pag);


