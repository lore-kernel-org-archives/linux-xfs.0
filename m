Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C38513D265
	for <linux-xfs@vger.kernel.org>; Wed, 17 Apr 2024 12:59:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713358787; cv=none; b=Kj76vFf9HLL6h7ozcxSkp7vMW/mNlhBDtxT323gqFPDLCzrjV/LHmrCIxDfEl0a0ray+pO/geWHd3F/qm3Yv7nx3npkOgbvsDimX+zeFiPpj6+tD0vtN2yIzf9xcHjpLhursY9YQxBeNbgjyUBvBW8w70Ma92jH9O6rPd/OICsc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713358787; c=relaxed/simple;
	bh=ZNVbwtxD85cCeqweuaKEK0b9mByz5cJu7n0S4ki4yX4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oYM9AuISVE6OX28f9ZrGMVHohsFzCDiEnUYx7zECuxUgeSEuEpkoqnSI8x2/5u1a/oMarGOF1fk0RuXafJhxRZ/ebpr6ceX/c5wrlj1Nxudv11tyD5Mbgbj4LJnWgZU7sPj3eywahKuY6WzJ07SOrjptpD108JykX6LgGFZo/xU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=K//KWyd4; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="K//KWyd4"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1713358785;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=khb2u3O/il9uk77RiG+4Pil1DtPMbjmv6VNImXopwLc=;
	b=K//KWyd4OfFonIDJCQxdT+4VoKMdt58/jMCPksEG3u+Qebst9S7FrffOgB5yeo4n1J3EdQ
	4u6pZb5admxfggdLYpIiIAqb0pPhpDmwJyYaUhf9izphZcR6eiFTg6WrltWOXDz9Po/pNU
	rIIyeu1IBdtotj1tOJHbbD4hT2RG7kw=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-246-NEwPBhpAOOC3YDCnp7VgmQ-1; Wed, 17 Apr 2024 08:59:44 -0400
X-MC-Unique: NEwPBhpAOOC3YDCnp7VgmQ-1
Received: by mail-ej1-f71.google.com with SMTP id a640c23a62f3a-a51eb0c14c8so256709066b.0
        for <linux-xfs@vger.kernel.org>; Wed, 17 Apr 2024 05:59:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713358782; x=1713963582;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=khb2u3O/il9uk77RiG+4Pil1DtPMbjmv6VNImXopwLc=;
        b=GH9qVUPozcEKBYzxVuRHvEYDJ0OzRqjE1HiBvN5dqKnq+dNb7fOyu4NhcGn6SpJbv2
         zZyrom9yUHshZzj5VIWF3iP0uNyZENdFIzKAZCQHTJQM97U0N8Z55yIL0JR6f5BP9TSw
         /sLLOfI3dIuE6mtRZEs3NdBX/KVI9+PV91O82bmfU+OcsYPxGCC/Z9aIJF+1UWGcIfVB
         PFuLMnZ0l/e0jsGwOZTXMPweEAjwGpFrAlaPB4eP0IeL/6lGp5IKlyk33CfRckjPS0iI
         g597uTSRBpxYGh8JG2pKCdr6oJPLtiZadQA9oqBqtbTWYy5kpuf6eDWRPSRXNdUpSQvu
         3pDQ==
X-Forwarded-Encrypted: i=1; AJvYcCXyPLpIbwdePhYS3Y1c2v2Q9FeKxDGBu9oDKEUjdUS90XPdJL6ya0DLEett2vnocjEeJXBknWYErf6KmBYrKkf8HnLJ27AfDcro
X-Gm-Message-State: AOJu0Yxr2f0xo/qGHRltB/9gY5TXUtTYexYTee+FuKaufgFJjnMwcYQI
	+/pc4OWwQVoLCiMuE0IRifkURuBNUbcUmkFKXS49envCKSJvPwyzS7V2hpp1LPQ1G8Atw6+K8DU
	s4KfLMHRhCb+ygaEgBfsL8Q9p+T/aab24dNciekbm4raYKWpSvS8kGoIc
X-Received: by 2002:a17:906:f34c:b0:a55:5620:675c with SMTP id hg12-20020a170906f34c00b00a555620675cmr1226329ejb.34.1713358781801;
        Wed, 17 Apr 2024 05:59:41 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFYQ+GXDJoFqazMFkCVzQtRvB1kJ45xZBHiwO5JdZoDwoAPr7NkjlIPIwh/o/KgMxlNw5tzLQ==
X-Received: by 2002:a17:906:f34c:b0:a55:5620:675c with SMTP id hg12-20020a170906f34c00b00a555620675cmr1226312ejb.34.1713358781237;
        Wed, 17 Apr 2024 05:59:41 -0700 (PDT)
Received: from thinky.redhat.com ([109.183.6.197])
        by smtp.gmail.com with ESMTPSA id gc22-20020a170906c8d600b00a534000d525sm3330252ejb.158.2024.04.17.05.59.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Apr 2024 05:59:40 -0700 (PDT)
From: Andrey Albershteyn <aalbersh@redhat.com>
To: cem@kernel.org,
	linux-xfs@vger.kernel.org
Cc: djwong@kernel.org,
	hch@infradead.org,
	Andrey Albershteyn <aalbersh@redhat.com>
Subject: [PATCH v2 1/3] xfs_fsr: replace atoi() with strtol()
Date: Wed, 17 Apr 2024 14:59:35 +0200
Message-ID: <20240417125937.917910-2-aalbersh@redhat.com>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20240417125937.917910-1-aalbersh@redhat.com>
References: <20240417125937.917910-1-aalbersh@redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Replace atoi() which silently fails with strtol() and report the
error.

Signed-off-by: Andrey Albershteyn <aalbersh@redhat.com>
---
 fsr/xfs_fsr.c | 26 +++++++++++++++++++++++---
 1 file changed, 23 insertions(+), 3 deletions(-)

diff --git a/fsr/xfs_fsr.c b/fsr/xfs_fsr.c
index 02d61ef9399a..cf764755288d 100644
--- a/fsr/xfs_fsr.c
+++ b/fsr/xfs_fsr.c
@@ -164,7 +164,13 @@ main(int argc, char **argv)
 			usage(1);
 			break;
 		case 't':
-			howlong = atoi(optarg);
+			errno = 0;
+			howlong = strtol(optarg, NULL, 10);
+			if (errno) {
+				fprintf(stderr, _("%s: invalid interval: %s\n"),
+					optarg, strerror(errno));
+				exit(1);
+			}
 			if (howlong > INT_MAX) {
 				fprintf(stderr,
 				_("%s: the maximum runtime is %d seconds.\n"),
@@ -179,10 +185,24 @@ main(int argc, char **argv)
 			mtab = optarg;
 			break;
 		case 'b':
-			argv_blksz_dio = atoi(optarg);
+			errno = 0;
+			argv_blksz_dio = strtol(optarg, NULL, 10);
+			if (errno) {
+				fprintf(stderr,
+					_("%s: invalid block size: %s\n"),
+					optarg, strerror(errno));
+				exit(1);
+			}
 			break;
 		case 'p':
-			npasses = atoi(optarg);
+			errno = 0;
+			npasses = strtol(optarg, NULL, 10);
+			if (errno) {
+				fprintf(stderr,
+					_("%s: invalid number of passes: %s\n"),
+					optarg, strerror(errno));
+				exit(1);
+			}
 			break;
 		case 'C':
 			/* Testing opt: coerses frag count in result */
-- 
2.42.0

