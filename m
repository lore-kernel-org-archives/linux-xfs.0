Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A05F53380;
	Mon,  1 Apr 2024 16:51:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711990285; cv=none; b=Iib+VxHuxjLdLwQVVdIPyoS1uxcHt81mC7n1f8GjuoJQWGmQLwJZRJo6dYXNdDwfyKWuepH8Q57XyF7CnfS1x2X9z+776BaI3ZOv5F22JiQl+HwHsdh3UaJQ4swvwWtSn+zF2Zz1YswnHmO/97vdqhjcZ7upf3YARnnrCz/SHA8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711990285; c=relaxed/simple;
	bh=lcfftUazBUUCk6PY5DrLFKR82Jwb9gCa408haQcHPXg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XmNfnvG84XpD+zJX+6a3OyuxPWdefh9YYwAtUxm6g5854t2qCK/LpqquKMKKsnOHiLBfxim61+RB3T3JqbuDtFdxOVON8Pr5xFUheFz+4hOJq1obwETs2bMneRR+ozsrlgXlXe8/qbwQm8i0U9aw5ZHslIPD6ZLg0oQg+w8799Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=magYYiaH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="magYYiaH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57494C433F1;
	Mon,  1 Apr 2024 16:51:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711990284;
	bh=lcfftUazBUUCk6PY5DrLFKR82Jwb9gCa408haQcHPXg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=magYYiaHI7RJ6DkK7X3asrXPOWczQFwG6YXrhR/ywss5GVphGTJEFGoeJkluE+kp1
	 a0VRqMtwPoy3VgAy9RIUBeQ/ZtPtE9LF1k+rOx95AXQtg6gxoEZkPMb6osbjNYID5W
	 RShDkfkOeTSSmSKoDWn+NBHrqr4pzTgFYXFh4BVE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	linux-xfs@vger.kernel.org,
	Andrey Albershteyn <aalbersh@redhat.com>,
	Christoph Hellwig <hch@lst.de>,
	Chandan Babu R <chandanbabu@kernel.org>,
	Catherine Hoang <catherine.hoang@oracle.com>,
	"Darrick J. Wong" <djwong@kernel.org>
Subject: [PATCH 6.6 275/396] xfs: reset XFS_ATTR_INCOMPLETE filter on node removal
Date: Mon,  1 Apr 2024 17:45:24 +0200
Message-ID: <20240401152556.109124828@linuxfoundation.org>
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

From: Andrey Albershteyn <aalbersh@redhat.com>

commit 82ef1a5356572219f41f9123ca047259a77bd67b upstream.

In XFS_DAS_NODE_REMOVE_ATTR case, xfs_attr_mode_remove_attr() sets
filter to XFS_ATTR_INCOMPLETE. The filter is then reset in
xfs_attr_complete_op() if XFS_DA_OP_REPLACE operation is performed.

The filter is not reset though if XFS just removes the attribute
(args->value == NULL) with xfs_attr_defer_remove(). attr code goes
to XFS_DAS_DONE state.

Fix this by always resetting XFS_ATTR_INCOMPLETE filter. The replace
operation already resets this filter in anyway and others are
completed at this step hence don't need it.

Fixes: fdaf1bb3cafc ("xfs: ATTR_REPLACE algorithm with LARP enabled needs rework")
Signed-off-by: Andrey Albershteyn <aalbersh@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Chandan Babu R <chandanbabu@kernel.org>
Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/libxfs/xfs_attr.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -421,10 +421,10 @@ xfs_attr_complete_op(
 	bool			do_replace = args->op_flags & XFS_DA_OP_REPLACE;
 
 	args->op_flags &= ~XFS_DA_OP_REPLACE;
-	if (do_replace) {
-		args->attr_filter &= ~XFS_ATTR_INCOMPLETE;
+	args->attr_filter &= ~XFS_ATTR_INCOMPLETE;
+	if (do_replace)
 		return replace_state;
-	}
+
 	return XFS_DAS_DONE;
 }
 


