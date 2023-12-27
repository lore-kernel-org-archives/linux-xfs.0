Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4526BBA37;
	Mon,  1 Jan 2024 00:47:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GbSZiNHb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0EB60C433C7;
	Mon,  1 Jan 2024 00:47:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704070038;
	bh=zlWQEVFfe4SiOucH/uZWNprbCKcl+wf5WGbGtjn3jv4=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=GbSZiNHbyz2yX0VdyCJd1NR08sS045m2C7EVNd7yVI4fg2JPdVPTveQxTioOpwOeA
	 AkQF8G+NxQ12XME52jDnwq9j9pvADKdb7iNE7okISrUcklwlKjVtM+i2fDwE9vKnCG
	 cGG4N8Ln+B8EoQL0oh7eNCJHo7ShZgBqqOj4xdnahfuMKmf9kBZH7RsWEO9VGGzvXK
	 PpLzPJXonlttBsIM8uiVstsDyl25q2CxGU9k3mc7ekKjB/PkSOwVwHl6XY4wQlaIx0
	 0O4iVUWzgwM6rcFU+yksgVNKv16SZo4z9AeBiOgexSRO9QOZ6/fBZo7ittb8dBEyPy
	 j6qf/rVsn+AIA==
Date: Sun, 31 Dec 2023 16:47:17 +9900
Subject: [PATCH 04/11] populate: create hardlinks for parent pointers
From: "Darrick J. Wong" <djwong@kernel.org>
To: zlang@redhat.com, djwong@kernel.org
Cc: fstests@vger.kernel.org, catherine.hoang@oracle.com,
 allison.henderson@oracle.com, guan@eryu.me, linux-xfs@vger.kernel.org
Message-ID: <170405028480.1824869.1614789435748683929.stgit@frogsfrogsfrogs>
In-Reply-To: <170405028421.1824869.17871351204326094851.stgit@frogsfrogsfrogs>
References: <170405028421.1824869.17871351204326094851.stgit@frogsfrogsfrogs>
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
---
 common/populate |   38 ++++++++++++++++++++++++++++++++++++++
 src/popdir.pl   |   11 +++++++++++
 2 files changed, 49 insertions(+)


diff --git a/common/populate b/common/populate
index 8097151919..83cd0eb5db 100644
--- a/common/populate
+++ b/common/populate
@@ -464,6 +464,44 @@ _scratch_xfs_populate() {
 		cp --reflink=always "${SCRATCH_MNT}/REFCOUNTBT" "${SCRATCH_MNT}/REFCOUNTBT2"
 	fi
 
+	# Parent pointers
+	is_pptr="$(_xfs_has_feature "$SCRATCH_MNT" parent -v)"
+	if [ $is_pptr -gt 0 ]; then
+		echo "+ parent pointers"
+
+		# Create a couple of parent pointers
+		__populate_create_dir "${SCRATCH_MNT}/PPTRS" 1 '' --hardlink --format "two_%d"
+
+		# Create one xattr leaf block of parent pointers
+		nr="$((blksz * 2 / 16))"
+		__populate_create_dir "${SCRATCH_MNT}/PPTRS" ${nr} '' --hardlink --format "many%04d"
+
+		# Create multiple xattr leaf blocks of large parent pointers
+		nr="$((blksz * 16 / 16))"
+		__populate_create_dir "${SCRATCH_MNT}/PPTRS" ${nr} '' --hardlink --format "y%0254d"
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
+			ln "${SCRATCH_MNT}/PPTRS/vlength" "${SCRATCH_MNT}/PPTRS/${fname}"
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

