Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C54121E0DC3
	for <linux-xfs@vger.kernel.org>; Thu, 17 Oct 2024 19:06:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729191968; cv=none; b=oHHus5JR/a8gxSyugX79FZVAlsScXXmz31q+ucatD0JDHjx9HW2ovSxPq3eGpSk3lsuCd97QGkCSdK8v5sn3zLNXgiqzrkV0sQH/A9EJHBEcXEX9AITK/oYLa+nuIXq25q/mHmIRtlU1jMv3oIJYni7gRKUtPE9awoLEExJl8pA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729191968; c=relaxed/simple;
	bh=SxuTi0hY62G2t5zB85jSOqku0p2WQ9wrHbGwCLzRVAg=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=fHY/2EL7RarJfCYCOm9C0P80WXvqDr9aY+HSPT1syC9Lt1AWW1S8vq0Uw8LjJN+tkg4EwbDTIbcCCdBBDvX2IA15qyss0uQ2UdmXlOQ/pzgfYYm8A6ew/Lx18Fjts4sssf2OGnYHUf5Lwn2K0ZRPf0ENIIkhI9XlGGx2YhxzdOY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Vq+DLZEb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Vq+DLZEb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9136C4CEC3;
	Thu, 17 Oct 2024 19:06:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1729191968;
	bh=SxuTi0hY62G2t5zB85jSOqku0p2WQ9wrHbGwCLzRVAg=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=Vq+DLZEbJvsrY1rjgtCmBqb3O5ONG2L0vJD+FJoknWeHQujKUvmUzuW1onMgaSaw6
	 XwLKd2UYC2btRXmTAePHdWVYiOlNshn2I41B0gixAJX2ehBwayVQ0dDHAJIq87hf4W
	 RHapHBCiDNzqBThmLI+/fNb9au/OQau49xmPg9RDdZH8+U3qzA1uQnbZw8PPPOZEQp
	 lVOc580bTwQBp5pGQQufTmictC2RhUcqIzkmowqhI6B+fz7jzRkD6HAiYNrll5KGlu
	 X/5iCQFWos2A88nWMWaXT8waEKwogUvQ6nDfYyMMunAM1nu668wOMbjQqWEHP3hVEa
	 dc6H3Do+XIWig==
Date: Thu, 17 Oct 2024 12:06:08 -0700
Subject: [PATCH 13/34] xfs: encode the rtsummary in big endian format
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <172919071892.3453179.14627804052679866991.stgit@frogsfrogsfrogs>
In-Reply-To: <172919071571.3453179.15753475627202483418.stgit@frogsfrogsfrogs>
References: <172919071571.3453179.15753475627202483418.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Currently, the ondisk realtime summary file counters are accessed in
units of 32-bit words.  There's no endian translation of the contents of
this file, which means that the Bad Things Happen(tm) if you go from
(say) x86 to powerpc.  Since we have a new feature flag, let's take the
opportunity to enforce an endianness on the file.  Encode the summary
information in big endian format, like most of the rest of the
filesystem.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_format.h   |    4 +++-
 fs/xfs/libxfs/xfs_rtbitmap.h |    7 +++++++
 fs/xfs/scrub/rtsummary.c     |    5 +++++
 3 files changed, 15 insertions(+), 1 deletion(-)


diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
index cd9457ed5873fe..f56ff9f43c218f 100644
--- a/fs/xfs/libxfs/xfs_format.h
+++ b/fs/xfs/libxfs/xfs_format.h
@@ -719,10 +719,12 @@ union xfs_rtword_raw {
 
 /*
  * Realtime summary counts are accessed by the word, which is currently
- * stored in host-endian format.
+ * stored in host-endian format.  Starting with the realtime groups feature,
+ * the words are stored in be32 ondisk.
  */
 union xfs_suminfo_raw {
 	__u32		old;
+	__be32		rtg;
 };
 
 /*
diff --git a/fs/xfs/libxfs/xfs_rtbitmap.h b/fs/xfs/libxfs/xfs_rtbitmap.h
index f9c0d241590104..7be76490a31879 100644
--- a/fs/xfs/libxfs/xfs_rtbitmap.h
+++ b/fs/xfs/libxfs/xfs_rtbitmap.h
@@ -300,6 +300,8 @@ xfs_suminfo_get(
 {
 	union xfs_suminfo_raw	*info = xfs_rsumblock_infoptr(args, index);
 
+	if (xfs_has_rtgroups(args->mp))
+		return be32_to_cpu(info->rtg);
 	return info->old;
 }
 
@@ -312,6 +314,11 @@ xfs_suminfo_add(
 {
 	union xfs_suminfo_raw	*info = xfs_rsumblock_infoptr(args, index);
 
+	if (xfs_has_rtgroups(args->mp)) {
+		be32_add_cpu(&info->rtg, delta);
+		return be32_to_cpu(info->rtg);
+	}
+
 	info->old += delta;
 	return info->old;
 }
diff --git a/fs/xfs/scrub/rtsummary.c b/fs/xfs/scrub/rtsummary.c
index 8f3f69b26cad04..49fc6250bafcaa 100644
--- a/fs/xfs/scrub/rtsummary.c
+++ b/fs/xfs/scrub/rtsummary.c
@@ -151,6 +151,11 @@ xchk_rtsum_inc(
 	struct xfs_mount	*mp,
 	union xfs_suminfo_raw	*v)
 {
+	if (xfs_has_rtgroups(mp)) {
+		be32_add_cpu(&v->rtg, 1);
+		return be32_to_cpu(v->rtg);
+	}
+
 	v->old += 1;
 	return v->old;
 }

