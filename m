Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7BA0403EA1
	for <linux-xfs@vger.kernel.org>; Fri, 25 Sep 2026 05:13:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790313227; cv=none; b=jTqavcFkWfmVtpjb+uo/7K/QoEXLsXkkR4uw7zYn4r2KdlVU0VRHCjnLgSaU8wXDPnaDa3pitZCjwMzk32eJ5EdxK/AxuysPoDKev9olWIWc53naVIRGIm2WwpML56Z5+tdCE+0ofBr354uBLIL4/pV9SQJgzapR9Zx1EUl7o+8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790313227; c=relaxed/simple;
	bh=wqQuJk40flwElfFAdmRwdNYn4h34B3ro4JoHCHV28PM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JwQ/4f2I/X4UTc0AsCJYkRf54fI8xMUabxmIlq05WItgVRSh89vWEYxKWPJVMjiSnQUIqccnp+WOkM643z+gBSJUHuJH3pctAI5GdGYV7CCu8gQqztReKOAmPAe5+6+m/UEs350lEnsElmjHqbUHMBoV74pWzNMLJiKcJ0PzYWk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=KObTiVhj; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="KObTiVhj"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=fd7ni8zMEdmS91uwIBrUPIa2xF3jGkM94FPBbdQwTEM=; b=KObTiVhja0OlSuCmxOSzhAoHvR
	FCo1SlA3z8hP7NGVYdpvQhHXgrmxju9Z2Qab822fRxg30GpREl6ipN8nzziRCYW0Z5eSHDy0qchk6
	N7az+3SYbO1HO0Em/kiKJTqxIc5R1bPbYn9NgpKIt0RTzppaNVV51hK+qHswey1nvPHfXR855Nb2N
	1zehI8nRoeJUs9evJK7kLFgO5mQ9fXYoOgfrFTO7bNilrLpFL+mgabTDhzIBDRP4gFf0NsN6g7I6B
	WgiRE3InZ687IDlbLlQ+qBmAqq/HDJ8Ou3hKkzAMYsl7ie9KE3gcmYL4rc1gX3qZcPpPR8Zazhr5R
	IxbqT/FA==;
Received: from 2a02-8389-2301-9f00-b711-947d-6c5b-1af5.cable.dynamic.v6.surfer.at ([2a02:8389:2301:9f00:b711:947d:6c5b:1af5] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1x9yFi-0000000CgbM-45xA;
	Fri, 25 Sep 2026 05:13:43 +0000
From: Christoph Hellwig <hch@lst.de>
To: Andrey Albershteyn <aalbersh@kernel.org>
Cc: "Darrick J . Wong" <djwong@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 01/10] libxfs: refactor the reinit case in libxfs_buftarg_init
Date: Fri, 25 Sep 2026 07:12:47 +0200
Message-ID: <20260925051336.2997014-2-hch@lst.de>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260925051336.2997014-1-hch@lst.de>
References: <20260925051336.2997014-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

I had to wade through this to understand what is going on here.  Factor
the reinit code into a well-name helper and dump the rationale for it
into a comment to make it easier for the next person to understand the
logic.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 libxfs/init.c | 75 ++++++++++++++++++++++++++++++---------------------
 1 file changed, 45 insertions(+), 30 deletions(-)

diff --git a/libxfs/init.c b/libxfs/init.c
index b89c9fe360d4..63015badc24e 100644
--- a/libxfs/init.c
+++ b/libxfs/init.c
@@ -487,6 +487,43 @@ static char *wf_opts[] = {
 	[WF_MAX_OPTS]		= NULL,
 };
 
+static void
+libxfs_buftarg_reinit(
+	struct xfs_mount	*mp,
+	struct libxfs_init	*xi)
+{
+	if (mp->m_ddev_targp->bt_bdev != xi->data.dev ||
+	    mp->m_ddev_targp->bt_mount != mp) {
+		fprintf(stderr,
+			_("%s: bad buftarg reinit, ddev\n"),
+			progname);
+		exit(1);
+	}
+
+	if (!xi->log.dev || xi->log.dev == xi->data.dev) {
+		if (mp->m_logdev_targp != mp->m_ddev_targp) {
+			fprintf(stderr,
+			_("%s: bad buftarg reinit, ldev mismatch\n"),
+				progname);
+			exit(1);
+		}
+	} else if (mp->m_logdev_targp->bt_bdev != xi->log.dev ||
+		   mp->m_logdev_targp->bt_mount != mp) {
+		fprintf(stderr,
+			_("%s: bad buftarg reinit, logdev\n"),
+			progname);
+		exit(1);
+	}
+	if ((xi->rt.dev || xi->rt.dev == xi->data.dev) &&
+	    (mp->m_rtdev_targp->bt_bdev != xi->rt.dev ||
+	     mp->m_rtdev_targp->bt_mount != mp)) {
+		fprintf(stderr,
+			_("%s: bad buftarg reinit, rtdev\n"),
+			progname);
+		exit(1);
+	}
+}
+
 void
 libxfs_buftarg_init(
 	struct xfs_mount	*mp,
@@ -532,37 +569,15 @@ libxfs_buftarg_init(
 		}
 	}
 
+	/*
+	 * This can happen if the utility called libxfs_buftarg_init manually
+	 * before libxfs_mount, which calls us again.
+	 *
+	 * In this case all buftargs should be initialized already, and we just
+	 * ensure the values are sane and match the current mount.
+	 */
 	if (mp->m_ddev_targp) {
-		/* should already have all buftargs initialised */
-		if (mp->m_ddev_targp->bt_bdev != xi->data.dev ||
-		    mp->m_ddev_targp->bt_mount != mp) {
-			fprintf(stderr,
-				_("%s: bad buftarg reinit, ddev\n"),
-				progname);
-			exit(1);
-		}
-		if (!xi->log.dev || xi->log.dev == xi->data.dev) {
-			if (mp->m_logdev_targp != mp->m_ddev_targp) {
-				fprintf(stderr,
-				_("%s: bad buftarg reinit, ldev mismatch\n"),
-					progname);
-				exit(1);
-			}
-		} else if (mp->m_logdev_targp->bt_bdev != xi->log.dev ||
-			   mp->m_logdev_targp->bt_mount != mp) {
-			fprintf(stderr,
-				_("%s: bad buftarg reinit, logdev\n"),
-				progname);
-			exit(1);
-		}
-		if ((xi->rt.dev || xi->rt.dev == xi->data.dev) &&
-		    (mp->m_rtdev_targp->bt_bdev != xi->rt.dev ||
-		     mp->m_rtdev_targp->bt_mount != mp)) {
-			fprintf(stderr,
-				_("%s: bad buftarg reinit, rtdev\n"),
-				progname);
-			exit(1);
-		}
+		libxfs_buftarg_reinit(mp, xi);
 		return;
 	}
 
-- 
2.53.0

