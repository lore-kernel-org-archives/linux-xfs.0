Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3E0757314
	for <linux-xfs@vger.kernel.org>; Tue, 26 Mar 2024 03:21:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711423266; cv=none; b=LOvyGbtC0jiGEZQYfH4bnoqGekUiBQihtGgMzd5UgCvt80teluYMfmxXgjrNndLq3ZYDi3ldhB0K9moOF0TQMUu0ampUUqEMh1SKAXeDRoeqY7ZXCxz1a09cgMEG0vfCtSvlMrNPtkUPTKVKyOEZaRjlQdurhEDhNR3LCb3a8Nc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711423266; c=relaxed/simple;
	bh=0UuG4vBXbmEaGS75OK71jjzeajtHGu0L/38i5RTAgnQ=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=CWWJ7u2lSbsz6+LVXnEo2YG3lh2IlGRQH0HOjbvwNPGaxaIbZty/8i9HmEOtldFTI7ETMIze2Mkxdgk64eAPI1WDsQVncydcuj4oe0SxtR/tNcey42kuPyBow0uex5URM5iCgr+KUetdfcGBRcLPeVzHxJzrD2/fUQEsBOiGdp8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jEmplHkV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jEmplHkV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA33DC433C7;
	Tue, 26 Mar 2024 03:21:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711423266;
	bh=0UuG4vBXbmEaGS75OK71jjzeajtHGu0L/38i5RTAgnQ=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=jEmplHkVq+UtJrMHgPTY7UX1DHgo39odtyRjureMwpG8MgznsnbZyNNxdEWQQwLau
	 9PSlZBjB4ayt9wSa1HWb0Goups2Mv32LPqP22KsZfb9hGqVOIAI3Qy5KTxjFJer4Jg
	 IZkE9GGN1rnyS2v+940EBYEgpK671Y1Ze6TS7JTkwYCiAr9dNS6L2I8xSP0Pznl2p9
	 VCXsSvcQMpv9OBo+751M+w3KF7BSEQ7gB2FOQJ8Yk4Xs3FZfmLBuzppib+k7o7Ja6z
	 3367JVbrjQhMMwy1Jmz1etvc6gp5sk8mzPq10pQ6+eGISYXJtdGHeOaT7Dl4loqbqa
	 yESMrcgz9YvUQ==
Date: Mon, 25 Mar 2024 20:21:06 -0700
Subject: [PATCH 1/5] xfs_repair: double-check with shortform attr verifiers
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, Bill O'Donnell <bodonnel@redhat.com>,
 linux-xfs@vger.kernel.org
Message-ID: <171142128580.2214086.15436408247764490018.stgit@frogsfrogsfrogs>
In-Reply-To: <171142128559.2214086.13647333402538596.stgit@frogsfrogsfrogs>
References: <171142128559.2214086.13647333402538596.stgit@frogsfrogsfrogs>
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

Call the shortform attr structure verifier as the last thing we do in
process_shortform_attr to make sure that we don't leave any latent
errors for the kernel to stumble over.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Bill O'Donnell <bodonnel@redhat.com>
---
 repair/attr_repair.c |   17 +++++++++++++++++
 1 file changed, 17 insertions(+)


diff --git a/repair/attr_repair.c b/repair/attr_repair.c
index 01e4afb90d5c..f117f9aef9ce 100644
--- a/repair/attr_repair.c
+++ b/repair/attr_repair.c
@@ -212,6 +212,7 @@ process_shortform_attr(
 {
 	struct xfs_attr_sf_hdr		*hdr = XFS_DFORK_APTR(dip);
 	struct xfs_attr_sf_entry	*currententry, *nextentry, *tempentry;
+	xfs_failaddr_t			fa;
 	int				i, junkit;
 	int				currentsize, remainingspace;
 
@@ -373,6 +374,22 @@ process_shortform_attr(
 		}
 	}
 
+	fa = libxfs_attr_shortform_verify(hdr, be16_to_cpu(hdr->totsize));
+	if (fa) {
+		if (no_modify) {
+			do_warn(
+	_("inode %" PRIu64 " shortform attr verifier failure, would have cleared attrs\n"),
+				ino);
+		} else {
+			do_warn(
+	_("inode %" PRIu64 " shortform attr verifier failure, cleared attrs\n"),
+				ino);
+			hdr->count = 0;
+			hdr->totsize = cpu_to_be16(sizeof(struct xfs_attr_sf_hdr));
+			*repair = 1;
+		}
+	}
+
 	return(*repair);
 }
 

