Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A726D15FA7C
	for <linux-xfs@vger.kernel.org>; Fri, 14 Jun 2024 16:07:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718381241; cv=none; b=JYKX2fi69H865f+K5TzSDHELFfq2E2qpAilAy3njbZGyraLLheiCRlMEwZoJxou7abD68WdM1mPGHnp36k4oFNQIC6Lwry7nCt4hzl+FbnaKv2r+LDWXJAEPxbWptFih59MApUFfT1BiV1IP+AEF/s/MoGAi4FTXM1psWEPAMTc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718381241; c=relaxed/simple;
	bh=KS9sk5Ltsv+8EZ29iGSyuSKwEbpt7VaxwpkHUKIFmtQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Pc2xrMbFsRy/F0Vd0G/48ojGE42tt5YtzkVVbe/h1Fhx01Yxmc4Rfw5LNL+oRxjv+R0Cv/cmlfyHWO5Q9f3eeDnddHUqZPlKcajypL/0E79BJq1qm5TfNwcR+EG779cMNGaK5nEobPCeYHbAl7yBMCPBr1ryDOTowFDLj8TuneA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=QOZ6eFA9; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="QOZ6eFA9"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1718381238;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=9PVRyo3ezgSjZI9Bg5Iq38keITb7PbMizTr25hGog0M=;
	b=QOZ6eFA9JkEBSSOKxbg2D6Kh2/M1CGPH33iwacioKb9aiJIpeGiQfUpHKYOvm7QC5X7IMQ
	k7lYXkNbbV680ITp3Pzh6SQGN6Cn2wXNH7s1k8uUGYHQVKpHgH5aj/AvilwVLl+a7iODFs
	7lVY92fukbQ5MvS8Xw5H25srQ355fqo=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-652-MhIbYsedNy6P4zHr-U4Xfw-1; Fri,
 14 Jun 2024 12:07:15 -0400
X-MC-Unique: MhIbYsedNy6P4zHr-U4Xfw-1
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id BB475195608B;
	Fri, 14 Jun 2024 16:07:13 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.22.34.24])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 3A71419560BF;
	Fri, 14 Jun 2024 16:07:12 +0000 (UTC)
From: Bill O'Donnell <bodonnel@redhat.com>
To: linux-xfs@vger.kernel.org
Cc: cmaiolino@redhat.com,
	Bill O'Donnell <bodonnel@redhat.com>,
	Christoph Hellwig <hch@lst.de>,
	"Darrick J . Wong" <djwong@kernel.org>
Subject: [PATCH v3 4/4] xfs_repair: correct type of variable global_msgs.interval to time_t
Date: Fri, 14 Jun 2024 11:00:16 -0500
Message-ID: <20240614160643.1879156-5-bodonnel@redhat.com>
In-Reply-To: <20240614160643.1879156-1-bodonnel@redhat.com>
References: <20240614160643.1879156-1-bodonnel@redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

Use time_t instead of int for interval field.

Coverity-id: 1596599

Signed-off-by: Bill O'Donnell <bodonnel@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
---
 repair/progress.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/repair/progress.c b/repair/progress.c
index 2ce36cef..15455a99 100644
--- a/repair/progress.c
+++ b/repair/progress.c
@@ -91,7 +91,7 @@ typedef struct msg_block_s {
 	uint64_t	*done;
 	uint64_t	*total;
 	int		count;
-	int		interval;
+	time_t		interval;
 } msg_block_t;
 static msg_block_t 	global_msgs;
 
-- 
2.45.2

