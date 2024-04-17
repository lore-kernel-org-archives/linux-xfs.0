Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44CB414901E
	for <linux-xfs@vger.kernel.org>; Wed, 17 Apr 2024 16:19:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713370781; cv=none; b=PFjjrgk0cGzpNCZSUj4PQUAHmotLUSCK+pw+gi/G8QhmCS0FaYiFwvq1v3C1xX+TQSFrqNawBsSLkSkBpn3RragGbab2npO82OyqDout1Ph3XvLQU/iU57xA15lYgy44jqyLfOBwe7bx/ar7dBBL2PwhuD6W24UVpFSfNKO8rw0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713370781; c=relaxed/simple;
	bh=kfopneWVUzAWtOEy8Qg0l7TIUCGXxxCSaPD9GnIirMw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TJetjEARiS/LIbyLk/ufG70q7FhKI5rqVsnYxPMJlh6qJiwGDgQYdKCpq6guJtG9jHuNz1X3aprAufctiKBhi/00rIkR1rZ2xVjqZzhdw3N4zRdEbw3F66eAVLdFV21i24pKGtSONPGA2W2Kvbi1iZfmbK+yddeSj23dCzWw9f8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=E8Gjx63j; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="E8Gjx63j"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1713370779;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=IiaO8seLkPKK5bXXWNYfUJC8WqVyivK7Zsl5rhBzW04=;
	b=E8Gjx63j8NAyRF8L0EtVahLSFxQuNPKKg6lJj+eeNeIfRCX82XhNvThZqxEki1ISVhJd4J
	RS+DJcbxoExopx7ETv2DQ1R83FEJv5uWo1homMkFPAHAmaNuXs0ZWe5EUo3bym8ZtOZ925
	nCcBeRKZ+2x5XiDG/m6dWL7fDFJZzCs=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-428-HbdH0yKuNNaeqAaAwdkDRQ-1; Wed, 17 Apr 2024 12:19:37 -0400
X-MC-Unique: HbdH0yKuNNaeqAaAwdkDRQ-1
Received: by mail-ej1-f69.google.com with SMTP id a640c23a62f3a-a46852c2239so441481366b.1
        for <linux-xfs@vger.kernel.org>; Wed, 17 Apr 2024 09:19:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713370776; x=1713975576;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=IiaO8seLkPKK5bXXWNYfUJC8WqVyivK7Zsl5rhBzW04=;
        b=frP9wXALAONdfOEy1s5x29SmRwMZbbixoArNSKXdV7UZkQE16ZDn3XiAdvPk1zeWky
         nDTmALdg+H3MbmOBlGmMvOKQqu+Nt4Vn44HI/2pC9fJVnOe8KDw0lYrClTqQnW/k7u/1
         IhO3Jj7u0f5KOQ6GSBD+4bLJCYIZmYaLCSti8diG/hZDMApjYcNdbNrMBQAHPq0bljuv
         +SSNu6wxxlQ+iHqccB8MjWZvUB/iVNd6W/2f1heuoS+4x/UlJ3wHZEOeKZZJ1UnSReF9
         6L9XeF0pSEXWoCABZoHqb0GWFkvO1E49qln8sTbPOkTKQLfobomxIcR1KvM6p2TBwaqK
         9rZg==
X-Forwarded-Encrypted: i=1; AJvYcCXmuPyJvhYI8rktsjAsbH5Fust7pi6h054lg7jXs8SovvfK3FxxapPBss9LlGdqeLQdmS8OqabVSG4hMRIgQTLvuSHEAwV+pt+l
X-Gm-Message-State: AOJu0YyDEV5AgNRiDRIfWgbOcpugluNA5U/0H6FfMPiP6BhXmMvT62zf
	piOwBcJUxb5vncQ+eELFV1oiMV/+xOt8iRJHWZG7ic8pZtDpFfBRDg9K2wPyqf2WaK4Xak3Lz71
	qW/ujR2lKPZloYskasIqOt67/3OhCaM0MMkoTqckRE3hvcdYq9Hg103Yd
X-Received: by 2002:a17:907:bb86:b0:a52:6fcb:100f with SMTP id xo6-20020a170907bb8600b00a526fcb100fmr97ejc.12.1713370776323;
        Wed, 17 Apr 2024 09:19:36 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IG7nxB59EJrFRzM0IQoQvh6HFdGzXDNDKriMErtaKZKSyl8060UGK3LyDU7KXv6mamsXuMW4Q==
X-Received: by 2002:a17:907:bb86:b0:a52:6fcb:100f with SMTP id xo6-20020a170907bb8600b00a526fcb100fmr67ejc.12.1713370775582;
        Wed, 17 Apr 2024 09:19:35 -0700 (PDT)
Received: from thinky.redhat.com ([109.183.6.197])
        by smtp.gmail.com with ESMTPSA id q23-20020a170906a09700b00a519ec0a965sm8243334ejy.49.2024.04.17.09.19.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Apr 2024 09:19:34 -0700 (PDT)
From: Andrey Albershteyn <aalbersh@redhat.com>
To: cem@kernel.org,
	linux-xfs@vger.kernel.org
Cc: djwong@kernel.org,
	hch@infradead.org,
	Andrey Albershteyn <aalbersh@redhat.com>,
	Christoph Hellwig <hch@lst.de>
Subject: [PATCH v3 1/3] xfs_fsr: replace atoi() with strtol()
Date: Wed, 17 Apr 2024 18:19:29 +0200
Message-ID: <20240417161931.964526-2-aalbersh@redhat.com>
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

Replace atoi() which silently fails with strtol() and report the
error.

Signed-off-by: Andrey Albershteyn <aalbersh@redhat.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fsr/xfs_fsr.c | 26 +++++++++++++++++++++++---
 1 file changed, 23 insertions(+), 3 deletions(-)

diff --git a/fsr/xfs_fsr.c b/fsr/xfs_fsr.c
index 02d61ef9399a..fdd37756030a 100644
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
+				fprintf(stderr, _("%s: invalid runtime: %s\n"),
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

