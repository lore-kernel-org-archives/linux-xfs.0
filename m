Received: from flow-b2-smtp.messagingengine.com (flow-b2-smtp.messagingengine.com [202.12.124.137])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8AC533A1689;
	Tue, 29 Sep 2026 03:42:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.137
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790653378; cv=none; b=pGOIoPkwzXhZhaCP3YxUAg+oXaGZGMN1D6JpturciFMotmFDTpCs2tb8rO164TNv2qYdc8oKNwW6jZNlMP0ItnlVnLgbF6elj5IBKYT5PS1/TlawuygDRH586RQ1vRHiZm9e2uM+lTXVTaY2aLHlpX2C9SP88oqoNNjSYlQqSxM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790653378; c=relaxed/simple;
	bh=Qd14xP5VlLyXFKx+ORoztcHxVFAgERVgaqTkeiMmfv4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YJH7400qckQjf+2FzRnhgrbS7eXXkqWVLTvJ8HaIutVVZTxzSqCsuLugz3LtXiYBPKS+vXJNdrmHqkmYNwJwZKr3CovQoBO8ATYmivMYCkdVfoTwgSnNwHox8JEMshxvQc6u+d8MAcYIaOSVdJo4fH8sL9mdVgJruqdda4QbsxU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=ownmail.net; spf=pass smtp.mailfrom=ownmail.net; dkim=pass (2048-bit key) header.d=ownmail.net header.i=@ownmail.net header.b=IO9CGq0n; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=BUefSLyP; arc=none smtp.client-ip=202.12.124.137
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=ownmail.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ownmail.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ownmail.net header.i=@ownmail.net header.b="IO9CGq0n";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="BUefSLyP"
Received: from phl-compute-06.internal (phl-compute-06.internal [10.202.2.46])
	by mailflow.stl.internal (Postfix) with ESMTP id 06FC41301935;
	Mon, 28 Sep 2026 23:42:56 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-06.internal (MEProxy); Mon, 28 Sep 2026 23:42:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ownmail.net; h=
	cc:cc:content-transfer-encoding:content-type:date:date:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:reply-to:subject:subject:to:to; s=fm1; t=1790653375;
	 x=1790660575; bh=2O/60FCivWhWCVVOfomZmHHuRxTPAq2UvXz2LKlNcDs=; b=
	IO9CGq0nVjFm8570ZyKM27IXYcKPj24uoV5oacziNQ3brhdDmFbxyT0nT2TVWOjV
	9U0LCv7x960dMNNFT2ZwoTfLJEtsb1b7WYfmjuny8+MJX3nhvfNZ5XAZrPPa7bjM
	cEmgOjmTYfjLoSTVWSROU1ABqE0dAu5U+eBwOt25CdVk0JsXX/MEHWa80YYGJydK
	Zlyxd4ROsv7AuTCMTefhDLOvS2kMIb/yw5Zkf0L13qd+X9MNrm5qrwlQZYwo/SED
	FegfyydBZa1ZriG9IpSMVPUehQop+SbMYFjR9q/UMK3bRec4tBNnpzx0VZQ1jtQY
	Z7A+zY5fpKZ6+eCJxaeTDg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:reply-to:subject:subject:to:to:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm1; t=1790653375; x=1790660575; bh=2
	O/60FCivWhWCVVOfomZmHHuRxTPAq2UvXz2LKlNcDs=; b=BUefSLyP/rkSO/ut2
	7b2if0LHKCGOmNT2Xrqx1RQrDE0UrwT6mWotfuWdE371Vs6k/5eTJlVORtjUlRl4
	vDen87HLen3IwDO9NWQhNqwuHPiWhKMvaf2Tms+/BFR49++jjfQ+tzdM07JJjfL/
	6oT3tCkzAmtZ6ZWnEHYXPPQEaMsDOlwjC6Ts9pUn1fSUrVTdah5aMI1Wgws/dKKk
	zTG5Fkn4lfcVp02IwhDdvy0x/99xU7QSWd9sgavNtpkQ2A39TP9Lldy6MhZJCfWD
	VG3kl0qc75kSEK8T0gEQiz8KV9SkL8SD3ZHTEeODVFecUaXNMXR0SSdRn52rKyc3
	bqBqw==
X-ME-Sender: <xms:vzO7apxeKOwB8960HYdX2wEZWf8hG0-b0MbfQJ0aurUbwjvyI0HzFA>
    <xme:vzO7asOOAWJcXkwvlKVQXpREg9_qmIKZzWHOIvgEjnwXoG7B1i31JKALzdI4yj5Oo
    1bbCdGocJhKM-AcU6pYzkAKXcLqLliFiCc7zRfmjVJeLeUVrGHD>
X-ME-Received: <xmr:vzO7arhPeTMucOaOkGJaNMh7xWd1QqaIqlSfiSJZLYmqsVNY5ZHy6VIrkdBhPOm0xbLK6cTecsAUGGrmVT4Rvqux0QyHwfI>
X-ME-Proxy-Cause: dmFkZTGoJB+17Zq7ThrEPjmxn4ZGYu519RzWwVi/88aejzKjstMboztaed73ef7D6avpE+
    +4ud1a3y7i3orjwLfnXoctNyz4isc8MlqqkCj9w/LgYTxltRiENCW6GCIqrBIGfd6BoOtn
    3U4T9DnMQq0t334tHmkLT0tBGbfhvTaaBwaOBKtxwtl6WpY46qwankbHLMumQlIvXZxJZX
    MK4M+NdZABlSsm1lFGpu8Zoavf0+po6/QQ3FmqOSdXOPNwreWLw4U6EONlQdAFPuoTNGlS
    rFYPmLdcGE1rV4M0fAMpJKofG+st3+8PfQ+b7I9sMwGW86B3jq8HWH1QNmIbUmtd6GqsIx
    3DVTTK3c2J4I5ksQ7YyAt2ucbNF9r0AlsngiXh1ZkIv7thtpYXLNnTUIfCDQfndn444S46
    l1dh51qZhsKVnaNR6bMarDeu5tNsrUujIGjUBidPSanYSk6e7/kUoJs+bjRxMxsvdwHgj6
    HKnMlgAbD24F8kSuVHwT2UZSNIiB+cS4WDZI9tUzhwFoGRd2lPAtPEJSXm1Pe2LV9JNLFp
    GZDEgrMbCuznyjBU1tR9RO271343XCEitk5ltMl9yuFi2TNY/8BLoMaBLR3qdeiu/TBDeh
    6iPoZ0/BmrQucexrf8RUmMuStwUqtHfY0fumNrXcrDExj9+GXZGQyED/sRAQ
X-ME-Proxy: <xmx:vzO7aqXl35KyDtNVZqU_B_sQXFLoZTfUk79lE_WKdImBnUegDQoaFQ>
    <xmx:vzO7apxilpgaIJQYhGoMG4yYHtVRxYaJH9kAPyhtX_q4bwPNHp2G6g>
    <xmx:vzO7alM6nb3XkoPNmncM9IB5zYXVqe-DMzfNyLu93kgkQQBmjM6Low>
    <xmx:vzO7amaEbVoai8n90Tg8O8x-BOqC1HBtSTvCGT1QDh-AkxtgxloLIg>
    <xmx:vzO7aqpmPFgEKPq0kHh564-Ucrq4-XCv4BztJZdZfouHRpbhNK6oprBI>
Feedback-ID: i9d664b8f:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 28 Sep 2026 23:42:47 -0400 (EDT)
From: NeilBrown <neilb@ownmail.net>
To: Miklos Szeredi <miklos@szeredi.hu>,
	Amir Goldstein <amir73il@gmail.com>,
	Kees Cook <kees@kernel.org>,
	Joel Granados <joel.granados@kernel.org>,
	Richard Weinberger <richard@nod.at>,
	Anton Ivanov <anton.ivanov@cambridgegreys.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Breno Leitao <leitao@debian.org>,
	Andreas Hindborg <a.hindborg@kernel.org>,
	Jan Harkes <jaharkes@cs.cmu.edu>,
	Hugh Dickins <hughd@google.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Hyunchul Lee <hyc.lee@gmail.com>,
	Carlos Maiolino <cem@kernel.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>
Cc: Jeff Layton <jlayton@kernel.org>,
	Jan Kara <jack@suse.cz>,
	linux-fsdevel@vger.kernel.org,
	fuse-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-unionfs@vger.kernel.org,
	linux-um@lists.infradead.org,
	codalist@coda.cs.cmu.edu,
	coda@cs.cmu.edu,
	linux-mm@kvack.org,
	ntfs@lists.linux.dev,
	linux-xfs@vger.kernel.org
Subject: [PATCH 3/7] coda: don't d_drop() early.
Date: Tue, 29 Sep 2026 13:36:03 +1000
Message-ID: <20260929034158.1455429-4-neilb@ownmail.net>
X-Mailer: git-send-email 2.50.0.107.gf914562f5916.dirty
In-Reply-To: <20260929034158.1455429-1-neilb@ownmail.net>
References: <20260929034158.1455429-1-neilb@ownmail.net>
Reply-To: NeilBrown <neil@brown.name>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: NeilBrown <neil@brown.name>

Proposed locking changes will mean that calling d_drop() could
effectively unlock the name allowing a parallel lookup to proceed.
For this reason it could only be called *after* the attempt to create a
symlink (in this case) has completed (whether successfully or not).

So move the d_drop() to after the venus_symlink() call.

Signed-off-by: NeilBrown <neil@brown.name>
---
 fs/coda/dir.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/coda/dir.c b/fs/coda/dir.c
index 67148edfadee..bcbc9d058303 100644
--- a/fs/coda/dir.c
+++ b/fs/coda/dir.c
@@ -249,13 +249,13 @@ static int coda_symlink(struct mnt_idmap *idmap,
 	if (symlen > CODA_MAXPATHLEN)
 		return -ENAMETOOLONG;
 
+	error = venus_symlink(dir_inode->i_sb, coda_i2f(dir_inode), name, len,
+			      symname, symlen);
 	/*
-	 * This entry is now negative. Since we do not create
+	 * This entry is still negative. Since we did not create
 	 * an inode for the entry we have to drop it.
 	 */
 	d_drop(de);
-	error = venus_symlink(dir_inode->i_sb, coda_i2f(dir_inode), name, len,
-			      symname, symlen);
 
 	/* mtime is no good anymore */
 	if (!error)
-- 
2.50.0.107.gf914562f5916.dirty

