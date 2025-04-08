Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83B9723C8C3;
	Tue,  8 Apr 2025 18:17:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744136253; cv=none; b=t6hB7osOJc45M+oZmr73rv1V1w7ZQ7/En3XkyqWITkYRtHifaNjfADqPDJjRfvqWgAbPTatU1Ug3WB83fis1eW2lJXi8EglHmXl0kd0fiTG2UpTsgSzsyDnA4KgCWvpOzVTJpnyKaA3k3z5iebY/Q9HuMhwuUfgnvCLGJCAGdk8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744136253; c=relaxed/simple;
	bh=O/kxoYf6jlgmM4m3JrleHYEoXbE8s6HNTj/svKRRK74=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=lyJYtPp1hTXMW9mse2cfzMKgResEVdWTNYqdlozn/POF9INmrrzNxhnjrdBZR69im+QH3J7Ki3vsBg0uHrRitSRoJqKmmx9bNxQ+E+MmOajTH1VslZtzLmDgw4QKX00QJr3WPJ4+uDjP4L7q9JkYK4Yeo/KCpGqnndwc8Ol+Dig=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZBWjDF1h; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZBWjDF1h"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D96CDC4CEE5;
	Tue,  8 Apr 2025 18:17:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1744136253;
	bh=O/kxoYf6jlgmM4m3JrleHYEoXbE8s6HNTj/svKRRK74=;
	h=Date:From:To:Cc:Subject:From;
	b=ZBWjDF1hzQdAb3vCbz+ZK4uo2isvU5eRv1MaqEuCW2e+DgSe03HlK+UR/tOx3xG4h
	 krh30S2UMPai3Jrwo/OmVKpo4FHb1akIfpiTEuSje5a3onkrvT0+sRu1Ow1XcP0Aox
	 k8S/GK//SK3FPJUzDKhxo2I5lI2X8eAqFtorgsofN8bACMKKfZagwtE2xbisMli6ci
	 FZXeNHKudU1FuWv9SQ3QM5nOSE2VWEOUhsjP/J8wwLpoiD9j0ElOHb336ldjDmmwoF
	 ig1TRJYXaWm7QJT5Bo17dvX1YWMzeZjVSjnihtZrvzLCWFxtS/WXSbo2HEa9NxLXmx
	 k+z20QzC71Fzg==
Date: Tue, 8 Apr 2025 11:17:32 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Zorro Lang <zlang@redhat.com>
Cc: fstests <fstests@vger.kernel.org>, xfs <linux-xfs@vger.kernel.org>,
	Christoph Hellwig <hch@infradead.org>
Subject: [PATCH] xfs/801: provide missing sysfs-dump function
Message-ID: <20250408181732.GH6274@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

From: Darrick J. Wong <djwong@kernel.org>

This test uses sysfs-dump to capture THP diagnostic information to
$seqres.full.  Unfortunately, that's not a standard program (it's one of
my many tools) and I forgot to paste the script into the test.  Hence
it's been broken since merge for everyone else.  Fix it.

Cc: <fstests@vger.kernel.org> # v2024.08.11
Fixes: 518896a7b483c0 ("xfs: test online repair when xfiles consists of THPs")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 tests/xfs/801 |   12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/tests/xfs/801 b/tests/xfs/801
index 1190cfab8a9f94..a05a6efc1a9058 100755
--- a/tests/xfs/801
+++ b/tests/xfs/801
@@ -42,6 +42,18 @@ test -w "$knob" || _notrun "tmpfs transparent hugepages disabled"
 pagesize=`getconf PAGE_SIZE`
 pagesize_kb=$((pagesize / 1024))
 
+sysfs-dump() {
+	for i in "$@"; do
+		if [ -d "$i" ]; then
+			for x in "$i/"*; do
+				test -f "$x" && echo "$x: $(cat "$x")"
+			done
+		else
+			test -f "$i" && echo "$i: $(cat "$i")"
+		fi
+	done
+}
+
 echo "settings now: pagesize=${pagesize_kb}KB" >> $seqres.full
 sysfs-dump /sys/kernel/mm/transparent_hugepage/* >> $seqres.full
 
