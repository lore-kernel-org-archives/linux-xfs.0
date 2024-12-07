Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BC04139E
	for <linux-xfs@vger.kernel.org>; Sat,  7 Dec 2024 00:20:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733530806; cv=none; b=MvFAMSxowv9oG+782ARIltLYXen8+mlsjfLnf+pCUcixIGGlPeEd4pBmcmJGHZdDOMSDQmagVmZgg9eNDlfKLTmAs61LYGZa2TMN95Yf//SWPHjml9duDLp3DZ22yGt9PPVuEq40GbbpvHXyQVn0DDcwDWpVaYBJqs0TxdXUol0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733530806; c=relaxed/simple;
	bh=aWndZv9SlS+JGwBkKxym/air6iUpjsabbVa3W3/NuiA=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=aBMBRSml7qs1UC3Y12y8yWxjE7x4/6kIT1f1YOuZdTRfU4aDjivEgbOt0YePfqatRREQWuyfsI4OH/3/FM1C8q2HmS43RpZiX78I2/+K9wRa5rpuBR6LnoLq1iSCRhu+bFzsl+eKY/5eGyxfMk8BgMw8zknGuQez+FALBxbKctQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lLSF1TD2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lLSF1TD2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 688FBC4CED1;
	Sat,  7 Dec 2024 00:20:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733530806;
	bh=aWndZv9SlS+JGwBkKxym/air6iUpjsabbVa3W3/NuiA=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=lLSF1TD2QZ11wrxNGEasmYmPEW6qoGUzA3zhaREF00wLwU1Tdd4P7CQrdGzMsTdcZ
	 DKltibV11SPbkRzk3VXvHe8tKsvKDfP3wnrai6RGfOoXLsil7a9H5LEQxRx8/I7u5H
	 5cBBBPoNJ7CLEUTygacGZjm1NYfZb8iQHWsQOrhGEH+G8n8upDEgQVfy9m14dEbw1D
	 SfsdEpmxGoMJ5cHQfcKgPG/TouP4PB0LkRI1gJMvOX5k5zdbqdNZSbrRTbjotO+PTB
	 on2JG7JI0gb3N/Peds2M0NcCx5I7YpzbUPVneMgXwcyja12StHdpVJRuPS7FHVQYHE
	 lj1Tnkpvq6gUQ==
Date: Fri, 06 Dec 2024 16:20:04 -0800
Subject: [PATCH 1/2] xfs_quota: report warning limits for realtime space
 quotas
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173352753972.129972.7804228230884394394.stgit@frogsfrogsfrogs>
In-Reply-To: <173352753955.129972.8619019803110503641.stgit@frogsfrogsfrogs>
References: <173352753955.129972.8619019803110503641.stgit@frogsfrogsfrogs>
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

