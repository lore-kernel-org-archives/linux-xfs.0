Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8C9414D2A4
	for <linux-xfs@vger.kernel.org>; Wed, 17 Apr 2024 16:19:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713370783; cv=none; b=TFoAQaZuRHiqWhcyiFoeINsXFAfAB+wcqaaCKqw+sS6AU9ofFDAyjgp+W169Vz0Bk9Ja7tSyScEv1VJXP6jiBreM6JabOfNyCM04/Qdlmje5W99IFu2fPDkEYN5rPBI0M8zx7y8RueVObiuauLLoGCzUS36/lYNqtuOlrl2aJF8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713370783; c=relaxed/simple;
	bh=1E5y44abDRpyALZ+s8e6kXPfcSFzbn2HWIAWc6J+qCw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=c1tmSt+1EAIqwx98XKjOBP/18JCc4T6HakS3rh/f7/M9L96RXvJ0eqxYRSqVqxj2l/+0LGdoPhYil97H2Po8CqOjuH+nwAI7t8fK8Pc9Q0guFaSUs6AJjz/eG3mTrm3RVxzGjlqB5htOxN6pz5vGYQ8FOq773t6WQIlRx9XRSv0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=a0zmRr2Z; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="a0zmRr2Z"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1713370780;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=3Nzfm18ejw+tnM3xZO6gyjkZvwV4m5FSoUpfxoaN+fA=;
	b=a0zmRr2ZwvAWqm73ickHxM02dY3GCIE/d2bGVLi4eEZIluYDVUja3BltlYDbOJd9kC5htC
	3L7cygEL5gnkiqCa9SHgEi6xtVMg4tvt13ou/zB2gyMisYzw9zmSp5a/FqIeFmj2xzi6Rq
	Rlkn3/6sXWCAm0iFMH3veDz2AqmkHzg=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-592-u9NeZzXYNv-gjJmoB1JKjQ-1; Wed, 17 Apr 2024 12:19:39 -0400
X-MC-Unique: u9NeZzXYNv-gjJmoB1JKjQ-1
Received: by mail-ej1-f72.google.com with SMTP id a640c23a62f3a-a52539e4970so261245366b.1
        for <linux-xfs@vger.kernel.org>; Wed, 17 Apr 2024 09:19:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713370778; x=1713975578;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=3Nzfm18ejw+tnM3xZO6gyjkZvwV4m5FSoUpfxoaN+fA=;
        b=u5eYNFOU3aC1LZexPqbT0x1JFl2vejo4ufJN7pN+CJ1zZ3Ra4ivfIfXeorMuKIdMsc
         IN5UOmX7Z4uRhec8y635o6/NNy0tnzkCY4mHdV2HbgFhcC17TDki+8vz2RV7dscTyhEH
         UhkeeG4zv3aqHEvFpkn8eqswjLphPYJlexMCidhBb4Nz5OQDD4/j2Crge5+2/F2v+/LX
         g4fKH6TtP0GifwyuyqNt3LLsZG9obIph+c9qI5rPydRvu3cGgpaYnwjd+l50J2DTu6Ds
         08HiV7W9FucDChrj5ofDCYaHrGB0RmvuA4e9+8Nqne4z0cGDt4waHuNNYy8m4J3JeUH4
         alwg==
X-Forwarded-Encrypted: i=1; AJvYcCXuJ7lyziNGAVAa2G/uIzAC4bhEQH0pvTSPORgQzUuJHmAeAEH4qS8akKHdOdGDbywRnLSgw18r/E7x0V5cFKmC+Qqz9f+S5U/e
X-Gm-Message-State: AOJu0YxN70x/WNDsMxlg8FB/Y7aH/lkWxtLhdNOqwsZnjjpmIXxSFbkP
	ozuxVft/8lcSTQMGUu/biEusG+LLLzN2iDt5fkft29Y8Q1lmTQUay9c9HSVgA/hhn9NtK1quBTL
	dly6sANLjjsaank4x/fa3tcbBiPCruod3/eqq/nnqGU6Vk/gaoDMuEAAX
X-Received: by 2002:a17:906:c194:b0:a51:982e:b3f7 with SMTP id g20-20020a170906c19400b00a51982eb3f7mr9938181ejz.37.1713370777962;
        Wed, 17 Apr 2024 09:19:37 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IE27qa3JqyDz0qs3OhX7GrsjPCgbxUszZp3GuTipgylfSsszsf7QYcJePdT8WoqxoS9wVdUtA==
X-Received: by 2002:a17:906:c194:b0:a51:982e:b3f7 with SMTP id g20-20020a170906c19400b00a51982eb3f7mr9938169ejz.37.1713370777506;
        Wed, 17 Apr 2024 09:19:37 -0700 (PDT)
Received: from thinky.redhat.com ([109.183.6.197])
        by smtp.gmail.com with ESMTPSA id q23-20020a170906a09700b00a519ec0a965sm8243334ejy.49.2024.04.17.09.19.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Apr 2024 09:19:36 -0700 (PDT)
From: Andrey Albershteyn <aalbersh@redhat.com>
To: cem@kernel.org,
	linux-xfs@vger.kernel.org
Cc: djwong@kernel.org,
	hch@infradead.org,
	Andrey Albershteyn <aalbersh@redhat.com>,
	Christoph Hellwig <hch@lst.de>
Subject: [PATCH v3 3/3] xfs_repair: catch strtol() errors
Date: Wed, 17 Apr 2024 18:19:31 +0200
Message-ID: <20240417161931.964526-4-aalbersh@redhat.com>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20240417161931.964526-1-aalbersh@redhat.com>
References: <20240417161931.964526-1-aalbersh@redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

strtol() sets errno if string parsing. Abort and tell user which
parameter is wrong.

Signed-off-by: Andrey Albershteyn <aalbersh@redhat.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 repair/xfs_repair.c | 40 +++++++++++++++++++++++++++++++++++++++-
 1 file changed, 39 insertions(+), 1 deletion(-)

diff --git a/repair/xfs_repair.c b/repair/xfs_repair.c
index 2ceea87dc57d..2fc89dac345d 100644
--- a/repair/xfs_repair.c
+++ b/repair/xfs_repair.c
@@ -252,14 +252,22 @@ process_args(int argc, char **argv)
 					if (!val)
 						do_abort(
 		_("-o bhash requires a parameter\n"));
+					errno = 0;
 					libxfs_bhash_size = (int)strtol(val, NULL, 0);
+					if (errno)
+						do_abort(
+		_("-o bhash invalid parameter: %s\n"), strerror(errno));
 					bhash_option_used = 1;
 					break;
 				case AG_STRIDE:
 					if (!val)
 						do_abort(
 		_("-o ag_stride requires a parameter\n"));
+					errno = 0;
 					ag_stride = (int)strtol(val, NULL, 0);
+					if (errno)
+						do_abort(
+		_("-o ag_stride invalid parameter: %s\n"), strerror(errno));
 					break;
 				case FORCE_GEO:
 					if (val)
@@ -272,19 +280,31 @@ process_args(int argc, char **argv)
 					if (!val)
 						do_abort(
 		_("-o phase2_threads requires a parameter\n"));
+					errno = 0;
 					phase2_threads = (int)strtol(val, NULL, 0);
+					if (errno)
+						do_abort(
+		_("-o phase2_threads invalid parameter: %s\n"), strerror(errno));
 					break;
 				case BLOAD_LEAF_SLACK:
 					if (!val)
 						do_abort(
 		_("-o debug_bload_leaf_slack requires a parameter\n"));
+					errno = 0;
 					bload_leaf_slack = (int)strtol(val, NULL, 0);
+					if (errno)
+						do_abort(
+		_("-o debug_bload_leaf_slack invalid parameter: %s\n"), strerror(errno));
 					break;
 				case BLOAD_NODE_SLACK:
 					if (!val)
 						do_abort(
 		_("-o debug_bload_node_slack requires a parameter\n"));
+					errno = 0;
 					bload_node_slack = (int)strtol(val, NULL, 0);
+					if (errno)
+						do_abort(
+		_("-o debug_bload_node_slack invalid parameter: %s\n"), strerror(errno));
 					break;
 				case NOQUOTA:
 					quotacheck_skip();
@@ -305,7 +325,11 @@ process_args(int argc, char **argv)
 					if (!val)
 						do_abort(
 		_("-c lazycount requires a parameter\n"));
+					errno = 0;
 					lazy_count = (int)strtol(val, NULL, 0);
+					if (errno)
+						do_abort(
+		_("-o lazycount invalid parameter: %s\n"), strerror(errno));
 					convert_lazy_count = 1;
 					break;
 				case CONVERT_INOBTCOUNT:
@@ -356,7 +380,11 @@ process_args(int argc, char **argv)
 			if (bhash_option_used)
 				do_abort(_("-m option cannot be used with "
 						"-o bhash option\n"));
+			errno = 0;
 			max_mem_specified = strtol(optarg, NULL, 0);
+			if (errno)
+				do_abort(
+		_("%s: invalid memory amount: %s\n"), optarg, strerror(errno));
 			break;
 		case 'L':
 			zap_log = 1;
@@ -377,7 +405,11 @@ process_args(int argc, char **argv)
 			do_prefetch = 0;
 			break;
 		case 't':
+			errno = 0;
 			report_interval = strtol(optarg, NULL, 0);
+			if (errno)
+				do_abort(
+		_("%s: invalid interval: %s\n"), optarg, strerror(errno));
 			break;
 		case 'e':
 			report_corrected = true;
@@ -397,8 +429,14 @@ process_args(int argc, char **argv)
 		usage();
 
 	p = getenv("XFS_REPAIR_FAIL_AFTER_PHASE");
-	if (p)
+	if (p) {
+		errno = 0;
 		fail_after_phase = (int)strtol(p, NULL, 0);
+		if (errno)
+			do_abort(
+		_("%s: invalid phase in XFS_REPAIR_FAIL_AFTER_PHASE: %s\n"),
+				p, strerror(errno));
+	}
 }
 
 void __attribute__((noreturn))
-- 
2.42.0

