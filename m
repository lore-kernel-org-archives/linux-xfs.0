Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39515521222;
	Mon,  7 Sep 2026 16:41:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788799267; cv=none; b=Eg5hhB9s8klhEIw8AjBWY5cCkZR/B21cW8Mt6aik8uVZy5SZSGQEAa/nsTXkDC8Ld4+/EWp/2vcK+TXi4CfM5DK0PQ92yTVkK4stysaY1FanV51cZlXzUmGMWsOURHi8x9dr9iAwxhOIiG35kpHrznYBqfKyxnVqShLG3ynTHmM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788799267; c=relaxed/simple;
	bh=yHVO9IW0P6E/t6ZIXzcboEpbp/L6AoTtc20agFnNINM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LsZd7FTBr5/WHcRw/zDCbjFfDFzyQyPhjovHtdFezlz45R3B7VUrisBuV1L/fZUx00Zg6abOkaOkSpPdm+/dWqIzBY7I6hT5FPscMMeJCuzHsuVVU/iQO3ILMVfk3mW4fxIQ8ZA7d4XXaEccGsrdX10sWe9NjfL0ZBtRInreIF0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lUdfek25; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lUdfek25"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BEB641F00A3D;
	Mon,  7 Sep 2026 16:41:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788799265;
	bh=OC6f08LI8bFuM3kv3Q/QPSpvwK1RYWMLUx3wTdqhFYM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lUdfek250pi4ZiuJcWQoOVeaC/UPoWtxecSNzzSrF27WVD14uJ/2wspmRsb/m1rvI
	 yQpaRxRFH/fl9y8TV+QXJS5Yo30IbLpO5n66UKz9CRzk9yNp46MWqU8DON+C6qt8ZY
	 urLo5k7j2Di6M7uvpStwNRCnko++Lt0ekWgwsbILRpAzTQ81WWK8f5ckrcK6EwHCXA
	 RzgsUBHj6FOvQ33n2+lYU/Ti66D8Zx3fInNcQB4DOKFewV248zHSOGPWVwjjiLnqCE
	 Z2namBTsDbacHmUyTh18ntbhTJxUyeA+i5L4UeuLR9LS3XUFGkt4mV5o7yrN7JI0sK
	 7efihbjzYB2cg==
From: cem@kernel.org
To: zlang@kernel.org
Cc: djwong@kernel.org,
	hch@lst.de,
	linux-xfs@vger.kernel.org,
	fstests@vger.kernel.org,
	jack@suse.cz
Subject: [RFC PATCH 1/2] common/nfs: add management helpers
Date: Mon,  7 Sep 2026 18:40:47 +0200
Message-ID: <20260907164054.111393-2-cem@kernel.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260907164054.111393-1-cem@kernel.org>
References: <20260907164054.111393-1-cem@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Carlos Maiolino <cem@kernel.org>

This adds a few new helpers to manage local nfs client/servers. These
can be used to exercise bugs which happens through a nfs share.

Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
---
 common/nfs | 55 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 55 insertions(+)

diff --git a/common/nfs b/common/nfs
index a03eaf48e1c0..4508a8a2e494 100644
--- a/common/nfs
+++ b/common/nfs
@@ -33,3 +33,58 @@ _require_scratch_nfs_version()
 	fi
 	_scratch_unmount
 }
+
+# Start rpcbind if it is not already running.
+_start_rpcbind()
+{
+	rpcinfo -p localhost > /dev/null 2>&1 && return 0
+	rpcbind 2>> $seqres.full || _notrun "Cannot start rpcbind"
+	/usr/sbin/rpc.statd 2>> $seqres.full || _notrun "Cannot start rpc.statd"
+	/usr/sbin/rpc.idmapd 2>> $seqres.full || _notrun "Cannot start rpc.idmapd"
+	/usr/sbin/nfsdcld 2>> $seqres.full || _notrun "Cannot start nfsdcld"
+
+}
+
+# Stop rpcbind.
+_stop_rpcbind()
+{
+	pkill rpcbind 2>/dev/null
+}
+
+# Start the NFS server if not already running.
+_start_nfsd()
+{
+	rpcinfo -p localhost 2>/dev/null | grep -q nfs && return 0
+	rpc.nfsd 2>> $seqres.full || _notrun "Cannot start rpc.nfsd"
+	rpc.mountd 2>> $seqres.full || _notrun "Cannot start rpc.mountd"
+}
+
+# Stop the NFS server.
+_stop_nfsd()
+{
+	rpc.nfsd 0 2>/dev/null
+	pkill rpc.mountd 2>/dev/null
+}
+
+# Require a NFS server to be available and start rpcbind and nfsd if they are
+# not already running.
+_require_nfs_server()
+{
+	type -P exportfs > /dev/null 2>&1 || \
+		_notrun "exportfs utility required, skipped this test"
+	type -P rpc.nfsd > /dev/null 2>&1 || \
+		_notrun "rpc.nfsd utility required, skipped this test"
+	type -P rpc.mountd > /dev/null 2>&1 || \
+		_notrun "rpc.mountd utility required, skipped this test"
+	_start_rpcbind
+	_start_nfsd
+}
+
+# Require a NFS client to be available.
+_require_nfs_client()
+{
+	grep -q nfs /proc/filesystems 2>/dev/null || \
+		_notrun "Kernel does not support NFS client"
+	type -P mount.nfs > /dev/null 2>&1 || \
+		_notrun "mount.nfs utility required, skipped this test"
+}
-- 
2.55.0

