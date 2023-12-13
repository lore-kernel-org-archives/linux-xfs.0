Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C791224E8;
	Wed, 13 Dec 2023 22:34:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="qrUqOhhI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B676C433C7;
	Wed, 13 Dec 2023 22:34:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1702506880;
	bh=+cSw5p+7uvHF78olMTp+YdaRZOGROXOa64Wx3n+65+Y=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
	b=qrUqOhhIwmdYC5nKXgTredjMWfeDtwvrCdEzbv7OnPlKM/NSi+ZBFDCr07vxntYNf
	 pw6QOtQZ/hai4YiyxeZh6TekTsJ9jlTxd835c8CYzKwqR7cYLTCwL06GSGBaFXglOh
	 ogdsiGLx6Rizisxb4l07b7+Ee0VDUuwxFH/4HXerKxOM4baAELpK8AtfKLrv6vWGg1
	 WpquCBDR6m6cQ0gt8WTIOhMv+sWjPvrVWxokNDQfw3bduAgQzbe8KeAfhE1xnnjzYt
	 su3i28cafn9bWU8zODJ5my0Pu6k2XL+KXnY3YjGbUVPP5mPB8e13TdiYDlW8ox7AfL
	 WyYgckDf1IuRA==
Subject: [PATCH 2/3] generic/410: don't blow away seqres.full during test
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, zlang@redhat.com
Cc: guan@eryu.me, fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Date: Wed, 13 Dec 2023 14:34:39 -0800
Message-ID: <170250687956.1363584.15519840736150289118.stgit@frogsfrogsfrogs>
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

Don't truncate $seqres.full every time we format a new filesystem; this
makes debugging of this weird failure:

--- /tmp/fstests/tests/generic/410.out	2023-07-11 12:18:21.642971022 -0700
+++ /var/tmp/fstests/generic/410.out.bad	2023-11-29 01:13:00.020000000 -0800
@@ -107,6 +107,9 @@ mpB/dir SCRATCH_DEV
 mpC SCRATCH_DEV
 mpC/dir SCRATCH_DEV
 ======
+mkdir: cannot create directory '/mnt/410/3871733_mpA': File exists
+mkdir: cannot create directory '/mnt/410/3871733_mpB': File exists
+mkdir: cannot create directory '/mnt/410/3871733_mpC': File exists
 make-shared a slave shared mount
 before make-shared run on slave shared
 ------

nearly impossible.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 tests/generic/410 |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)


diff --git a/tests/generic/410 b/tests/generic/410
index 8cc36d9f38..5fb5441a0c 100755
--- a/tests/generic/410
+++ b/tests/generic/410
@@ -93,7 +93,7 @@ start_test()
 {
 	local type=$1
 
-	_scratch_mkfs >$seqres.full 2>&1
+	_scratch_mkfs >>$seqres.full 2>&1
 	_get_mount -t $FSTYP $SCRATCH_DEV $MNTHEAD
 	$MOUNT_PROG --make-"${type}" $MNTHEAD
 	mkdir $mpA $mpB $mpC

