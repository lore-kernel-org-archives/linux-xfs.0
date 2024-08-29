Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F4281B5824
	for <linux-xfs@vger.kernel.org>; Thu, 29 Aug 2024 17:59:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724954389; cv=none; b=QTpgC7mOA1mug2iU6NZixCePWmkqrB++A2DhBM/OOb2jDS06sz+nE4vz6sLz3QIrLFv/XU0jj3LTTwxzSLjzGhS9mnmwbpI2npaxJNnbPlq7EuahMqM47P3SO4L1WRZU/3Cgfns+mbYD7tnhYATC19SPZeJICU1ikskasDQ43aA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724954389; c=relaxed/simple;
	bh=UK2kZoaOK+qkOkGXBfff7uBnurqVaUKxtCGAeRlgWRA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=ewcoxfISr9l1HpydJK7SrJHZIv/iphKNIHOjmJrLONQMkMTexsTKz/fazNy5ekmhrkaqGvReRqIG2aqiFV8Pv0tlpOXiQmcAfPsrRLRFOb85UYG9jS7ENsYGI1atEViEDa3rXqDssDwXI6HDTAVs5fhf9wNf4WQxElSqPv29nXA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=gFdN0Ud8; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="gFdN0Ud8"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1724954385;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=G4OAS47nLZkKTGtSXXW/PPuD7KrSBL0al+OI+Y8gUyU=;
	b=gFdN0Ud8zX7Vxvu/wCNCvj00D2yI0ipVEnEqrVGmOREbdKtxnGw9SrbQPkjoKod21Pjnx4
	/t75oDbwGsy8S7LAvvv410CvajNKuks5/qzbd2iPH7tiycq8eAn74wboAzjQfltNYjrqbp
	NwJ3IHttJhSeGtIlUE5MCPW3SBTpZ7w=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-222-Xa7bOW_NNA6_u3cqqHz3Dw-1; Thu,
 29 Aug 2024 13:59:42 -0400
X-MC-Unique: Xa7bOW_NNA6_u3cqqHz3Dw-1
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 114DD19560A6;
	Thu, 29 Aug 2024 17:59:41 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.22.33.32])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 6FD7819560A3;
	Thu, 29 Aug 2024 17:59:39 +0000 (UTC)
From: Bill O'Donnell <bodonnel@redhat.com>
To: linux-xfs@vger.kernel.org
Cc: cem@kernel.org,
	djwong@kernel.org,
	sandeen@sandeen.net,
	Bill O'Donnell <bodonnel@redhat.com>
Subject: [PATCH] xfsdump: prevent use-after-free in fstab_commit()
Date: Thu, 29 Aug 2024 12:59:25 -0500
Message-ID: <20240829175925.59281-1-bodonnel@redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17

Fix potential use-after-free of list pointer in fstab_commit().
Use a copy of the pointer when calling invidx_commit().

Coverity CID 1498039.

Signed-off-by: Bill O'Donnell <bodonnel@redhat.com>
---
 invutil/fstab.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/invutil/fstab.c b/invutil/fstab.c
index 88d849e..fe2b1f9 100644
--- a/invutil/fstab.c
+++ b/invutil/fstab.c
@@ -66,6 +66,7 @@ fstab_commit(WINDOW *win, node_t *current, node_t *list)
     data_t *d;
     invt_fstab_t *fstabentry;
     int fstabentry_idx;
+    node_t *list_cpy = list;
 
     n = current;
     if(n == NULL || n->data == NULL)
@@ -77,8 +78,10 @@ fstab_commit(WINDOW *win, node_t *current, node_t *list)
 
     if(d->deleted == BOOL_TRUE && d->imported == BOOL_FALSE) {
 	for(i = 0; i < d->nbr_children; i++) {
-	    invidx_commit(win, d->children[i], list);
+		list_cpy = list;
+		invidx_commit(win, d->children[i], list_cpy);
 	}
+	free(list_cpy);
 	mark_all_children_commited(current);
 
 	fstabentry_idx = (int)(((long)fstabentry - (long)fstab_file[fidx].mapaddr - sizeof(invt_counter_t)) / sizeof(invt_fstab_t));
@@ -101,8 +104,10 @@ fstab_commit(WINDOW *win, node_t *current, node_t *list)
 	invt_fstab_t *dest;
 
 	for(i = 0; i < d->nbr_children; i++) {
-	    invidx_commit(win, d->children[i], list);
+		list_cpy = list;
+		invidx_commit(win, d->children[i], list_cpy);
 	}
+	free(list_cpy);
 	mark_all_children_commited(current);
 
 	if(find_matching_fstab(0, fstabentry) >= 0) {
-- 
2.46.0

