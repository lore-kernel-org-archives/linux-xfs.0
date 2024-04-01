Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B529E1C0DE7;
	Mon,  1 Apr 2024 16:49:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711990180; cv=none; b=mfvwactLU8w7AHIWdQ0YEnp3xZT5OIC2riqd6oz740IKNUpeZYRLtEpvE3ZICqzBwWggDHptyspqULbJXEpZMrISW+5AyIxiVkjT4kzlMAB/tkaRV1LBgM5IsYeD4n3FtNx5Uvi3g7FFyegYNd+tMjOLLNxznUiTWo1PzdnrUGk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711990180; c=relaxed/simple;
	bh=JnbtSbRfTw+puw4aFKCZx+WGdj4K2GzwRu+hnWg8BPk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BA71vcEs1nMZUF10jrlZGWwrbix8Mbhew0VV0g1kS7tShZUbDF6orJtvJKvs/cyeWE+iM3ZFpHZKfw+fu2dA2hT15j1/tGE+4zIFwoWfyy1R0CiDsFxGLNrWG/1SErOGmfKHBWwvlazr2JMerctsLyuUq/ibo7cXe8Ybo62BnE0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2lBcjAYl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2lBcjAYl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24116C433C7;
	Mon,  1 Apr 2024 16:49:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711990180;
	bh=JnbtSbRfTw+puw4aFKCZx+WGdj4K2GzwRu+hnWg8BPk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2lBcjAYlEPNt/pcD26ckfM03DeEoMN8bLyeuOysv0hHVNjSwq5Rg2vd/X3EkW0+/e
	 7iobFeihYTFCnBTx9UY++vxMTNYFbPwBvWMCc8Fco/Y+O38KEInYO2exNUMCRs5ylW
	 SLBeErxdtaaJfnlhHCNl5UR0UPIXOux09LrXRJ/U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	linux-xfs@vger.kernel.org,
	Eric Sandeen <sandeen@redhat.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Chandan Babu R <chandanbabu@kernel.org>,
	Catherine Hoang <catherine.hoang@oracle.com>
Subject: [PATCH 6.6 270/396] xfs: short circuit xfs_growfs_data_private() if delta is zero
Date: Mon,  1 Apr 2024 17:45:19 +0200
Message-ID: <20240401152555.962560699@linuxfoundation.org>
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

From: Eric Sandeen <sandeen@redhat.com>

commit 84712492e6dab803bf595fb8494d11098b74a652 upstream.

Although xfs_growfs_data() doesn't call xfs_growfs_data_private()
if in->newblocks == mp->m_sb.sb_dblocks, xfs_growfs_data_private()
further massages the new block count so that we don't i.e. try
to create a too-small new AG.

This may lead to a delta of "0" in xfs_growfs_data_private(), so
we end up in the shrink case and emit the EXPERIMENTAL warning
even if we're not changing anything at all.

Fix this by returning straightaway if the block delta is zero.

(nb: in older kernels, the result of entering the shrink case
with delta == 0 may actually let an -ENOSPC escape to userspace,
which is confusing for users.)

Fixes: fb2fc1720185 ("xfs: support shrinking unused space in the last AG")
Signed-off-by: Eric Sandeen <sandeen@redhat.com>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandanbabu@kernel.org>
Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/xfs_fsops.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/fs/xfs/xfs_fsops.c
+++ b/fs/xfs/xfs_fsops.c
@@ -134,6 +134,10 @@ xfs_growfs_data_private(
 	if (delta < 0 && nagcount < 2)
 		return -EINVAL;
 
+	/* No work to do */
+	if (delta == 0)
+		return 0;
+
 	oagcount = mp->m_sb.sb_agcount;
 	/* allocate the new per-ag structures */
 	if (nagcount > oagcount) {


