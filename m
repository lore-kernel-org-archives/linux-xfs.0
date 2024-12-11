Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D4001C1F22;
	Wed, 11 Dec 2024 20:07:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733947679; cv=none; b=lvSEdr3QO3mC0XQ1qHAo6CvzF+/Ek8nfGOdu7q2gvEujkIOBzwuzJ7437PN3xrca8wNcGGrto2Ya/JrCPwW4jJiswpaKzLGRfGITfkB02Sr72A0oyuuzJWN6/btrhaS+VkwjezjTzxipcIBXrlZJvsesrHdCrVaSh7hjJ3ixiKc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733947679; c=relaxed/simple;
	bh=jYJayrTQJvKRAI0mBU27ZP63G//tvKs0ArIgrBMb7G4=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=aw/AAo36xj8CYGlF5wQYKvnWGyJJLV0f9k2u+SsGZKKwQD3io8sfkZjVqzPuJReyNcJrPj5MKiDWnkLOQKjICVtpgYlDU150bfyZ/6YSpgzmjkMmcKeTAWab7DWVUlNLbZcyr3nQlh8hb2DCUx0EkzHZtEBDFaUBc/ClGmc69w8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dcQ2I1Mb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dcQ2I1Mb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 216E8C4CED2;
	Wed, 11 Dec 2024 20:07:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733947679;
	bh=jYJayrTQJvKRAI0mBU27ZP63G//tvKs0ArIgrBMb7G4=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=dcQ2I1MbkpEkk4f4wqaVCNjgagWLbMACji5WWsGjOTMlp7U4N/vNoorDtIpvUZrjN
	 AVzxbop9FeUCnZJUQyabEi+ttMKgENOMM4K1jQ6NOxDZbMBtOuYoroPNovXJl94SA/
	 QaO9XysCFw7yHsbx2M+KroDJpnZ8/livlfQ7z1GxWlIOXLnPwT8KJp48SStVMT3Rsd
	 eU0xucv9xNN7rc1uaXlwE9iIt8Ev9Mw0hAD7uF8nfftFRTkJX9AFwb90/Gzq8kPR+E
	 4iPSYW49gqTfdicNlRzwm+lys5epyBLijZ2eSxbZ5ksLglgslZe3oMid84AjouuFES
	 HBw2iXS8hfVCw==
Date: Wed, 11 Dec 2024 12:07:58 -0800
Subject: [PATCH 2/6] xfs: don't crash on corrupt /quotas dirent
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: stable@vger.kernel.org, hch@lst.de, linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <173394758103.171676.16671624158372257924.stgit@frogsfrogsfrogs>
In-Reply-To: <173394758055.171676.7276594331259256376.stgit@frogsfrogsfrogs>
References: <173394758055.171676.7276594331259256376.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

If the /quotas dirent points to an inode but the inode isn't loadable
(and hence mkdir returns -EEXIST), don't crash, just bail out.

Cc: <stable@vger.kernel.org> # v6.13-rc1
Fixes: e80fbe1ad8eff7 ("xfs: use metadir for quota inodes")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_qm.c |    7 +++++++
 1 file changed, 7 insertions(+)


diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
index 69b70c3e999d72..dc8b1010d4d332 100644
--- a/fs/xfs/xfs_qm.c
+++ b/fs/xfs/xfs_qm.c
@@ -731,6 +731,13 @@ xfs_qm_create_metadir_qinos(
 		error = xfs_dqinode_mkdir_parent(mp, &qi->qi_dirip);
 		if (error && error != -EEXIST)
 			return error;
+		/*
+		 * If the /quotas dirent points to an inode that isn't
+		 * loadable, qi_dirip will be NULL but mkdir_parent will return
+		 * -EEXIST.  In this case the metadir is corrupt, so bail out.
+		 */
+		if (XFS_IS_CORRUPT(mp, qi->qi_dirip == NULL))
+			return -EFSCORRUPTED;
 	}
 
 	if (XFS_IS_UQUOTA_ON(mp) && !qi->qi_uquotaip) {

