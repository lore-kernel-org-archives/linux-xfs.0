Received: from mail-dl1-f43.google.com (mail-dl1-f43.google.com [74.125.82.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC82E3358DA
	for <linux-xfs@vger.kernel.org>; Wed,  1 Jul 2026 15:39:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782920344; cv=none; b=bfTaXKuzr7jXd/0BiVg3zt2Ei7ATrFprMOKmfsbDUbev54OsqYv/nGiEs3rxViTYj5TK/83Yrn4mrnEka7YRzqYIR5fx8WLEzA2Dl77hfuuKOUSMS19mdHqao4XIAPPb64+LKv+u5awvm+Kv5spuGaWbtYhO0m54X/C7nxnOvoo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782920344; c=relaxed/simple;
	bh=YBxIB/ieZk9pIFFKON/ChwjqykpOC6LcHRGPaTOpsio=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FdukedNYirfg9lMsiIi5ImpuCT/xFVFkK5e9mott9VGr69e5BXcjPyhimp8JY+qWTtO3N4bvY3cC4Zx4tJhXbLG6WPN0qStfVpcpgHwhkWTbPse4klsmN6soSEqqiH2Rxz0xUkxh0g4nZ0eopuiHRMDIcdifTE6Wrv3QeS0jGuo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=mr2T0k6L; arc=none smtp.client-ip=74.125.82.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mr2T0k6L"
Received: by mail-dl1-f43.google.com with SMTP id a92af1059eb24-139f1dfc9faso1115121c88.0
        for <linux-xfs@vger.kernel.org>; Wed, 01 Jul 2026 08:39:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782920343; x=1783525143; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=sHYX65pHJtAmEIu815eclMgDLvYuahlm+h4yUIRxrYU=;
        b=mr2T0k6Ld+38tce1CtRABt2YVWwkSdR3LIl3OSli5rvNufvzmaeForLaMCwGv7AUKb
         tj6la31e5gHYhn0gOlbU9Te03lJ/xmFDdXVUEsPVCkat7UQ3yJrdlbCE2IjdxBJHWXPQ
         WTXOzmFBox2e97Xp3SQWP1vtOEBO6PYJIFHEiP5mZOWoWzTJlrBTTcj2O/1WEtUhYWEj
         VU8I5OBsx0QjVhKuoCvbLqIFnno3F/hQv+HQNJzRerjfrMYNDqfB2knq2pJRYti89+kk
         hBwtwS4tJOBNPrVQNLzZWMMJVVyO8ZC5dgnEU0SkYPBuE85PTiITlzuG8gfkYk8d87Bo
         vLdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782920343; x=1783525143;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=sHYX65pHJtAmEIu815eclMgDLvYuahlm+h4yUIRxrYU=;
        b=Iw3bUUXer97oP6tZwkov0Fz0uGiJo4knOn59StPBp1fjOMf9NC4pCsXQxuQ3wVGVnP
         g0Ut9RSuJg/mSiSvgSobA5sbosQzUFrrbJ50KEZmeh1t8tyTLrKbp7TM3wPb5gShaSbS
         2Y9V8tySPxKr2gu2xjGVv5vPCPHRm3eb4Vvf7IuLeIqZBQZPFw6gHnQIW0lgiLD509G4
         FyS0oe9qLWK22R7UpE8m6+UFZo2c77mbxhCAltNpKPKMfXZBOyW5dQ0IR4KCf6kRFeSG
         MiU0s8LJzt0tMDRcwkVO5xwBtszpMXlLZwgJMnMUZq77vR5xZ6itXSnX6MeAwVoLGShz
         O1Vg==
X-Gm-Message-State: AOJu0YzMpQIVjORy/h4HUPqFeJUXgGZCc2kWtn8E9m3K2nl8oD8JQkC9
	8B9DChcSVyRJGy2uLhrF6Mv+KTBGcNDErf+HdM7YrxY+CURweqQuRvNqfjPg5htTZiU=
X-Gm-Gg: AfdE7clPdI3+8P+nHnG8RUeb8xPTX0OkNHS+mkE3+c30qUytSsGc8sJBocqA98xTtPT
	O6fwFHjKhas0iNFGglkTRV+LfFdV43vNIbmJ96IjNlenOw11BcXJc9//DeR0Mtk/uLYfzsYlpqR
	XbwlqhTThUc6FmTav5niyGmOzwb6+wiir+UJMl8EWqUQdM2BP43+XsIGBjOVpNMiJcqxUDECVNE
	gNrWBQe2AmAWhojqjvF2QdUEFJKUojOLLTHpUDzUOmkRxti9xa+FlpkZ+I7LdQGrLam8h3xyD5U
	zOI2EvYjlRzJ/aQeQdl6RdL/JKzm3bbODCvfukzTgmeEbkdMoSVS1BF7b4+MENaUniEIJMRhnmZ
	IwOviKO1yV1rbNf4M0tpBQM5ClON+ygx34ya7e/k+KBsHZBgHY9UwLuoZDs62vdRmUKORGbLT88
	qEzZgcPPsUPsrDKV4JxoVcu3OCkRplW4vgPJ8U9XBB3KQsC6TqHOSOOP/93A==
X-Received: by 2002:a05:7022:2603:b0:139:98f7:d4a1 with SMTP id a92af1059eb24-13b390ec0fbmr1096919c88.16.1782920342832;
        Wed, 01 Jul 2026 08:39:02 -0700 (PDT)
Received: from fx.tailc0aff1.ts.net ([206.206.192.132])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-13b2cd1be7bsm15761678c88.1.2026.07.01.08.39.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Jul 2026 08:39:02 -0700 (PDT)
From: Weiming Shi <bestswngs@gmail.com>
To: linux-xfs@vger.kernel.org
Cc: Carlos Maiolino <cem@kernel.org>,
	"Darrick J . Wong" <djwong@kernel.org>,
	Brian Foster <bfoster@redhat.com>,
	Christoph Hellwig <hch@infradead.org>,
	Xiang Mei <xmei5@asu.edu>,
	Weiming Shi <bestswngs@gmail.com>
Subject: [PATCH v2 2/3] xfs: splice unsorted log items back to the transaction after the loop
Date: Wed,  1 Jul 2026 08:38:32 -0700
Message-ID: <20260701153833.3155514-4-bestswngs@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260701153833.3155514-2-bestswngs@gmail.com>
References: <20260701153833.3155514-2-bestswngs@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On error, xlog_recover_reorder_trans() splices the leftover sort_list
items back to trans->r_itemq inside the loop before breaking out.  The
loop tail already splices the per-fate lists back, so do sort_list there
too, guarded by the assert that used to sit after the loop.

No functional change.  It drops the duplicated splice so the next patch
can add another error case without repeating it.

Signed-off-by: Weiming Shi <bestswngs@gmail.com>
---
 fs/xfs/xfs_log_recover.c | 16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index a1b373c68f0e..5347f6a5ec42 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -1912,12 +1912,6 @@ xlog_recover_reorder_trans(
 			xfs_warn(log->l_mp,
 				"%s: unrecognized type of log operation (%d)",
 				__func__, ITEM_TYPE(item));
-			/*
-			 * return the remaining items back to the transaction
-			 * item list so they can be freed in caller.
-			 */
-			if (!list_empty(&sort_list))
-				list_splice_init(&sort_list, &trans->r_itemq);
 			error = -EFSCORRUPTED;
 			break;
 		}
@@ -1945,7 +1939,15 @@ xlog_recover_reorder_trans(
 		}
 	}
 
-	ASSERT(list_empty(&sort_list));
+	/*
+	 * Return the remaining items back to the transaction item list so they
+	 * can be freed in caller.  This should only happen when we encountered
+	 * an error.
+	 */
+	if (!list_empty(&sort_list)) {
+		ASSERT(error);
+		list_splice_init(&sort_list, &trans->r_itemq);
+	}
 	if (!list_empty(&buffer_list))
 		list_splice(&buffer_list, &trans->r_itemq);
 	if (!list_empty(&item_list))
-- 
2.43.0

