Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AC9F6BB58;
	Thu, 20 Jun 2024 20:57:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718917079; cv=none; b=Vd8Amm9TITRxula23zBeKzBbwsg39JvUjD+fo5N6X+sKpVx2kULJ+MKr20xhTMFGQ5pO3SVcnsdZiXOEOHxwOMxmmNlcP6RwbLj5s5qyDLhzMJqRAY/mtSLQdDfS4kI5Jlmcxx0Q7i0kSlMXIapdE+imlZZ5G0QmujN0vo5lI1M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718917079; c=relaxed/simple;
	bh=cBn6zD2gwi6O3iHZGfgj6C7EYqbk/x9FJpyavpGY0N8=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=fzZqobCO7T6ydoM/jBSkcC+G7NsZf1ZFrju/J+e2fYinJTLRgz2t0IsgN56Egp9lqlp5s9oM9B3jk9FA1e7on0SgyLWRMehGsx9IlG7ZGJbADw85JpMQwhFgzCXGDcqPUZvrUwmTUHV1+TuB4Qb0tDHqJr3jKWq/Dh6JJesYAcI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LuKZkJV2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LuKZkJV2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6723C2BD10;
	Thu, 20 Jun 2024 20:57:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1718917078;
	bh=cBn6zD2gwi6O3iHZGfgj6C7EYqbk/x9FJpyavpGY0N8=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=LuKZkJV2pBwWGNBJLm5nBgx8tKvmr3l1CPpOR1qVz5qGVXgNGWNbl6PeFJBWV/2Ci
	 bkEAxnpktsZD3Ke43Hh9M12L8/HydyV/nwaavlCmVPiaR7qJErmBs9RZ0mpAOzt8oa
	 FPEoUs4NK4jksFi9vwn2QFexApDhmJe7g0ytNjDYuxiUSX3/0nVXQl632ChaDjqf4O
	 nKRXEDNDXS6mT1gvMNuykuCJu1cqPNTsKya9Mskx1QyA7L2DeRanbctxNlI4UcVFBy
	 GtMFXn6z3c9yJtZZ22/QzP66C5n7PeMegAJAEE0BkRXY7o8zFowlaAYEIUvFvXBmLL
	 GQDSYjwMAYCcQ==
Date: Thu, 20 Jun 2024 13:57:58 -0700
Subject: [PATCH 04/11] populate: create hardlinks for parent pointers
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, zlang@redhat.com
Cc: Christoph Hellwig <hch@lst.de>, fstests@vger.kernel.org,
 allison.henderson@oracle.com, catherine.hoang@oracle.com,
 linux-xfs@vger.kernel.org
Message-ID: <171891669701.3035255.7311693728768644513.stgit@frogsfrogsfrogs>
In-Reply-To: <171891669626.3035255.15795876594098866722.stgit@frogsfrogsfrogs>
References: <171891669626.3035255.15795876594098866722.stgit@frogsfrogsfrogs>
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

Create some hardlinked files so that we can exercise parent pointers.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 common/populate |   42 ++++++++++++++++++++++++++++++++++++++++++
 src/popdir.pl   |   11 +++++++++++
 2 files changed, 53 insertions(+)


diff --git a/common/populate b/common/populate
index 15f8055c2c..9fda19df06 100644
--- a/common/populate
+++ b/common/populate
@@ -464,6 +464,48 @@ _scratch_xfs_populate() {
 		cp --reflink=always "${SCRATCH_MNT}/REFCOUNTBT" "${SCRATCH_MNT}/REFCOUNTBT2"
 	fi
 
+	# Parent pointers
+	is_pptr="$(_xfs_has_feature "$SCRATCH_MNT" parent -v)"
+	if [ $is_pptr -gt 0 ]; then
+		echo "+ parent pointers"
+
+		# Create a couple of parent pointers
+		__populate_create_dir "${SCRATCH_MNT}/PPTRS" 1 '' \
+			--hardlink --format "two_%d"
+
+		# Create one xattr leaf block of parent pointers
+		nr="$((blksz * 2 / 16))"
+		__populate_create_dir "${SCRATCH_MNT}/PPTRS" ${nr} '' \
+			--hardlink --format "many%04d"
+
+		# Create multiple xattr leaf blocks of large parent pointers
+		nr="$((blksz * 16 / 16))"
+		__populate_create_dir "${SCRATCH_MNT}/PPTRS" ${nr} '' \
+			--hardlink --format "y%0254d"
+
+		# Create multiple paths to a file
+		local moof="${SCRATCH_MNT}/PPTRS/moofile"
+		touch "${moof}"
+		for ((i = 0; i < 4; i++)); do
+			mkdir -p "${SCRATCH_MNT}/PPTRS/SUB${i}"
+			ln "${moof}" "${SCRATCH_MNT}/PPTRS/SUB${i}/moofile"
+		done
+
+		# Create parent pointers of various lengths
+		touch "${SCRATCH_MNT}/PPTRS/vlength"
+		local len_len
+		local tst
+		local fname
+		ln "${SCRATCH_MNT}/PPTRS/vlength" "${SCRATCH_MNT}/PPTRS/b"
+		for len in 32 64 96 128 160 192 224 250 255; do
+			len_len="${#len}"
+			tst="$(perl -e "print \"b\" x (${len} - (${len_len} + 1))")"
+			fname="v${tst}${len}"
+			ln "${SCRATCH_MNT}/PPTRS/vlength" \
+				"${SCRATCH_MNT}/PPTRS/${fname}"
+		done
+	fi
+
 	# Copy some real files (xfs tests, I guess...)
 	echo "+ real files"
 	test $fill -ne 0 && __populate_fill_fs "${SCRATCH_MNT}" 5
diff --git a/src/popdir.pl b/src/popdir.pl
index e89095aafe..0104957a3c 100755
--- a/src/popdir.pl
+++ b/src/popdir.pl
@@ -17,6 +17,7 @@ GetOptions("start=i" => \$start,
 	   "dir=s" => \$dir,
 	   "remove!" => \$remove,
 	   "help!" => \$help,
+	   "hardlink!" => \$hardlink,
 	   "verbose!" => \$verbose);
 
 
@@ -35,6 +36,7 @@ Options:
   --format=str      printf formatting string for file name ("%08d")
   --verbose         verbose output
   --help            this help screen
+  --hardlink        hardlink subsequent files to the first one created
 EOF
   exit(1) unless defined $help;
   # otherwise...
@@ -56,12 +58,21 @@ if ($file_pct < 0) {
 	$file_pct = 100;
 }
 
+if ($hardlink) {
+	$file_pct = 100;
+	$link_fname = sprintf($format, $start);
+}
+
 for ($i = $start; $i <= $end; $i += $incr) {
 	$fname = sprintf($format, $i);
 
 	if ($remove) {
 		$verbose && print "rm $fname\n";
 		unlink($fname) or rmdir($fname) or die("unlink $fname");
+	} elsif ($hardlink && $i > $start) {
+		# hardlink everything after the first file
+		$verbose && print "ln $link_fname $fname\n";
+		link $link_fname, $fname;
 	} elsif (($i % 100) < $file_pct) {
 		# create a file
 		$verbose && print "touch $fname\n";

