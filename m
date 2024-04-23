Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 608DC134CCA
	for <linux-xfs@vger.kernel.org>; Tue, 23 Apr 2024 12:37:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713875823; cv=none; b=ZABdtKV6MnRQ8sVKenQSKWVbu46aCZS6jQmK99IjKHfO5/KH5SdOnMf8Mel6ssZT2MpXitInIYjW4BF77wl+gwaiSpHtWvLdxvsavvuIxG/F671/vNgOmEnUfTT20E8mwncVXP4Zk7bZAx3k12wrrUPlQu4EXM0B/rSJZQRMYFk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713875823; c=relaxed/simple;
	bh=ulMq5NcQJ+Mm4bToiJej1gzpiwB8mC3K7VcZcG9FsKY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=g++PPWkQq0AfXoYUT1zBiKUOqLFg7vdPbCt5RB8GLnwfbExOc5AahGXEwypFT/gDWq+fhI5kjgazj01Hyl7M0Ip4VoAZXci6TefBXBtIvRKWQFJ8qSzgqfjwLSP9SzoxT2SATSKeNnNfIOH7faOmA0MD0yc6LoJhTIb+zi6rHxU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=bQIenZ73; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="bQIenZ73"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1713875820;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=FSdLmKVak3TNL+D9ABpWccd8Qslsa3Pvs9zG76WZCUo=;
	b=bQIenZ739JQr+a2XCX3oEIx5DsRhhTBT1mdWV/fmQg31Zuesoij+Zry+6qMyOU+8IouokV
	4PgSZbW5gTS6Xc88IDkHpu3iIyfVVa/dV9d+iNg5/wiSikBzQN9a5xzwortegdOC7am4i8
	VPNRdPWIY8clGEq/ubVOWiDfGcqVXVA=
Received: from mail-lj1-f199.google.com (mail-lj1-f199.google.com
 [209.85.208.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-625-wArSill0NzCb6H4npsnAlg-1; Tue, 23 Apr 2024 08:36:58 -0400
X-MC-Unique: wArSill0NzCb6H4npsnAlg-1
Received: by mail-lj1-f199.google.com with SMTP id 38308e7fff4ca-2da2f30cb50so40652701fa.2
        for <linux-xfs@vger.kernel.org>; Tue, 23 Apr 2024 05:36:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713875817; x=1714480617;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=FSdLmKVak3TNL+D9ABpWccd8Qslsa3Pvs9zG76WZCUo=;
        b=S1U1M8xCeYLD96p39AMdl2L/bRSZVfi63Gb2FfBbDBZT+dar4YvbNCEIrap3rF56UE
         uVYgkHmT0gGW7mtefd3Y6q3L2p8BMtJKFdcrwTFNE4unV5EtPim6PBeBmJ/SI7PVFvbl
         x2VqhUNxKA9GvamcyGaS0iE1uRrp1LXe2OFGyCe+rPUpfophrwizj2OvmeUUAE0/o7/a
         0/LyCNsAqYH0IgFbShlSYY8MA/AoL8nc3eHlh2+vHUb9TDD/dyb2qkyHXVXRJ9JFCzCk
         yEbrPH/LrsG2BdrIlWvsIXxKjrok5haINOf5m/nhXi8NXn3AVrzEn9Ezpoeokpp5Ly1g
         Y4cQ==
X-Forwarded-Encrypted: i=1; AJvYcCUG9MT7eBevzzDPmp24C8veDA2RAkFQ+6PuynEaoWQ1MbpXg7pHVLPvBizrPjdQ9HsRWIhVw+wFhl3DnazB+1eOxeqQZYoYJRo4
X-Gm-Message-State: AOJu0Yz7ayyitaER2cLC8wg0Wj61wCfNfog1NOrnkw6LiT6jyFLk2wf4
	kTBc9gYI2wnxkMrggs8j8m3OMTUohtbyDi/x6OWtMGORZU95tu4m6PO9lEHOeNuvu6Vn8cZnxKQ
	S0cj2m8eDoC2QQcoRNrUQpP509RbqZ97zdlZXwyn+7HDrj3P/SvK4tQxK
X-Received: by 2002:a2e:7a09:0:b0:2dc:ae40:c797 with SMTP id v9-20020a2e7a09000000b002dcae40c797mr8683306ljc.15.1713875817055;
        Tue, 23 Apr 2024 05:36:57 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEIA5yxWSenyzdbd847+b4uxYnxzPsOOYxS1pMneGAQD8bw0T2R2ImOOQJIlTVr5mWrCaPWrg==
X-Received: by 2002:a2e:7a09:0:b0:2dc:ae40:c797 with SMTP id v9-20020a2e7a09000000b002dcae40c797mr8683287ljc.15.1713875816560;
        Tue, 23 Apr 2024 05:36:56 -0700 (PDT)
Received: from thinky.redhat.com ([109.183.6.197])
        by smtp.gmail.com with ESMTPSA id et3-20020a056402378300b00571d8da8d09sm4783170edb.68.2024.04.23.05.36.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Apr 2024 05:36:56 -0700 (PDT)
From: Andrey Albershteyn <aalbersh@redhat.com>
To: cem@kernel.org,
	linux-xfs@vger.kernel.org
Cc: Andrey Albershteyn <aalbersh@redhat.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Bill O'Donnell <bodonnel@redhat.com>,
	Christoph Hellwig <hch@lst.de>
Subject: [PATCH v5 1/4] xfs_db: fix leak in flist_find_ftyp()
Date: Tue, 23 Apr 2024 14:36:14 +0200
Message-ID: <20240423123616.2629570-3-aalbersh@redhat.com>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20240423123616.2629570-2-aalbersh@redhat.com>
References: <20240423123616.2629570-2-aalbersh@redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When count is zero fl reference is lost. Fix it by freeing the list.

Fixes: a0d79cb37a36 ("xfs_db: make flist_find_ftyp() to check for field existance on disk")
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Bill O'Donnell <bodonnel@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrey Albershteyn <aalbersh@redhat.com>
---
 db/flist.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/db/flist.c b/db/flist.c
index c81d229ab99c..0a6cc5fcee43 100644
--- a/db/flist.c
+++ b/db/flist.c
@@ -424,8 +424,10 @@ flist_find_ftyp(
 		if (f->ftyp == type)
 			return fl;
 		count = fcount(f, obj, startoff);
-		if (!count)
+		if (!count) {
+			flist_free(fl);
 			continue;
+		}
 		fa = &ftattrtab[f->ftyp];
 		if (fa->subfld) {
 			flist_t *nfl;
-- 
2.42.0

