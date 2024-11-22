Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 665A222339;
	Fri, 22 Nov 2024 16:54:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732294478; cv=none; b=B1/IPF6ZKuaQhh4Ypnt791OQ4Bt7dNvdz2dR1jKafKG5tE57rxjILOjuRyO1fU4282dRhkg1DNb3p4gJuxo660isL/OZe5AuZzRlFuwRq1LrY0sc598ZduNQTA+J77xlUImvGP3DHL25SwGaF2TZvNTx/wvhRwVNVf3+9nhFGi0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732294478; c=relaxed/simple;
	bh=xoZYZcbhaXPVuUUb3eqxkHGXvjFqsgU9jp/QiJ6gyyE=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=se/io7lPm2m8LUJYDxJfPVmsHQOfkHbhjgJwyeNvWTxwJ9t/a1kWCsI7hHmAhQ+dOeJccna5xDc6sytqeURKCXIme76hBi5p8rNG8O7P3l65JsxrZ3vN0+pu/zV8heaR7Dx9l9l21ucgnpY7rdcvp4Kv2Yy0XNukevPFd398Rc4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=pp+8XBcY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="pp+8XBcY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D64DBC4CECE;
	Fri, 22 Nov 2024 16:54:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1732294477;
	bh=xoZYZcbhaXPVuUUb3eqxkHGXvjFqsgU9jp/QiJ6gyyE=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=pp+8XBcYIHsxZr+a+k9fivDXNxxQqxNCAX6hwFYp99C0WxfXkni/SUsrCywhh2D3v
	 49XWsDalx8Nv8+a5Wfhtv/hI9Zv60bOjKtN58ROsZxLoU3uUoEy2u/RHb5R2tEWiqp
	 LrOI1RxKILCCanryT/lZtMXRzp48HGP1Lo+S8B0YZy7jPWJ2Z0QzQggvka/ShnXMcA
	 L+LUX07LOw3rYER24F0TWaXxcI5zYOWdjMkIBpW64fvs8Ag3moZ71c1xkxKuqha+Cb
	 TGMTvig/AYMLn4oy68vRGc/G5GWFGoiazjPxp/+VcGaM7Q4Wywc25cO75Rc/7LZEN/
	 QPHZ2wfMWpp1w==
Date: Fri, 22 Nov 2024 08:54:37 -0800
Subject: [PATCH 16/17] xfs/157: do not drop necessary mkfs options
From: "Darrick J. Wong" <djwong@kernel.org>
To: zlang@redhat.com, djwong@kernel.org
Cc: zlang@kernel.org, fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <173229420255.358248.5980322427420325625.stgit@frogsfrogsfrogs>
In-Reply-To: <173229419991.358248.8516467437316874374.stgit@frogsfrogsfrogs>
References: <173229419991.358248.8516467437316874374.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Zorro Lang <zlang@kernel.org>

To give the test option "-L oldlabel" to _scratch_mkfs_sized, xfs/157
does:

  MKFS_OPTIONS="-L oldlabel $MKFS_OPTIONS" _scratch_mkfs_sized $fs_size

but the _scratch_mkfs_sized trys to keep the $fs_size, when mkfs
fails with incompatible $MKFS_OPTIONS options, likes this:

  ** mkfs failed with extra mkfs options added to "-L oldlabel -m rmapbt=1" by test 157 **
  ** attempting to mkfs using only test 157 options: -d size=524288000 -b size=4096 **

but the "-L oldlabel" is necessary, we shouldn't drop it. To avoid
that, we give the "-L oldlabel" to _scratch_mkfs_sized through
function parameters, not through global MKFS_OPTIONS.

Signed-off-by: Zorro Lang <zlang@kernel.org>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
[djwong: fix more string quoting issues]
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 tests/xfs/157 |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)


diff --git a/tests/xfs/157 b/tests/xfs/157
index 9b5badbaeb3c76..e102a5a10abe4b 100755
--- a/tests/xfs/157
+++ b/tests/xfs/157
@@ -66,8 +66,7 @@ scenario() {
 }
 
 check_label() {
-	MKFS_OPTIONS="-L oldlabel $MKFS_OPTIONS" _scratch_mkfs_sized $fs_size \
-		>> $seqres.full
+	_scratch_mkfs_sized "$fs_size" "" -L oldlabel >> $seqres.full 2>&1
 	_scratch_xfs_db -c label
 	_scratch_xfs_admin -L newlabel "$@" >> $seqres.full
 	_scratch_xfs_db -c label

