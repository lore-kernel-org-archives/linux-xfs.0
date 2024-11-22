Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 239107082F;
	Fri, 22 Nov 2024 16:53:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732294400; cv=none; b=CrZd+LjZiHMAkPSBfUfC2H20lmDc+w82vmgz58imWdFFdL2T4kfbxtbOnBG6OF1SsAsBL4KlE60B4MwnQjtVb3XY5vWQvVwnQIfplgLHDplkpB9GXRLJkw57Tk/ag8psqX2g+UBfUw5e6RmXyDE9IhHWDb9Eyq8kETmTrG84F2g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732294400; c=relaxed/simple;
	bh=BJP7oRpeUsyY8KQ7I8nt5/4GCsG2VhbI6uP5nDt1imE=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=N8aTrnrPSKCcrHHtoiy+yxALsOGjH94KPYtdkznxBjTcx7t7MewUY0bdD/Aww77UGuzp78fS8FEp/qhNfdQNnvYPJNCuMl4maTs7Yc4KxJcTV3MhcHHYPvueKzu7DX3qH0d6oYBVdIEG9nEczMmPY34zD4GPf3czCNrmWnyNlpE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jbHo0Y9+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jbHo0Y9+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B78D3C4CECE;
	Fri, 22 Nov 2024 16:53:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1732294399;
	bh=BJP7oRpeUsyY8KQ7I8nt5/4GCsG2VhbI6uP5nDt1imE=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=jbHo0Y9+A6VKjj9vFJ1U9PliycB6j7mX62K+V+SZWac22+OtQ//NvMhNTe+Dy6yUQ
	 zFHim74mB+uRRQN6aK2JPD5aL/PyXKj+F7zfrHglpLiSpA81hxOvgC93M59tCu3Yk4
	 tt5nUg3p4ULNppXWwTFuwI8IiJDOhFMfYt10qP17Q7xdKL9XDzrSEe0J2lFgZL5iWn
	 aRXqv4WkkSZM1X/h/+oV2ThtXvXX3DntyqYCYOWjnXxnf01Oz1RHuR1cfyh6UGlvKa
	 RkmzKn/9m78H7dtAEbXV2jY/wV4Ba7KGrLYGjyKXIJyHhrCu2e+rGo3m482OaayZz+
	 C2bmBT39rU2Dg==
Date: Fri, 22 Nov 2024 08:53:19 -0800
Subject: [PATCH 11/17] xfs/009: allow logically contiguous preallocations
From: "Darrick J. Wong" <djwong@kernel.org>
To: zlang@redhat.com, djwong@kernel.org
Cc: hch@lst.de, fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <173229420178.358248.14522170594906217361.stgit@frogsfrogsfrogs>
In-Reply-To: <173229419991.358248.8516467437316874374.stgit@frogsfrogsfrogs>
References: <173229419991.358248.8516467437316874374.stgit@frogsfrogsfrogs>
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
 

