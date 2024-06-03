Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 389FD23A0
	for <linux-xfs@vger.kernel.org>; Mon,  3 Jun 2024 19:18:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717442335; cv=none; b=TTIWSS4Ewls0+MRDXhPTGMWKJziMZbANwka+kVXh1CJbwmm++VcAQUyihHXLgHZIF8zgyW5clItfuWsnVn38GKE2CVrM/0JKNymeS3xRunZ5FA6dWs7nlCBc0AGogKd3UwsiJYhxLrXPikAgt1l+b1QzNoGubQJb4AjPEBm2hPE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717442335; c=relaxed/simple;
	bh=3SKzJ0X5YXQukQa1PqKPuRa5T951vzzpRlUNuWXk3WU=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=q0vLmWBINB8px0xsMwHsRT799rU1Vw5RXztHVtVslaAPtWL+Gy2gQHvvVNNqWKrIZJJSqeJ2puWb6SxSBWmYbR4xyfJ05OESBLTSsRTb2+rx3rSFVLBstZeBUgHx6BEMNiNXHME9tCuMbjFMjUKLeyQ0+yhlGsQAM8DYUMj6BNA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Yiuexs4o; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Yiuexs4o"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7DB7C2BD10;
	Mon,  3 Jun 2024 19:18:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1717442334;
	bh=3SKzJ0X5YXQukQa1PqKPuRa5T951vzzpRlUNuWXk3WU=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=Yiuexs4o3IrLtBFmWZlP94uQ/i06aNLBWKlV+fg2gs4YYD3P3nTCuF85+Jg6ejj7d
	 DCgCHGNO1FG092uuViAMxB1HgsnytXx6POc4swl7ChvnNFypw/idEzF/y0tnXBi/mV
	 KJYectDpxqwi1SWaIIpfCDo0mXlEGyQPRCv5cqdJJNSp5gWbdp3ufzv2kX6Nk2v6KD
	 5O9I5w4FRIuQ0Dekn6XWPdGhlJF/WkKAGiQHT0TluueOQHhlmb0LD9+cj3mv7qMIVH
	 qApMIcdSMZGca3hguxLRd3whpAtmBd+TcD4u8RCWPdKPMp9Tqy2jxu9JpVSPmitfMH
	 jtd5D2LIMvqTA==
Date: Mon, 03 Jun 2024 12:18:54 -0700
Subject: [PATCH 103/111] xfs: add a realtime flag to the bmap update log redo
 items
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, Carlos Maiolino <cmaiolino@redhat.com>,
 linux-xfs@vger.kernel.org
Message-ID: <171744040913.1443973.9396455803700132492.stgit@frogsfrogsfrogs>
In-Reply-To: <171744039240.1443973.5959953049110025783.stgit@frogsfrogsfrogs>
References: <171744039240.1443973.5959953049110025783.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Source kernel commit: 7302cda7f8b08062b11d2ba9ae0b4f3871fe3d46

Extend the bmap update (BUI) log items with a new realtime flag that
indicates that the updates apply against a realtime file's data fork.
We'll wire up the actual code later.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
---
 libxfs/xfs_log_format.h |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)


diff --git a/libxfs/xfs_log_format.h b/libxfs/xfs_log_format.h
index 269573c82..16872972e 100644
--- a/libxfs/xfs_log_format.h
+++ b/libxfs/xfs_log_format.h
@@ -838,10 +838,12 @@ struct xfs_cud_log_format {
 
 #define XFS_BMAP_EXTENT_ATTR_FORK	(1U << 31)
 #define XFS_BMAP_EXTENT_UNWRITTEN	(1U << 30)
+#define XFS_BMAP_EXTENT_REALTIME	(1U << 29)
 
 #define XFS_BMAP_EXTENT_FLAGS		(XFS_BMAP_EXTENT_TYPE_MASK | \
 					 XFS_BMAP_EXTENT_ATTR_FORK | \
-					 XFS_BMAP_EXTENT_UNWRITTEN)
+					 XFS_BMAP_EXTENT_UNWRITTEN | \
+					 XFS_BMAP_EXTENT_REALTIME)
 
 /*
  * This is the structure used to lay out an bui log item in the

