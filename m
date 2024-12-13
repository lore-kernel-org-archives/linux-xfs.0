Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C50E17BA6
	for <linux-xfs@vger.kernel.org>; Fri, 13 Dec 2024 01:12:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734052356; cv=none; b=oSJx8oF+IexRysrhkO45E7hjngfuvFGPIltM+SRse+zOYs4s8S1O5a2iVVeYAf5PGuR4eunuukgI0lyUP+1g1ym2GFWMq4BtJI3o8F3xNR813/VagDqIb2vTnsm9f/L+m0OoebrDlecHTJSkvOqPJdTcFCEIcKO19qC+m4q6YoI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734052356; c=relaxed/simple;
	bh=Zzn2cn72e6Lyg/08ew7galaqS6ZL6kz3l4ulcoC6dFw=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=I+R3Brw0zaBZ2EjA/E9SiCkv2KLoRHgdzvkHTZwMoSVofEoW7extlyc7J9HGZsVhYa5YBd0ttMnQNSolb22FlRsV+RFv/zxIEf/R+7GNrdOstZ3cKKWpvmfJq5iVl1vekSWa7376me07k2AQmuOtoEzp2on3P9ILXVN47Vic2I8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZatflcCU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZatflcCU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 074C3C4CECE;
	Fri, 13 Dec 2024 01:12:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734052356;
	bh=Zzn2cn72e6Lyg/08ew7galaqS6ZL6kz3l4ulcoC6dFw=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=ZatflcCUtawM7ni67O8Qlmx3gE6346Wrd5eifQVPt0xSN4JatYab4uOABG5SBnESF
	 +oRcW5XloYTckyoZSaKx5DaCLWNvyZg64XKYMKMVTnldfdIrTTC+I8Ji22kLmb6WHY
	 ARs2Dq297ypPhM/+HAmxe0PY9T8pn51OyOiqNQEu6IvXNdsEf+dRqIpMGXYQ8UVf2h
	 pSBrHNjY06CN4JdzRpiD+FQfAxiRT06xAOnh5fln9xe69ZJo9CrBGk6CBewuudvjWj
	 7dMgoOc0sThD0WxAOcgRJuZpqqsJ37VQNMf0LJPqGDxyqHEzEMRq/ZXBLzzOofj/mv
	 NZSgt6mAHuMVQ==
Date: Thu, 12 Dec 2024 17:12:35 -0800
Subject: [PATCH 09/43] xfs: add realtime refcount btree block detection to log
 recovery
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173405124722.1182620.17398362509623993412.stgit@frogsfrogsfrogs>
In-Reply-To: <173405124452.1182620.15290140717848202826.stgit@frogsfrogsfrogs>
References: <173405124452.1182620.15290140717848202826.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Identify rt refcount btree blocks in the log correctly so that we can
validate them during log recovery.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 fs/xfs/xfs_buf_item_recover.c |    4 ++++
 1 file changed, 4 insertions(+)


diff --git a/fs/xfs/xfs_buf_item_recover.c b/fs/xfs/xfs_buf_item_recover.c
index 4f2e4ea29e1f57..b05d5b81f642da 100644
--- a/fs/xfs/xfs_buf_item_recover.c
+++ b/fs/xfs/xfs_buf_item_recover.c
@@ -271,6 +271,9 @@ xlog_recover_validate_buf_type(
 		case XFS_REFC_CRC_MAGIC:
 			bp->b_ops = &xfs_refcountbt_buf_ops;
 			break;
+		case XFS_RTREFC_CRC_MAGIC:
+			bp->b_ops = &xfs_rtrefcountbt_buf_ops;
+			break;
 		default:
 			warnmsg = "Bad btree block magic!";
 			break;
@@ -859,6 +862,7 @@ xlog_recover_get_buf_lsn(
 		break;
 	}
 	case XFS_RTRMAP_CRC_MAGIC:
+	case XFS_RTREFC_CRC_MAGIC:
 	case XFS_BMAP_CRC_MAGIC:
 	case XFS_BMAP_MAGIC: {
 		struct xfs_btree_block *btb = blk;

