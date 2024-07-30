Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 666AB33D5
	for <linux-xfs@vger.kernel.org>; Tue, 30 Jul 2024 00:53:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722300827; cv=none; b=KaSJG2/yd+1A2JSCYsl+K3QMnItI1uBpiCPU4yAY9ACAV2bs85idCfVCWU2lZqIJzwQIsgvAc0zCuCxCL+J7wrudiHF2KT/Ltr1lh3dk00VTqszhgMKZNT7bS6sr7Tu/ipUjXKl5/w+dfUxi1Zp8pz/8zZQqXE1NhH3/7+7rVjg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722300827; c=relaxed/simple;
	bh=z90GpLfbvwyU2a8WZe7YRFFxaDvkyeH0QK3HQXbEQ5w=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=pOASp9hQ7We1F6mjdzG+t9bqSsEPtjeW3SptZLmH8NuWnmSa071SLt++DOInt6YkD3j2qs+bBbnYXlxP4rfCL9hJQVnFmFi+jUJezpTDMCV7ON3FFc0pZd+SUsGm8DQFliYh3zqpTLy64PA4gM75hOO9zMN6uvM6rRvIMmHPIrc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FgwZ4hQ2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FgwZ4hQ2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0E2EC32786;
	Tue, 30 Jul 2024 00:53:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722300827;
	bh=z90GpLfbvwyU2a8WZe7YRFFxaDvkyeH0QK3HQXbEQ5w=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=FgwZ4hQ2VvBdVq2a80uLXkp0JAKO0Y6/BmtoZQErG3XmX/AmhW17ndtTJNL3cEtnv
	 BxoS6ZVJvcocnvFWzpqxjJdi3gZtKQpZJd2VuRLhfbfbLz9b3LTRFrMiqoNBlgwfY3
	 vSE+UJYl5ws6/LCeJ1qEBbCYrTDn0Z1749LELgFKoKbfVcUzxXPti3nNrYG145SqmL
	 PKeeS6scx78FGhvaoQ3OV0hR/9N2ok0KK/reI4Z6DiTd765a3UgmzXcwRI4BVuUYjK
	 0+ElzMV3EB1AzI0D5FaG4xHYef15i2w7ObCm0T8pIzt/FV7fZreanMh8Xyj1Gw88vY
	 V76WkDPapAwdQ==
Date: Mon, 29 Jul 2024 17:53:46 -0700
Subject: [PATCH 115/115] xfs: fix direction in XFS_IOC_EXCHANGE_RANGE
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, Chandan Babu R <chandanbabu@kernel.org>,
 linux-xfs@vger.kernel.org
Message-ID: <172229844055.1338752.3125976389287760838.stgit@frogsfrogsfrogs>
In-Reply-To: <172229842329.1338752.683513668861748171.stgit@frogsfrogsfrogs>
References: <172229842329.1338752.683513668861748171.stgit@frogsfrogsfrogs>
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

Source kernel commit: dc5e1cbae270b625dcb978f8ea762eb16a93a016

The kernel reads userspace's buffer but does not write it back.
Therefore this is really an _IOW ioctl.  Change this before 6.10 final
releases.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Chandan Babu R <chandanbabu@kernel.org>
---
 libxfs/xfs_fs.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)


diff --git a/libxfs/xfs_fs.h b/libxfs/xfs_fs.h
index 97996cb79..454b63ef7 100644
--- a/libxfs/xfs_fs.h
+++ b/libxfs/xfs_fs.h
@@ -996,7 +996,7 @@ struct xfs_getparents_by_handle {
 #define XFS_IOC_FSGEOMETRY	     _IOR ('X', 126, struct xfs_fsop_geom)
 #define XFS_IOC_BULKSTAT	     _IOR ('X', 127, struct xfs_bulkstat_req)
 #define XFS_IOC_INUMBERS	     _IOR ('X', 128, struct xfs_inumbers_req)
-#define XFS_IOC_EXCHANGE_RANGE	     _IOWR('X', 129, struct xfs_exchange_range)
+#define XFS_IOC_EXCHANGE_RANGE	     _IOW ('X', 129, struct xfs_exchange_range)
 /*	XFS_IOC_GETFSUUID ---------- deprecated 140	 */
 
 

