Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38D45415F3B;
	Wed, 23 Sep 2026 05:58:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790143090; cv=none; b=qw54MIBzx7txeH8EQxh69JumuNc5G2Wypv+aGxl3zfSGPKWnDr2mbMUGUWinqMZvMDdHLqhY2LAfsi3yqNuCzlOCgibgX81vzRK0EJJrkitLPk4deSHgyXvI6bH9g5mLkj/tvP1s3NqGNcrxGBH59ae8mD90JRJ55STrXyJFZiM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790143090; c=relaxed/simple;
	bh=hJ5JTN2DiO4TkOZdKXdRsjgid+Bm9yKfkXuud/5oaT0=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=iKDE1dQFtDpqUR9+Obodh5Sm9sgZcmHwY6PLIsvpcL7fi4sz5caxuiW12Fn1G2IJoyh3r5bVvpvsQs+ZkJSbdDFs9XQ694qBjg1oWv6EdHgvGsETayaFjXSyIkVsUctPfk+6zcYaPyi86tccTiE28v48kCTJ+3/e+bTMsCWkxFg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fFPIkTrN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fFPIkTrN"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 104441F0089A;
	Wed, 23 Sep 2026 05:58:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790143089;
	bh=Crt2zxWLLuLUE4BsnLS2pv8dhMVrVXCcnIDvOGrjVLw=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=fFPIkTrNXH70RDMPuX9zXQTWWXvuVGL+k4GNha4TPwIaOj1rOChBwsoqb5C7C+Bjt
	 IgkBrGuV2W1KX+FlMVNoBEAjmFDyyKB5YFkQrFrqcEQCO2bjpBV8KYItx3ddqnHICH
	 cKeCmUSYnYQ/y1dlckH8+ZDLN9PMvE8YlAdq4tZj+JX/X31CJHZyW2SlPETRYZs1Pk
	 JIhiYSUXuJpVn4nx9Jf5BLgVtza7LDU+JmzH8JZZDI6gwPoAyp6TafK/PX7+idH9OJ
	 ZI2A8XgWLfrOWWADZKgd/cX0ifRiEpxZ1s+VfLrsfC9iSpEHGC23iZiJ1x02kTZP8z
	 EQcKG9lGhmC/Q==
Date: Tue, 22 Sep 2026 22:58:08 -0700
Subject: [PATCH 03/13] xfs: fix buffer overruns in xfs_ioc_attr_list
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: hch@lst.de, stable@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <179014158992.1874904.15961657710909637002.stgit@frogsfrogsfrogs>
In-Reply-To: <179014158847.1874904.13591868745136552281.stgit@frogsfrogsfrogs>
References: <179014158847.1874904.13591868745136552281.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

When we converted the al_offset array in struct xfs_attrlist into a VLA,
the size of the object shrank by 4 bytes.  Unfortunately, the buffer
size validation in the attrlist ioctl wasn't updated to notice this, so
the al_offset[0] assignment blindly writes off the end of the buffer.
LOLLM noticed the omitted check and complained.

Cc: <stable@vger.kernel.org> # v6.5
Fixes: 371baf5c9750a2 ("xfs: convert flex-array declarations in struct xfs_attrlist*")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_handle.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)


diff --git a/fs/xfs/xfs_handle.c b/fs/xfs/xfs_handle.c
index 0689cade8f74c2..fd9d4d8258fff2 100644
--- a/fs/xfs/xfs_handle.c
+++ b/fs/xfs/xfs_handle.c
@@ -409,7 +409,7 @@ xfs_ioc_attr_list(
 	void				*buffer;
 	int				error;
 
-	if (bufsize < sizeof(struct xfs_attrlist) ||
+	if (bufsize < struct_size(alist, al_offset, 1) ||
 	    bufsize > XFS_XATTR_LIST_MAX)
 		return -EINVAL;
 

