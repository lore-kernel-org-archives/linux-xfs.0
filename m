Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=111.22.67.151
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794793728;
	b=3T+fIPBNVshiOkrYH6gHcgJiXIWsgua4teXOIstNfaecm/42SrZyVZ6gpEFqEki7ZXrG
	 QX7/QCiDJbIJ9ASgPNtRvh+JVfeHSq6jWMs/I104vfLqgFdcNiIJxPH4TYMHncPA1WdRy
	 Of0pEnluDj+h8SN8Ui5kYJlRJgjOCXfAauWedZLtqRSEvxEKg09ayQ4vD+SawRQ5cMuJE
	 mNJpzotaP41jYLCoucp8NC46tCGSg0I7ff/rlU1D3b6QWXOsudwx+nsOe2LkE7klZemNR
	 cXcfBE++RI8esZk81KHPUIA5LLcmqwGh6P0ainXFutBTNsFEEn6hZaZcxb8OEZDFlOQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794793728;
	h=DMARC-Filter:DKIM-Signature:X-RM-TagInfo:X-RM-SPAM-FLAG:Received:
	 X-RM-TRANSID:X-RM-TagInfo:X-RM-SPAM-FLAG:Received:X-RM-TRANSID:From:
	 To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=ZGXJ9Z6c5QRKFJOfmStwKcNo6B6D+MpUfYxYJOSZg1Y=;
	b=0pwANh3W4VW7zFMemaH5126ZLx2RnYl4y7DLSorrGGizzmbelE/gi6JUzVjED9OOmLtx
	 dGnwPSzisqDE6YAv/32bzTVzeZ88iKykHuwMBKdW30dBxmrGgdh5wRE7qXBAKyw3Pyed4
	 LBdcwbuRuytwvTFu9i3gOxyAEAHsZy5rV9aNWX2EnZL1yj6gxnAIofo5XWfdEYEPcE30W
	 DKEmd64g6mK37F8ZZBJMbQu5U1OyW6xHSHgaoe9tA7Ker4sZ4PNKcQAJz25LAN/6pEimj
	 yvWWOh/5xh9eI4ZqH019bUFoQetNOtu9DiIdw7BFSHfmaJFR9wMr+JOEWXEQrDV27+w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=cmss.chinamobile.com;
	spf=pass smtp.mailfrom=cmss.chinamobile.com;
	dkim=pass header.d=cmss.chinamobile.com header.i=@cmss.chinamobile.com header.a=rsa-sha256 header.s=default header.b=DjkUab7K;
	arc=none smtp.remote-ip=111.22.67.151
Received: from cmccmta8.chinamobile.com (cmccmta8.chinamobile.com [111.22.67.151])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5CEE2606A331;
	Mon, 16 Nov 2026 01:48:47 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 5CEE2606A331
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cmss.chinamobile.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cmss.chinamobile.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=cmss.chinamobile.com header.i=@cmss.chinamobile.com header.a=rsa-sha256 header.s=default header.b=DjkUab7K
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=cmss.chinamobile.com; s=default; l=0;
	h=from:subject:message-id:to:cc:mime-version;
	bh=47DEQpj8HBSa+/TImW+5JCeuQeRkm5NMpJWZG3hSuFU=;
	b=DjkUab7KVkJ2HvI8uNxSlAuvJpMKfnzp6r++iAV5UOo8bmBsN++KrHP5k+eXRlAQ0ZTqqUU3FCoVs
	 l6jTv0pg9sls0m+78poGDPH0lOCXYEKCz1zls2+gHxW4Ggzk7M18VauGBFBuHLKWi7OHkpGARxpaxt
	 RV+cdWXgsm+7cLLQ=
X-RM-TagInfo: emlType=0                                       
X-RM-SPAM-FLAG:00000000
Received:from spf.mail.chinamobile.com (unknown[10.188.0.87])
	by rmmx-syy-dmz-app06-12006 (RichMail) with SMTP id 2ee66afa60fb6ea-c669a;
	Mon, 16 Nov 2026 09:48:44 +0800 (CST)
X-RM-TRANSID:2ee66afa60fb6ea-c669a
X-RM-TagInfo: emlType=0                                       
X-RM-SPAM-FLAG:00000000
Received:from fedora (unknown[223.108.79.102])
	by rmsmtp-syy-appsvr02-12002 (RichMail) with SMTP id 2ee26afa60f06ba-77819;
	Mon, 16 Nov 2026 09:48:44 +0800 (CST)
X-RM-TRANSID:2ee26afa60f06ba-77819
From: Yiqing Wu <wuyiqing@cmss.chinamobile.com>
To: Carlos Maiolino <cem@kernel.org>
Cc: linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Yiqing Wu <wuyiqing@cmss.chinamobile.com>
Subject: [PATCH] xfs: remove unused variable in xchk_stats_estimate_bufsize()
Date: Mon, 16 Nov 2026 09:48:02 +0800
Message-ID: <20261116014802.16078-1-wuyiqing@cmss.chinamobile.com>
X-Mailer: git-send-email 2.56.0
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The css variable in xchk_stats_estimate_bufsize() is initialized to
point to the start of the cs_stats array and incremented on every
iteration of the scan loop, but it is never dereferenced.  GCC flags
this as a dead assignment when building with W=1:

  fs/xfs/scrub/stats.c:146:34: warning: variable css set but not used [-Wunused-but-set-variable=]

Drop the variable and the loop increment.

Signed-off-by: Yiqing Wu <wuyiqing@cmss.chinamobile.com>
---
 fs/xfs/scrub/stats.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/xfs/scrub/stats.c b/fs/xfs/scrub/stats.c
index 6934d76cfd15..dfdac4e7b4ad 100644
--- a/fs/xfs/scrub/stats.c
+++ b/fs/xfs/scrub/stats.c
@@ -143,7 +143,6 @@ STATIC size_t
 xchk_stats_estimate_bufsize(
 	struct xchk_stats	*cs)
 {
-	struct xchk_scrub_stats	*css = &cs->cs_stats[0];
 	unsigned int		i;
 	size_t			field_width;
 	size_t			ret = 0;
@@ -157,7 +156,7 @@ xchk_stats_estimate_bufsize(
 			      offsetof(struct xchk_scrub_stats, checktime_us)) /
 			     sizeof(uint64_t));
 
-	for (i = 0; i < XFS_SCRUB_TYPE_NR; i++, css++) {
+	for (i = 0; i < XFS_SCRUB_TYPE_NR; i++) {
 		if (!name_map[i])
 			continue;
 
-- 
2.56.0



