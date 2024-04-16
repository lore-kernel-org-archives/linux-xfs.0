Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DFB31386B3
	for <linux-xfs@vger.kernel.org>; Tue, 16 Apr 2024 20:29:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713299371; cv=none; b=AkkSmcTtZCQKEobnhm2vQvNXiUIZ3Qm/oEwuxPPaK1VuJHzo/YI6SOQpMfIwt+T0Ffq5DwxVbsmgQHZA8EwbdTe6/nWU567TazgcgoBTtZGtSm+hS34xHSM8euMtrUE3uSCQfo5Xb4Q7JOMzPoIvCcaI1tRPuMOz/NooGsAviz0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713299371; c=relaxed/simple;
	bh=LAwifmJjqqKdtom0jvW5ZTQUTTgwchGgry4EWAvZN0o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F7HF3lp2Yw0SPeDjm6kdgxHU08N7Cy1LJdmmCCbQUFGeSVwuP3BNG39S/F8YaMGRBmbLTeD9LLMysdMSqFrokT6vxf+qLRcn5ns8p6Ye7k18/WCrjnNx2uMBH9z3xS4s0BSyaKy1ti7n9ArWhZuCwBoMFZrRtHQKwVPm6fNcObo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=T4NRyZLR; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="T4NRyZLR"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1713299369;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=rRCORNYcWVFbmh/2xxhKEJsLintLjX6NpgxfqjdOQBw=;
	b=T4NRyZLRQUKVIoO+u1rG5QEfWXq71nhOhLUU8xva9MqtgGmZTG2vIdAGa3BexZgPuhOaHb
	e2pzUsCph0Xj+CeOL3+7PGnfEby0vCd3AkCb14yTB3wa8PnlYWXLUux9RP+dLp/43ihojJ
	FChFd3fv/8KXJn87C8U8yByXBh4Mf+g=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-292-6wsoth1YPbWFexiHwCxo1Q-1; Tue, 16 Apr 2024 16:29:28 -0400
X-MC-Unique: 6wsoth1YPbWFexiHwCxo1Q-1
Received: by mail-ed1-f70.google.com with SMTP id 4fb4d7f45d1cf-56c1ac93679so3726237a12.2
        for <linux-xfs@vger.kernel.org>; Tue, 16 Apr 2024 13:29:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713299367; x=1713904167;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=rRCORNYcWVFbmh/2xxhKEJsLintLjX6NpgxfqjdOQBw=;
        b=wxI5j+xkrvxzNv3NhsLtY9Q1piHVE7nT6osjqY+pVQFmvv8PZ6kT/AXRUzg23LQb/u
         w8sEKDL7ABZU36LwRXvtLaFLoObFXiL/Vn8KL9SIqKhBt+cqkvJ2SQ1O6b4j1S4mp0MC
         Va3IuuxT3qk5HHA1BKUkfZXOAaKSPIAXiFLxfQjFStyiLYseY5W9YZQeZwCJZOKx6Aqr
         2yYqXg8/63JCH9xgp49WlEwrWT43fjnpIHrDl3sgKt9uGwSLhIYuRvyslWpon93E4v2o
         IuHmSlkUR5KMhLbC9Yb9XbPb7ikBuJcTN54b5e7Ph/X7BtSqNULSyPdW1zDqrP7NJNeQ
         a/9g==
X-Forwarded-Encrypted: i=1; AJvYcCXWXh7QjNl7qk7W8frLxXfwvmFvRDE7Tkp9SJUKYAFjIg+J+UqZeH2RzFtwHM5Cy9H0RnQXxiOvXpWwniDsR0mFMogFtpJNh804
X-Gm-Message-State: AOJu0YzuQ1Psm9ZVImUOUDyNgFdsPNCkr/ByAke6T8UXhcu9SLVyWAba
	SmOtd83T1V6gZ+ttMoDjC+fRp5/2VX419Y2zdMskMijRZ1zQU9eQlyAuWGlF7yZch95n1dBPaGX
	DS9Z22D8fR49aRihsKW993nck4knzSxv5I0JWN4Oh9RfviKqWlGRX8Bu/
X-Received: by 2002:a50:8ad4:0:b0:56e:ca2:c92b with SMTP id k20-20020a508ad4000000b0056e0ca2c92bmr9223764edk.18.1713299366698;
        Tue, 16 Apr 2024 13:29:26 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEPjMPt+AY1+8QU0wTuEIAWAJXPEDB2ho0ysX54pUaMz3yuTVso8KQrGuHAVv5pCzufqCV3WQ==
X-Received: by 2002:a50:8ad4:0:b0:56e:ca2:c92b with SMTP id k20-20020a508ad4000000b0056e0ca2c92bmr9223752edk.18.1713299366175;
        Tue, 16 Apr 2024 13:29:26 -0700 (PDT)
Received: from thinky.redhat.com ([109.183.6.197])
        by smtp.gmail.com with ESMTPSA id e21-20020a056402105500b0056e685b1d45sm6488423edu.87.2024.04.16.13.29.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Apr 2024 13:29:25 -0700 (PDT)
From: Andrey Albershteyn <aalbersh@redhat.com>
To: cem@kernel.org,
	linux-xfs@vger.kernel.org
Cc: djwong@kernel.org,
	hch@infradead.org,
	Andrey Albershteyn <aalbersh@redhat.com>
Subject: [PATCH 1/2] xfs_fsr: replace atoi() with strtol()
Date: Tue, 16 Apr 2024 22:28:41 +0200
Message-ID: <20240416202841.725706-3-aalbersh@redhat.com>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20240416202841.725706-2-aalbersh@redhat.com>
References: <20240416202841.725706-2-aalbersh@redhat.com>
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
 fsr/xfs_fsr.c | 23 ++++++++++++++++++++---
 1 file changed, 20 insertions(+), 3 deletions(-)

diff --git a/fsr/xfs_fsr.c b/fsr/xfs_fsr.c
index 4e29a8a2c548..5fabc965183e 100644
--- a/fsr/xfs_fsr.c
+++ b/fsr/xfs_fsr.c
@@ -164,7 +164,12 @@ main(int argc, char **argv)
 			usage(1);
 			break;
 		case 't':
-			howlong = atoi(optarg);
+			howlong = strtol(optarg, NULL, 10);
+			if (errno) {
+				fprintf(stderr, _("%s: invalid interval: %s\n"),
+					progname, strerror(errno));
+				exit(1);
+			}
 			if (howlong > INT_MAX) {
 				fprintf(stderr, _("%s: too long\n"), progname);
 				exit(1);
@@ -177,10 +182,22 @@ main(int argc, char **argv)
 			mtab = optarg;
 			break;
 		case 'b':
-			argv_blksz_dio = atoi(optarg);
+			argv_blksz_dio = strtol(optarg, NULL, 10);
+			if (errno) {
+				fprintf(stderr,
+					_("%s: invalid block size: %s\n"),
+					progname, strerror(errno));
+				exit(1);
+			}
 			break;
 		case 'p':
-			npasses = atoi(optarg);
+			npasses = strtol(optarg, NULL, 10);
+			if (errno) {
+				fprintf(stderr,
+					_("%s: invalid number of passes: %s\n"),
+					progname, strerror(errno));
+				exit(1);
+			}
 			break;
 		case 'C':
 			/* Testing opt: coerses frag count in result */
-- 
2.42.0

