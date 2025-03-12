Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61BBC1F12F1;
	Wed, 12 Mar 2025 23:11:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741821109; cv=none; b=eQ0oBL+AbON8FwudALB5poOHL0ptz/DBr3FacUuutB5w1bIQzcSREcUJIfsQf2SNc1damRfcENWrQkOQZ44j4hb51sr36bmsxZCLApOge9EsHViRPBeiIgt93S74t0Tm4XCTMaaXcsT0ohtaVU4vgi7bWCD+DsLigS0ZcI4E88w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741821109; c=relaxed/simple;
	bh=7md1fT4J8la6NB8X5MqoHWWlkWJ5c5EnxluckLLYGjE=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=RA8XBbZqFDt8H06SRfmRpJhkN00lJe/OFzh6TymKqSSYi1jKI50PltLsBOaQhx8XxZNa+30RMBM4J1Uo2V9JkH5+hwckG2U2g+tSIekWLyS90CuAgaEI2WVAWO0SJZjr3c7tkPRs7tjk0SQyHAaCRKfRdSv0aeJh+U44hn+C0qs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=p2ljCGYA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="p2ljCGYA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1824C4CEE3;
	Wed, 12 Mar 2025 23:11:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1741821108;
	bh=7md1fT4J8la6NB8X5MqoHWWlkWJ5c5EnxluckLLYGjE=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=p2ljCGYALIp/LraDbuuPJdG+KZh3BFq3edEhQ2azYQWYy0DuZ5b2sXxCJEfRdq0uG
	 H27c2Gg9aSKQ7Pb24/elM5/5aATcRGhrIfjAIx7imMZM9S/XC+/pfWL6iUa1vrYp9b
	 ZLoCn2TSbac8VjbcwDujt0GgV0+Kcy8jZhBXSCwzEEq5aUL5taXGhq9wRGFWtmtjbt
	 m4K91FJlPcWX5SBa+EgwcSAUNgXSP/q1FjAIW44BdDy+WOo7YNchFdIajyYy+TZTin
	 ZuOJ2L53q/j6TS6Fu1MjMoAReJJq78uVDPevLs5qFUPDgInjw4eN/fSU8moUGwdoOH
	 UthMH9G8TeWDA==
Date: Wed, 12 Mar 2025 16:11:48 -0700
Subject: [PATCH 2/3] generic/537: disable quota mount options for pre-metadir
 rt filesystems
From: "Darrick J. Wong" <djwong@kernel.org>
To: zlang@redhat.com, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Message-ID: <174182089142.1400713.12586249978501158339.stgit@frogsfrogsfrogs>
In-Reply-To: <174182089094.1400713.5283745853237966823.stgit@frogsfrogsfrogs>
References: <174182089094.1400713.5283745853237966823.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Fix this regression in generic/537:

mount: /opt: permission denied.
       dmesg(1) may have more information after failed mount system call.
mount -o uquota,gquota,pquota, -o ro,norecovery -ortdev=/dev/sdb4 /dev/sda4 /opt failed
mount -o uquota,gquota,pquota, -o ro,norecovery -ortdev=/dev/sdb4 /dev/sda4 /opt failed
(see /var/tmp/fstests/generic/537.full for details)

for reasons explained in the giant comment.  TLDR: quota and rt aren't
compatible on older xfs filesystems so we have to work around that.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 tests/generic/537 |   17 +++++++++++++++++
 1 file changed, 17 insertions(+)


diff --git a/tests/generic/537 b/tests/generic/537
index f57bc1561dd57e..3be743c4133f4f 100755
--- a/tests/generic/537
+++ b/tests/generic/537
@@ -18,6 +18,7 @@ _begin_fstest auto quick trim
 
 # Import common functions.
 . ./common/filter
+. ./common/quota
 
 _require_scratch
 _require_fstrim
@@ -36,6 +37,22 @@ _scratch_mount -o ro >> $seqres.full 2>&1
 $FSTRIM_PROG -v $SCRATCH_MNT >> $seqres.full 2>&1
 _scratch_unmount
 
+# As of kernel commit 9f0902091c332b ("xfs: Do not allow norecovery mount with
+# quotacheck"), it is no longer possible to mount with "norecovery" and any
+# quota mount option if the quota mount options would require a metadata update
+# such as quotacheck.  For a pre-metadir XFS filesystem with a realtime volume
+# and quota-enabling options, the first two mount attempts will have succeeded
+# but with quotas disabled.  The mount option parsing for this next mount
+# attempt will see the same quota-enabling options and a lack of qflags in the
+# ondisk metadata and reject the mount because it thinks that will require
+# quotacheck.  Edit out the quota mount options for this specific
+# configuration.
+if [ "$FSTYP" = "xfs" ]; then
+	if [ "$USE_EXTERNAL" = "yes" ] && [ -n "$SCRATCH_RTDEV" ]; then
+		_qmount_option ""
+	fi
+fi
+
 echo "fstrim on ro mount with no log replay"
 norecovery="norecovery"
 test $FSTYP = "btrfs" && norecovery=nologreplay

