Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEF1F7082F;
	Fri, 22 Nov 2024 16:54:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732294494; cv=none; b=KXZJS3LBdU/2muV/gm0hFUpnqPolQxzOxYbAk6eWK2NQbiJyv/PSwd/415CDJbVZV/BAJNjIm43z9PwgTNLfc/VOTSGV4EJAkHHm1XSYe0k+a4rXRNThdVPLdMfxla1TDJhWScERLNIeMJd3VLFMQCtOrpXH05k6P14m6pofLpE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732294494; c=relaxed/simple;
	bh=u/Fh2gjxTg+tmrMRCsGA2+Mcd2OI98kMFiliB2UDlqo=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=JlI5vfwjsKji5uvxZvdCMkbmPT2qraeO64ulBbzSu6PrD5yd4cueE+U4SU/eEeTXwT3mNmj3Hlrop/bWajo6YUmdyubuveArGYhTgaKl9xX7wR9RvcHeYKIAfiERbnWFx1hA7RBnBJY8MmO0sfdv7aP1BPqWC5sMuxYP3030an8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VmVUQBLb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VmVUQBLb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6ECDDC4CECE;
	Fri, 22 Nov 2024 16:54:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1732294493;
	bh=u/Fh2gjxTg+tmrMRCsGA2+Mcd2OI98kMFiliB2UDlqo=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=VmVUQBLb3DWJIQ4XJTX4g8/9VAnBHcsjEtTb0LNzLqAGeQ7ZAy5d+4pyQ5ejz73/A
	 zDukWogTv2qa2724rmYULJU9XYOKE6PN4M2Zj8iw5AGGA5UiIo18mY/V6kMijFWPzO
	 Y/NFxxlEOfwANRyPnjigu5fcISkuZ2rrZsmyC0FyLnRFNRHwLVEWgJ4s+EC6IXhZZy
	 wbH/h+bAnn2Xk1xK/xyxmIOioyb/EdpYG6nFLPpZylAi2LCdQkBtwiubWH/qArCxcc
	 qx27DrqqFMBM8pY8ZpdtGUSbQx8FUlwDbgt8L8vfxV1XHGRTmYKs4JHnroyNQL/7Iq
	 eNbJTpt1fDvPA==
Date: Fri, 22 Nov 2024 08:54:53 -0800
Subject: [PATCH 17/17] generic/366: fix directio requirements checking
From: "Darrick J. Wong" <djwong@kernel.org>
To: zlang@redhat.com, djwong@kernel.org
Cc: fstests@vger.kernel.org, fstests@vger.kernel.org,
 linux-xfs@vger.kernel.org
Message-ID: <173229420269.358248.6325435085396026110.stgit@frogsfrogsfrogs>
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

From: Darrick J. Wong <djwong@kernel.org>

On a system with 4k-sector storage devices, this test fails with:

 --- /tmp/fstests/tests/generic/366.out	2024-11-17 09:04:53.161104479 -0800
 +++ /var/tmp/fstests/generic/366.out.bad	2024-11-20 21:02:30.948000000 -0800
 @@ -1,2 +1,34 @@
  QA output created by 366
 +fio: io_u error on file /opt/file1: Invalid argument: read offset=15360, buflen=512
 +fio: io_u error on file /opt/file1: Invalid argument: read offset=15360, buflen=512

The cause of this failure is that we cannot do 512byte directios to a
device with 4k LBAs.  Update the precondition checking to exclude this
scenario.

Cc: <fstests@vger.kernel.org> # v2024.11.17
Fixes: 4c1629ae3a3a56 ("generic: new test case to verify if certain fio load will hang the filesystem")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 tests/generic/366 |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)


diff --git a/tests/generic/366 b/tests/generic/366
index 6e7dd7279218c4..b322bcca72fecc 100755
--- a/tests/generic/366
+++ b/tests/generic/366
@@ -20,7 +20,7 @@ _begin_fstest auto quick rw
 . ./common/filter
 
 _require_scratch
-_require_odirect
+_require_odirect 512	# see fio job1 config below
 _require_aio
 
 _fixed_by_kernel_commit xxxxxxxxxxxx \

