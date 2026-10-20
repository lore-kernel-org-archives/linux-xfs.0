Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1792465729;
	b=OMhf5fJt4f5ykTo2aN+utqonXsCCaO36LsYcdokTguBqLJUC4s6MlnkAZYGdqO4jVFNg
	 Xv1AG+tqu7VK3yT9ZNuaVBYMElGPSRziGAH6HX9YUgD2ENIAAnMcsAahINnfe0dNUk5RV
	 5w0xdT1KQTjDhkphlwEn8LRyDvacNuKLWzEQTdMPrJvCdFdNAEO8au+oCaIqha2OwQ3Bw
	 PK0HAj4kR/YkZmVFB1P5zKzGExmG/fo7TqkbM808uPjCFBYYsifaTSI3OVGWUpLi+Pv0V
	 aMxLDV/DpO2JnCeEnHjFGd89fl8lp4GCTbucvUaFosEAYPllrpJR3xBMG+kxBUuCMGw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792465729;
	h=Received:DKIM-Signature:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=T3eHs3MYtNv1Be9j5cHBcOk8yd6K4DGLR+8G7nFWCKo=;
	b=GqR/PkGrQCUTq14KqRAZGgijwx8dlkAwTr3rdAwTk5ObeKYwx7G+qYFCdMCdWpn4J3bf
	 B+lMa2uku+bnoJKP2nvvdkdG1l20jrH6RMWC/RVpZaqluZO6eJiAYqd686ipk9V0BTg/t
	 8US1/3GsYlZ3indDNMp/ZTo+TfJZwODwA4m/xGmYLfTEheh208f1Wr23/9FPmBfB13tIg
	 FbRtrsHmJ/flO7kApL7pSaBn9YWEfJDIWfU0hNYX8QpZ3wN33BGchah5UhukVnJqg6KFm
	 HJSlsWFj2DHEEk8Gf5iTW5WNKyzcbLVS4gT+rzF1Hn/aDAHAo9+KatjVKkFFyB/80uA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=h+41xMUE;
	arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFA1A60A2602;
	Tue, 20 Oct 2026 03:08:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=h+41xMUE
Authentication-Results: smtp.kernel.org; arc=none smtp.remote-ip=100.80.115.77
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1792465728;
	b=nWrG+cCs9W2vYBDDEmCNNrueXwUtnmtN0FgbPDEPRO2YTsjuPiJg8Px/t91M80xiCplH
	 fBBzykzju2mjWJ09651RZabSeorw1MTYhRFZDG2cyxjokgx27Iu4Xed2x9SS3Qwgh1atU
	 zsYOUvJRokHQQJWzAY8paHoTVyCuxny0quyofPkooxHU9Zw+8IdpyCfHpIH8EqqjHIBoZ
	 NJqgrFhY+oHE51w810mAn2jx5cSkhtn21cPWwEH9LHry54JRaQokcMoVyGjJgZeBJsoTU
	 O+WhL8irZECx4fCYp01AW6JxEw1PBdSmERVeQLRwobPJR6Q96gdOjaD5M4SLzg7U1rg==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1792465728;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=T3eHs3MYtNv1Be9j5cHBcOk8yd6K4DGLR+8G7nFWCKo=;
	b=Q7+CaGosOM12G+lmoPHQpwgL7yuzJEnapkRVVjUuqcmuxEP172/IMIQF/T1dtn2ccqRV
	 z60arX3B5aYrX05COow9tOMAL2kbaJARXHoxQ/JeiaYLKTaTlNgq0z/pSLRmn2OPy35jL
	 JlDuZjVu5A3L7da8xdl69TSIzNeFAhlPkB7Vzmk49ROzIANSQDXRIUa3yVtsTXy1dfxMU
	 EldpBaeo4Eeu1OMZOW9HGq6yloBlL01Odf3aIPf/qMMEzy4oa7sa7T+jZ6dC93CfkP8LD
	 jVNCdhcPuQhBijMAcz1iOLLN4oqEl1QK2cmJjBwdh7T/gSUpaNHnvzUEuOHBpRwTdCQ==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 2F9D21F000C8;
	Tue, 20 Oct 2026 03:08:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792465728;
	bh=T3eHs3MYtNv1Be9j5cHBcOk8yd6K4DGLR+8G7nFWCKo=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=h+41xMUE6Mo4fS2gGu3bn76GgMiGPm3DnNZBS+OFM8OThKEOejN0jt2IHiI/82EfL
	 bfaoKw/qUNLr8p+TRgyDjxYHlxYv+t35TuHYtnDmdA09NjsqF/5CjdaYOhcI6L8o31
	 i0onXdNMT4tWxR0Y2rx0zAn6lVQtEAPSpusnI8kWv2lbfOgW50NsP5xIFIWb74+QDp
	 pKSPCGU70O+HrVVzqlGVRmoEziWzafzyBiMShu0ysIHGxxuVVaDNI5wjs7Rlroc9aE
	 khNNqkBdz1RDwGtzTRcoGTMV9paDpGIAcmkY+OSXyk+bqU9wEbHblXI/tRI0Ycd6O5
	 jak+aA22/uAgw==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id 0A9634302B;
	Tue, 20 Oct 2026 03:08:45 +0000 (UTC)
From: Daejun Park via B4 Relay <devnull+daejun7.park.samsung.com@kernel.org>
Date: Tue, 20 Oct 2026 12:08:50 +0900
Subject: [PATCH v4 7/9] xfs: take the invalidate lock while mapping a pNFS
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
Message-Id: <20261020-xfs-pnfs-batch-v4-7-9230fa2ca4a4@samsung.com>
References: <20261020-xfs-pnfs-batch-v4-0-9230fa2ca4a4@samsung.com>
In-Reply-To: <20261020-xfs-pnfs-batch-v4-0-9230fa2ca4a4@samsung.com>
To: Carlos Maiolino <cem@kernel.org>, linux-xfs@vger.kernel.org
Cc: Christoph Hellwig <hch@lst.de>, "Darrick J. Wong" <djwong@kernel.org>, 
 Dave Chinner <dgc@kernel.org>, Chuck Lever <cel@kernel.org>, 
 Jeff Layton <jlayton@kernel.org>, Dai Ngo <Dai.Ngo@oracle.com>, 
 Sergey Bashirov <sergeybashirov@gmail.com>, 
 Andrey Albershteyn <aalbersh@kernel.org>, linux-nfs@vger.kernel.org, 
 linux-kernel@vger.kernel.org, Daejun Park <daejun7.park@samsung.com>
X-Mailer: b4 0.13.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1792465723; l=2355;
 i=daejun7.park@samsung.com; s=20261006; h=from:subject:message-id;
 bh=pzXqa98nUpOfj34pEKQp0o7a2GOVpueUtMKC0I0ygYU=;
 b=vMoz17Ju+w70xKlFcoCMCTsP7kxWo3Yh7U75S8fp8sX9qW7GOrKPFvff4V0FrDihcxcbmn12c
 7BOI5gYexmfCNGOpbVvSMFv9ck4MNJ66EtneBXd/LUc07p73bszTWfm
X-Developer-Key: i=daejun7.park@samsung.com; a=ed25519;
 pk=4yUfDqGRZTIj0Ik43z1GoMZRWCNm/rgX6uJuM9dtNIg=
X-Endpoint-Received: by B4 Relay for daejun7.park@samsung.com/20261006 with
 auth_id=1122
X-Original-From: Daejun Park <daejun7.park@samsung.com>
Reply-To: daejun7.park@samsung.com
Content-Transfer-Encoding: 7bit

From: Daejun Park <daejun7.park@samsung.com>

xfs_fs_map_blocks() flushes and invalidates the page cache of the file
under the iolock and then maps the range, but a write fault takes only
the invalidate lock (XFS_MMAPLOCK_SHARED in __xfs_write_fault()), not
the iolock. A fault on a shared mapping of the file can therefore add a
delalloc extent to the range between the flush and the mapping, which
trips the ASSERT on DELAYSTARTBLOCK, or is handed to nfsd, which warns
about a filesystem that returned a delalloc extent and refuses the
layout.

Take the invalidate lock in exclusive mode together with the iolock, as
__xfs_file_fallocate() does, so that page faults wait until the layout
has been mapped.

Not marked for stable: the race needs a process on the server that
writes to a shared mapping of the file while a client gets a layout for
the same range, and the comment above xfs_break_leased_layouts() already
leaves such writers unsynchronized with pNFS clients.

Suggested-by: Darrick J. Wong <djwong@kernel.org>
Link: https://lore.kernel.org/r/20260519145949.GH9555@frogsfrogsfrogs
Signed-off-by: Daejun Park <daejun7.park@samsung.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_pnfs.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/xfs_pnfs.c b/fs/xfs/xfs_pnfs.c
index 7b508f63d3..8d7a71db5f 100644
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
@@ -260,13 +263,13 @@ xfs_fs_map_blocks(
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


