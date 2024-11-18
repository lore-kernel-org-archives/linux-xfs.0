Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4208E198837;
	Mon, 18 Nov 2024 23:03:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731970993; cv=none; b=KowNR5Kr/pMTujqflZ+LM6MofFNNSE0wFKMUZJCGiIcPtrpOC93JQMiL1G0HFV6KAZPNJh+k9cY5nBpWwF28OF/jlhsOViXQNTDVHRWgjIK0cAIvP7e+o9WfoHVqAsHT9sEjQgAyx2FeJVZw04a+ZpPTrxEZTAAhCypUVZfJyT8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731970993; c=relaxed/simple;
	bh=Tv0atNFyjK31N3BhYZ1AIjk+ekfRIL2S8dEGie9pqvQ=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=UG2I3NX1Q/nJOvOzX11clBD1yDgwPdTk65d+C53e5CZFfw4XRGoPTL87y9Ff/E9p/4+/j77ZG3hZMMM8/Wcjmyu4XkgY5hWCCfsxlQ7jaCOSy0EJyY98s9WIOoVUzqLisv1xUo2Mxzyw73rg8RS1cv4Az7BJ7ToDON6rjArO4Pk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gx9xIB8O; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gx9xIB8O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 155F1C4CECF;
	Mon, 18 Nov 2024 23:03:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1731970993;
	bh=Tv0atNFyjK31N3BhYZ1AIjk+ekfRIL2S8dEGie9pqvQ=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=gx9xIB8OzGzVPj7XriRS9EwJVG1iil350f4bo/qzDeduJeF+gkvDuIaqNx1tv9S6p
	 ByRgfjds7Jjt/aX+6vcm9Hf0+waCoC+alQByDvIcf18jVchvvJSwvh2JaUZjeIHJ63
	 pHYRQXM1D9lnK0ZC5ZbzOQde61UtdYplLBMd5D8iMpPmo4MXY3f5I/u3Rg8I9L0Hbo
	 kq19ZkLm/pYf7XMPMfvbFq5YgTzhOtxeVsxSSJVXKcBotNsbk61qgRhHvFJAvNJ/6v
	 0Gn1I+1Gvk+6DpUU/DvoINWtBf1iVW+kJvht1AloUTNRq09lAm7DzaEabyOo5iU/7S
	 FxTD4zKJzc2MA==
Date: Mon, 18 Nov 2024 15:03:12 -0800
Subject: [PATCH 07/12] xfs/009: allow logically contiguous preallocations
From: "Darrick J. Wong" <djwong@kernel.org>
To: zlang@redhat.com, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Message-ID: <173197064532.904310.16393171518805565423.stgit@frogsfrogsfrogs>
In-Reply-To: <173197064408.904310.6784273927814845381.stgit@frogsfrogsfrogs>
References: <173197064408.904310.6784273927814845381.stgit@frogsfrogsfrogs>
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
 

