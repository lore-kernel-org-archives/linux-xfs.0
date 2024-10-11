Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB5997464
	for <linux-xfs@vger.kernel.org>; Fri, 11 Oct 2024 01:05:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728608704; cv=none; b=oCAjL0dFfdvURLgIyElCl0edgc36vbNhI6trpNbX88d+1Wizf/spP51fEBuhoNg5HXK+d6XWK9cq1YjEyK5w3oxCrSaZ6A/yqY8KHUv5mliVtZD8T5omUF/gDygIMzlAloq+Vj6lLQcg5Eepn765yrfbwVI6Ypk8I5QWt954Qr4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728608704; c=relaxed/simple;
	bh=62lqbP8dTPFwJz2OF/EYS2YnCxj8w3U1IbSCO5TVuHw=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=kR1WKZ1IYIpW+c4+dsXRmr3watecXOWgYvwQAUK/eAq26zvp6duA8hxF+sq+SQx1uw21rySpa7cFBAQgn6seh3cb8d2OltWanvk5mrEFeiPb1nAbDpR5lLTIygWmYhW+tkL0MgUG1p89KeGOjplNITXwzqmBou2n/aN7oUYFaWo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GzP6rtVH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GzP6rtVH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8C73C4CEC5;
	Fri, 11 Oct 2024 01:05:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1728608704;
	bh=62lqbP8dTPFwJz2OF/EYS2YnCxj8w3U1IbSCO5TVuHw=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=GzP6rtVH2Eef36UW/vdQ3sJZkaPwZeySF/GO9Te7Eyg0iP55xU1qPAkHh5ETosCA/
	 F483nw3TzQPelrA3Y4V07zmdQyVswdBQQ6oC/RGsKTHsElojtQn1OjK2vu6QsC3mpc
	 tMhmMxQ1PNoTmCFRPbM+USE34QVU9bksUVLNZjDiCTfjww4Ctovp+9Q3J/JjuRPMbi
	 lot6c2ur9cCvC1iT83bTQvemvw/pfpoZ3H6H2IRTyKePZISfL2fxCyS0+5kljLBjru
	 e0b308KdVJXQm2S22XFmV/jwHT1/jdphCUMcG1ksY/lGcfs4NdGQqbZPQj3rZWFatF
	 DsTXVfVkoU3Kg==
Date: Thu, 10 Oct 2024 18:05:04 -0700
Subject: [PATCH 13/36] xfs: encode the rtsummary in big endian format
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <172860644465.4178701.13150981194165543095.stgit@frogsfrogsfrogs>
In-Reply-To: <172860644112.4178701.15760945842194801432.stgit@frogsfrogsfrogs>
References: <172860644112.4178701.15760945842194801432.stgit@frogsfrogsfrogs>
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
index 728e3cf5ad3221..2462f128955cad 100644
--- a/fs/xfs/libxfs/xfs_format.h
+++ b/fs/xfs/libxfs/xfs_format.h
@@ -746,10 +746,12 @@ union xfs_rtword_raw {
 
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

