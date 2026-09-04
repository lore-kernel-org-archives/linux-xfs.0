Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A407F29ACC5
	for <linux-xfs@vger.kernel.org>; Fri,  4 Sep 2026 11:32:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788521566; cv=none; b=ighaDt7LFCrL3Q6VlMqSQ7yIj/yN4sspvImAtLi4uJYjW5/HiAM4SgTMbKjjB4dltcSD650uHG5mNCJRkl9qNT+BFb80sWFwMWBZLz+3bHfz/vG3H2zXT/+PZZHbwKdqIryN7SBUJhoeKEvvUH5eFz7LAsFKHU2ISaQ0Oh4tknY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788521566; c=relaxed/simple;
	bh=UwGAgYw8jMrU89ql5KECdpeUHCv6azbhs/trmriFUZQ=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=M9aQ6RolXx8jz5+ldNE9vepJTFvbT18GZmSkoDBECW72P0OU+ahVn/VGcl2IZ3rpeNfuJ8V5cyJb1pl86AXosZ5/mFsZ2057it3tgisNgjKy2zaw1LvFZHj2X78+X2+rpO7NXQu0FguXNfGjgtMVGiWTRiLASRqGs2ywXH62UyI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=e9kdY2Jk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="e9kdY2Jk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A23C41F00A3D
	for <linux-xfs@vger.kernel.org>; Fri,  4 Sep 2026 11:32:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788521565;
	bh=ATZhJHFxm1U0VYUIEMxTLAh7nfTG2QXjp0ROO/56gMs=;
	h=From:To:Subject:Date:In-Reply-To:References;
	b=e9kdY2JkNMWE5bJV+z9Vdm4Ffmx7U+L2W+5RFqYHGDEfcvWQtPI7xoCMou2y5aRlt
	 jfJigAt7xmgWAXIIthC8gnLRFSiVOhCMIEv/yD7JDCJrm8SsFzKCBdQ/qkGkX63Z9q
	 Uj8ldz22rRG9g4FKGxPgVr3UJy4vAnA89qfw5uUFqrTYucMBjtjBqlu2hCbTmuwThF
	 C/7rScMf9DIcQ+xhIT8Wo2P3B6kf0qUhMvsyrGlG6rkyAeuT8N8Gu0Lkc2tVVGZnBH
	 uYBXSNosrdkoxqTyeLf528g/ashx/RAetnhuIe23oMsesl8WSd8NcdgH5hsDj6RY2h
	 GJfri4Rda+wUQ==
From: cem@kernel.org
To: linux-xfs@vger.kernel.org
Subject: [RFC PATCH 3/3] xfs: make xfs_iomap_write_direct() report an error to xfs_trans_cancel
Date: Fri,  4 Sep 2026 13:32:23 +0200
Message-ID: <20260904113231.1408890-4-cem@kernel.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904113231.1408890-1-cem@kernel.org>
References: <20260904113231.1408890-1-cem@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Carlos Maiolino <cem@kernel.org>

I've been in the situation a few times where the transaction got
cancelled by some reason. Most of time because bmapi_write failed and I
start a guessing game trying to understand why.

So if xfs_iomap_write_direct fails and it causes the transaction to be
cancelled, send the error to xfs_trans_cancel so the error gets logged
into the kernel log buffer.

Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
---
 fs/xfs/xfs_iomap.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
index ff05e6b1b0bb..3d1a52757697 100644
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -344,7 +344,7 @@ xfs_iomap_write_direct(
 	return error;
 
 out_trans_cancel:
-	xfs_trans_cancel(tp);
+	xfs_trans_cancel(tp, error);
 	goto out_unlock;
 }
 
-- 
2.55.0

