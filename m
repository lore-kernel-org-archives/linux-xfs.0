Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECC44148827
	for <linux-xfs@vger.kernel.org>; Fri,  6 Dec 2024 23:56:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733529411; cv=none; b=tUsk1UcG3PEZRQ4ZgwXqXJTmPctEWz7F1SzfpT+hZSZJWNd93xGeZ/G+uRrngAoa5W5oDLEhCxLYRZu6nCteB+z2t3DmLJLFUhkoZeAeAcX81VG40LGfCOaTIr7fP5/Ug+7oxgo3gEfwU5tBDV0Aq/2GBYTckzQJBHOUcDxkCL4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733529411; c=relaxed/simple;
	bh=bcOsnCCU0+ioyTyXsyHLCHWmFsplb/AZHSKR+X6z/bs=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=HNe6qFdt0sUTDda/p1jcbphKrZgGRWL7KQ1rWrFAxWvWa9PdcRh5oPXkjMOqA7xEjcQefFgRgPTAnYNagqya0q17tiDUP4rKyVPVxhEovlSCIkChOF7I0b4UtOG2wcnlQvPGSafWzTu5TrC+gctsiDV9OL6ulFDAakdVTdw9cGU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=e13MdV1v; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="e13MdV1v"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75498C4CED2;
	Fri,  6 Dec 2024 23:56:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733529410;
	bh=bcOsnCCU0+ioyTyXsyHLCHWmFsplb/AZHSKR+X6z/bs=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=e13MdV1vYXh4rsTa+NuKTf3bdFqHsieP3WVWaBc58u/D4rfvvfZpB8rMO4fO2jb7r
	 p9fPrteqKmrJLurJmG0/HuDeCO18Oy2Eh8B9kxtI/XfKYffJykbmAHgEaCaGl6GT+s
	 RVKv697Z0elZPz0Wz/8b1RavqZvL7ag74AJPoKosnkG2dVrUWFqAIam9AZ5f03oau0
	 ecwmlQvpYIr08f+nF8xjL0MUjY0xcvOyIzMkVkOK7Zkinb4TEuz9So6ya6LrSzgvUe
	 ZapiSE3z2aYpcTJgBmYOayrpUczi/Nsgt6+mZNSqvAbDJGewNI+vySCWBII0ndXvMf
	 +hJKGTVMAKbzw==
Date: Fri, 06 Dec 2024 15:56:50 -0800
Subject: [PATCH 21/46] xfs: encode the rtbitmap in big endian format
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: hch@lst.de, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173352750316.124560.15446416951033337147.stgit@frogsfrogsfrogs>
In-Reply-To: <173352749923.124560.17452697523660805471.stgit@frogsfrogsfrogs>
References: <173352749923.124560.17452697523660805471.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Source kernel commit: eba42c2c53c8b8905307b702c93dffef0719a896

Currently, the ondisk realtime bitmap file is accessed in units of
32-bit words.  There's no endian translation of the contents of this
file, which means that the Bad Things Happen(tm) if you go from (say)
x86 to powerpc.  Since we have a new feature flag, let's take the
opportunity to enforce an endianness on the file.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 libxfs/xfs_format.h   |    4 +++-
 libxfs/xfs_rtbitmap.h |    7 ++++++-
 2 files changed, 9 insertions(+), 2 deletions(-)


diff --git a/libxfs/xfs_format.h b/libxfs/xfs_format.h
index 016ee4ff537440..cd9457ed5873fe 100644
--- a/libxfs/xfs_format.h
+++ b/libxfs/xfs_format.h
@@ -709,10 +709,12 @@ struct xfs_agfl {
 
 /*
  * Realtime bitmap information is accessed by the word, which is currently
- * stored in host-endian format.
+ * stored in host-endian format.  Starting with the realtime groups feature,
+ * the words are stored in be32 ondisk.
  */
 union xfs_rtword_raw {
 	__u32		old;
+	__be32		rtg;
 };
 
 /*
diff --git a/libxfs/xfs_rtbitmap.h b/libxfs/xfs_rtbitmap.h
index 2286a98ecb32bb..f9c0d241590104 100644
--- a/libxfs/xfs_rtbitmap.h
+++ b/libxfs/xfs_rtbitmap.h
@@ -210,6 +210,8 @@ xfs_rtbitmap_getword(
 {
 	union xfs_rtword_raw	*word = xfs_rbmblock_wordptr(args, index);
 
+	if (xfs_has_rtgroups(args->mp))
+		return be32_to_cpu(word->rtg);
 	return word->old;
 }
 
@@ -222,7 +224,10 @@ xfs_rtbitmap_setword(
 {
 	union xfs_rtword_raw	*word = xfs_rbmblock_wordptr(args, index);
 
-	word->old = value;
+	if (xfs_has_rtgroups(args->mp))
+		word->rtg = cpu_to_be32(value);
+	else
+		word->old = value;
 }
 
 /*

