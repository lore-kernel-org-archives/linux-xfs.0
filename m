Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793240582;
	b=Iv1kJGGUwQVtucSsPbfBcrY1Lef/IwSjZhAhYepGuVCzg10Ts5o1xwbD+K84HOVOow68
	 wP/do6pJZbNtsALZp9cJZHkC+8FA9/JIZ72Xmtd5paLnKbDraz6qVisL23x65tYzx6Fix
	 23UZVlGYvEs1JL+HOhwYDWpbQFdLdk6gsn0gOz3wYOLXlF4RUPH4jsfxMBI98fp57gs/d
	 7EdKaGeYvVOZnhloVgfahQFCJJF/TV/4xoOAhhb+t4mxewpwoxsxy78k6iRiY0WjY8dDY
	 L6yLiVHvut+VxFwcSg7J9Gi12LVtjk/xBcgYKbUcviECNxC5/CTlXctSMGkcG4CcLmg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793240582;
	h=Received:DKIM-Signature:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=4kiMZVmwM7DlhwUBz/uAfVwGiRsFDL/YimsXyBGFmas=;
	b=x3pRwZq6y4mwg9sICuKjlcM6GceMWUHVXTPuz2a3KBOEC3tkPKSU36RU5lTkvZmF7Lq7
	 deNjFPbOj9LCbgo5gEb4votHyyqiFpn+pZ3WlFcFhddj/KzHuikrOiJnsRNST0PNRu4bg
	 xjVLzwlIMfvHceSuNgDkwhxFmZdb/x/78yvbQn5rJgm3xJWom+DODOc7adWs9ZtiKYXhb
	 n7pNbrvM5xmeQDB0waOufO8w7j98jKCe11hUK4dHoP+JsUGc4P7WlmtwVYbqs70rRpRX/
	 BJ5bXN68dEbTbfaS9Z1I6RbfAtCyCe4SuwPRoPVKo6KCQVE2BfJu1+NlQXPDGaiooqQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=NCVBxSYZ;
	arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34E2060A2609;
	Thu, 29 Oct 2026 02:23:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=NCVBxSYZ
Authentication-Results: smtp.kernel.org; arc=none smtp.remote-ip=100.80.115.77
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1793240582;
	b=hH551XktS/zQFlFBTrmvGBJa7Jq/Ojk1mI4IINTwgxm/QXHMj89vAMjmIPUdLUhKRtDs
	 C8APlZfpuRpt01HU89CAMCrhx+rqB9C3ruXoNp5zfQJr1X7W07U8OqfetOfMemRelbO1Z
	 T+q7eYYflKfawsL6qhHEAlQbxtkeg92A6RchvP+Ebxlrz4Hcx77eUVoAx4xAXDUnR/m7x
	 prVXZDozMVGXorU3OGSM2QMibEx7m7mp0v3bA8AzljK1bPp835dOLmy7zVLswoMgyfuIF
	 yCwozl/1dseMveNU8mlKAbjE6piQQV1AFQgJw1rWiGEyZI4yo8yTQRZFhRXL2rJ4EwQ==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1793240582;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=4kiMZVmwM7DlhwUBz/uAfVwGiRsFDL/YimsXyBGFmas=;
	b=xGi+T0YIgvQdfMsJbVzFzlqRAAYPnbokI/d296iUEtBzxzpYl7HrSimPN5gT6s4djvj2
	 KdYMjHoJaDht4xTGbo84BYjk5fpPwq4Pv0eNXEFPlUY1LQCQdPh1jWIpjzDQTcodvuzen
	 i5PgvUe4yhPyGfFXMYP+8a0Iuc9wFwYm+vJet17sdckjZpqGAaSFD3BeYSdF8JCYOkFpJ
	 N9eOJiXozu/y48ga1j6wOalVb9lJkVDITM6sUuptahs9ZU/V1ww5wPLgLPQPyKckLlpcG
	 F3fq9NDVNiV27xb5sDtzF1MXFS5k5esILWMBI8m0X5BXx8G6SfZ52g/iz6DAWL8q0bQ==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id F10631F031E5;
	Thu, 29 Oct 2026 02:23:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793240582;
	bh=4kiMZVmwM7DlhwUBz/uAfVwGiRsFDL/YimsXyBGFmas=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=NCVBxSYZP1cI63smxJWrEvAhaNDxiSzT84zKvJfvl7Gdh9BjV8jy6HhhZ52zNm+2Z
	 9FC+Ks0CalfZgRC8k9YAef2ts/ogkQMRDvEvHNSNQFasRTZp6NAtKVSU7lBuZt4iXP
	 ehu99kOuFXoysev+RHivSMg8cPobLlmoL30tQTIywVZUjti5n4wyvCcSSS8yAbmMjQ
	 6eSNlOWoitzK9cDkbecoGC5TOOCU2lkV48n1A90LBWI22MOi22P4rH3QxeBbZWEuwQ
	 jPT7rXynRPVwUy4+ljLzqOelW1Ul5r7FRB8sMCSMLff6GRfET/mcsz8ggNAWmZoiEV
	 i8Fzfg67SJLNQ==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id 0767C4569E;
	Thu, 29 Oct 2026 02:22:59 +0000 (UTC)
From: Daejun Park via B4 Relay <devnull+daejun7.park.samsung.com@kernel.org>
Date: Thu, 29 Oct 2026 11:23:04 +0900
Subject: [PATCH v5 7/9] xfs: take the invalidate lock while mapping a pNFS
 layout
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Message-Id: <20261029-xfs-pnfs-batch-v5-7-ef8d2eafb7fa@samsung.com>
References: <20261029-xfs-pnfs-batch-v5-0-ef8d2eafb7fa@samsung.com>
In-Reply-To: <20261029-xfs-pnfs-batch-v5-0-ef8d2eafb7fa@samsung.com>
To: Carlos Maiolino <cem@kernel.org>, linux-xfs@vger.kernel.org
Cc: Christoph Hellwig <hch@lst.de>, "Darrick J. Wong" <djwong@kernel.org>, 
 Dave Chinner <dgc@kernel.org>, Pankaj Raghav <p.raghav@samsung.com>, 
 Chuck Lever <cel@kernel.org>, Jeff Layton <jlayton@kernel.org>, 
 Dai Ngo <Dai.Ngo@oracle.com>, Sergey Bashirov <sergeybashirov@gmail.com>, 
 Andrey Albershteyn <aalbersh@kernel.org>, linux-nfs@vger.kernel.org, 
 linux-kernel@vger.kernel.org, Daejun Park <daejun7.park@samsung.com>
X-Mailer: b4 0.13.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1793240577; l=1836;
 i=daejun7.park@samsung.com; s=20261006; h=from:subject:message-id;
 bh=gBm+GQlIRCxEZO4KRoZl7CtxJsRVQymJZ83QN8nYo/0=;
 b=OtSKVXuoqsSukbkvXukaNN64ALis31zly7lzkWf1eVkX7HOpBXOASUDgUl0wwSl1L0igFvXeB
 hqq5fhp1dXMAsBwe308OWiwdFxl0K24FIZt1j6j3mn7qgW+Sw1jLFFW
X-Developer-Key: i=daejun7.park@samsung.com; a=ed25519;
 pk=4yUfDqGRZTIj0Ik43z1GoMZRWCNm/rgX6uJuM9dtNIg=
X-Endpoint-Received: by B4 Relay for daejun7.park@samsung.com/20261006 with
 auth_id=1122
X-Original-From: Daejun Park <daejun7.park@samsung.com>
Reply-To: daejun7.park@samsung.com
Content-Transfer-Encoding: 7bit

From: Daejun Park <daejun7.park@samsung.com>

xfs_fs_map_blocks() flushes the page cache under the iolock, but a
write fault takes only the invalidate lock. A fault on a shared mapping
can then add a delalloc extent before the range is mapped. That trips
an ASSERT, or nfsd warns and refuses the layout.

Take the invalidate lock with the iolock, as __xfs_file_fallocate()
does. Not for stable: pNFS already leaves local writers to shared
mappings unsynchronized.

Suggested-by: Darrick J. Wong <djwong@kernel.org>
Link: https://lore.kernel.org/r/20260519145949.GH9555@frogsfrogsfrogs
Signed-off-by: Daejun Park <daejun7.park@samsung.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_pnfs.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/xfs_pnfs.c b/fs/xfs/xfs_pnfs.c
index 7153e7a1e1..c1a6409f00 100644
--- a/fs/xfs/xfs_pnfs.c
+++ b/fs/xfs/xfs_pnfs.c
@@ -168,8 +168,11 @@ xfs_fs_map_blocks(
 	 * similar to direct I/O, except that the synchronization is much more
 	 * complicated.  See the comment near xfs_break_leased_layouts
 	 * for a detailed explanation.
+	 *
+	 * Take the invalidate lock as well, so that page faults cannot add
+	 * delalloc extents to the range while it is being mapped.
 	 */
-	xfs_ilock(ip, XFS_IOLOCK_EXCL);
+	xfs_ilock(ip, XFS_IOLOCK_EXCL | XFS_MMAPLOCK_EXCL);
 
 	error = -EINVAL;
 	limit = mp->m_super->s_maxbytes;
@@ -251,13 +254,13 @@ xfs_fs_map_blocks(
 		if (error)
 			goto out_unlock;
 	}
-	xfs_iunlock(ip, XFS_IOLOCK_EXCL);
+	xfs_iunlock(ip, XFS_IOLOCK_EXCL | XFS_MMAPLOCK_EXCL);
 
 	error = xfs_bmbt_to_iomap(ip, iomap, &imap, 0, 0, seq);
 	*device_generation = mp->m_generation;
 	return error;
 out_unlock:
-	xfs_iunlock(ip, XFS_IOLOCK_EXCL);
+	xfs_iunlock(ip, XFS_IOLOCK_EXCL | XFS_MMAPLOCK_EXCL);
 	return error;
 }
 

-- 
2.43.0


