Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=198.137.202.133
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793115764;
	b=VFV0nHEunqFEKcZUCRNlykEMqih42SyZVy9Pw0cFVYaewNjVufJpPSFnsByuXWceyJbw
	 xu4CzmpMD4Ss3ENJXL5KCMTZ3mrpCJIUwtbVM87AHchE7g4T0nqpK4NHwWdjQ2N9SfmXB
	 D0wERk0sq+AOBbUWxDib7DXM186oJez2hR534M58KCrNJGTD6LFm6jW26C1/DAtcEPHa9
	 1bR7LTMUfwDdfXusXobCkXlhhrvdvSuE/o+7fKHuTO6qqpRcoHD+XqatgkSAzQiLZimaf
	 di9SyFiawNpAw2z1tLhnu20AM0fIMKCuJp3YpmmGrNEtPl3SvpKxhwgnhMp3WoxgEEw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793115764;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-SRS-Rewrite;
	bh=/QiXOIWAa1N6M3U6Smd4V4fqUFNZcziaYXSTFmrc0Uk=;
	b=T/Gp7388XaP2jClVS0xx857UvTE73pst8Fa1GyhnraqIdgMP64lpqXi+EawA5HYB5gAG
	 BLe55l1ZW77WREq0wcNk5rTirAKTi+6Y76MG2stN/aUlPhN00Th9EvrZgH8EE6JYZwwZZ
	 e2D7Ide6gP6mfpjer8PrAblk4EN2kaBuY+T03YrPw7HszHWtqti1m21/cjHCY7I5/pp/e
	 TCIZBhM1Iwf2z+qs+hjq0alWIDL6T/VT2CMRkPIH7RrYUe+LaZOh99Z3DeslAKmRlPbMq
	 Xg9qhanIeYgRqAFZiiq1dz4mvMeGLTo1R7/iZa243iziNKsQ6tnvKx7iirXk1t8T8KQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=fail header.from=lst.de;
	spf=none smtp.mailfrom=bombadil.srs.infradead.org;
	dkim=pass header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=uuGUakhX;
	arc=none smtp.remote-ip=198.137.202.133
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EB78606A31F
	for <linux-xfs@vger.kernel.org>; Tue, 27 Oct 2026 15:42:44 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2EB78606A31F
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=uuGUakhX
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=/QiXOIWAa1N6M3U6Smd4V4fqUFNZcziaYXSTFmrc0Uk=; b=uuGUakhXNh+vzyVE39yvX0WLtU
	hCen9vKIyPKf0yc1N8UvEBU+gDm4ii8ucr1KqvqrPRtn0vcRd3N73pY1y9g4k4wshICxsSJHyr7WR
	ZkwAh5PuUdtrz1lqo96STo7F9LzMJPOXixxzm2+CMkx3JfOJZD7BxnVGelDcZw9dgDaNVw87RVlt6
	We9wg+w1MyDG4XWu5iduVCO7TjqCADTSsgf9mHyzukKAHWaZlQ5R7Kyse1h0H4h8mAA+CGDIOJaa2
	XKQvW/lvHMhSnj0oFvE31EHV5TPk941DvxV75y0PYUkdD4BaCIXOD+8C31WN0FGYK4n3j21TGQf0/
	+/6qjQSQ==;
Received: from 2a02-8389-2301-9f00-31e8-efb6-e973-61ca.cable.dynamic.v6.surfer.at ([2a02:8389:2301:9f00:31e8:efb6:e973:61ca] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.100.1 #2 (Red Hat Linux))
	id 1xLjJz-00000005Fuv-1kci;
	Tue, 27 Oct 2026 15:42:43 +0000
From: Christoph Hellwig <hch@lst.de>
To: Andrey Albershteyn <aalbersh@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH 1/7] libfrog: constify getprnam
Date: Tue, 27 Oct 2026 16:42:15 +0100
Message-ID: <20261027154237.1997484-2-hch@lst.de>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261027154237.1997484-1-hch@lst.de>
References: <20261027154237.1997484-1-hch@lst.de>
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
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 libfrog/projects.c | 2 +-
 libfrog/projects.h | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/libfrog/projects.c b/libfrog/projects.c
index dbde97021c63..4b2aec51b7bd 100644
--- a/libfrog/projects.c
+++ b/libfrog/projects.c
@@ -94,7 +94,7 @@ getprent(void)
 
 fs_project_t *
 getprnam(
-	char		*name)
+	const char	*name)
 {
 	fs_project_t	*p = NULL;
 
diff --git a/libfrog/projects.h b/libfrog/projects.h
index 779194749edb..8355c0bbeb48 100644
--- a/libfrog/projects.h
+++ b/libfrog/projects.h
@@ -20,7 +20,7 @@ typedef struct fs_project {
 extern void setprent(void);
 extern void endprent(void);
 extern fs_project_t *getprent(void);
-extern fs_project_t *getprnam(char *__name);
+extern fs_project_t *getprnam(const char *__name);
 extern fs_project_t *getprprid(prid_t __id);
 
 typedef struct fs_project_path {
-- 
2.53.0

