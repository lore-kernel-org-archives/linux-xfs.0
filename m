Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC88925A2DC
	for <linux-xfs@vger.kernel.org>; Wed,  9 Apr 2025 07:58:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744185519; cv=none; b=eHDWeIEW8CvSCDn8H91quD/Xf1EPk85Ca2NuMllXigSYcdRvuprCaOcDYSmQfGUOadthk2hZBLcH4x/Xx6dm+h9UObk/oSfE06er+VZb7Kd3Cbev6loMTYk2Rt3cgK26spV5RU0fsWr/3jOIXduQvEmjRSvrauceeUdi3G+Dcio=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744185519; c=relaxed/simple;
	bh=N/0T7+nprmcoq3RhnjPmi3gKjJ+DeHeWkZAdiOcpnyE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZC2MBX1H5iboy217gsB+9Pjdk0IKwoLj90mYV5PdNwxCgjp9kkqBQkgCXozUtkV+cKHGefCu6hqsgwzXYQZpcPw/lN6gVtrvnmnhjMrVq1H2fjjOEPrSaWLWPRa8CThJMp8UaxO7mOOOzz/3MMZ0rpyAj7CjkzEFBHZohvhBaUU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=iY9Uvabj; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="iY9Uvabj"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=evbJI3sefSfJwixBrr/NYM+7t+WWVXDpXTnUrWdZ15w=; b=iY9UvabjcF88/HYRuhKITSquA3
	x6ErMS2NFC2JyL7OzNTmKfHRygQ+JmrAYCLElSEBS3/7bHt2WqV1fjcl4XKzgujX3KOVArEeWychp
	AdzH02ayygFBfo0Ub/6seui0ebzoFIUk0d39dqOnaAHcyEhJHidqCueOkELvws1i7tsB2QWZ6qYhg
	k0J0vZlWGmK8q/BMIEs30BHlqlVLyP7dEZWVe08OZ1wo5Aqc2v+KSPNRTpBjwrS4++k13xmKHAmoQ
	720dAPCtr6hbjEo1gYhaSAETbvS7lT15GwKvNErvdbb9xGebEm1hc+cFjHJ/RJw7PaYYdH7oWqLYK
	7K+s0EOg==;
Received: from 2a02-8389-2341-5b80-08b8-afb4-7bb0-fe1c.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:8b8:afb4:7bb0:fe1c] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1u2QKS-00000006Ujs-1jPO;
	Wed, 09 Apr 2025 07:58:37 +0000
From: Christoph Hellwig <hch@lst.de>
To: Andrey Albershteyn <aalbersh@kernel.org>
Cc: "Darrick J . Wong" <djwong@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 39/45] xfs_io: don't re-query geometry information in fsmap_f
Date: Wed,  9 Apr 2025 09:55:42 +0200
Message-ID: <20250409075557.3535745-40-hch@lst.de>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250409075557.3535745-1-hch@lst.de>
References: <20250409075557.3535745-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

But use the information store in "file".

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 io/fsmap.c | 18 +++---------------
 1 file changed, 3 insertions(+), 15 deletions(-)

diff --git a/io/fsmap.c b/io/fsmap.c
index 6a87e8972f26..3cc1b510316c 100644
--- a/io/fsmap.c
+++ b/io/fsmap.c
@@ -166,9 +166,9 @@ static void
 dump_map_verbose(
 	unsigned long long	*nr,
 	struct fsmap_head	*head,
-	bool			*dumped_flags,
-	struct xfs_fsop_geom	*fsgeo)
+	bool			*dumped_flags)
 {
+	struct xfs_fsop_geom	*fsgeo = &file->geom;
 	unsigned long long	i;
 	struct fsmap		*p;
 	int			agno;
@@ -395,7 +395,6 @@ fsmap_f(
 	struct fsmap		*p;
 	struct fsmap_head	*head;
 	struct fsmap		*l, *h;
-	struct xfs_fsop_geom	fsgeo;
 	long long		start = 0;
 	long long		end = -1;
 	int			map_size;
@@ -470,17 +469,6 @@ fsmap_f(
 		end <<= BBSHIFT;
 	}
 
-	if (vflag) {
-		c = -xfrog_geometry(file->fd, &fsgeo);
-		if (c) {
-			fprintf(stderr,
-				_("%s: can't get geometry [\"%s\"]: %s\n"),
-				progname, file->name, strerror(c));
-			exitcode = 1;
-			return 0;
-		}
-	}
-
 	map_size = nflag ? nflag : 131072 / sizeof(struct fsmap);
 	head = malloc(fsmap_sizeof(map_size));
 	if (head == NULL) {
@@ -531,7 +519,7 @@ fsmap_f(
 			break;
 
 		if (vflag)
-			dump_map_verbose(&nr, head, &dumped_flags, &fsgeo);
+			dump_map_verbose(&nr, head, &dumped_flags);
 		else if (mflag)
 			dump_map_machine(&nr, head);
 		else
-- 
2.47.2

