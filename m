Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F4D914F9CC
	for <linux-xfs@vger.kernel.org>; Thu, 20 Jun 2024 23:14:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718925283; cv=none; b=XF2SG3BAmwN6Y28YEZ1zAI4hQqTBWyFRk0u24xsNQu2x4vvn1g4vMEZH1zo1PvEtEiblOnKKzs72dnia1jBmfX8FyIpOnmzpsnBBUzeJjm5skk7eNH77lF0caEvhHCnncZJ/zzAWbeTGDrQrWaShMr5BYCvUa2UmGMquqT15yTY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718925283; c=relaxed/simple;
	bh=BNI9+s72cbwfRYMugMXo+ZKBxHEwTWN2KXkTOBlDV6g=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=aLVK3S4E0IOt1SFcZqwOiqnzA5kos7MGXh0WGrrFxqEl5DIiveiDi/E3+s77l98OSgPO3TFL71XSPmsj5MKPcIKWF/88Cv6AYoOjFJudtCx2EDYMFT5rmHKLfUzQuU/D/xyBVkMZ9CXPb0kqKTXhpt53niMRNJa1+Xq0Ssc1csU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BokC0QPQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BokC0QPQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D031BC2BD10;
	Thu, 20 Jun 2024 23:14:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1718925282;
	bh=BNI9+s72cbwfRYMugMXo+ZKBxHEwTWN2KXkTOBlDV6g=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=BokC0QPQidQuMVM4t7ZOfGvolWqTidPX7kAQ9vV6RwrKse6uxtdXQbesQXrGonbwx
	 dBU+s88RQ/47BKF1XZg5Sh1AZkPk0KG+cqdJ7i/knCMxCAmsIIFGDkzuXxtX08TZkd
	 7xA0q2K2UGn8NL/wLZJvWvpRbQfuE8HlBAdt5+4N9R3N+hF5um20wE6bSVFLOwTO9H
	 BAJMdD9FKJPQPc2VIWV314rEytwFhbhBQSz3fTAEKYMl7aimiWP5kSRORhGf2TEnqz
	 Ao4DrS5VhIpo18Rw5JTrauC4w3f2w1KATWSFzgzc1seRLU8xNrbGTsBl+2qrgm2sFH
	 bYTKCX7rjzXpA==
Date: Thu, 20 Jun 2024 16:14:42 -0700
Subject: [PATCH 5/6] xfs: fix direction in XFS_IOC_EXCHANGE_RANGE
From: "Darrick J. Wong" <djwong@kernel.org>
To: hch@lst.de, chandanbabu@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <171892459317.3192151.14305994848485102437.stgit@frogsfrogsfrogs>
In-Reply-To: <171892459218.3192151.10366641366672957906.stgit@frogsfrogsfrogs>
References: <171892459218.3192151.10366641366672957906.stgit@frogsfrogsfrogs>
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

The kernel reads userspace's buffer but does not write it back.
Therefore this is really an _IOW ioctl.  Change this before 6.10 final
releases.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_fs.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)


diff --git a/fs/xfs/libxfs/xfs_fs.h b/fs/xfs/libxfs/xfs_fs.h
index 97996cb79aaa..454b63ef7201 100644
--- a/fs/xfs/libxfs/xfs_fs.h
+++ b/fs/xfs/libxfs/xfs_fs.h
@@ -996,7 +996,7 @@ struct xfs_getparents_by_handle {
 #define XFS_IOC_FSGEOMETRY	     _IOR ('X', 126, struct xfs_fsop_geom)
 #define XFS_IOC_BULKSTAT	     _IOR ('X', 127, struct xfs_bulkstat_req)
 #define XFS_IOC_INUMBERS	     _IOR ('X', 128, struct xfs_inumbers_req)
-#define XFS_IOC_EXCHANGE_RANGE	     _IOWR('X', 129, struct xfs_exchange_range)
+#define XFS_IOC_EXCHANGE_RANGE	     _IOW ('X', 129, struct xfs_exchange_range)
 /*	XFS_IOC_GETFSUUID ---------- deprecated 140	 */
 
 

