Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77DC228E8
	for <linux-xfs@vger.kernel.org>; Sat,  7 Dec 2024 00:20:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733530822; cv=none; b=XxxlyoTJ/R6jHP7BErpSelwLFYJAN15gG0BFRDFpLcQqM2Xr+6ZW9w5H/HnMUXZh0UIifu4CRoZ4MJDBYooiAljIwzj9B1tCg+FthQHDiJbrsvznwrEI3jIwgSUTE3ogS0QcrHSSCmFHqyCt3Xe/9lwayEQUT5sGHKqYs4iIlSE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733530822; c=relaxed/simple;
	bh=seDNnXomwU4qkXH6pArd155eNtZ7h6reqWpZjtCx6YY=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=GC/z3eBThHVvukZ4RA/6ab1+ddGTz491eCmMR0zkt1CRYtuqIjv7huiGFaYuZ26YWEdlLAegKnBCXPihaREPkj1EEXWfseuE0cd9Z5MUzh8BbdHW0kynpSXs1gN/lZM0EpGUTTI3/UdAUQ4vOc/yKPpgYReuN4VwG825uOz7RTY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=D0L0/Kh5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="D0L0/Kh5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00EE7C4CED1;
	Sat,  7 Dec 2024 00:20:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733530822;
	bh=seDNnXomwU4qkXH6pArd155eNtZ7h6reqWpZjtCx6YY=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=D0L0/Kh5YsUK/o8a0VJfwtH2jLYpdVxFdCEmI0faaYIk8IVh8xM1hlTudAk0uejzS
	 UES6l0+j/2zBclIENx41rDKoO2eiv/GZ6XTyMtNE5MQQDSnEBdMYvReh6S/yZkUNOk
	 hj7iPSBcym6jh6xY++5n7ZFW11MB2Ujf1/4p+wQT+wgzGyjhiCAjfRpCpTuyY7Oc9A
	 IxVUlOHKfMRVQ8Enbyxcp/HYqvb/CpYeLx4h9n7en0avbji1CONXdak6Hd0VzTXOGL
	 V9PqZaYwTFxHHduexVQhfwd0k4zOEnSwBPqzTO4mTjCgaCHPt1p3tPlN64F5SpsMmZ
	 wYFPz3FuFccpQ==
Date: Fri, 06 Dec 2024 16:20:21 -0800
Subject: [PATCH 2/2] mkfs: enable rt quota options
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173352753987.129972.1053967457172318865.stgit@frogsfrogsfrogs>
In-Reply-To: <173352753955.129972.8619019803110503641.stgit@frogsfrogsfrogs>
References: <173352753955.129972.8619019803110503641.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Now that the kernel supports quota and realtime devices, allow people to
format filesystems with permanent quota options.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 mkfs/xfs_mkfs.c |    6 ------
 1 file changed, 6 deletions(-)


diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index b644022a5091ba..b141e2c09c7bfb 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -2650,12 +2650,6 @@ _("cowextsize not supported without reflink support\n"));
 		cli->sb_feat.exchrange = true;
 	}
 
-	if (cli->sb_feat.qflags && cli->xi->rt.name) {
-		fprintf(stderr,
-_("persistent quota flags not supported with realtime volumes\n"));
-				usage();
-	}
-
 	/*
 	 * Persistent quota flags requires metadir support because older
 	 * kernels (or current kernels with old filesystems) will reset qflags

