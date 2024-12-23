Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3CEA18E35D
	for <linux-xfs@vger.kernel.org>; Mon, 23 Dec 2024 22:27:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734992829; cv=none; b=t96zdj1qaA/kZieIMBn85QZjeG9jdmfOq1824wvU5cMFPQtSJsMuSw2yXOIlW2AImmnkNFEiJNHwdurAzR3WYOoiFhe/ALBCbPd3h/4Vonv3k9Xf0QeEeH7k44pwtY5fwrklBqK2p6n7oadam0+ctsmsXjJrYS8GQr365lnFP4I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734992829; c=relaxed/simple;
	bh=NrKq61Gl+hw3SM06Dgd7jM25s/NTScLs3zqmz10L++0=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=fUMWqOT3cELdyw04qjsFKPjU81shSgA8U5e4SyvQvVLy8RbEJPc64eHmCWK/F8KG6kBG3x7yyVqae7ynogimGdcribhQKnOiZGN7yk55W8VdMlOPPJyuHfDuQ753+pqpivHShrPWWkdKbpj2exYK/4cCRq0BzEfOZZ0C9IbhENI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=azDsKMI8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="azDsKMI8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47095C4CED3;
	Mon, 23 Dec 2024 22:27:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734992829;
	bh=NrKq61Gl+hw3SM06Dgd7jM25s/NTScLs3zqmz10L++0=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=azDsKMI8AqstSQZsztZpaIX6enTac5NXb9YhRaElHTbt/ExGNsyUAEjaXJDXwTM9V
	 4J9eoWzlO5cVmnCPg35eIdjixVgFLkebZ/uA+PYs616aB2ZxAdaV50g0a7MNP2bKqg
	 RJ/QKLBGinWG+WR3veLx8DzhDKyLngvBTayV7SrvyG62qa7CYxysXboavv5TR8SNHN
	 xZPVusqJJEQaXhFwf+84tLh+j+QdrUK7s5tUs4VY58qjb93kfq/Isv+POyeqmUv7EU
	 ebFdUQFNVioXNrQNu/Pfb1Am3yJlbGHMXy1he7yQxU7U2OASUa80VB7cBumS66EhBc
	 SrCP8GRoOMTDA==
Date: Mon, 23 Dec 2024 14:27:08 -0800
Subject: [PATCH 1/2] xfs_quota: report warning limits for realtime space
 quotas
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173498945457.2299549.10641269247354954728.stgit@frogsfrogsfrogs>
In-Reply-To: <173498945439.2299549.17098839803824591839.stgit@frogsfrogsfrogs>
References: <173498945439.2299549.17098839803824591839.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Report the number of warnings that a user will get for exceeding the
soft limit of a realtime volume.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 include/xqm.h |    5 ++++-
 quota/state.c |    1 +
 2 files changed, 5 insertions(+), 1 deletion(-)


diff --git a/include/xqm.h b/include/xqm.h
index 573441db98601a..045af9b67fdf2b 100644
--- a/include/xqm.h
+++ b/include/xqm.h
@@ -184,7 +184,10 @@ struct fs_quota_statv {
 	__s32			qs_rtbtimelimit;/* limit for rt blks timer */
 	__u16			qs_bwarnlimit;	/* limit for num warnings */
 	__u16			qs_iwarnlimit;	/* limit for num warnings */
-	__u64			qs_pad2[8];	/* for future proofing */
+	__u16			qs_rtbwarnlimit;/* limit for rt blks warnings */
+	__u16			qs_pad3;
+	__u32			qs_pad4;
+	__u64			qs_pad2[7];	/* for future proofing */
 };
 
 #endif	/* __XQM_H__ */
diff --git a/quota/state.c b/quota/state.c
index 260ef51db18072..43fb700f9a7317 100644
--- a/quota/state.c
+++ b/quota/state.c
@@ -244,6 +244,7 @@ state_quotafile_stat(
 	state_warnlimit(fp, XFS_INODE_QUOTA, sv->qs_iwarnlimit);
 
 	state_timelimit(fp, XFS_RTBLOCK_QUOTA, sv->qs_rtbtimelimit);
+	state_warnlimit(fp, XFS_RTBLOCK_QUOTA, sv->qs_rtbwarnlimit);
 }
 
 static void

