Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BAD625A359;
	Tue, 21 Oct 2025 18:41:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761072109; cv=none; b=tmCsryeUIX0zJnZtKbJPtWScTs+Dxt7xKFE0eFbQcCcI45GBfwgik/2Eu4n21RYfcAoDQqrV8HvvPQfhhvi8DTOZ9oVENwECWfxLY5TBmoT+iD/3zajMmUNVZ7RQ+8N+UPIU7gWGMnm9+1TdIdvz7QKkKfwCmYKEzKR/TND+itc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761072109; c=relaxed/simple;
	bh=XMAlEMGOCdEdw2/F1k6y15m0Qqm/jWpu9QHTJhnlidg=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=WA5+wKNj3hC/vm+lhozi0/Yjsl5dyZ83VQ7s5tclK6gy+1vc6EMwKYeOIyFwfiPZNPsX3P7hWKTHy3o4EI8HRyacjTcIO9wynOa5fS0MGDVo2rHL4O66+XY62qcQKxHeDrjahanM4iLYqjZihLK7Kezeu7jaf9I3IqbJsevc0xE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=djNVkhxB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="djNVkhxB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53B25C4CEF1;
	Tue, 21 Oct 2025 18:41:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761072109;
	bh=XMAlEMGOCdEdw2/F1k6y15m0Qqm/jWpu9QHTJhnlidg=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=djNVkhxB3fgf8BwX+GxeXLGR/5eahjTaz8LOfpanJRLqvuRIN1cCUTepBu3xV35D/
	 ersL8S0Ab45UPT4jXkCEzReyQD0plizq2zV6yVyrWAO9+os8kGItErSuqs9r/YRvOu
	 /0PpBsn9Q7SF+o1pj65PPWp3+f0Bo6HEs7BvT0F0G9u6FuSlD2m8F/MYN9oz/K9oVx
	 HnuPWSsRR3Pz4gm25XwIACiUbkj7LE6Yc0YKlhnaN78u+yvNMDib9eiDx2RLR3xdPK
	 pxYnidHGz4Va3rbnv8GozrYtyb4usM4b7PTb/xlxNQSCP7VMiwx4C858VZwPyWNJF1
	 mZ4VqrZl7Nddg==
Date: Tue, 21 Oct 2025 11:41:48 -0700
Subject: [PATCH 10/11] check: line up stdout columns
From: "Darrick J. Wong" <djwong@kernel.org>
To: zlang@redhat.com, djwong@kernel.org
Cc: fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <176107188851.4163693.5236154684599011991.stgit@frogsfrogsfrogs>
In-Reply-To: <176107188615.4163693.708102333699699249.stgit@frogsfrogsfrogs>
References: <176107188615.4163693.708102333699699249.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

The output columns don't really line up:

generic/768       [not run] xfs_io pwrite doesn't support -A
ext4/049        6s
generic/325       [not run] fuse4fs does not support metadata journaling on fuse.ext4

Make them line up properly.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 check |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)


diff --git a/check b/check
index ce7eacb7c45d9e..2d089d351380d2 100755
--- a/check
+++ b/check
@@ -669,6 +669,10 @@ _stash_test_status() {
 	esac
 }
 
+# Figure out the maximum test name length, e.g. "generic/1212" => 12
+max_test_namelen=$(ls "$SRC_DIR"/*/* | \
+	awk 'BEGIN {x = 0} /\/[0-9]*$/ {l = length($0) - 6; if (l > x) x = l;} END {print x}')
+
 # Can we run systemd scopes?
 HAVE_SYSTEMD_SCOPES=
 systemctl reset-failed "fstests-check" &>/dev/null
@@ -880,7 +884,9 @@ function run_section()
 					     "" &> /dev/null
 		fi
 
-		echo -n "$seqnum"
+		# Print test name and leave the cursor at a consistent column
+		# number for later reporting of test outcome.
+		printf "%-*s" "$max_test_namelen" "$seqnum"
 
 		if $showme; then
 			if _expunge_test $seqnum; then

