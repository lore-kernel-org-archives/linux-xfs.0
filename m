Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00BD7224E8;
	Wed, 13 Dec 2023 22:34:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eL3qIiF5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66805C433C9;
	Wed, 13 Dec 2023 22:34:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1702506874;
	bh=89Fy9l4esXv0SvZBb/ocuRDW3q9+FBxPqtqzwWY3WpE=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
	b=eL3qIiF5b/sVRE9ge0fSer6M87vnUYBpDKKCehTZkGhG7ESqMIYrWmk3O5xvB7C1i
	 OEQDPo2eJ3RwH5lgS7dfDMz3W8MT+KGgJdbAxXAN06eh1pYnWpD4TzarA+O0c3lweP
	 KCSVInDuU736neoURk1JHfHHMvfZkBtD7ArFb8eVG1++BV+HYEg/iLiCnau7Bgk/8Z
	 kalD5yrSallnLHXCFxj8K9Oh81XeekVZb9+sKr+CoZf5DO1Jk6iv/1UzwYjhCRe0F5
	 bUbB2lM5EJLxbiWR8Z0z80+ptrXjQIdFcxXOjRzQhqc9wTknWAHhfWu5l6JxFeQ54s
	 L6mKsNABqQRZg==
Subject: [PATCH 1/3] generic/615: fix loop termination failures
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, zlang@redhat.com
Cc: guan@eryu.me, fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Date: Wed, 13 Dec 2023 14:34:33 -0800
Message-ID: <170250687380.1363584.4078567385149829394.stgit@frogsfrogsfrogs>
In-Reply-To: <170250686802.1363584.16475360795139585624.stgit@frogsfrogsfrogs>
References: <170250686802.1363584.16475360795139585624.stgit@frogsfrogsfrogs>
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

On 6.7-rc2, I've noticed that this test hangs unpredictably because the
stat loop fails to exit.  While the kill $loop_pid command /should/ take
care of it, it clearly isn't.

Set up an additional safety factor by checking for the existence of a
sentinel flag before starting the loop body.  In bash, "[" is a builtin
so the loop should run almost as tightly as it did before.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 tests/generic/615 |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)


diff --git a/tests/generic/615 b/tests/generic/615
index 4979306d56..9411229874 100755
--- a/tests/generic/615
+++ b/tests/generic/615
@@ -21,11 +21,10 @@ _require_odirect
 
 stat_loop()
 {
-	trap "wait; exit" SIGTERM
 	local filepath=$1
 	local blocks
 
-	while :; do
+	while [ -e "$loop_file" ]; do
 		blocks=$(stat -c %b $filepath)
 		if [ $blocks -eq 0 ]; then
 		    echo "error: stat(2) reported zero blocks"
@@ -39,6 +38,8 @@ _scratch_mount
 
 $XFS_IO_PROG -f -s -c "pwrite -b 64K 0 64K" $SCRATCH_MNT/foo > /dev/null
 
+loop_file=$tmp.loopfile
+touch $loop_file
 stat_loop $SCRATCH_MNT/foo &
 loop_pid=$!
 
@@ -64,6 +65,7 @@ for ((i = 0; i < 2000; i++)); do
 	$XFS_IO_PROG -d -c "pwrite -b 64K 0 64K" $SCRATCH_MNT/foo > /dev/null
 done
 
+rm -f $loop_file
 kill $loop_pid &> /dev/null
 wait
 

