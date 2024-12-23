Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C608513FEE
	for <linux-xfs@vger.kernel.org>; Mon, 23 Dec 2024 22:04:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734991453; cv=none; b=t7AQ/cFfugYJk7O7Akto7fOZUpoeP1KtD8/J0HXfU0VOQwMtU+TePp4sIKI9IukXqftsA/4BmXZ7YV+WS8sTM2hTEFshRo1S6P/X95LV3gt4qDUxEIQHBmLwafk6IUbfR8EDgV8mYUQ71SJIx30JP7sIFAgP+bZudAt0Ezeqtdo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734991453; c=relaxed/simple;
	bh=CxJwoKE3HahBeSJoS22ztfSBJsei+Mzqj/xCM3/CsDk=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=sqhZgj3/OsU2NBMP68pDNaRSCemib7LTmSDviHWHr0YIzoEnAyK+HcANipIxrka6YGVSnxfYuh0TQTpwyzR/OQpeGGpMsiHhSvmuom/cXnUz+GEP9w4wLz6My8wWNuIB461b0H+pP3MSJ636NBb6LaS12A8RS29kJx6/rT2Ce6c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Qwc3JNHT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Qwc3JNHT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E2A2C4CED3;
	Mon, 23 Dec 2024 22:04:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734991453;
	bh=CxJwoKE3HahBeSJoS22ztfSBJsei+Mzqj/xCM3/CsDk=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=Qwc3JNHTbAvj+Quf5fiP72R+Io8Gd8GJwRnq+JVtxr+bhu1oIl2J2LI7qP5b6532c
	 V/mQGsLqOoxY6dbGB79MQr6/QiOwtghxZpvIslrAffTqfE8XqdEzGdhaJh1xiFReft
	 1Lgz8Qt1LUsRDfRGvpgd64tZSEIrQ5eRUGFKXa2A9JItAQ2yjFFjuOIA06/htyt4oE
	 IadTpA5/2CnCua5v67ep33btsblOsmvl98PbBbX/WJB1dQ/h55UDwGZulSWOhz90I5
	 x89ikBb1Dwr+t+OMeLw+oh2d0hxnfel5WDg6Pc8II0GwrTej/i+HgStTg0Rqc2jb5h
	 god6d1V0mz4Gg==
Date: Mon, 23 Dec 2024 14:04:13 -0800
Subject: [PATCH 23/52] xfs: grow the realtime section when realtime groups are
 enabled
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173498942847.2295836.12086208165941734293.stgit@frogsfrogsfrogs>
In-Reply-To: <173498942411.2295836.4988904181656691611.stgit@frogsfrogsfrogs>
References: <173498942411.2295836.4988904181656691611.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Source kernel commit: ee321351487ae00db147d570c8c2a43e10207386

Enable growing the rt section when realtime groups are enabled.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 libxfs/xfs_shared.h |    1 +
 1 file changed, 1 insertion(+)


diff --git a/libxfs/xfs_shared.h b/libxfs/xfs_shared.h
index 9363f918675ac0..e7efdb9ceaf382 100644
--- a/libxfs/xfs_shared.h
+++ b/libxfs/xfs_shared.h
@@ -160,6 +160,7 @@ void	xfs_log_get_max_trans_res(struct xfs_mount *mp,
 #define	XFS_TRANS_SB_RBLOCKS		0x00000800
 #define	XFS_TRANS_SB_REXTENTS		0x00001000
 #define	XFS_TRANS_SB_REXTSLOG		0x00002000
+#define XFS_TRANS_SB_RGCOUNT		0x00004000
 
 /*
  * Here we centralize the specification of XFS meta-data buffer reference count

