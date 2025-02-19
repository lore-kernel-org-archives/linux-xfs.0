Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB71517ADE8;
	Wed, 19 Feb 2025 00:49:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739926173; cv=none; b=YM7DFZH9vqxhmK6UArZTfRq8Ytborvy0A8iSRjklq/xFIvAyF8IRpNW785JlgGPfzmp7c08E6P0LluHNmtkbS1inIxE2d1A8E3/TFZ0xIzl+3gxmNnE/6oxEcMp/f3lWXMob/Pp8S/Blz0tk4IRv/vSQa7XPn5+K9F+RoD3UTSE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739926173; c=relaxed/simple;
	bh=dXn/8pkHFN0oDGpOwSmMICP48C+z/XVZiELIIfE7bQk=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=eNVzXZU5DDeaH4onUv4BEDhz7fXKWBfF40YElLC5yQCCV8DmmJQlqI4TjcM7N3qj6D//EVI9g6d6SXH8vTwFuMz7gVMNoatF/DyEFVIdBjT3UI979T171DLVyZr24ocoa2v2YeG7IqVo1Ntpg63HBqcY4j+yvhM1oqfwR6pP5QE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XkkxcnFi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XkkxcnFi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1EEC1C4CEE6;
	Wed, 19 Feb 2025 00:49:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1739926173;
	bh=dXn/8pkHFN0oDGpOwSmMICP48C+z/XVZiELIIfE7bQk=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=XkkxcnFiP9RZBJdxJWAkQWCHG3+MNhp0dFs2FT4fbuOh6+aetjRFG5ct6Qtk2Z09C
	 hKWlXk9hqd7Q8ee6qUTSEQ7OrmSKgFp+ATCtiLLNFKunGr4++JmBDHrQEdccEl4mYd
	 Oh5v7+Cwc5/h4lhcD78MxVdAY7LU03l37/UsdIjvxx98O4Y3MjqEj/FWlb737LtJX/
	 PFYfdz2htkzOd92V29NFDywR76HOs0ASr0UOejkCnoGzgl3Hzl1pqI7A9Qt0AJpw3y
	 svS4DCv3cF8Kn1u7XLii09KSPS3wPDG4F3pAW5XbL852SfaLQUBwbeprDRR9LyDbuh
	 8g7H4wAAmZTNw==
Date: Tue, 18 Feb 2025 16:49:31 -0800
Subject: [PATCH 2/2] dio_writeback_race: align the directio buffer to base
 page size
From: "Darrick J. Wong" <djwong@kernel.org>
To: zlang@redhat.com, djwong@kernel.org
Cc: fstests@vger.kernel.org, hch@lst.de, linux-xfs@vger.kernel.org,
 fstests@vger.kernel.org
Message-ID: <173992586646.4077946.4152131666050168978.stgit@frogsfrogsfrogs>
In-Reply-To: <173992586604.4077946.15594107181131531344.stgit@frogsfrogsfrogs>
References: <173992586604.4077946.15594107181131531344.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

There's no need to align the memory buffer for the direcio write to the
file allocation unit size; base page size will do.  This fixes the
following error when generic/761 is run against an XFS rt filesystem
with a 28k rtextsize:

 QA output created by 761
+failed to allocate aligned memory
+cat: /opt/foobar: No such file or directory
 Silence is golden

Cc: <fstests@vger.kernel.org> # v2025.02.16
Fixes: 17fb49493426ad ("fstests: add a generic test to verify direct IO writes with buffer contents change")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 src/dio-writeback-race.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)


diff --git a/src/dio-writeback-race.c b/src/dio-writeback-race.c
index 2d3156e5b0974a..cca7d0e3b94cc9 100644
--- a/src/dio-writeback-race.c
+++ b/src/dio-writeback-race.c
@@ -102,7 +102,7 @@ int main (int argc, char *argv[])
 		fprintf(stderr, "missing argument\n");
 		goto error;
 	}
-	ret = posix_memalign(&buf, blocksize, blocksize);
+	ret = posix_memalign(&buf, sysconf(_SC_PAGESIZE), blocksize);
 	if (!buf) {
 		fprintf(stderr, "failed to allocate aligned memory\n");
 		exit(EXIT_FAILURE);

