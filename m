Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36C7CEEA5;
	Tue, 18 Jun 2024 00:50:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718671825; cv=none; b=oMKZ7eo8iILWaEou5cfRi9q2Xe/MoFPmuECI/ZM3vqzu9QP1Ec0Fxo2e9GAb7FVLmlA5LGpl2uPxFzmJM5rPLPc4SdFX0981PHyS6D7VHicL7GmTYcqnrA1pumXbbtF+gaP0ezp7RpEscsnydizhr0I3MqFLFJ12BL0pTZOEvqA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718671825; c=relaxed/simple;
	bh=PTS8KGIbOjHV0MWUtnWTjBYpC23r74kbpGfhKWqeRO4=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=YWBxSm92fYa6XNIGq33DPme6uQzQIOoDDNOnMeRiempj4/D9GKGwyJP66ppF4Aq5r3B/IMR0spAFjlCwnLKgpEMBF2Hp+Q/tZWaoT/DZCE4PAfcAwQO+QxtXX2h4zLyK8Z6FTilxkB8Q5rWUBEkg8MuB0IWHQVNbL3boFxu2TMg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TAkHIjMk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TAkHIjMk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03B49C2BD10;
	Tue, 18 Jun 2024 00:50:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1718671825;
	bh=PTS8KGIbOjHV0MWUtnWTjBYpC23r74kbpGfhKWqeRO4=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=TAkHIjMkdZINyJH85juohFblI1/6f3cWKjxFNLLXjWaScCH/hb1PKJj0A0paQACk5
	 Wnzsz1iys20NOJFdWD8R9a7BD36yRSVO2aL3o6tmK8K7pi+LHyyRHzMR2I+5sOEpTf
	 C73TMLN0FWytJ4ZQdcHCbhKzzY5YKUko3QvP0NW3dBLR7bQhSuk3l3yUJ1OJyc9Y65
	 ZmklNmHMncJ9CGfTQPA7eaE9SNXK008kOMUg9S80gh/RxlfzTfJXFejzfO4GwmOIsO
	 OKHeuXgiG7XVH5V6k3Gb9bAWxHpwvBYJnBq4LK1x95Ouo4TKD+MiMcD1kIEZmLNXVx
	 ctAe0YX28zK4Q==
Date: Mon, 17 Jun 2024 17:50:24 -0700
Subject: [PATCH 04/11] populate: create hardlinks for parent pointers
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, zlang@redhat.com
Cc: fstests@vger.kernel.org, guan@eryu.me, linux-xfs@vger.kernel.org,
 allison.henderson@oracle.com, catherine.hoang@oracle.com
Message-ID: <171867145868.793846.6556224145030803204.stgit@frogsfrogsfrogs>
In-Reply-To: <171867145793.793846.15869014995794244448.stgit@frogsfrogsfrogs>
References: <171867145793.793846.15869014995794244448.stgit@frogsfrogsfrogs>
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
index 15f8055c2c..d80e78f386 100644
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

