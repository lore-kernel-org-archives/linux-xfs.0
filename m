Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B124734CFDD
	for <linux-xfs@vger.kernel.org>; Thu,  2 Jul 2026 20:00:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783022425; cv=none; b=cY7r/oVMCTrQGwhugMu4rRba47liMLjPRo3O2ucHzL6R482cLibrsUNGp56Qol8OGSLPcaBsKFEmOVz6jPtW32INjcXoBOZ69/OdDrLm+uhhNVpfRAOw3eFjEjraRLN5Gm6yQcJ1r/xeZogw54+rWmNFedRFxXIYCkrg4NwQt/0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783022425; c=relaxed/simple;
	bh=PdsoGcP94LxT9ac6aBo5El/c3gsu4cJdxUb55s0HNSs=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=b03aGjo61dr+vBh8HMDG+I3eDkfFJVdkCpExDehzQA9tFPgLZVVCN2qUXTWhWj5/2aV0fkzOevgt4ud7lsY4GePRyPoyR3DeXyND4jkBI1sCibsGHFcOzqiUhPylJ+7GqcSTN5A30NuzM11uB8uy46IXZdSoslCr36/37u6jNJ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=S5sAFS5g; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="S5sAFS5g"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id A988D1F000E9;
	Thu,  2 Jul 2026 20:00:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783022421;
	bh=3mXBfEII2E2xeSXoaDjwyQ2DfFrRUmiP8hwK4s4ppOs=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=S5sAFS5gGsKjaNUyDxP4G2UDmgrGnY41w02NJv1O2WwuY3Jhk9xlk8GKgCThjOYQZ
	 0IgRjMmQjlKorS/COjXGcRZXlFbZRSgcYthD5kVJhoVa+vH+Jtb97hQI5RQxwtzWeh
	 dSttvxQMShgAraN2hiGE+4tddjeByzTuO7/xmB3l8xjhUiJl5grOVTSmMZKQfkpweD
	 wtVnNhOXFHP795YagIOaBBrMpPSiFIDOYQYKhuxRWcsZCBz5Yr7fBb8L2x9TI5Vacd
	 Lbpr6JAPWdLwTrWyKZG4JPvTEnqj1uDsdb5788Onqt/76m1jtF8Fy1AiJtJQZ9PPoA
	 FQ5YP46Gms7Yg==
Date: Thu, 02 Jul 2026 13:00:21 -0700
Subject: [PATCH 5/5] xfs: zero directory data block padding on write
 verification
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: cem@kernel.org, dgc@kernel.org, ytohnuki@amazon.com,
 linux-xfs@vger.kernel.org
Message-ID: <178302225998.845293.2646519648540192911.stgit@frogsfrogsfrogs>
In-Reply-To: <178302225882.845293.16022494313921827307.stgit@frogsfrogsfrogs>
References: <178302225882.845293.16022494313921827307.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Yuto Ohnuki <ytohnuki@amazon.com>

Source kernel commit: 8fbb1877dfa5e26bda1baf8cc6abd3f805098486

Old kernels did not zero the pad field in xfs_dir3_data_hdr when
initializing directory data blocks, so existing filesystems may have
non-zero padding on disk.

Zero the pad field in xfs_dir3_data_write_verify alongside the existing
LSN and checksum updates. The pad field is pure alignment padding with
no runtime meaning, so zeroing it during write verification is safe and
has no additional I/O cost. This lets filesystems gradually self-heal
stale non-zero padding as directories are modified, without requiring an
explicit repair pass.

Suggested-by: Dave Chinner <dgc@kernel.org>
Signed-off-by: Yuto Ohnuki <ytohnuki@amazon.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
---
 libxfs/xfs_dir2_data.c |    6 ++++++
 1 file changed, 6 insertions(+)


diff --git a/libxfs/xfs_dir2_data.c b/libxfs/xfs_dir2_data.c
index fb5e4b021217a5..93540a7549ed2e 100644
--- a/libxfs/xfs_dir2_data.c
+++ b/libxfs/xfs_dir2_data.c
@@ -379,6 +379,7 @@ xfs_dir3_data_write_verify(
 	struct xfs_mount	*mp = bp->b_mount;
 	struct xfs_buf_log_item	*bip = bp->b_log_item;
 	struct xfs_dir3_blk_hdr	*hdr3 = bp->b_addr;
+	struct xfs_dir3_data_hdr *datahdr3 = bp->b_addr;
 	xfs_failaddr_t		fa;
 
 	fa = xfs_dir3_data_verify(bp);
@@ -393,6 +394,11 @@ xfs_dir3_data_write_verify(
 	if (bip)
 		hdr3->lsn = cpu_to_be64(bip->bli_item.li_lsn);
 
+	/*
+	 * Zero padding that may be stale from old kernels.
+	 */
+	datahdr3->pad = 0;
+
 	xfs_buf_update_cksum(bp, XFS_DIR3_DATA_CRC_OFF);
 }
 

