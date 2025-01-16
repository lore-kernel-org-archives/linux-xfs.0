Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43F511862
	for <linux-xfs@vger.kernel.org>; Thu, 16 Jan 2025 21:38:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737063512; cv=none; b=iv2JY3b7Dl1S1RXbMHCS7Sq4ASFA4mGkSqaINFHtY4vIluPLQz7HcKgpqAKy+2iuCr2SX+0i1MXUgfRt8Xk5pZryx1U0CJq3IacuZGWqJy+lswgXmWkJxjit8/Uf0/JsL860HCOfD4Smt/nvK5LmbJVJLSnyacelni5wbpk9tCY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737063512; c=relaxed/simple;
	bh=M0WRnFfjI2kUn+ZTlG0PXJh2Rti0XL0FqRO32hitaUo=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=hGBwiN/56jws8vDjJJhudOzz8Dnw7fS9CkTUbh5GmFSmOLlEd50Nf8cxqerkqsx5FdVhNccAuP0T/uCs1SvAfaG4oJNtLwg0JRzYdwbK5VkUH8fJP8nbyGBuc3nW10PK79zodSId8GQ6t/HpZmwUSJvjeua2YFG2Gz6rxETkhdA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bqvQ/PQ9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bqvQ/PQ9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7BABC4CEDD;
	Thu, 16 Jan 2025 21:38:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1737063511;
	bh=M0WRnFfjI2kUn+ZTlG0PXJh2Rti0XL0FqRO32hitaUo=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=bqvQ/PQ93kLRcfhYYNXys5jvk1z8LViHP+TzDesy9BZcV6KUh5UTidNYYQyBuat/i
	 ZgZ/vO15x3V6yhpR6hUvCUMnUATiOpOYOfE1UxoXFKf12TYQAqKhxPU/v6ixX+S6lx
	 Hmw1vZY2dNXiL7MC9wCvuOl6U1vYCfyZgPRi1xW+7bNTQrNDHWwIYCIC9VBlhisley
	 b5+ahUXyl6g0Z73QUmsy4w2h5sGLvn1s5Td34CzOkziwISiNt0qwMsomJH+au+oSUg
	 HuSPY2Wiu/GeP//5W77mEs7YSb/UD3I0luHvTzIB6U3L0LzRoJnUjcc8ntjMtuhV6l
	 yj5kQqDoWAT4Q==
Date: Thu, 16 Jan 2025 13:38:31 -0800
Subject: [PATCH 1/1] xfs: don't return an error from
 xfs_update_last_rtgroup_size for !XFS_RT
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: bfoster@redhat.com, hch@lst.de, cem@kernel.org, linux-xfs@vger.kernel.org
Message-ID: <173706331839.1823579.12938125763181503439.stgit@frogsfrogsfrogs>
In-Reply-To: <173706331824.1823579.16623323047900629482.stgit@frogsfrogsfrogs>
References: <173706331824.1823579.16623323047900629482.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Christoph Hellwig <hch@lst.de>

Source kernel commit: 7ee7c9b39ed36caf983706f5b893cc5c37a79071

Non-rtg file systems have a fake RT group even if they do not have a RT
device, and thus an rgcount of 1.  Ensure xfs_update_last_rtgroup_size
doesn't fail when called for !XFS_RT to handle this case.

Fixes: 87fe4c34a383 ("xfs: create incore realtime group structures")
Reported-by: Brian Foster <bfoster@redhat.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
---
 libxfs/xfs_rtgroup.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)


diff --git a/libxfs/xfs_rtgroup.h b/libxfs/xfs_rtgroup.h
index 7e7e491ff06fa5..2d7822644efff0 100644
--- a/libxfs/xfs_rtgroup.h
+++ b/libxfs/xfs_rtgroup.h
@@ -272,7 +272,7 @@ static inline int xfs_initialize_rtgroups(struct xfs_mount *mp,
 }
 
 # define xfs_rtgroup_extents(mp, rgno)		(0)
-# define xfs_update_last_rtgroup_size(mp, rgno)	(-EOPNOTSUPP)
+# define xfs_update_last_rtgroup_size(mp, rgno)	(0)
 # define xfs_rtgroup_lock(rtg, gf)		((void)0)
 # define xfs_rtgroup_unlock(rtg, gf)		((void)0)
 # define xfs_rtgroup_trans_join(tp, rtg, gf)	((void)0)

