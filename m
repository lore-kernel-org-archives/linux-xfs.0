Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DE111E5717;
	Mon, 18 Nov 2024 23:04:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731971056; cv=none; b=LpymId+Wk0+IG4omQMVa9HPNH90DMVArr5Me7qAGJit+Nke25/UaIS3ouaOIf2lB6iyvGHq77Q9W0EJDvKN/+UkPV5nSVEzHtBkeTPg2/JNZcp7f3RRKH8zTb1ZpLLP33ftim+0YsFkPvQl32MnB/V+t+dfOzmr3ng2vtoiVPPQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731971056; c=relaxed/simple;
	bh=xoZYZcbhaXPVuUUb3eqxkHGXvjFqsgU9jp/QiJ6gyyE=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=TMo22zgyfAt/fMWOmsrh9hzW+mj3RAkXWpXRY2lS8TxLstWNvkPPZxQhxMMGDfT1Aav9vMdeun3U1Fi/5IIQxFfettmrFz8uMiFKIyylT04VsCobDJzlKL0yP7sF8psPh5/Yj7ofGKL7KieSeNaflUerDfLj6DenMjcjCruF2ro=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=g2FOQzlT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="g2FOQzlT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5B9BC4CECC;
	Mon, 18 Nov 2024 23:04:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1731971055;
	bh=xoZYZcbhaXPVuUUb3eqxkHGXvjFqsgU9jp/QiJ6gyyE=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=g2FOQzlTeJjyx2M0Or1wSK85u2mwu8X2kvEHltlBTCCYnNmXdZDwyY4CG5+IEmtk/
	 2EYKrMisp+eLupNNdtdSFbfg0RHKFwNjrGkiVvlx7nec1pMrj1qEeAnjKMFdx6c69V
	 SfWeVOCdV82RN8IMGvKxqLjg/mknvrxY25OYKqzlwIKqjefSK+g5K7eNzPKCdmigOl
	 5C/+Ng9dElGKrwhvroMrLcyhYunL8GaY4Qwe7xhW8eIGqP/UKCNdP3aOJ/0fd4ELKs
	 8d3+AggWAmVHPG4ChJxfJ7VdG219AMF6Pz1FKeq4jiiwG7mX91EYGN8n/Xx8RY7hRE
	 fQmOMSfQxPUXQ==
Date: Mon, 18 Nov 2024 15:04:15 -0800
Subject: [PATCH 11/12] xfs/157: do not drop necessary mkfs options
From: "Darrick J. Wong" <djwong@kernel.org>
To: zlang@redhat.com, djwong@kernel.org
Cc: zlang@kernel.org, linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Message-ID: <173197064593.904310.9005954163451030743.stgit@frogsfrogsfrogs>
In-Reply-To: <173197064408.904310.6784273927814845381.stgit@frogsfrogsfrogs>
References: <173197064408.904310.6784273927814845381.stgit@frogsfrogsfrogs>
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

