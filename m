Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC7848F5C;
	Mon,  1 Apr 2024 16:48:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711990129; cv=none; b=NNGihxURvU5uoFoIATKQWdOG782/A8NsaHy7UHP4Ho71UCN9Sey2dDNGQfTxTN5fAvYFMKvnspk4+WSHvwvKiriPv19ny3+1AVqUhwjhA0/aCbjJqt4hFKTxRxCz83Mfj5lAZJ0FWkFc5GFZmL39X68j0zXOrscYl9omq4uXV2E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711990129; c=relaxed/simple;
	bh=8FhqAFC/glW9Xhb6joA0VP5pO7JSv+bJ0shrxcA0kSI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=exQl4TMhQFFWpUzeY9fay1w/LTm509tiMs092grMCSe8BvlG33997tfm04jZScLOlRVkFIFChprgBNwLN0FcIzC8suEF/+rhJ6d68u00PYlTDALhrCVblrPe/IxulXdscxpw2MhRRUlbzsyU+KTD7RoiUqXnIkYHftdZL4GDaU4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Kvjl/EvU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Kvjl/EvU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56025C433F1;
	Mon,  1 Apr 2024 16:48:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711990129;
	bh=8FhqAFC/glW9Xhb6joA0VP5pO7JSv+bJ0shrxcA0kSI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Kvjl/EvU256q/4jE5S286iaGj8PHG3vQtpzRiZT0M60YEiz6gKt5JonB94B3daChf
	 OvgHvamNegc7cMuo4lCXlQTiCjHwC2/z2em+W048F+dbF1BJ7mk7KoVJ6pRVjQoquZ
	 Zp4Cn2KyAoLh/nGgZKt5ftmGs4oHCh0xHM4M6+5g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	linux-xfs@vger.kernel.org,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Catherine Hoang <catherine.hoang@oracle.com>
Subject: [PATCH 6.6 256/396] xfs: dont leak recovered attri intent items
Date: Mon,  1 Apr 2024 17:45:05 +0200
Message-ID: <20240401152555.539858720@linuxfoundation.org>
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

From: "Darrick J. Wong" <djwong@kernel.org>

commit 07bcbdf020c9fd3c14bec51c50225a2a02707b94 upstream.

If recovery finds an xattr log intent item calling for the removal of an
attribute and the file doesn't even have an attr fork, we know that the
removal is trivially complete.  However, we can't just exit the recovery
function without doing something about the recovered log intent item --
it's still on the AIL, and not logging an attrd item means it stays
there forever.

This has likely not been seen in practice because few people use LARP
and the runtime code won't log the attri for a no-attrfork removexattr
operation.  But let's fix this anyway.

Also we shouldn't really be testing the attr fork presence until we've
taken the ILOCK, though this doesn't matter much in recovery, which is
single threaded.

Fixes: fdaf1bb3cafc ("xfs: ATTR_REPLACE algorithm with LARP enabled needs rework")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/xfs_attr_item.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

--- a/fs/xfs/xfs_attr_item.c
+++ b/fs/xfs/xfs_attr_item.c
@@ -329,6 +329,13 @@ xfs_xattri_finish_update(
 		goto out;
 	}
 
+	/* If an attr removal is trivially complete, we're done. */
+	if (attr->xattri_op_flags == XFS_ATTRI_OP_FLAGS_REMOVE &&
+	    !xfs_inode_hasattr(args->dp)) {
+		error = 0;
+		goto out;
+	}
+
 	error = xfs_attr_set_iter(attr);
 	if (!error && attr->xattri_dela_state != XFS_DAS_DONE)
 		error = -EAGAIN;
@@ -608,8 +615,6 @@ xfs_attri_item_recover(
 			attr->xattri_dela_state = xfs_attr_init_add_state(args);
 		break;
 	case XFS_ATTRI_OP_FLAGS_REMOVE:
-		if (!xfs_inode_hasattr(args->dp))
-			goto out;
 		attr->xattri_dela_state = xfs_attr_init_remove_state(args);
 		break;
 	default:


