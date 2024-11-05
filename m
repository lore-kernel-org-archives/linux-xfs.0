Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FD4F18E023
	for <linux-xfs@vger.kernel.org>; Tue,  5 Nov 2024 22:33:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730845998; cv=none; b=iyjEsfqKxYIzx7ijn2t72t8GVuNzV7yp/7K4XyBzAOrT3xyMaQyOZ6an9NcYczNW6CoNCm2Wnj4lpN+SDQXj/wynrqImqSJwxU71rBuSWdyQPtt/cfn3CZQnk26OqFAj5bWs3u9lf9b4ej/t64eW+SRDcccDwQXXVXEYx00+lb8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730845998; c=relaxed/simple;
	bh=SxuTi0hY62G2t5zB85jSOqku0p2WQ9wrHbGwCLzRVAg=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=XtGKkRuLn2r8u38+oce12vRNNRgPca5iJffeEj1kMfGVcNrp4rbe0UmZcs3AjEKVwByX0NBfhvxdDXn1ZuknIYFXt/0PW18jdQ+PRylaB8+w/LoGYcACsOMU3tPCRn10fI3TKiLB6aMCplp5B1/MEJLMCvEkJLWtvau6VHN2ovI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DnNdx0bP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DnNdx0bP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF6BFC4CECF;
	Tue,  5 Nov 2024 22:33:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1730845997;
	bh=SxuTi0hY62G2t5zB85jSOqku0p2WQ9wrHbGwCLzRVAg=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=DnNdx0bPs33lWjXeOspYS1c1cKJXcTikIhx/VwESHMWKvylIP8Z/fmuddsj4krpl2
	 hajQ7rwx7p3Id0BHpGcenhf3GAbncEYFXw70ayu/wmC+UFPXxIVmQ4UeXbzhnp0Zfs
	 AsLQLKEU9B4IJo8J9oJsMsX+VqDLikQZafAfxZ/ZcsR+P4JZdCb++jY1LHALKJ13ZU
	 64ZYzPclKPH69Tva5YKMQJemotRR5EDItp8VRo0adwNSi/VRaR6RhWmlKbBlc+YgP1
	 4dMZD9wmbSLLVr2JWb0QZ9jd/1T+lV1xdCcea/0L9c1YURZs4JxfnpjqtQ4TIv1zfH
	 bq2wtwyTFiTag==
Date: Tue, 05 Nov 2024 14:33:17 -0800
Subject: [PATCH 13/34] xfs: encode the rtsummary in big endian format
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <173084398406.1871887.12706231219388339335.stgit@frogsfrogsfrogs>
In-Reply-To: <173084398097.1871887.5832278892963229059.stgit@frogsfrogsfrogs>
References: <173084398097.1871887.5832278892963229059.stgit@frogsfrogsfrogs>
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

