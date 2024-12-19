Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D28E41A08CC
	for <linux-xfs@vger.kernel.org>; Thu, 19 Dec 2024 19:37:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734637032; cv=none; b=MZl5pR1NimFO0oROTJYwzcLkyz0nRFLPHuTAcipvklMI1AGNBMuvYo0+9INZ0+YkyetmPMNpqqbusACPWJEvTAJuEdSEpIn2FdzX+4zY0rPQxPy97RohSYxDR1Wo2LNDXjeuMfuqAwZqTwS3AdYw4EE9CH9MEDrnbEq9Jrr5HUY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734637032; c=relaxed/simple;
	bh=Jtokb0PVehQconv58gAy6SaT+6s4nqyAG3KPe1xRR5A=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=RqJEdorJcSP8atQEG74Wla9JF9+EGvktL+73lbEJwGBHXqt8+xmjqbrHVjoP82x91tEJi8WU9P1DMbTBG52B5gy9z5naYCeFEJMWI8SpOEt/14kkcIYV5SRlFwa29PmOpE5ao5YlqOjd2GANOefVsIh2pWYadiVha+K+UekkUrA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=d/sKxw9q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="d/sKxw9q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE70EC4CECE;
	Thu, 19 Dec 2024 19:37:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734637032;
	bh=Jtokb0PVehQconv58gAy6SaT+6s4nqyAG3KPe1xRR5A=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=d/sKxw9q0a7Ud6RCX1MyEiUxqvwbSya7bCrfQY4vhaXvd0vdSt2jMfDto5VF5YUg2
	 WB5tpUsi40RZUDvPr940izq7DjsAzzlb+sgAaNj3lTg0s9w8LaQ+YbfOFnGBismX/6
	 LNEWpkrnmGPLxhLwB7DMf3F/kvZlA14QeEZiE6d+HHbjTKNjtkFn8FkoTOhpu42uTF
	 LkAr1GWEAS1viQemAboLoyImStcEA/wBP3zBof8sCHwMWLsXDwwv8r4rDfiDE19SoC
	 qv37KqfJ3nBT1ayFYGNWRsU09vVu7qrT10Qo2Y/4JMMAoRrtCgTz2KfMShWdhAzZDp
	 /01EfeC7DneUg==
Date: Thu, 19 Dec 2024 11:37:12 -0800
Subject: [PATCH 16/43] xfs: update rmap to allow cow staging extents in the rt
 rmap
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <173463581252.1572761.5940139620557154469.stgit@frogsfrogsfrogs>
In-Reply-To: <173463580863.1572761.14930951818251914429.stgit@frogsfrogsfrogs>
References: <173463580863.1572761.14930951818251914429.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Don't error out on CoW staging extent records when realtime reflink is
enabled.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_rmap.c |    7 +++++++
 1 file changed, 7 insertions(+)


diff --git a/fs/xfs/libxfs/xfs_rmap.c b/fs/xfs/libxfs/xfs_rmap.c
index f8415fd96cc2aa..3cdf50563fecb9 100644
--- a/fs/xfs/libxfs/xfs_rmap.c
+++ b/fs/xfs/libxfs/xfs_rmap.c
@@ -285,6 +285,13 @@ xfs_rtrmap_check_meta_irec(
 		if (irec->rm_blockcount != mp->m_sb.sb_rextsize)
 			return __this_address;
 		return NULL;
+	case XFS_RMAP_OWN_COW:
+		if (!xfs_has_rtreflink(mp))
+			return __this_address;
+		if (!xfs_verify_rgbext(rtg, irec->rm_startblock,
+					    irec->rm_blockcount))
+			return __this_address;
+		return NULL;
 	default:
 		return __this_address;
 	}

