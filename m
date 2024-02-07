Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B77D4DDAD;
	Wed,  7 Feb 2024 02:18:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707272320; cv=none; b=I0LU/3dampwyUQQqR5yRcnbOOlfVcd1+iVHR73FMWRjy/SI0+nbKjDbG0Mm+MorjPNHo9jgBKbQnphnyQtaF+TEEZGg5GiOih7352wUg2vO/0sz58j3H3aJ3mVWHkSYYI6Uzq5oVicNsGd4Te4Vb6qT7tWMjAj9+5yg5pvmYZvw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707272320; c=relaxed/simple;
	bh=fs+/6X504QXUZiSdF82CtLw9I4//7aorGeisV9NNaoc=;
	h=Subject:From:To:Cc:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=QjSx5MBM0Ey877l+JcJ/lsdvfTXTnpMt0zMGwka1ow7i2rZpqgssnq0TW4MuMQMlmcwfwXRaD76jlRErSLHQ9SSDC7iZN9yl8NkmEGnl8Gqbsk1MA9uk5FdyE4ZBHl2rvJ/MeB8sUk69p+KeMt+V16TakczLc5niDm3qyUxfB9Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=pjkUwKFm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="pjkUwKFm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2600BC433C7;
	Wed,  7 Feb 2024 02:18:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1707272320;
	bh=fs+/6X504QXUZiSdF82CtLw9I4//7aorGeisV9NNaoc=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
	b=pjkUwKFmlCOwkJt+N+xl6sCbpaJfvlGXcKQi0Fk0bOpyQD+JK3lfy8c9aH7eV2r39
	 aE3JcprgS+qixtCvzU0/pVBFtH3/nclmNJNASnnHhd3Y2Qw6L/3/UomM5XJGKkmNVH
	 agF1T+cA4X1llxh5oS8fgdrXQC8RVEWi8OmcpLO3soGKwJ9RKwkqQrswa7p8G3PHBX
	 Ra+0+KMz8DC+7Rbq1MxI/9tLwRmgZ+1ontZ3106YYaCM6iK9+iK00krojCZ4+MQ2/z
	 qS0gI/ioBas9tj6S1a5IQLn3Ql0Ca7siTpkPrzJJrNJSZeul+Y6C1Z7Ff2zTTwdQN3
	 rAOUIBIycV/rw==
Subject: [PATCH 01/10] generic/256: constrain runtime with TIME_FACTOR
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, zlang@redhat.com
Cc: Andrey Albershteyn <aalbersh@redhat.com>, Christoph Hellwig <hch@lst.de>,
 Zorro Lang <zlang@kernel.org>, linux-xfs@vger.kernel.org,
 fstests@vger.kernel.org, guan@eryu.me
Date: Tue, 06 Feb 2024 18:18:39 -0800
Message-ID: <170727231958.3726171.771566828109380255.stgit@frogsfrogsfrogs>
In-Reply-To: <170727231361.3726171.14834727104549554832.stgit@frogsfrogsfrogs>
References: <170727231361.3726171.14834727104549554832.stgit@frogsfrogsfrogs>
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

This test runs 500 iterations of a "fill the fs and try to punch" test.
Hole punching can be particularly slow if, say, the filesystem is
mounted with -odiscard and the DISCARD operation takes a very long time.
In extreme cases, I can see test runtimes of 4+ hours.

Constrain the runtime of _test_full_fs_punch by establishing a deadline
of (30 seconds * TIME_FACTOR) and breaking out of the for loop if the
test goes beyond the time budget.  This keeps the runtime within the
customary 30 seconds.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Andrey Albershteyn <aalbersh@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Zorro Lang <zlang@kernel.org>
---
 tests/generic/256 |    7 +++++++
 1 file changed, 7 insertions(+)


diff --git a/tests/generic/256 b/tests/generic/256
index 808a730f3a..ea6cc2938a 100755
--- a/tests/generic/256
+++ b/tests/generic/256
@@ -44,6 +44,8 @@ _test_full_fs_punch()
 	local file_len=$(( $(( $hole_len + $hole_interval )) * $iterations ))
 	local path=`dirname $file_name`
 	local hole_offset=0
+	local start_time
+	local stop_time
 
 	if [ $# -ne 5 ]
 	then
@@ -57,6 +59,9 @@ _test_full_fs_punch()
 		-c "fsync" $file_name &> /dev/null
 	chmod 666 $file_name
 
+	start_time="$(date +%s)"
+	stop_time=$(( start_time + (30 * TIME_FACTOR) ))
+
 	# All files are created as a non root user to prevent reserved blocks
 	# from being consumed.
 	_fill_fs $(( 1024 * 1024 * 1024 )) $path/fill $block_size 1 \
@@ -64,6 +69,8 @@ _test_full_fs_punch()
 
 	for (( i=0; i<$iterations; i++ ))
 	do
+		test "$(date +%s)" -ge "$stop_time" && break
+
 		# This part must not be done as root in order to
 		# test that reserved blocks are used when needed
 		_user_do "$XFS_IO_PROG -f -c \"fpunch $hole_offset $hole_len\" $file_name"

