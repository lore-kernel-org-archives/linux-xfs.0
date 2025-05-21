Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 382B51A317A;
	Wed, 21 May 2025 22:42:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747867344; cv=none; b=eG3it72GDOKKVBOEQ/pFlLdN/Bm+xkItQaHTbnokln4lfMCbFei+v7F9fIvEnAH1b/9uU8qrbDjaL5VmLSbw2IkT6EYrSIoZAuUh76/Y9HA2PoU28CWZJ+Ze0AeZcb/i1b8k4Ed0RtFBhPK2SCFG+tEet0ZRYekQra5+LE+NBPU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747867344; c=relaxed/simple;
	bh=xlhv+9bPoV78cO1mXtelHKkZwgwzKv23FBeU7uchEi4=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Aah5oAaD2arLNB/d1CUfwu7upygtIvtDj09qKvLZw+ig2U7Wa2Ka+LWhGtxvpcnLnRRooHXltS5bYnHaPhMXMDiSLKX9ECg/rz6zbddSkORHIkQUj6moneJCQa7LIowiWrZaUGoaB7Tk/VxhpqpFthePnkq/GdMuHtcNktX6h+g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Z8QLfLav; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Z8QLfLav"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD7B7C4CEE4;
	Wed, 21 May 2025 22:42:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1747867343;
	bh=xlhv+9bPoV78cO1mXtelHKkZwgwzKv23FBeU7uchEi4=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=Z8QLfLavYE4TeKsXa/5E04XBGqdHC9zoQVH5Wleupr+fS9TokMIksyWdq2m/imqzA
	 Fect5dnUjf0kvtbsBTa9DYFTFQLhMCHgzK+j72LgVqAoORm3bGeMa/4j52zZeSvL8J
	 HjMRVv2GVXjEtbWBA+ofE+ZIovLMVgjbL9WtOl977l55Hh/O/tkW+sbLYwcW4qNBCs
	 K8hW9QQGvnxvVV3xadPfJEyE3erdWIcJnDlEs/NeR8znBTgKe9R+gwbPnQsYXyqJqA
	 iaDDlg87rLgXd39PmcAgrGkP47wbRANkPwaQi5e+D1S2WkdSUf0O+74s+1EMByX3uZ
	 zSPRn+aW6yUTA==
Date: Wed, 21 May 2025 15:42:23 -0700
Subject: [PATCH 2/4] generic/251: skip this test if fstrim geometry detection
 fails
From: "Darrick J. Wong" <djwong@kernel.org>
To: zlang@redhat.com, djwong@kernel.org
Cc: fstests@vger.kernel.org, fstests@vger.kernel.org,
 linux-xfs@vger.kernel.org
Message-ID: <174786719732.1398933.6661596329740320998.stgit@frogsfrogsfrogs>
In-Reply-To: <174786719678.1398933.16005683028409620583.stgit@frogsfrogsfrogs>
References: <174786719678.1398933.16005683028409620583.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

There's no reason to wait until fstrim_loop to detect the length
constraints on the FITRIM call since failing to detect any constraints
just leads to _notrun.  Run that stuff from the top level scope so that
we don't start up a bunch of exercisers for no good reason.

Cc: <fstests@vger.kernel.org> # v2023.10.29
Fixes: 95b0db739400c2 ("generic/251: check min and max length and minlen for FSTRIM")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 tests/generic/251 |   11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)


diff --git a/tests/generic/251 b/tests/generic/251
index 644adf07cc42d5..1fb26f4caa3732 100755
--- a/tests/generic/251
+++ b/tests/generic/251
@@ -103,11 +103,6 @@ fstrim_loop()
 	# always remove the $tmp.fstrim_loop file on exit
 	trap "_destroy_fstrim; exit \$status" 2 15 EXIT
 
-	set_minlen_constraints
-	set_length_constraints
-	echo "MINLEN max=$FSTRIM_MAX_MINLEN min=$FSTRIM_MIN_MINLEN" >> $seqres.full
-	echo "LENGTH max=$FSTRIM_MAX_LEN min=$FSTRIM_MIN_LEN" >> $seqres.full
-
 	fsize=$(_discard_max_offset_kb "$SCRATCH_MNT" "$SCRATCH_DEV")
 
 	while true ; do
@@ -177,6 +172,12 @@ function run_process() {
 
 nproc=$((4 * LOAD_FACTOR))
 
+# Discover the fstrim constraints before we do anything else
+set_minlen_constraints
+set_length_constraints
+echo "MINLEN max=$FSTRIM_MAX_MINLEN min=$FSTRIM_MIN_MINLEN" >> $seqres.full
+echo "LENGTH max=$FSTRIM_MAX_LEN min=$FSTRIM_MIN_LEN" >> $seqres.full
+
 # Use fsstress to create a directory tree with some variability
 content=$SCRATCH_MNT/orig
 mkdir -p $content

