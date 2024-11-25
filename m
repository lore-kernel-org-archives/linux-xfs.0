Received: from relay.smtp-ext.broadcom.com (relay.smtp-ext.broadcom.com [192.19.144.209])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C5ED13C80E
	for <linux-xfs@vger.kernel.org>; Mon, 25 Nov 2024 22:26:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.19.144.209
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732573589; cv=none; b=oYNFyak1iQzdNGLFr0zVgwmHtJdEvWUWhcgC005ssA3zbAMzeUN0bmiQQU6WHMOM9iSPd/jDXN7fdHouMt3mXBqFDg5x/PCT/mvVufpLYUeqHoGTs+6yIwbN0p66wBYL2Vh6nu/0pq1ngC72XlurK1MZe5uGR+Lb4BAxVXPRGCM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732573589; c=relaxed/simple;
	bh=DxV0ZYtZhx0j71BKj6s1gQ9m3nGm9kZ0DLlQD2Kjaao=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=QXTKV7T5BdEB3M//QkeG1sP+63hD0iskSq2gu+jkqibmkgh71Ls6n1Dc3tw3VaKnbQ+MJ4qeAmac6NUJjuCMefwGuXy6w5jvm8jCP5rrAXNoPeZ5B4GKH+DCY+Nrl3NK9FJ92aIv+LZNeEM4Thi2MxS/rQeLGNHVhWnYhlwmHDU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=vKk6pPHz; arc=none smtp.client-ip=192.19.144.209
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="vKk6pPHz"
Received: from mail-lvn-it-01.lvn.broadcom.net (mail-lvn-it-01.lvn.broadcom.net [10.36.132.253])
	by relay.smtp-ext.broadcom.com (Postfix) with ESMTP id CF7AAC00151A;
	Mon, 25 Nov 2024 14:26:19 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 relay.smtp-ext.broadcom.com CF7AAC00151A
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=broadcom.com;
	s=dkimrelay; t=1732573579;
	bh=DxV0ZYtZhx0j71BKj6s1gQ9m3nGm9kZ0DLlQD2Kjaao=;
	h=From:To:Cc:Subject:Date:From;
	b=vKk6pPHzeS+YFAES7CLLClmeXxqquYErbS3wK8V9RmEmafeC2+PLXczhS/cn3HpL5
	 GuZ1PB2eSLhLDupjB5MeRHyMH+52P1YEL1fXk62ZATOnLfoSpBsb1GTsajEwJ+Wl2p
	 kJCn09mdoQ3j1y1YXCLwMEzuwllj/BIJtJB/39tM=
Received: from stbirv-lnx-1.igp.broadcom.net (stbirv-lnx-1.igp.broadcom.net [10.67.48.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail-lvn-it-01.lvn.broadcom.net (Postfix) with ESMTPSA id 8546518041CAC6;
	Mon, 25 Nov 2024 14:26:19 -0800 (PST)
From: Florian Fainelli <florian.fainelli@broadcom.com>
To: linux-xfs@vger.kernel.org
Cc: mmayer@broadcom.com,
	justin.chen@broadcom.com,
	catherine.hoang@oracle.com,
	Florian Fainelli <florian.fainelli@broadcom.com>
Subject: [PATCH] xfs_io: Avoid using __kernel_rwf_t for older kernels
Date: Mon, 25 Nov 2024 14:26:18 -0800
Message-Id: <20241125222618.1276708-1-florian.fainelli@broadcom.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

__kernel_rwf_t was defined with upstream Linux commit
ddef7ed2b5cbafae692d1d580bb5a07808926a9c ("annotate RWF_... flags")
which has been included in Linux v4.14 and newer. When building xfsprogs
against older kernel headers, this type is not defined, leading to the
following build error:

pwrite.c: In function 'pwrite_f':
../include/xfs/linux.h:236:22: error: '__kernel_rwf_t' undeclared (first use in this function); did you mean '__kernel_off_t'?
 #define RWF_ATOMIC ((__kernel_rwf_t)0x00000040)
                      ^~~~~~~~~~~~~~
pwrite.c:329:22: note: in expansion of macro 'RWF_ATOMIC'
    pwritev2_flags |= RWF_ATOMIC;

Fixes: ee6c5941352a ("xfs_io: add RWF_ATOMIC support to pwrite")
Signed-off-by: Florian Fainelli <florian.fainelli@broadcom.com>
---
 include/linux.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux.h b/include/linux.h
index e9eb7bfb26a1..68b43393aad7 100644
--- a/include/linux.h
+++ b/include/linux.h
@@ -233,7 +233,7 @@ struct fsxattr {
 
 /* Atomic Write */
 #ifndef RWF_ATOMIC
-#define RWF_ATOMIC	((__kernel_rwf_t)0x00000040)
+#define RWF_ATOMIC	(0x00000040)
 #endif
 
 /*
-- 
2.34.1

