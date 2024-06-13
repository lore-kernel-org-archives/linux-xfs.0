Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AABD13E03E
	for <linux-xfs@vger.kernel.org>; Thu, 13 Jun 2024 21:19:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718313598; cv=none; b=X28pG36pVkBk03OP13Wfl3i2unqgdpkrTahGXdbbL/lUlcfshpl0TFMzMvcQugCz18Fn+SoPOWnlKtveubsmn/WLyaFUfBY0zSyW+AMJrmNCaJl8lDVzBw2Icx5yODd0B2Cih3pC/iwfgXghkTYmwVzMmKUutQElOR+UmJYswxQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718313598; c=relaxed/simple;
	bh=hcgP6moRKDZpupzvJuP5HEtlh8u9Gky/DxONTuAjDWU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=I5d+tfRTk5ExCOo/irGbBf4ostx13vRzNGj1DIKTcy8q3RktGIbAOHcKj23i/gSGLc78GQJZhKRw1SA1njg7DHWPHj7CBbUXMozNOedca2gTrxylCf5/r+lCow8N+xjEBKyHmeNrem4l/kFuMsaYgzfR6f+7vrCQRBmf5Tebf30=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=jGyMTVIg; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="jGyMTVIg"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1718313596;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=snThJpWDNgNHCNOl6uD91ooMEJ1Wr3g9bkc7QeOUZT8=;
	b=jGyMTVIgC/Pg4N6r3gMopj0ambFHmlNw+/529moDd0wUJmEHNowTTJx9PKLZIjtWj7C+E/
	iCKxOgfadrOWw+IS9nIFV/TzX90M8JVJbHzYbSVNbgREZVHnbodoa/QocquYR7UuBMw8li
	Qr7Z63MVp55ILS5qmNCq0mr9zAINd3Y=
Received: from mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-417--LXLnofsPHKUzydXYUukBg-1; Thu,
 13 Jun 2024 17:19:53 -0400
X-MC-Unique: -LXLnofsPHKUzydXYUukBg-1
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 4C4EA19560A0
	for <linux-xfs@vger.kernel.org>; Thu, 13 Jun 2024 21:19:52 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.22.34.24])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 7D868195605B;
	Thu, 13 Jun 2024 21:19:51 +0000 (UTC)
From: Bill O'Donnell <bodonnel@redhat.com>
To: linux-xfs@vger.kernel.org
Cc: cmaiolino@redhat.com,
	Bill O'Donnell <bodonnel@redhat.com>
Subject: [PATCH v2 4/4] xfs_repair: correct type of variable global_msgs.interval to time_t
Date: Thu, 13 Jun 2024 16:09:18 -0500
Message-ID: <20240613211933.1169581-5-bodonnel@redhat.com>
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

Use time_t instead of int for interval field.

Coverity-id: 1596599

Signed-off-by: Bill O'Donnell <bodonnel@redhat.com>
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

