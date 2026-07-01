Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAF9B356775
	for <linux-xfs@vger.kernel.org>; Wed,  1 Jul 2026 14:51:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782917486; cv=none; b=nsncxVA4MbxnmMeWSv04r9akK6Bkhb6pG4syPho3tNtBCVPsdAEXu4v26SDdRP9eU7P/emrOePfl44ELr0K8U5ets1ypkWlGv8Z95G3c2/Z3hksz/1oAqb2KzZPL7Jd540U7WdUvF5WHg7YUChE9HkeG9XEpGKxoX2NrEMXlSGk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782917486; c=relaxed/simple;
	bh=gowKhwTtw/CXkZHltqwqQfro3NoZnPc8s3Yq2CmhoPo=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=In8OUUSg60RdKspCCPfVKxyGhXLXxgvI8yAS1Rw7KF3bTbMFaKyUeCxnG2+wGlNp0pkTd5W8Wao1u7KvKE5MvA5xekvTR0KN1TmXxCRtgNsJ1od/TNnSTPiv8dJyTZSG3u5/HGwiv9lXuFr1FEACmnifsJ2KNhOr0bWM+7JwoCA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Mw1hKa9P; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Mw1hKa9P"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 7AC021F000E9;
	Wed,  1 Jul 2026 14:51:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782917485;
	bh=3VPCKo7H29KMKaKHz/Z/7QdyNhft1l4CTmjU2lNi0mE=;
	h=Date:From:To:Cc:Subject;
	b=Mw1hKa9PlPhe7uIVkX/4NOfW1n0LxV4gAf8Uh6vI0jAi0uniT+eH94np/x8K5YUBp
	 XQW/oPXMubN+e4GYgAlumZpR09nLMuXU01sJIaA2yr8OcOnwmfwZ75/lr81C3BMj9b
	 3E0fRB1KvnfwFpUnTJ3FbmVfWamw6wslCblIwVkdqcHoaIWjkcUMjbeWPB5DkXftfD
	 nmJGFlkgD29kTbrzCF6PAVlvmVrCyI+c9yoPeJWk/1tV6DlWfcpeAPK6eQCLCB8Jgu
	 ZU2G3ang35a32WZT5A5luTkaYqQfruUsSQrvZ8Q0JrOv4nPFyL9J3WDroIE5GpOFA7
	 LsoCOe5uif4SQ==
Date: Wed, 1 Jul 2026 07:51:24 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Subject: [PATCH] xfs_scrub: fix spacemap scan for internal rt devices
Message-ID: <20260701145124.GE6526@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

From: Darrick J. Wong <djwong@kernel.org>

The scrub media scan on a filesystem with an internal rt volume still
fails with:

 # xfs_scrub -dTvnx /mnt
 Phase 6: Verify data file integrity.
 Error: dev 7:0 rtgroup 1 fsmap: Invalid argument. (spacemap.c line 162)
 Error: dev 7:0 rtgroup 0 fsmap: Invalid argument. (spacemap.c line 162)
 Info: /mnt: Scrub aborted after phase 6. (xfs_scrub.c line 522)

(this was from xfs/586)

When I tried to add support for internal rt devices in commit
37591ef3f4f14c ("xfs_scrub: support internal RT device"), I forgot that
fsmap reports physical offsets into the underlying block device, and
therefore expects the query keys to reflect that.  Put another way, to
scan a single rtgroup, one must add @rtstart to the fmr_physical field
of the query keys.

This hasn't been reported until now because we inadvertently also
disabled spacemap scans of internal rt volumes until commit
3e4bb144f657b1 ("xfs_scrub: handle media scans of internal rt devices
correctly").

Cc: <linux-xfs@vger.kernel.org> # v6.15.0
Fixes: 37591ef3f4f14c ("xfs_scrub: support internal RT device")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
sorry, I missed this one earlier :(
---
 scrub/spacemap.c |   13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/scrub/spacemap.c b/scrub/spacemap.c
index 45ac61d0942ccb..65d716374c9eb3 100644
--- a/scrub/spacemap.c
+++ b/scrub/spacemap.c
@@ -148,6 +148,19 @@ scan_rtg_rmaps(
 	keys[1].fmr_offset = ULLONG_MAX;
 	keys[1].fmr_flags = UINT_MAX;
 
+	/*
+	 * fsmap for an internal rt volume treats physical ranges as offsets
+	 * into the underlying block device.  Shift the query range up by
+	 * @rtstart here to skip the synthetic "internal filesystem" fsmap.
+	 */
+	if (ctx->mnt.fsgeom.rtstart) {
+		uint64_t	offset = ctx->mnt.fsgeom.rtstart *
+					 ctx->mnt.fsgeom.blocksize;
+
+		keys[0].fmr_physical += offset;
+		keys[1].fmr_physical += offset;
+	}
+
 	if (sbx->aborted)
 		return;
 
