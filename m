Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 110832E2663
	for <linux-xfs@vger.kernel.org>; Mon, 22 Sep 2025 15:29:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758554996; cv=none; b=MgdfbAUJ+O8XUqYNQQ478IuOhGc7u02M7JG/+I9Kmg11V8wgaAoj7V4lh7mnBW1YuPR7xtb2DX1Y93mSW4BfDeS7UlJkhkPqOEFYtkCmyw9TPs4nCngVr62gJsjOjICdNHJnk0Jpvl4C851GozUhcmaxnzAUn3nAjkN2hgaFdw0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758554996; c=relaxed/simple;
	bh=wi0I7dYLmikNzwUUKmxZRMbNa1yqfKeXJmN8wHuG6Qc=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=KGmeSzTVFsSmEg87lD/Jrc4XuKPA28xlzlItJb2W/lU7lUwMFcDIxxeSOWd52t+eRkH2Tv6QXr5gx2FNZ+a+JqPse519dnf716PhJQtrbFvz30htE5zWsDO4PVLBorUm0D4BMhfSLoTx/dSLcLGMxarvkGpUmf8lNnLAc4JSR3M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kerB5JcH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kerB5JcH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D3D0C4CEF0;
	Mon, 22 Sep 2025 15:29:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1758554995;
	bh=wi0I7dYLmikNzwUUKmxZRMbNa1yqfKeXJmN8wHuG6Qc=;
	h=Date:From:To:Cc:Subject:From;
	b=kerB5JcHaWcgGzYosJpupL1nJHW3aydzmDlW4MuQGC1jncoZP9kaZ7l+mXXAOFzTS
	 bjbAzic6JRJQtgK3m3ZIti5GIAR66J98nnxcb+mFZH651YtbtrMkJsR+Z5drhdlIhA
	 WJnJZ3ScGD4n/ZGp/dc7O1Jv225Ieo8GTnpv2Bsere88NjISAZKdekW+vme+05+PzG
	 RDGKwdB2lO5Oj5xUSmlEhrxMmKfOfu0f2+JZGEKmAmvsdGxnGAEGfcx9bFNelEdKxO
	 6N/bx6E3d/0UDanpDbxV5IGHC7ZheE3opSwSMp0VqIqXy19uJ5bI+mFrbC9WbYvl0Y
	 97VlTL2shpgwg==
Date: Mon, 22 Sep 2025 08:29:54 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: xfs <linux-xfs@vger.kernel.org>
Cc: Andrey Albershteyn <aalbersh@redhat.com>
Subject: regressions in xfs/633 and xfs/437?
Message-ID: <20250922152954.GR8096@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hey folks,

Have any of you noticed a recent regression in xfs/437 and xfs/633?

--- /run/fstests/bin/tests/xfs/437.out	2025-07-15 14:41:40.303420629 -0700
+++ /var/tmp/fstests/xfs/437.out.bad	2025-09-21 18:53:36.368250642 -0700
@@ -1,2 +1,3 @@
 QA output created by 437
 Silence is golden.
+mkfs/proto.c:1428:	error = libxfs_iget(mp, NULL, dst_ino, 0, &ip);

--- /var/tmp/fstests/xfs/633.out.bad
+++ /dev/fd/63	2025-09-21 17:45:58.431935255 -0700
@@ -1,6 +1,107468 @@
 QA output created by 633
 Format and populate
 Recover filesystem
+./common/xfs: line 335: 326611 Segmentation fault      (core dumped) $XFS_DB_PROG "$@" $(_scratch_xfs_db_options)
+./common/xfs: line 335: 326617 Segmentation fault      (core dumped) $XFS_DB_PROG "$@" $(_scratch_xfs_db_options)
 Check file contents
+--- /tmp/326192.stat.before	2025-09-21 17:36:10.071959154 -0700
++++ /tmp/326192.stat.after	2025-09-21 17:36:12.863959041 -0700
+@@ -1,23 +1,3 @@
+-11a4 0:0 0 0 fifo 0 1731556303 ./S_IFIFO
+-2000 0:0 0 0 character special file 0 1758501368 ./newfiles/p0/d1/c19
+-2000 0:0 0 0 character special file 0 1758501368 ./newfiles/p0/d1/c1a
<snip>

The xfs/437 failure is trivially fixable, not sure what's causing the
segfault here?  Probably something in the new file_{get,set}attr code in
xfs_db is my guess...?

MKFS_OPTIONS  -- -f -m metadir=1,autofsck=1,uquota,gquota,pquota, -n size=8k, /dev/sdf
MOUNT_OPTIONS -- /dev/sdf /opt

(note that both problems happen on a variety of different
configurations)

--D
