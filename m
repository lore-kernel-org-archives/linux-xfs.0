Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93CD2146A8B
	for <linux-xfs@vger.kernel.org>; Thu, 13 Jun 2024 21:19:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718313595; cv=none; b=PhEWHwLfEpWVXVXpeyZD/nRmTgKTJibsUoflsgGwa9M1HOeWQ/UdqYM2aqNlUmhFNXCNsqZH1f3owYyptveWQfaVQfGEWOKPyeqrEEy/A1rx1nPht8JiIdag/5PJlXPnrA+psqSinsCIrgbsIGeOuDhw+Y/L+w1Q8iXJjQ7Zzxk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718313595; c=relaxed/simple;
	bh=MsUb0lGC++++dHyYNwhtYinCgn/ezm/B8qvnNlS0ibQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QcjA1lROz6NW4dJ1LWb8CbitpHIq4z/N359n/m+LqoyFZbgp8K8YysqzVcOdYKVic5sFiNaruyQ+HoExbBCVqvePlQ49vz+/vgprwKeK+/QqM1QRfD8E0PD8VPdSzswyn5KxDE8m6/WZ095v+qjaTwkIPbspKo9AafvQLYmigfk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=huxy9CN1; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="huxy9CN1"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1718313592;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=BluPTFhbGG4VfN2SKggYKjir+O59yxRUyVs90UZ89JA=;
	b=huxy9CN1Jio0E/t+UgshJSvG9hXGttL6kwZr68zWMJrEU+1+vMT88w5VtonqTLl4PMB3KN
	uZCjxojXRcFz2DdbpbC3O6fGoRm/15rx4HeSyn8CrrS/nByObM/CeSLzgDpCzEfSkrEjp+
	jS9qtPBPdbttLwg5sibrj+h+3Vvtb20=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-439-LBHA4VstNjGs-YeWx2QUgQ-1; Thu,
 13 Jun 2024 17:19:51 -0400
X-MC-Unique: LBHA4VstNjGs-YeWx2QUgQ-1
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 45CEB19560AA
	for <linux-xfs@vger.kernel.org>; Thu, 13 Jun 2024 21:19:50 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.22.34.24])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 77E431956050;
	Thu, 13 Jun 2024 21:19:49 +0000 (UTC)
From: Bill O'Donnell <bodonnel@redhat.com>
To: linux-xfs@vger.kernel.org
Cc: cmaiolino@redhat.com,
	Bill O'Donnell <bodonnel@redhat.com>
Subject: [PATCH v2 2/4] xfs_db: fix unitialized automatic struct ifake to 0.
Date: Thu, 13 Jun 2024 16:09:16 -0500
Message-ID: <20240613211933.1169581-3-bodonnel@redhat.com>
In-Reply-To: <20240613211933.1169581-1-bodonnel@redhat.com>
References: <20240613211933.1169581-1-bodonnel@redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17

Ensure automatic struct ifake is properly initialized.

Coverity-id: 1596600, 1596597

Signed-off-by: Bill O'Donnell <bodonnel@redhat.com>
---
 db/bmap_inflate.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/db/bmap_inflate.c b/db/bmap_inflate.c
index 33b0c954..219f9bbf 100644
--- a/db/bmap_inflate.c
+++ b/db/bmap_inflate.c
@@ -340,7 +340,7 @@ build_new_datafork(
 	const struct xfs_bmbt_irec	*irec,
 	xfs_extnum_t			nextents)
 {
-	struct xbtree_ifakeroot		ifake;
+	struct xbtree_ifakeroot		ifake = {};
 	struct xfs_btree_cur		*bmap_cur;
 	int				error;
 
@@ -394,7 +394,7 @@ estimate_size(
 		.leaf_slack		= 1,
 		.node_slack		= 1,
 	};
-	struct xbtree_ifakeroot		ifake;
+	struct xbtree_ifakeroot		ifake = {};
 	struct xfs_btree_cur		*bmap_cur;
 	int				error;
 
-- 
2.45.2

