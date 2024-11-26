Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0F15C133;
	Tue, 26 Nov 2024 01:22:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732584157; cv=none; b=kF+rKiZ9BmPG/gCo8HtZodPOK1HkXFpjXClGUjj11Is02RCAwea8djl+5GRCHCDTRIj7b211cjaJ+LL3Yi/cLTxEebZ26jh3OEZ2eGAd2C0mlE1Z3e/DCiU56dtS3fJhuZTLpoD/zOJ/M6HbWYDPQhVOdnQ/Z+QcVxzAJmAlllg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732584157; c=relaxed/simple;
	bh=BJP7oRpeUsyY8KQ7I8nt5/4GCsG2VhbI6uP5nDt1imE=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=MgEftrVhWkhO8JbFm6YMYIhogTeuWWgY0c7UP4j9Ga7+R//40xBq92oU5XRQEIFFOp4gFWXoFCIWOdep5cnpkBxOBytA69WLD+tMyR9wF4cBWxEOJoO2+NAXVOWgaUvMLL3nwodoptr7WiYWgogWdYoAOiO+cHWpfvwofHj3ePk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Hsi/eCWV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Hsi/eCWV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 956F3C4CECE;
	Tue, 26 Nov 2024 01:22:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1732584157;
	bh=BJP7oRpeUsyY8KQ7I8nt5/4GCsG2VhbI6uP5nDt1imE=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=Hsi/eCWVu4E5QA54G4IsZ4WDTKBHOrLe04+87jun6MxCZL++UmJg9LFDhJONonjPL
	 QAxQW9TyqYXJyxpC5xFc8MJdAZGmkyu6dlcSiZWQiU2W1wNJZPtcZ8aCslHKGbncsd
	 M57805tklgMFeiWn5uLLoSg7TjIbcAjPiSLIr1ldpHFK8/EbHOX5t3vrgTvbKEsmun
	 Pz36te/S3R/yhx/5baA8dgBckEy9yPgKhh6l7PCxXJ/iAY/PPvRgkBcfAWE6WbomYc
	 kPKACcFOwZVxX1nmy/mDvXRgZ79Y8ZBT8XM70iJmq5d7QZJP9Mif1Chh55U669waKn
	 DIQDtVh2I9quw==
Date: Mon, 25 Nov 2024 17:22:37 -0800
Subject: [PATCH 08/16] xfs/009: allow logically contiguous preallocations
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, zlang@redhat.com
Cc: hch@lst.de, fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <173258395193.4031902.6288465123347994448.stgit@frogsfrogsfrogs>
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

The new rtgroups feature implements a simplistic rotor to pick the
rtgroup for an initial allocation to a file.  This causes test failures
if the preallocations are spread across two rtgroups, which happens if
there are more subtests than rtgroups.

One way to fix this would be to reset the rotor then each subtest starts
allocating from rtgroup 0, but the only way to do that is to cycle the
scratch mount, which is a bit gross.

Instead, report logically contiguous mappings as a single mapping even
if the physical space is not contiguous.  Unfortunately, there's not
enough context in the comments to know if the test actually was checking
for physical contiguity?  Or if this is just an exerciser of the old
preallocation calls, and it's fine as long as the file ranges are mapped
(or unmapped) as desired.

Messing with some awk is a lot cheaper than umount/mount cycling.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 tests/xfs/009 |   29 ++++++++++++++++++++++++++++-
 1 file changed, 28 insertions(+), 1 deletion(-)


diff --git a/tests/xfs/009 b/tests/xfs/009
index dde505f079f4f8..bb42ce32490df5 100755
--- a/tests/xfs/009
+++ b/tests/xfs/009
@@ -49,13 +49,26 @@ _filesize()
 _block_filter()
 {
 	$AWK_PROG -v bsize="$bsize" '
+	BEGIN {
+		br_pos = 0
+		br_len = 0
+	}
+	function dump_blockrange() {
+		if (br_len == 0)
+			return
+		printf("        [%d,%d]: BLOCKRANGE\n", br_pos, br_len)
+		br_pos = 0
+		br_len = 0
+	}
 	/blocksize/ {
+		dump_blockrange()
 		printf("    blocksize BSIZE\n")
 
 		next
 	}
 
 	/CMD/ {
+		dump_blockrange()
 		split($3, off, "=")
 		offset = strtonum(off[2])
 		if (offset != -1)
@@ -72,6 +85,7 @@ _block_filter()
 	}
 
 	/MAP/ {
+		dump_blockrange()
 		split($2, off, "=")
 		offset = strtonum(off[2])
 		if (offset != -1)
@@ -90,6 +104,7 @@ _block_filter()
 	}
 
 	/TRUNCATE/ {
+		dump_blockrange()
 		split($2, off, "=")
 		offset = strtonum(off[2]) / bsize
 
@@ -99,16 +114,28 @@ _block_filter()
 	}
 
 	/\[[0-9]+,[0-9]+\]:/ {
-		printf("        %s BLOCKRANGE\n", $1)
+		rangestr = gensub(/\[([0-9]+),([0-9]+)\]:/, "\\1,\\2", "g", $1);
+		split(rangestr, off, ",")
+		if (br_pos + br_len == off[1]) {
+			br_len += off[2];
+		} else {
+			dump_blockrange()
+			br_pos = off[1];
+			br_len = off[2];
+		}
 
 		next
 	}
 
 	{
+		dump_blockrange()
 		print
 
 		next
 	}
+	END {
+		dump_blockrange()
+	}
 	'
 }
 

