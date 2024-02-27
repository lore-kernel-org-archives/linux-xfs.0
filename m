Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01AAA15D0;
	Tue, 27 Feb 2024 02:01:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708999280; cv=none; b=UuMA0hPhOV2mEu1ktdLcMj7lJQ0ZH+u8eZBFagHJwM3803rvUFqUohUESySkCLbA8iyRH6eDXBQaGUtYA40WTg5FDBqrJisgss19bSdBRxgsxIvouBtE96W2CxWXyunyDoC2cOm1D7CKTl4Wx8zIADsF1k2CpZZ8/gIh8fuEo30=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708999280; c=relaxed/simple;
	bh=pY2zO92z0bcQiq4/Quu7kcvBmDBJECejc5jwXkAuh00=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=kH4qkxKPP9qnf0puYYsrlKybItgGhpj+Bb5VGGrwcH/h4rBjW477AGwhru0t6WXh9h2/qvIwkpBmjZRNPjssMzXAiTIeDBEtg8jW0zYL4t9WspAGXdP2ECgnoBWBWk4Wm6CT+DEYyOFHK0X+AeTXbvN6lrJddOLIx97UjMPYG/c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=k4Pvif7z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="k4Pvif7z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81323C433C7;
	Tue, 27 Feb 2024 02:01:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1708999279;
	bh=pY2zO92z0bcQiq4/Quu7kcvBmDBJECejc5jwXkAuh00=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=k4Pvif7zWwntmmSxr9hel0FcCVknJkySwtTU1LpN/GM/r/nJPRBbA0HDvjaci315g
	 f2o9ARqkN4izoGE98IKIyDOiuPJ5k+26yG/vN93lv80yOpinCQuVPym2uio4n2dsUX
	 w3x60S1knZKPgK5SirXiNFr24KUwJV6ejAWDZ3H1fnYpvUtNjoiYqeShDQNkPFnBws
	 X1LXiLClWbgLnoJXHqEeXFlFXM4P+sMHYMjw7jWZLWopRbE25eQWGA3TC4jBkRHpNL
	 dH01uOh3Co+ckhFdglW1McWp/fR1kB4N46LYfng7dtzlxnr/yVw9qLsgtuTtOyFbGq
	 th1ZZNgacwr3g==
Date: Mon, 26 Feb 2024 18:01:19 -0800
Subject: [PATCH 3/8] generic/192: fix spurious timeout
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, zlang@redhat.com
Cc: linux-xfs@vger.kernel.org, guan@eryu.me, fstests@vger.kernel.org
Message-ID: <170899915261.896550.17109752514258402651.stgit@frogsfrogsfrogs>
In-Reply-To: <170899915207.896550.7285890351450610430.stgit@frogsfrogsfrogs>
References: <170899915207.896550.7285890351450610430.stgit@frogsfrogsfrogs>
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

I have a theory that when the nfs server that hosts the root fs for my
testing VMs gets backed up, it can take a while for path resolution and
loading of echo, cat, or tee to finish.  That delays the test enough to
result in:

--- /tmp/fstests/tests/generic/192.out	2023-11-29 15:40:52.715517458 -0800
+++ /var/tmp/fstests/generic/192.out.bad	2023-12-15 21:28:02.860000000 -0800
@@ -1,5 +1,6 @@
 QA output created by 192
 sleep for 5 seconds
 test
-delta1 is in range
+delta1 has value of 12
+delta1 is NOT in range 5 .. 7
 delta2 is in range

Therefore, invoke all these utilities with --help before the critical
section to make sure they're all in memory.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 tests/generic/192 |   16 +++++++++++++---
 1 file changed, 13 insertions(+), 3 deletions(-)


diff --git a/tests/generic/192 b/tests/generic/192
index 0d3cd03b4b..2825486635 100755
--- a/tests/generic/192
+++ b/tests/generic/192
@@ -29,17 +29,27 @@ delay=5
 testfile=$TEST_DIR/testfile
 rm -f $testfile
 
+# Preload every binary used between sampling time1 and time2 so that loading
+# them has minimal overhead even if the root fs is hosted over a slow network.
+# Also don't put pipe and tee creation in that critical section.
+for i in echo stat sleep cat; do
+	$i --help &>/dev/null
+done
+
 echo test >$testfile
-time1=`_access_time $testfile | tee -a $seqres.full`
+time1=`_access_time $testfile`
+echo $time1 >> $seqres.full
 
 echo "sleep for $delay seconds"
 sleep $delay # sleep to allow time to move on for access
 cat $testfile
-time2=`_access_time $testfile | tee -a $seqres.full`
+time2=`_access_time $testfile`
+echo $time2 >> $seqres.full
 
 cd /
 _test_cycle_mount
-time3=`_access_time $testfile | tee -a $seqres.full`
+time3=`_access_time $testfile`
+echo $time3 >> $seqres.full
 
 delta1=`expr $time2 - $time1`
 delta2=`expr $time3 - $time1`

