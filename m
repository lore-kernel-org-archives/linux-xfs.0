Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4592ACA5A;
	Tue, 26 Nov 2024 01:22:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732584174; cv=none; b=jGDPEKMVmTh4opaSdMRX4IaFm7yK+kRz0NixoGUuAg/aWbKzqubVvyOle6Uf7NfkvuOCIVKTqTc8/dk/EFDsG4fxtzKfHZvs/eBshwYpLsSuRWzfvwCOim+SBvwC0Ng7nCRqWTW3xtgbuOlpg9xHuaZtc4CYnRN/lKEGay/MOHc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732584174; c=relaxed/simple;
	bh=y8PpZm+HcG5jNGFNt/C/yNnVzaez8vzAR40bqTAe2d0=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=H3XhjmvRsHrhIovhbHUXSFiGk6XWRSw5Y0BxAJAyDsgcLJfdwyFGKyOmSxIl7NwGi5YeTW8ELJekqzxWetiBbffl/quKjS5SOlx1frmNIKLNYEPUnZxvwewtBLU5DAN8BbVPdGceiqqsJ38OfGBDRbwGekXb48VHte9FLrUYMa8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bW1k+MB8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bW1k+MB8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7A2AC4CECE;
	Tue, 26 Nov 2024 01:22:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1732584173;
	bh=y8PpZm+HcG5jNGFNt/C/yNnVzaez8vzAR40bqTAe2d0=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=bW1k+MB8Nq9X6oNUHt1pIKQ9xGDWYtyuRxjoHDgjoP6pcJlhAGwmG6EhdB6jmO8m+
	 rAXJEAKtQJO5qRNydK9K7Qvf7a4YA8AaJirUcC7i4JTzveKM5j2Q3jd2kmXmMwFsYy
	 J0okHyzF5qL0e6mBoW95piOAzG+OhadCSNrkRRY/omF66N7g2s+M+PVQojy4uxEShn
	 LOKzACgY9R0LZlOSA4SA2RXUP3Npf3yCkgLovJ/BdsudD9qSJZyJW8rEYUimDNtm9T
	 xy3TRyPI3lyG87/JW8pG95cfcerDdnuGAcF774QKmn4yb4CAZqWzL8AuG5gtpSh+4H
	 MCVqZF8wjjfVg==
Date: Mon, 25 Nov 2024 17:22:52 -0800
Subject: [PATCH 09/16] generic/251: use sentinel files to kill the fstrim loop
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, zlang@redhat.com
Cc: hch@lst.de, fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <173258395208.4031902.5911808012153746451.stgit@frogsfrogsfrogs>
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

Apparently the subshell kill doesn't always take, and then the test runs
for hours and hours because nothing stops it.  Instead, use a sentinel
file to detect when fstrim_loop should stop execing background fstrims.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 tests/generic/251 |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)


diff --git a/tests/generic/251 b/tests/generic/251
index b432fb11937911..d59e91c3e0a33a 100755
--- a/tests/generic/251
+++ b/tests/generic/251
@@ -125,12 +125,15 @@ fstrim_loop()
 			wait $fpid
 		fi
 		while [ $start -lt $fsize ] ; do
+			test -s $tmp.fstrim_loop || break
 			$FSTRIM_PROG -m ${minlen}k -o ${start}k -l ${step}k $SCRATCH_MNT &
 			fpid=$!
 			wait $fpid
 			start=$(( $start + $step ))
 		done
+		test -s $tmp.fstrim_loop || break
 	done
+	rm -f $tmp.fstrim_loop
 }
 
 function check_sums() {
@@ -188,6 +191,7 @@ find -P . -xdev -type f -print0 | xargs -0 md5sum | sort -o $tmp/content.sums
 
 echo -n "Running the test: "
 pids=""
+echo run > $tmp.fstrim_loop
 fstrim_loop &
 fstrim_pid=$!
 p=1
@@ -199,8 +203,10 @@ done
 echo "done."
 
 wait $pids
-kill $fstrim_pid
-wait $fstrim_pid
+truncate -s 0 $tmp.fstrim_loop
+while test -e $tmp.fstrim_loop; do
+	sleep 1
+done
 
 status=0
 

