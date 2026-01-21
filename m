Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 784B917ADE0;
	Wed, 21 Jan 2026 01:27:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768958821; cv=none; b=dDc6FLY0AJk8NK3CfSxG9JKsZrhobxWjgZuBJuA+Kji7vaR4S2zW/xl4M4NV94LetX5LuNaiXO4nkXXyBCW01pSkFPL7q39On2YczYxGLx8oTdtmvby4Mo3rwIG5asYPfEhfbV0Hj/rhuEDWjbXmQ3753oJAgFImLGdhIcjSJUs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768958821; c=relaxed/simple;
	bh=orwpS0Og+aCv0X+AgpJLEvXAQPvqmJrGRd4y2yw5pnI=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=g5bP+GBUP4pNaOhLNjVZVXCrwU3dLtW/7ispBfAHVajx9wvwMyEYFicXKaXfvZYwvepgAJEl7Z6gnWFEbHTlrPqbs/ZBwt+2v9AuAZYWJMu8hl2hmQGf+w+FEnuGhM80JrleS007tOF9K04lNT8ekuVxrD8SaHKcnzoz4nq7hWc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=vImaTZRg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="vImaTZRg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A766C16AAE;
	Wed, 21 Jan 2026 01:27:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768958820;
	bh=orwpS0Og+aCv0X+AgpJLEvXAQPvqmJrGRd4y2yw5pnI=;
	h=Date:From:To:Cc:Subject:From;
	b=vImaTZRgYe+RRhL2qEZ1vrvHQPvDnhMD/nKsxcDvUGo+fAGmznkm0/uiWJEoekNHH
	 4k2lw8ibjg4VhMin7dowglxDal8GgMr9lel584sa0LqkdhaNRB76KyX/U/OqxKOR2Z
	 FU8LfMvrq+2U1pX25Xu73fTuOf8nV2Dy6EsK5Hsg2jlPDReqw7LleESrgj4RwN9Lk1
	 leB31CCO+iPnTYmGKA4SGvj4aEeIOXaOFZHcYBfC3BnWaNXfrL/n0IHNOOtmGXMjLy
	 ZzxcGO0PfRjUo1ON50C+aZB2JWj31p76if+ZKuqDmoaxp8G8vTMdz1I6is08JW9kZg
	 61RVB+Hd7hRmA==
Date: Tue, 20 Jan 2026 17:27:00 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Zorro Lang <zlang@redhat.com>
Cc: fstests <fstests@vger.kernel.org>, xfs <linux-xfs@vger.kernel.org>
Subject: [PATCH] xfs/614: fix test for parent pointers
Message-ID: <20260121012700.GF15541@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

From: Darrick J. Wong <djwong@kernel.org>

Almost a decade ago, the initial rmap/reflink patches were merged with
hugely overestimated log space reservations.  Although we adjusted the
actual runtime reservations a few years ago, we left the minimum log
size calculations in place to avoid compatibility problems between newer
mkfs and older kernels.

With the introduction of parent pointers, we can finally use the more
accurate reservations for minlog computations and mkfs can format
smaller logs as a result.  This causes the output of this test to
change, though it wasn't needed until parent pointers were enabled by
default.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 common/xfs                       |    3 +
 tests/xfs/614                    |    1 
 tests/xfs/614.cfg                |    4 +
 tests/xfs/614.out.lba1024_parent |  177 ++++++++++++++++++++++++++++++++++++++
 tests/xfs/614.out.lba2048_parent |  177 ++++++++++++++++++++++++++++++++++++++
 tests/xfs/614.out.lba4096_parent |  177 ++++++++++++++++++++++++++++++++++++++
 tests/xfs/614.out.lba512_parent  |  177 ++++++++++++++++++++++++++++++++++++++
 7 files changed, 716 insertions(+)
 create mode 100644 tests/xfs/614.out.lba1024_parent
 create mode 100644 tests/xfs/614.out.lba2048_parent
 create mode 100644 tests/xfs/614.out.lba4096_parent
 create mode 100644 tests/xfs/614.out.lba512_parent

diff --git a/common/xfs b/common/xfs
index 8b1b87413659ad..7fa0db2e26b4c9 100644
--- a/common/xfs
+++ b/common/xfs
@@ -1732,6 +1732,9 @@ _xfs_filter_mkfs()
 		print STDERR "dirversion=$1\ndirbsize=$2\n";
 		print STDOUT "naming   =VERN bsize=XXX\n";
 	}
+	if (/^naming\s+=.*parent=(\d+)/) {
+		print STDERR "parent=$1\n";
+	}
 	if (/^log\s+=(internal log|[\w|\/.-]+)\s+bsize=(\d+)\s+blocks=(\d+),\s+version=(\d+)/ ||
 		/^log\s+=(internal log|[\w|\/.-]+)\s+bsize=(\d+)\s+blocks=(\d+)/) {
 		print STDERR "ldev=\"$1\"\nlbsize=$2\nlblocks=$3\nlversion=$4\n";
diff --git a/tests/xfs/614 b/tests/xfs/614
index e182f073fddd64..21a4e205847fc3 100755
--- a/tests/xfs/614
+++ b/tests/xfs/614
@@ -32,6 +32,7 @@ rm -f "$loop_file"
 truncate -s 16M "$loop_file"
 $MKFS_XFS_PROG -f -N "$loop_file" | _filter_mkfs 2>$tmp.mkfs >/dev/null
 . $tmp.mkfs
+test "$parent" = 1 && sectsz="${sectsz}_parent"
 seqfull=$0
 _link_out_file "lba${sectsz}"
 
diff --git a/tests/xfs/614.cfg b/tests/xfs/614.cfg
index 0678032432540b..e824a2feed9988 100644
--- a/tests/xfs/614.cfg
+++ b/tests/xfs/614.cfg
@@ -2,3 +2,7 @@ lba512: lba512
 lba1024: lba1024
 lba2048: lba2048
 lba4096: lba4096
+lba512_parent: lba512_parent
+lba1024_parent: lba1024_parent
+lba2048_parent: lba2048_parent
+lba4096_parent: lba4096_parent
diff --git a/tests/xfs/614.out.lba1024_parent b/tests/xfs/614.out.lba1024_parent
new file mode 100644
index 00000000000000..90b9f8bd70a58f
--- /dev/null
+++ b/tests/xfs/614.out.lba1024_parent
@@ -0,0 +1,177 @@
+QA output created by 614
+sz 16M cpus 2 agcount 1 logblocks 1650
+sz 16M cpus 4 agcount 1 logblocks 1650
+sz 16M cpus 8 agcount 1 logblocks 1650
+sz 16M cpus 16 agcount 1 logblocks 1650
+sz 16M cpus 32 agcount 1 logblocks 1650
+sz 16M cpus 40 agcount 1 logblocks 1650
+sz 16M cpus 64 agcount 1 logblocks 1650
+sz 16M cpus 96 agcount 1 logblocks 1650
+sz 16M cpus 160 agcount 1 logblocks 1650
+sz 16M cpus 512 agcount 1 logblocks 1650
+-----------------
+sz 512M cpus 2 agcount 4 logblocks 16384
+sz 512M cpus 4 agcount 4 logblocks 16384
+sz 512M cpus 8 agcount 4 logblocks 16384
+sz 512M cpus 16 agcount 4 logblocks 16384
+sz 512M cpus 32 agcount 4 logblocks 16384
+sz 512M cpus 40 agcount 4 logblocks 16384
+sz 512M cpus 64 agcount 4 logblocks 16384
+sz 512M cpus 96 agcount 4 logblocks 16384
+sz 512M cpus 160 agcount 4 logblocks 16384
+sz 512M cpus 512 agcount 4 logblocks 16384
+-----------------
+sz 1G cpus 2 agcount 4 logblocks 16384
+sz 1G cpus 4 agcount 4 logblocks 16384
+sz 1G cpus 8 agcount 4 logblocks 16384
+sz 1G cpus 16 agcount 4 logblocks 16384
+sz 1G cpus 32 agcount 4 logblocks 25087
+sz 1G cpus 40 agcount 4 logblocks 31359
+sz 1G cpus 64 agcount 4 logblocks 50175
+sz 1G cpus 96 agcount 4 logblocks 65524
+sz 1G cpus 160 agcount 4 logblocks 65524
+sz 1G cpus 512 agcount 4 logblocks 65524
+-----------------
+sz 2G cpus 2 agcount 4 logblocks 16384
+sz 2G cpus 4 agcount 4 logblocks 16384
+sz 2G cpus 8 agcount 4 logblocks 16384
+sz 2G cpus 16 agcount 4 logblocks 16384
+sz 2G cpus 32 agcount 4 logblocks 25087
+sz 2G cpus 40 agcount 4 logblocks 31359
+sz 2G cpus 64 agcount 4 logblocks 50175
+sz 2G cpus 96 agcount 4 logblocks 75262
+sz 2G cpus 160 agcount 4 logblocks 125437
+sz 2G cpus 512 agcount 4 logblocks 131060
+-----------------
+sz 16G cpus 2 agcount 4 logblocks 16384
+sz 16G cpus 4 agcount 4 logblocks 16384
+sz 16G cpus 8 agcount 4 logblocks 16384
+sz 16G cpus 16 agcount 4 logblocks 16384
+sz 16G cpus 32 agcount 4 logblocks 25087
+sz 16G cpus 40 agcount 4 logblocks 31359
+sz 16G cpus 64 agcount 4 logblocks 50175
+sz 16G cpus 96 agcount 4 logblocks 75262
+sz 16G cpus 160 agcount 4 logblocks 125437
+sz 16G cpus 512 agcount 4 logblocks 401400
+-----------------
+sz 64G cpus 2 agcount 4 logblocks 16384
+sz 64G cpus 4 agcount 4 logblocks 16384
+sz 64G cpus 8 agcount 8 logblocks 16384
+sz 64G cpus 16 agcount 16 logblocks 16384
+sz 64G cpus 32 agcount 16 logblocks 25087
+sz 64G cpus 40 agcount 16 logblocks 31359
+sz 64G cpus 64 agcount 16 logblocks 50175
+sz 64G cpus 96 agcount 16 logblocks 75262
+sz 64G cpus 160 agcount 16 logblocks 125437
+sz 64G cpus 512 agcount 16 logblocks 401400
+-----------------
+sz 256G cpus 2 agcount 4 logblocks 32768
+sz 256G cpus 4 agcount 4 logblocks 32768
+sz 256G cpus 8 agcount 8 logblocks 32768
+sz 256G cpus 16 agcount 16 logblocks 32768
+sz 256G cpus 32 agcount 32 logblocks 32768
+sz 256G cpus 40 agcount 40 logblocks 32767
+sz 256G cpus 64 agcount 64 logblocks 50175
+sz 256G cpus 96 agcount 64 logblocks 75262
+sz 256G cpus 160 agcount 64 logblocks 125437
+sz 256G cpus 512 agcount 64 logblocks 401400
+-----------------
+sz 512G cpus 2 agcount 4 logblocks 65536
+sz 512G cpus 4 agcount 4 logblocks 65536
+sz 512G cpus 8 agcount 8 logblocks 65536
+sz 512G cpus 16 agcount 16 logblocks 65536
+sz 512G cpus 32 agcount 32 logblocks 65536
+sz 512G cpus 40 agcount 40 logblocks 65535
+sz 512G cpus 64 agcount 64 logblocks 65536
+sz 512G cpus 96 agcount 96 logblocks 75262
+sz 512G cpus 160 agcount 128 logblocks 125437
+sz 512G cpus 512 agcount 128 logblocks 401400
+-----------------
+sz 1T cpus 2 agcount 4 logblocks 131072
+sz 1T cpus 4 agcount 4 logblocks 131072
+sz 1T cpus 8 agcount 8 logblocks 131072
+sz 1T cpus 16 agcount 16 logblocks 131072
+sz 1T cpus 32 agcount 32 logblocks 131072
+sz 1T cpus 40 agcount 40 logblocks 131071
+sz 1T cpus 64 agcount 64 logblocks 131072
+sz 1T cpus 96 agcount 96 logblocks 131071
+sz 1T cpus 160 agcount 160 logblocks 131071
+sz 1T cpus 512 agcount 256 logblocks 401400
+-----------------
+sz 2T cpus 2 agcount 4 logblocks 262144
+sz 2T cpus 4 agcount 4 logblocks 262144
+sz 2T cpus 8 agcount 8 logblocks 262144
+sz 2T cpus 16 agcount 16 logblocks 262144
+sz 2T cpus 32 agcount 32 logblocks 262144
+sz 2T cpus 40 agcount 40 logblocks 262143
+sz 2T cpus 64 agcount 64 logblocks 262144
+sz 2T cpus 96 agcount 96 logblocks 262143
+sz 2T cpus 160 agcount 160 logblocks 262143
+sz 2T cpus 512 agcount 512 logblocks 401400
+-----------------
+sz 4T cpus 2 agcount 4 logblocks 521728
+sz 4T cpus 4 agcount 4 logblocks 521728
+sz 4T cpus 8 agcount 8 logblocks 521728
+sz 4T cpus 16 agcount 16 logblocks 521728
+sz 4T cpus 32 agcount 32 logblocks 521728
+sz 4T cpus 40 agcount 40 logblocks 521728
+sz 4T cpus 64 agcount 64 logblocks 521728
+sz 4T cpus 96 agcount 96 logblocks 521728
+sz 4T cpus 160 agcount 160 logblocks 521728
+sz 4T cpus 512 agcount 512 logblocks 521728
+-----------------
+sz 16T cpus 2 agcount 16 logblocks 521728
+sz 16T cpus 4 agcount 16 logblocks 521728
+sz 16T cpus 8 agcount 16 logblocks 521728
+sz 16T cpus 16 agcount 16 logblocks 521728
+sz 16T cpus 32 agcount 32 logblocks 521728
+sz 16T cpus 40 agcount 40 logblocks 521728
+sz 16T cpus 64 agcount 64 logblocks 521728
+sz 16T cpus 96 agcount 96 logblocks 521728
+sz 16T cpus 160 agcount 160 logblocks 521728
+sz 16T cpus 512 agcount 512 logblocks 521728
+-----------------
+sz 64T cpus 2 agcount 64 logblocks 521728
+sz 64T cpus 4 agcount 64 logblocks 521728
+sz 64T cpus 8 agcount 64 logblocks 521728
+sz 64T cpus 16 agcount 64 logblocks 521728
+sz 64T cpus 32 agcount 64 logblocks 521728
+sz 64T cpus 40 agcount 64 logblocks 521728
+sz 64T cpus 64 agcount 64 logblocks 521728
+sz 64T cpus 96 agcount 96 logblocks 521728
+sz 64T cpus 160 agcount 160 logblocks 521728
+sz 64T cpus 512 agcount 512 logblocks 521728
+-----------------
+sz 256T cpus 2 agcount 256 logblocks 521728
+sz 256T cpus 4 agcount 256 logblocks 521728
+sz 256T cpus 8 agcount 256 logblocks 521728
+sz 256T cpus 16 agcount 256 logblocks 521728
+sz 256T cpus 32 agcount 256 logblocks 521728
+sz 256T cpus 40 agcount 256 logblocks 521728
+sz 256T cpus 64 agcount 256 logblocks 521728
+sz 256T cpus 96 agcount 256 logblocks 521728
+sz 256T cpus 160 agcount 256 logblocks 521728
+sz 256T cpus 512 agcount 512 logblocks 521728
+-----------------
+sz 512T cpus 2 agcount 512 logblocks 521728
+sz 512T cpus 4 agcount 512 logblocks 521728
+sz 512T cpus 8 agcount 512 logblocks 521728
+sz 512T cpus 16 agcount 512 logblocks 521728
+sz 512T cpus 32 agcount 512 logblocks 521728
+sz 512T cpus 40 agcount 512 logblocks 521728
+sz 512T cpus 64 agcount 512 logblocks 521728
+sz 512T cpus 96 agcount 512 logblocks 521728
+sz 512T cpus 160 agcount 512 logblocks 521728
+sz 512T cpus 512 agcount 512 logblocks 521728
+-----------------
+sz 1P cpus 2 agcount 1024 logblocks 521728
+sz 1P cpus 4 agcount 1024 logblocks 521728
+sz 1P cpus 8 agcount 1024 logblocks 521728
+sz 1P cpus 16 agcount 1024 logblocks 521728
+sz 1P cpus 32 agcount 1024 logblocks 521728
+sz 1P cpus 40 agcount 1024 logblocks 521728
+sz 1P cpus 64 agcount 1024 logblocks 521728
+sz 1P cpus 96 agcount 1024 logblocks 521728
+sz 1P cpus 160 agcount 1024 logblocks 521728
+sz 1P cpus 512 agcount 1024 logblocks 521728
+-----------------
diff --git a/tests/xfs/614.out.lba2048_parent b/tests/xfs/614.out.lba2048_parent
new file mode 100644
index 00000000000000..b66afe566891ac
--- /dev/null
+++ b/tests/xfs/614.out.lba2048_parent
@@ -0,0 +1,177 @@
+QA output created by 614
+sz 16M cpus 2 agcount 1 logblocks 1650
+sz 16M cpus 4 agcount 1 logblocks 1650
+sz 16M cpus 8 agcount 1 logblocks 1650
+sz 16M cpus 16 agcount 1 logblocks 1650
+sz 16M cpus 32 agcount 1 logblocks 1650
+sz 16M cpus 40 agcount 1 logblocks 1650
+sz 16M cpus 64 agcount 1 logblocks 1650
+sz 16M cpus 96 agcount 1 logblocks 1650
+sz 16M cpus 160 agcount 1 logblocks 1650
+sz 16M cpus 512 agcount 1 logblocks 1650
+-----------------
+sz 512M cpus 2 agcount 4 logblocks 16384
+sz 512M cpus 4 agcount 4 logblocks 16384
+sz 512M cpus 8 agcount 4 logblocks 16384
+sz 512M cpus 16 agcount 4 logblocks 16384
+sz 512M cpus 32 agcount 4 logblocks 16384
+sz 512M cpus 40 agcount 4 logblocks 16384
+sz 512M cpus 64 agcount 4 logblocks 16384
+sz 512M cpus 96 agcount 4 logblocks 16384
+sz 512M cpus 160 agcount 4 logblocks 16384
+sz 512M cpus 512 agcount 4 logblocks 16384
+-----------------
+sz 1G cpus 2 agcount 4 logblocks 16384
+sz 1G cpus 4 agcount 4 logblocks 16384
+sz 1G cpus 8 agcount 4 logblocks 16384
+sz 1G cpus 16 agcount 4 logblocks 16384
+sz 1G cpus 32 agcount 4 logblocks 25087
+sz 1G cpus 40 agcount 4 logblocks 31359
+sz 1G cpus 64 agcount 4 logblocks 50175
+sz 1G cpus 96 agcount 4 logblocks 65523
+sz 1G cpus 160 agcount 4 logblocks 65523
+sz 1G cpus 512 agcount 4 logblocks 65523
+-----------------
+sz 2G cpus 2 agcount 4 logblocks 16384
+sz 2G cpus 4 agcount 4 logblocks 16384
+sz 2G cpus 8 agcount 4 logblocks 16384
+sz 2G cpus 16 agcount 4 logblocks 16384
+sz 2G cpus 32 agcount 4 logblocks 25087
+sz 2G cpus 40 agcount 4 logblocks 31359
+sz 2G cpus 64 agcount 4 logblocks 50175
+sz 2G cpus 96 agcount 4 logblocks 75262
+sz 2G cpus 160 agcount 4 logblocks 125437
+sz 2G cpus 512 agcount 4 logblocks 131059
+-----------------
+sz 16G cpus 2 agcount 4 logblocks 16384
+sz 16G cpus 4 agcount 4 logblocks 16384
+sz 16G cpus 8 agcount 4 logblocks 16384
+sz 16G cpus 16 agcount 4 logblocks 16384
+sz 16G cpus 32 agcount 4 logblocks 25087
+sz 16G cpus 40 agcount 4 logblocks 31359
+sz 16G cpus 64 agcount 4 logblocks 50175
+sz 16G cpus 96 agcount 4 logblocks 75262
+sz 16G cpus 160 agcount 4 logblocks 125437
+sz 16G cpus 512 agcount 4 logblocks 401400
+-----------------
+sz 64G cpus 2 agcount 4 logblocks 16384
+sz 64G cpus 4 agcount 4 logblocks 16384
+sz 64G cpus 8 agcount 8 logblocks 16384
+sz 64G cpus 16 agcount 16 logblocks 16384
+sz 64G cpus 32 agcount 16 logblocks 25087
+sz 64G cpus 40 agcount 16 logblocks 31359
+sz 64G cpus 64 agcount 16 logblocks 50175
+sz 64G cpus 96 agcount 16 logblocks 75262
+sz 64G cpus 160 agcount 16 logblocks 125437
+sz 64G cpus 512 agcount 16 logblocks 401400
+-----------------
+sz 256G cpus 2 agcount 4 logblocks 32768
+sz 256G cpus 4 agcount 4 logblocks 32768
+sz 256G cpus 8 agcount 8 logblocks 32768
+sz 256G cpus 16 agcount 16 logblocks 32768
+sz 256G cpus 32 agcount 32 logblocks 32768
+sz 256G cpus 40 agcount 40 logblocks 32767
+sz 256G cpus 64 agcount 64 logblocks 50175
+sz 256G cpus 96 agcount 64 logblocks 75262
+sz 256G cpus 160 agcount 64 logblocks 125437
+sz 256G cpus 512 agcount 64 logblocks 401400
+-----------------
+sz 512G cpus 2 agcount 4 logblocks 65536
+sz 512G cpus 4 agcount 4 logblocks 65536
+sz 512G cpus 8 agcount 8 logblocks 65536
+sz 512G cpus 16 agcount 16 logblocks 65536
+sz 512G cpus 32 agcount 32 logblocks 65536
+sz 512G cpus 40 agcount 40 logblocks 65535
+sz 512G cpus 64 agcount 64 logblocks 65536
+sz 512G cpus 96 agcount 96 logblocks 75262
+sz 512G cpus 160 agcount 128 logblocks 125437
+sz 512G cpus 512 agcount 128 logblocks 401400
+-----------------
+sz 1T cpus 2 agcount 4 logblocks 131072
+sz 1T cpus 4 agcount 4 logblocks 131072
+sz 1T cpus 8 agcount 8 logblocks 131072
+sz 1T cpus 16 agcount 16 logblocks 131072
+sz 1T cpus 32 agcount 32 logblocks 131072
+sz 1T cpus 40 agcount 40 logblocks 131071
+sz 1T cpus 64 agcount 64 logblocks 131072
+sz 1T cpus 96 agcount 96 logblocks 131071
+sz 1T cpus 160 agcount 160 logblocks 131071
+sz 1T cpus 512 agcount 256 logblocks 401400
+-----------------
+sz 2T cpus 2 agcount 4 logblocks 262144
+sz 2T cpus 4 agcount 4 logblocks 262144
+sz 2T cpus 8 agcount 8 logblocks 262144
+sz 2T cpus 16 agcount 16 logblocks 262144
+sz 2T cpus 32 agcount 32 logblocks 262144
+sz 2T cpus 40 agcount 40 logblocks 262143
+sz 2T cpus 64 agcount 64 logblocks 262144
+sz 2T cpus 96 agcount 96 logblocks 262143
+sz 2T cpus 160 agcount 160 logblocks 262143
+sz 2T cpus 512 agcount 512 logblocks 401400
+-----------------
+sz 4T cpus 2 agcount 4 logblocks 521728
+sz 4T cpus 4 agcount 4 logblocks 521728
+sz 4T cpus 8 agcount 8 logblocks 521728
+sz 4T cpus 16 agcount 16 logblocks 521728
+sz 4T cpus 32 agcount 32 logblocks 521728
+sz 4T cpus 40 agcount 40 logblocks 521728
+sz 4T cpus 64 agcount 64 logblocks 521728
+sz 4T cpus 96 agcount 96 logblocks 521728
+sz 4T cpus 160 agcount 160 logblocks 521728
+sz 4T cpus 512 agcount 512 logblocks 521728
+-----------------
+sz 16T cpus 2 agcount 16 logblocks 521728
+sz 16T cpus 4 agcount 16 logblocks 521728
+sz 16T cpus 8 agcount 16 logblocks 521728
+sz 16T cpus 16 agcount 16 logblocks 521728
+sz 16T cpus 32 agcount 32 logblocks 521728
+sz 16T cpus 40 agcount 40 logblocks 521728
+sz 16T cpus 64 agcount 64 logblocks 521728
+sz 16T cpus 96 agcount 96 logblocks 521728
+sz 16T cpus 160 agcount 160 logblocks 521728
+sz 16T cpus 512 agcount 512 logblocks 521728
+-----------------
+sz 64T cpus 2 agcount 64 logblocks 521728
+sz 64T cpus 4 agcount 64 logblocks 521728
+sz 64T cpus 8 agcount 64 logblocks 521728
+sz 64T cpus 16 agcount 64 logblocks 521728
+sz 64T cpus 32 agcount 64 logblocks 521728
+sz 64T cpus 40 agcount 64 logblocks 521728
+sz 64T cpus 64 agcount 64 logblocks 521728
+sz 64T cpus 96 agcount 96 logblocks 521728
+sz 64T cpus 160 agcount 160 logblocks 521728
+sz 64T cpus 512 agcount 512 logblocks 521728
+-----------------
+sz 256T cpus 2 agcount 256 logblocks 521728
+sz 256T cpus 4 agcount 256 logblocks 521728
+sz 256T cpus 8 agcount 256 logblocks 521728
+sz 256T cpus 16 agcount 256 logblocks 521728
+sz 256T cpus 32 agcount 256 logblocks 521728
+sz 256T cpus 40 agcount 256 logblocks 521728
+sz 256T cpus 64 agcount 256 logblocks 521728
+sz 256T cpus 96 agcount 256 logblocks 521728
+sz 256T cpus 160 agcount 256 logblocks 521728
+sz 256T cpus 512 agcount 512 logblocks 521728
+-----------------
+sz 512T cpus 2 agcount 512 logblocks 521728
+sz 512T cpus 4 agcount 512 logblocks 521728
+sz 512T cpus 8 agcount 512 logblocks 521728
+sz 512T cpus 16 agcount 512 logblocks 521728
+sz 512T cpus 32 agcount 512 logblocks 521728
+sz 512T cpus 40 agcount 512 logblocks 521728
+sz 512T cpus 64 agcount 512 logblocks 521728
+sz 512T cpus 96 agcount 512 logblocks 521728
+sz 512T cpus 160 agcount 512 logblocks 521728
+sz 512T cpus 512 agcount 512 logblocks 521728
+-----------------
+sz 1P cpus 2 agcount 1024 logblocks 521728
+sz 1P cpus 4 agcount 1024 logblocks 521728
+sz 1P cpus 8 agcount 1024 logblocks 521728
+sz 1P cpus 16 agcount 1024 logblocks 521728
+sz 1P cpus 32 agcount 1024 logblocks 521728
+sz 1P cpus 40 agcount 1024 logblocks 521728
+sz 1P cpus 64 agcount 1024 logblocks 521728
+sz 1P cpus 96 agcount 1024 logblocks 521728
+sz 1P cpus 160 agcount 1024 logblocks 521728
+sz 1P cpus 512 agcount 1024 logblocks 521728
+-----------------
diff --git a/tests/xfs/614.out.lba4096_parent b/tests/xfs/614.out.lba4096_parent
new file mode 100644
index 00000000000000..452891d1aa1270
--- /dev/null
+++ b/tests/xfs/614.out.lba4096_parent
@@ -0,0 +1,177 @@
+QA output created by 614
+sz 16M cpus 2 agcount 1 logblocks 1650
+sz 16M cpus 4 agcount 1 logblocks 1650
+sz 16M cpus 8 agcount 1 logblocks 1650
+sz 16M cpus 16 agcount 1 logblocks 1650
+sz 16M cpus 32 agcount 1 logblocks 1650
+sz 16M cpus 40 agcount 1 logblocks 1650
+sz 16M cpus 64 agcount 1 logblocks 1650
+sz 16M cpus 96 agcount 1 logblocks 1650
+sz 16M cpus 160 agcount 1 logblocks 1650
+sz 16M cpus 512 agcount 1 logblocks 1650
+-----------------
+sz 512M cpus 2 agcount 4 logblocks 16384
+sz 512M cpus 4 agcount 4 logblocks 16384
+sz 512M cpus 8 agcount 4 logblocks 16384
+sz 512M cpus 16 agcount 4 logblocks 16384
+sz 512M cpus 32 agcount 4 logblocks 16384
+sz 512M cpus 40 agcount 4 logblocks 16384
+sz 512M cpus 64 agcount 4 logblocks 16384
+sz 512M cpus 96 agcount 4 logblocks 16384
+sz 512M cpus 160 agcount 4 logblocks 16384
+sz 512M cpus 512 agcount 4 logblocks 16384
+-----------------
+sz 1G cpus 2 agcount 4 logblocks 16384
+sz 1G cpus 4 agcount 4 logblocks 16384
+sz 1G cpus 8 agcount 4 logblocks 16384
+sz 1G cpus 16 agcount 4 logblocks 16384
+sz 1G cpus 32 agcount 4 logblocks 25087
+sz 1G cpus 40 agcount 4 logblocks 31359
+sz 1G cpus 64 agcount 4 logblocks 50175
+sz 1G cpus 96 agcount 4 logblocks 65521
+sz 1G cpus 160 agcount 4 logblocks 65521
+sz 1G cpus 512 agcount 4 logblocks 65521
+-----------------
+sz 2G cpus 2 agcount 4 logblocks 16384
+sz 2G cpus 4 agcount 4 logblocks 16384
+sz 2G cpus 8 agcount 4 logblocks 16384
+sz 2G cpus 16 agcount 4 logblocks 16384
+sz 2G cpus 32 agcount 4 logblocks 25087
+sz 2G cpus 40 agcount 4 logblocks 31359
+sz 2G cpus 64 agcount 4 logblocks 50175
+sz 2G cpus 96 agcount 4 logblocks 75262
+sz 2G cpus 160 agcount 4 logblocks 125437
+sz 2G cpus 512 agcount 4 logblocks 131057
+-----------------
+sz 16G cpus 2 agcount 4 logblocks 16384
+sz 16G cpus 4 agcount 4 logblocks 16384
+sz 16G cpus 8 agcount 4 logblocks 16384
+sz 16G cpus 16 agcount 4 logblocks 16384
+sz 16G cpus 32 agcount 4 logblocks 25087
+sz 16G cpus 40 agcount 4 logblocks 31359
+sz 16G cpus 64 agcount 4 logblocks 50175
+sz 16G cpus 96 agcount 4 logblocks 75262
+sz 16G cpus 160 agcount 4 logblocks 125437
+sz 16G cpus 512 agcount 4 logblocks 401400
+-----------------
+sz 64G cpus 2 agcount 4 logblocks 16384
+sz 64G cpus 4 agcount 4 logblocks 16384
+sz 64G cpus 8 agcount 8 logblocks 16384
+sz 64G cpus 16 agcount 16 logblocks 16384
+sz 64G cpus 32 agcount 16 logblocks 25087
+sz 64G cpus 40 agcount 16 logblocks 31359
+sz 64G cpus 64 agcount 16 logblocks 50175
+sz 64G cpus 96 agcount 16 logblocks 75262
+sz 64G cpus 160 agcount 16 logblocks 125437
+sz 64G cpus 512 agcount 16 logblocks 401400
+-----------------
+sz 256G cpus 2 agcount 4 logblocks 32768
+sz 256G cpus 4 agcount 4 logblocks 32768
+sz 256G cpus 8 agcount 8 logblocks 32768
+sz 256G cpus 16 agcount 16 logblocks 32768
+sz 256G cpus 32 agcount 32 logblocks 32768
+sz 256G cpus 40 agcount 40 logblocks 32767
+sz 256G cpus 64 agcount 64 logblocks 50175
+sz 256G cpus 96 agcount 64 logblocks 75262
+sz 256G cpus 160 agcount 64 logblocks 125437
+sz 256G cpus 512 agcount 64 logblocks 401400
+-----------------
+sz 512G cpus 2 agcount 4 logblocks 65536
+sz 512G cpus 4 agcount 4 logblocks 65536
+sz 512G cpus 8 agcount 8 logblocks 65536
+sz 512G cpus 16 agcount 16 logblocks 65536
+sz 512G cpus 32 agcount 32 logblocks 65536
+sz 512G cpus 40 agcount 40 logblocks 65535
+sz 512G cpus 64 agcount 64 logblocks 65536
+sz 512G cpus 96 agcount 96 logblocks 75262
+sz 512G cpus 160 agcount 128 logblocks 125437
+sz 512G cpus 512 agcount 128 logblocks 401400
+-----------------
+sz 1T cpus 2 agcount 4 logblocks 131072
+sz 1T cpus 4 agcount 4 logblocks 131072
+sz 1T cpus 8 agcount 8 logblocks 131072
+sz 1T cpus 16 agcount 16 logblocks 131072
+sz 1T cpus 32 agcount 32 logblocks 131072
+sz 1T cpus 40 agcount 40 logblocks 131071
+sz 1T cpus 64 agcount 64 logblocks 131072
+sz 1T cpus 96 agcount 96 logblocks 131071
+sz 1T cpus 160 agcount 160 logblocks 131071
+sz 1T cpus 512 agcount 256 logblocks 401400
+-----------------
+sz 2T cpus 2 agcount 4 logblocks 262144
+sz 2T cpus 4 agcount 4 logblocks 262144
+sz 2T cpus 8 agcount 8 logblocks 262144
+sz 2T cpus 16 agcount 16 logblocks 262144
+sz 2T cpus 32 agcount 32 logblocks 262144
+sz 2T cpus 40 agcount 40 logblocks 262143
+sz 2T cpus 64 agcount 64 logblocks 262144
+sz 2T cpus 96 agcount 96 logblocks 262143
+sz 2T cpus 160 agcount 160 logblocks 262143
+sz 2T cpus 512 agcount 512 logblocks 401400
+-----------------
+sz 4T cpus 2 agcount 4 logblocks 521728
+sz 4T cpus 4 agcount 4 logblocks 521728
+sz 4T cpus 8 agcount 8 logblocks 521728
+sz 4T cpus 16 agcount 16 logblocks 521728
+sz 4T cpus 32 agcount 32 logblocks 521728
+sz 4T cpus 40 agcount 40 logblocks 521728
+sz 4T cpus 64 agcount 64 logblocks 521728
+sz 4T cpus 96 agcount 96 logblocks 521728
+sz 4T cpus 160 agcount 160 logblocks 521728
+sz 4T cpus 512 agcount 512 logblocks 521728
+-----------------
+sz 16T cpus 2 agcount 16 logblocks 521728
+sz 16T cpus 4 agcount 16 logblocks 521728
+sz 16T cpus 8 agcount 16 logblocks 521728
+sz 16T cpus 16 agcount 16 logblocks 521728
+sz 16T cpus 32 agcount 32 logblocks 521728
+sz 16T cpus 40 agcount 40 logblocks 521728
+sz 16T cpus 64 agcount 64 logblocks 521728
+sz 16T cpus 96 agcount 96 logblocks 521728
+sz 16T cpus 160 agcount 160 logblocks 521728
+sz 16T cpus 512 agcount 512 logblocks 521728
+-----------------
+sz 64T cpus 2 agcount 64 logblocks 521728
+sz 64T cpus 4 agcount 64 logblocks 521728
+sz 64T cpus 8 agcount 64 logblocks 521728
+sz 64T cpus 16 agcount 64 logblocks 521728
+sz 64T cpus 32 agcount 64 logblocks 521728
+sz 64T cpus 40 agcount 64 logblocks 521728
+sz 64T cpus 64 agcount 64 logblocks 521728
+sz 64T cpus 96 agcount 96 logblocks 521728
+sz 64T cpus 160 agcount 160 logblocks 521728
+sz 64T cpus 512 agcount 512 logblocks 521728
+-----------------
+sz 256T cpus 2 agcount 256 logblocks 521728
+sz 256T cpus 4 agcount 256 logblocks 521728
+sz 256T cpus 8 agcount 256 logblocks 521728
+sz 256T cpus 16 agcount 256 logblocks 521728
+sz 256T cpus 32 agcount 256 logblocks 521728
+sz 256T cpus 40 agcount 256 logblocks 521728
+sz 256T cpus 64 agcount 256 logblocks 521728
+sz 256T cpus 96 agcount 256 logblocks 521728
+sz 256T cpus 160 agcount 256 logblocks 521728
+sz 256T cpus 512 agcount 512 logblocks 521728
+-----------------
+sz 512T cpus 2 agcount 512 logblocks 521728
+sz 512T cpus 4 agcount 512 logblocks 521728
+sz 512T cpus 8 agcount 512 logblocks 521728
+sz 512T cpus 16 agcount 512 logblocks 521728
+sz 512T cpus 32 agcount 512 logblocks 521728
+sz 512T cpus 40 agcount 512 logblocks 521728
+sz 512T cpus 64 agcount 512 logblocks 521728
+sz 512T cpus 96 agcount 512 logblocks 521728
+sz 512T cpus 160 agcount 512 logblocks 521728
+sz 512T cpus 512 agcount 512 logblocks 521728
+-----------------
+sz 1P cpus 2 agcount 1024 logblocks 521728
+sz 1P cpus 4 agcount 1024 logblocks 521728
+sz 1P cpus 8 agcount 1024 logblocks 521728
+sz 1P cpus 16 agcount 1024 logblocks 521728
+sz 1P cpus 32 agcount 1024 logblocks 521728
+sz 1P cpus 40 agcount 1024 logblocks 521728
+sz 1P cpus 64 agcount 1024 logblocks 521728
+sz 1P cpus 96 agcount 1024 logblocks 521728
+sz 1P cpus 160 agcount 1024 logblocks 521728
+sz 1P cpus 512 agcount 1024 logblocks 521728
+-----------------
diff --git a/tests/xfs/614.out.lba512_parent b/tests/xfs/614.out.lba512_parent
new file mode 100644
index 00000000000000..b77659059abb9d
--- /dev/null
+++ b/tests/xfs/614.out.lba512_parent
@@ -0,0 +1,177 @@
+QA output created by 614
+sz 16M cpus 2 agcount 1 logblocks 2001
+sz 16M cpus 4 agcount 1 logblocks 2001
+sz 16M cpus 8 agcount 1 logblocks 2001
+sz 16M cpus 16 agcount 1 logblocks 2001
+sz 16M cpus 32 agcount 1 logblocks 2001
+sz 16M cpus 40 agcount 1 logblocks 2001
+sz 16M cpus 64 agcount 1 logblocks 2001
+sz 16M cpus 96 agcount 1 logblocks 2001
+sz 16M cpus 160 agcount 1 logblocks 2001
+sz 16M cpus 512 agcount 1 logblocks 2001
+-----------------
+sz 512M cpus 2 agcount 4 logblocks 16384
+sz 512M cpus 4 agcount 4 logblocks 16384
+sz 512M cpus 8 agcount 4 logblocks 16384
+sz 512M cpus 16 agcount 4 logblocks 16384
+sz 512M cpus 32 agcount 4 logblocks 16384
+sz 512M cpus 40 agcount 4 logblocks 16384
+sz 512M cpus 64 agcount 4 logblocks 16384
+sz 512M cpus 96 agcount 4 logblocks 16384
+sz 512M cpus 160 agcount 4 logblocks 16384
+sz 512M cpus 512 agcount 4 logblocks 16384
+-----------------
+sz 1G cpus 2 agcount 4 logblocks 16384
+sz 1G cpus 4 agcount 4 logblocks 16384
+sz 1G cpus 8 agcount 4 logblocks 16384
+sz 1G cpus 16 agcount 4 logblocks 16384
+sz 1G cpus 32 agcount 4 logblocks 25087
+sz 1G cpus 40 agcount 4 logblocks 31359
+sz 1G cpus 64 agcount 4 logblocks 50175
+sz 1G cpus 96 agcount 4 logblocks 65524
+sz 1G cpus 160 agcount 4 logblocks 65524
+sz 1G cpus 512 agcount 4 logblocks 65524
+-----------------
+sz 2G cpus 2 agcount 4 logblocks 16384
+sz 2G cpus 4 agcount 4 logblocks 16384
+sz 2G cpus 8 agcount 4 logblocks 16384
+sz 2G cpus 16 agcount 4 logblocks 16384
+sz 2G cpus 32 agcount 4 logblocks 25087
+sz 2G cpus 40 agcount 4 logblocks 31359
+sz 2G cpus 64 agcount 4 logblocks 50175
+sz 2G cpus 96 agcount 4 logblocks 75262
+sz 2G cpus 160 agcount 4 logblocks 125437
+sz 2G cpus 512 agcount 4 logblocks 131060
+-----------------
+sz 16G cpus 2 agcount 4 logblocks 16384
+sz 16G cpus 4 agcount 4 logblocks 16384
+sz 16G cpus 8 agcount 4 logblocks 16384
+sz 16G cpus 16 agcount 4 logblocks 16384
+sz 16G cpus 32 agcount 4 logblocks 25087
+sz 16G cpus 40 agcount 4 logblocks 31359
+sz 16G cpus 64 agcount 4 logblocks 50175
+sz 16G cpus 96 agcount 4 logblocks 75262
+sz 16G cpus 160 agcount 4 logblocks 125437
+sz 16G cpus 512 agcount 4 logblocks 401400
+-----------------
+sz 64G cpus 2 agcount 4 logblocks 16384
+sz 64G cpus 4 agcount 4 logblocks 16384
+sz 64G cpus 8 agcount 8 logblocks 16384
+sz 64G cpus 16 agcount 16 logblocks 16384
+sz 64G cpus 32 agcount 16 logblocks 25087
+sz 64G cpus 40 agcount 16 logblocks 31359
+sz 64G cpus 64 agcount 16 logblocks 50175
+sz 64G cpus 96 agcount 16 logblocks 75262
+sz 64G cpus 160 agcount 16 logblocks 125437
+sz 64G cpus 512 agcount 16 logblocks 401400
+-----------------
+sz 256G cpus 2 agcount 4 logblocks 32768
+sz 256G cpus 4 agcount 4 logblocks 32768
+sz 256G cpus 8 agcount 8 logblocks 32768
+sz 256G cpus 16 agcount 16 logblocks 32768
+sz 256G cpus 32 agcount 32 logblocks 32768
+sz 256G cpus 40 agcount 40 logblocks 32767
+sz 256G cpus 64 agcount 64 logblocks 50175
+sz 256G cpus 96 agcount 64 logblocks 75262
+sz 256G cpus 160 agcount 64 logblocks 125437
+sz 256G cpus 512 agcount 64 logblocks 401400
+-----------------
+sz 512G cpus 2 agcount 4 logblocks 65536
+sz 512G cpus 4 agcount 4 logblocks 65536
+sz 512G cpus 8 agcount 8 logblocks 65536
+sz 512G cpus 16 agcount 16 logblocks 65536
+sz 512G cpus 32 agcount 32 logblocks 65536
+sz 512G cpus 40 agcount 40 logblocks 65535
+sz 512G cpus 64 agcount 64 logblocks 65536
+sz 512G cpus 96 agcount 96 logblocks 75262
+sz 512G cpus 160 agcount 128 logblocks 125437
+sz 512G cpus 512 agcount 128 logblocks 401400
+-----------------
+sz 1T cpus 2 agcount 4 logblocks 131072
+sz 1T cpus 4 agcount 4 logblocks 131072
+sz 1T cpus 8 agcount 8 logblocks 131072
+sz 1T cpus 16 agcount 16 logblocks 131072
+sz 1T cpus 32 agcount 32 logblocks 131072
+sz 1T cpus 40 agcount 40 logblocks 131071
+sz 1T cpus 64 agcount 64 logblocks 131072
+sz 1T cpus 96 agcount 96 logblocks 131071
+sz 1T cpus 160 agcount 160 logblocks 131071
+sz 1T cpus 512 agcount 256 logblocks 401400
+-----------------
+sz 2T cpus 2 agcount 4 logblocks 262144
+sz 2T cpus 4 agcount 4 logblocks 262144
+sz 2T cpus 8 agcount 8 logblocks 262144
+sz 2T cpus 16 agcount 16 logblocks 262144
+sz 2T cpus 32 agcount 32 logblocks 262144
+sz 2T cpus 40 agcount 40 logblocks 262143
+sz 2T cpus 64 agcount 64 logblocks 262144
+sz 2T cpus 96 agcount 96 logblocks 262143
+sz 2T cpus 160 agcount 160 logblocks 262143
+sz 2T cpus 512 agcount 512 logblocks 401400
+-----------------
+sz 4T cpus 2 agcount 4 logblocks 521728
+sz 4T cpus 4 agcount 4 logblocks 521728
+sz 4T cpus 8 agcount 8 logblocks 521728
+sz 4T cpus 16 agcount 16 logblocks 521728
+sz 4T cpus 32 agcount 32 logblocks 521728
+sz 4T cpus 40 agcount 40 logblocks 521728
+sz 4T cpus 64 agcount 64 logblocks 521728
+sz 4T cpus 96 agcount 96 logblocks 521728
+sz 4T cpus 160 agcount 160 logblocks 521728
+sz 4T cpus 512 agcount 512 logblocks 521728
+-----------------
+sz 16T cpus 2 agcount 16 logblocks 521728
+sz 16T cpus 4 agcount 16 logblocks 521728
+sz 16T cpus 8 agcount 16 logblocks 521728
+sz 16T cpus 16 agcount 16 logblocks 521728
+sz 16T cpus 32 agcount 32 logblocks 521728
+sz 16T cpus 40 agcount 40 logblocks 521728
+sz 16T cpus 64 agcount 64 logblocks 521728
+sz 16T cpus 96 agcount 96 logblocks 521728
+sz 16T cpus 160 agcount 160 logblocks 521728
+sz 16T cpus 512 agcount 512 logblocks 521728
+-----------------
+sz 64T cpus 2 agcount 64 logblocks 521728
+sz 64T cpus 4 agcount 64 logblocks 521728
+sz 64T cpus 8 agcount 64 logblocks 521728
+sz 64T cpus 16 agcount 64 logblocks 521728
+sz 64T cpus 32 agcount 64 logblocks 521728
+sz 64T cpus 40 agcount 64 logblocks 521728
+sz 64T cpus 64 agcount 64 logblocks 521728
+sz 64T cpus 96 agcount 96 logblocks 521728
+sz 64T cpus 160 agcount 160 logblocks 521728
+sz 64T cpus 512 agcount 512 logblocks 521728
+-----------------
+sz 256T cpus 2 agcount 256 logblocks 521728
+sz 256T cpus 4 agcount 256 logblocks 521728
+sz 256T cpus 8 agcount 256 logblocks 521728
+sz 256T cpus 16 agcount 256 logblocks 521728
+sz 256T cpus 32 agcount 256 logblocks 521728
+sz 256T cpus 40 agcount 256 logblocks 521728
+sz 256T cpus 64 agcount 256 logblocks 521728
+sz 256T cpus 96 agcount 256 logblocks 521728
+sz 256T cpus 160 agcount 256 logblocks 521728
+sz 256T cpus 512 agcount 512 logblocks 521728
+-----------------
+sz 512T cpus 2 agcount 512 logblocks 521728
+sz 512T cpus 4 agcount 512 logblocks 521728
+sz 512T cpus 8 agcount 512 logblocks 521728
+sz 512T cpus 16 agcount 512 logblocks 521728
+sz 512T cpus 32 agcount 512 logblocks 521728
+sz 512T cpus 40 agcount 512 logblocks 521728
+sz 512T cpus 64 agcount 512 logblocks 521728
+sz 512T cpus 96 agcount 512 logblocks 521728
+sz 512T cpus 160 agcount 512 logblocks 521728
+sz 512T cpus 512 agcount 512 logblocks 521728
+-----------------
+sz 1P cpus 2 agcount 1024 logblocks 521728
+sz 1P cpus 4 agcount 1024 logblocks 521728
+sz 1P cpus 8 agcount 1024 logblocks 521728
+sz 1P cpus 16 agcount 1024 logblocks 521728
+sz 1P cpus 32 agcount 1024 logblocks 521728
+sz 1P cpus 40 agcount 1024 logblocks 521728
+sz 1P cpus 64 agcount 1024 logblocks 521728
+sz 1P cpus 96 agcount 1024 logblocks 521728
+sz 1P cpus 160 agcount 1024 logblocks 521728
+sz 1P cpus 512 agcount 1024 logblocks 521728
+-----------------
