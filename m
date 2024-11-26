Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F759DDA8;
	Tue, 26 Nov 2024 01:23:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732584205; cv=none; b=Th0inF8tGqD8KDMBTJLvU6ON/iwlvJgov/vAnTJ9pgV2wMBXOg+N+LVfHhuoK5yLBfXL18CCauTrhRSq2/hWFjRonxYHIYbNoqvV2OZ3O+uclmPoXSca7TAycIsE7mWqTcxyXo1oR3+kCG2CA15FRbR+wltjzRQ4MKMEFvAqBSg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732584205; c=relaxed/simple;
	bh=6CIUbx8kSjo0l3eG7u1gtvJLaK57xysVRS1XG42qpEs=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=omIhybGNtWH8J40p8B9Es0NKUHoJ/oTyhTIRal/KIVs9GrPy/EQSMslbDrE6gTZCG/2BluTDdLy4spfjBST9yLJf+/GQSq2sn/ZDpIOis1icCdMlk44a8/9pdygw8uJn116C/Jbq58Xm0eEVuPQhjyyshK8rU6nWD6Ncf6j/YzQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iyHkTMtO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iyHkTMtO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22D6DC4CECE;
	Tue, 26 Nov 2024 01:23:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1732584205;
	bh=6CIUbx8kSjo0l3eG7u1gtvJLaK57xysVRS1XG42qpEs=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=iyHkTMtOA0E5SUgrWBnPzaqNN7NhG0Bwrcznd9fZDqb+sfsgjrVLgTh31SaJXFdH4
	 NKMCn443RA8kCoLM3+94+fV7cUmY6VLFlygxbrVdZv5cZ1TvSF+An79TgZc0ImX3S+
	 LEg0jhiTBaq7nLJLgBgofe0nelADKHjuoxj2+tChcDeHbDBttn0S5Va9L15w/KoysM
	 yx5hAEGll/bKAr0EPqyo9gXAvyNhAoYV61uPbLyIV1zCclh/26GCal34NRTqM2hU//
	 aGZTtZaPhkITaJNAUpClRqrl/tQIGBq6UnixIgCanZ5JxzzdiiuHlnUhuzsz4uuH6H
	 XbkGlWiDX0X4w==
Date: Mon, 25 Nov 2024 17:23:24 -0800
Subject: [PATCH 11/16] generic/251: don't copy the fsstress source code
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, zlang@redhat.com
Cc: hch@lst.de, fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <173258395238.4031902.16373799205312238046.stgit@frogsfrogsfrogs>
In-Reply-To: <173258395050.4031902.8257740212723106524.stgit@frogsfrogsfrogs>
References: <173258395050.4031902.8257740212723106524.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Run fsstress for a short time to generate test data to replicate on the
scratch device so that we don't blow out the test runtimes on
unintentionally copying .git directories or large corefiles from the
developer's systems, etc.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 tests/generic/251 |    8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)


diff --git a/tests/generic/251 b/tests/generic/251
index b4ddda10cef403..ec486c277c6828 100755
--- a/tests/generic/251
+++ b/tests/generic/251
@@ -173,13 +173,11 @@ function run_process() {
 
 nproc=$((4 * LOAD_FACTOR))
 
-# Copy $here to the scratch fs and make coipes of the replica.  The fstests
-# output (and hence $seqres.full) could be in $here, so we need to snapshot
-# $here before computing file checksums.
+# Use fsstress to create a directory tree with some variability
 content=$SCRATCH_MNT/orig
 mkdir -p $content
-cp -axT $here/ $content/
-
+FSSTRESS_ARGS=$(_scale_fsstress_args -p 4 -d $content -n 1000 $FSSTRESS_AVOID)
+$FSSTRESS_PROG $FSSTRESS_ARGS >> $seqres.full
 mkdir -p $tmp
 
 (

