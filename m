Received: from esa4.hgst.iphmx.com (esa4.hgst.iphmx.com [216.71.154.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A8953E5A35;
	Mon, 15 Jun 2026 12:13:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.71.154.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781525617; cv=none; b=ej3IihvZNtGTdadEPhlIcg/WCqIUOzA76VGnS3qqG/HnxFKDNoIbp3xbnr9n6s95q4IwrVOkhSnOHx/c7SLg+ZbyO3tXIHmBmD/VkW2O3x9pEFEXWeNLlC8TSW3v8mJdqpgYnYRPLrKvqskBIFiQ1gTGX96J9/+jXcBO3MoVLo4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781525617; c=relaxed/simple;
	bh=5fBSnn+IRkj9PuEy6n+0YAjtAvKTxa1IcBI7l3BM/Kw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=CiSPjEllPoHLh3tkpxpzoYUxtsOP5qOJobGqkP2Tc9OkwdqxBgmB06wjXFumpPMRzb584Y0HwkhkNEsBGWJjHgkXsX6WuenrhHsCsVos7nzBthx9+W09kP37YuEMMdzbepqfZE690SQoGMdrezGDWKBIh1p39L8OvFyl2nT69G8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=F0EutZ3L; arc=none smtp.client-ip=216.71.154.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="F0EutZ3L"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1781525616; x=1813061616;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=5fBSnn+IRkj9PuEy6n+0YAjtAvKTxa1IcBI7l3BM/Kw=;
  b=F0EutZ3LPTic4nGXymALDfBSFWdxBAubmafiPQCD8XKBtAUSVw18Wf0g
   Jf0O5/2pNjlnAK97XolyxbCc2/ef7YpwrluTQdIjHE+7xQPdshLSQWE6X
   Ihwu7DiS6tiNzI498JTtiK1UFmTyN/ra6m4hmVOUtJ81zYv27CKVBIbwe
   eln7s71INidMoskEi7u40OWAmNavUFQkpsE6n1UyGX69I91wmEiKCypOs
   aEn9Gr+OPyOB76zewU1q1OrrIxuM95Gq5GRzhLY4rkwv4F/djJJ7EVk6l
   Voyr4jUB1F6VgzcBnWJDYVB4fab2buQl2xfNNMweoVfPTN9guyGXYesMW
   g==;
X-CSE-ConnectionGUID: zYLEr53xS4mJ7hPfSzMU5A==
X-CSE-MsgGUID: QvAfHLXNTAGBhk+BB/2fjA==
X-IronPort-AV: E=Sophos;i="6.24,206,1774281600"; 
   d="scan'208";a="145032002"
Received: from unknown (HELO uls-op-esad1-o.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 15 Jun 2026 20:13:29 +0800
X-CSE-ConnectionGUID: UErOt1NTQ2+S4xYbDUrY3Q==
X-CSE-MsgGUID: Lo2RdKdnRIqiEWOU4KLV7Q==
IronPort-SDR: 6a2fec4b_WGeymY1vmZNDNRE97cYBMfiBZlPekLxQNArjelOI3ewaMlV
 JXSz3OsMLQodx42RY7yym0R55xHdex7VJpXT7Rw==
Received: from uls-op-esai1-o.wdc.com ([10.248.3.45])
  by uls-op-esad1-o.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 15 Jun 2026 05:12:58 -0700
X-CSE-ConnectionGUID: GjaDYeRiTnerkjVhTutP6A==
X-CSE-MsgGUID: KJZ+WBoSTiq5CHfFPDYHEQ==
WDCIronportException: Internal
Received: from unknown (HELO shindev.ssa.fujisawa.hgst.com) ([10.149.67.30])
  by uls-op-esai1-o.wdc.com with ESMTP; 15 Jun 2026 05:12:58 -0700
From: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To: fstests@vger.kernel.org,
	Zorro Lang <zlang@kernel.org>,
	Dave Chinner <dchinner@redhat.com>
Cc: linux-xfs@vger.kernel.org,
	Christoph Hellwig <hch@lst.de>,
	Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: [PATCH] xfs/013: fix ENOSPC handling
Date: Mon, 15 Jun 2026 21:12:57 +0900
Message-ID: <20260615121257.512060-1-shinichiro.kawasaki@wdc.com>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Commit 000813899afb ("fstests: scale some tests for high CPU count
sanity") replaced "touch" with "echo -n >" to speed up file creation by
using a shell builtin redirection instead of forking and execing an
external binary. However, this broke the ENOSPC filtering the test
relies on.

When the scratch filesystem fills up, the shell redirection "> $dir/$i"
fails instead of the "touch" command. The shell applies redirections
left-to-right, so "> $dir/$i" is attempted before "2>&1". Because
opening the file fails immediately with ENOSPC, the command never runs
and the shell writes the error message "No space left on device" to the
stderr instead of the pipe. Then the error message is not passed to
"filter_enospc" and leaks into the test output, causing the test case
failure. The failure is recreated by running the test case with rather
small size of block devices, such as 128MiB null_blk:

xfs/013            - output mismatch (see /home/test/xfstests/results//xfs/013.out.bad)
    --- tests/xfs/013.out	2026-05-28 16:52:16.881159200 +0900
    +++ /home/test/xfstests/results//xfs/013.out.bad	2026-06-11 17:20:36.269003467 +0900
    @@ -5,3 +5,12305 @@
     naming   =VERN bsize=XXX
     log      =LDEV bsize=XXX blocks=XXX
     realtime =RDEV extsz=XXX blocks=XXX, rtextents=XXX
    +/home/test/xfstests/tests/xfs/013: line 45: /var/scratch/dir2/19013: No space left on device
    +/home/test/xfstests/tests/xfs/013: line 45: /var/scratch/dir2/6452: No space left on device
    +/home/test/xfstests/tests/xfs/013: line 45: /var/scratch/dir2/14964: No space left on device
    +/home/test/xfstests/tests/xfs/013: line 45: /var/scratch/dir2/10051: No space left on device
    ...
    (Run 'diff -u /home/test/xfstests/tests/xfs/013.out /home/test/xfstests/results//xfs/013.out.bad'  to see the entire diff)

To fix the ENOSPC handling, wrap the redirection in a brace group so
that "2>&1" is applied to the group before the inner redirection is
attempted. The redirection failure is then written to the group's
stderr, which is piped into "filter_enospc". This keeps the faster
builtin file creation than the "touch" command as the trigger commit
intended.

Fixes: 000813899afb ("fstests: scale some tests for high CPU count sanity")
Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
---
 tests/xfs/013 | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tests/xfs/013 b/tests/xfs/013
index fd011445..2e9b9850 100755
--- a/tests/xfs/013
+++ b/tests/xfs/013
@@ -28,7 +28,7 @@ _create()
 	mkdir -p $dir
 	for i in $(seq 0 $count)
 	do
-		echo -n > $dir/$i 2>&1 | filter_enospc
+		{ echo -n > $dir/$i ; } 2>&1 | filter_enospc
 	done
 }
 
@@ -42,7 +42,7 @@ _rand_replace()
 	do
 		file=$((RANDOM % count))
 		rm -f $dir/$file
-		echo -n > $dir/$file 2>&1 | filter_enospc
+		{ echo -n > $dir/$file ; } 2>&1 | filter_enospc
 	done
 }
 
-- 
2.54.0

