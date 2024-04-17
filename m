Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D38D84E01
	for <linux-xfs@vger.kernel.org>; Wed, 17 Apr 2024 12:53:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713358386; cv=none; b=I+Jm/iEhnoOtP+MdEmqoSkVtMw80zxlr374BpuPu1BUfA3uBvg4AD1utvTNRRKJGcllYg7zc+sNOvj9tZJ8boh4vGrKtwyQuQuWpOhsChCwS/iStzjMajDFCC0lu7MqWe95uomp4uqFF2nz+6k9So3HwlaX19fOKMRQr8e8cDOs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713358386; c=relaxed/simple;
	bh=86mJc4MtN/5Es3MhvKn42tq2qsn+xpUDzaPuadYgpBo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AHGujbW+mgCimJR8eVVmC+Co46DxapPYetX9D2WsyTih+MUxSP0S5gczl5u/tCk2RnIgweDdJr9Wfqcuo8DNPkxypQAuuAL3/CxUQ+1bvrpZP2TspHJ7J2V/eGvFa6N829Ide1kQOHoE9Wpnec5NjxojZLOxsWt78LEVl+Ufk7w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=eEgiJUpp; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="eEgiJUpp"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1713358383;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=pt1/JfZbYOQg6CpN4sXdw/WCUEY0WgJs4WPpgQycX/M=;
	b=eEgiJUppSSTIkLagGZDKLRCs/uza+8Gh34E3v82kc7AH+PDVq4/Pfm/5TKpbjaVY6ELvez
	Knw4Otfr6+z3ktg+7toQ2J+bjnfenjj5QwV5wl5Q1jhgIYHuLaDbg8OboXhIjyLlofsbX+
	GYaNBiQ7w+zj+Rj5t8g7A7MoM1fg+9M=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-612-76rp_6lNOSuOSCBNteZT5A-1; Wed, 17 Apr 2024 08:53:02 -0400
X-MC-Unique: 76rp_6lNOSuOSCBNteZT5A-1
Received: by mail-ej1-f72.google.com with SMTP id a640c23a62f3a-a51beadf204so304427566b.1
        for <linux-xfs@vger.kernel.org>; Wed, 17 Apr 2024 05:53:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713358381; x=1713963181;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=pt1/JfZbYOQg6CpN4sXdw/WCUEY0WgJs4WPpgQycX/M=;
        b=dJXsMQUt9UHoH107/iN3OPW0KX7KExDeTxxtRVip36fC+lPlZliAxm2bigCADlIRB1
         rKhqJap1Kxy/XRxzC3qGUOZBTOerQ6RxQbFpD7zAgX1fZtpsZaP9Nip1MFEDpqfilE+z
         VRLtLLIglkkFoV886eGKd6YOpJ2rOpAi6E7i9BK7DRg5R3ybPYUMjCiRRiiXc6XqkJeK
         6a6YQrSm8av2EF197hfuzAvmjrfClpDpWeFkD+Qf4QlnYgfE+piL4R5awR/ku6JNNCNo
         k0EKEYlENmt1pE/oFkBRCbdUee38Dh8PFiIdD4zu3G61meViLYvZbH1iVmlaDpN3eyfn
         j4pQ==
X-Forwarded-Encrypted: i=1; AJvYcCXF5oS+rUQhkt6m5ThSXpKsolsXTyp0/v8CsAYYolgQoNgu/1tsJnK2ANKvVQWWSR2xnZs5EUWnrRY/YDGsRKG3R/teDrYg+HrH
X-Gm-Message-State: AOJu0YzhwM9+gE163wGdc9F6vUio0VBDWFI4mCtMZJDJa/G+PAem0nrl
	oMQA5Vb11v2WmleZ7JIFQK8eoipscrvNF8Bj1ernHufU9Zo/IyDemQDPgaDN2N4qyqPSnkTR4P6
	Yy63/HPtE2BK5jduVkH3gmgDH5y85ops6X2ajRQWb5bY8VZ7rj6QUP4w2LqvLmaFW
X-Received: by 2002:a50:a6d2:0:b0:56e:f64:aaf6 with SMTP id f18-20020a50a6d2000000b0056e0f64aaf6mr10376570edc.5.1713358380576;
        Wed, 17 Apr 2024 05:53:00 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFfiSgXLAOmcyYmGpyFJXPBoMLge1tXqtd/lQNPUXiAhyJrJ+lWjQzC6zl/nuCWhZWrffshIw==
X-Received: by 2002:a50:a6d2:0:b0:56e:f64:aaf6 with SMTP id f18-20020a50a6d2000000b0056e0f64aaf6mr10376552edc.5.1713358379842;
        Wed, 17 Apr 2024 05:52:59 -0700 (PDT)
Received: from thinky.redhat.com ([109.183.6.197])
        by smtp.gmail.com with ESMTPSA id en8-20020a056402528800b0056e2432d10bsm7258169edb.70.2024.04.17.05.52.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Apr 2024 05:52:59 -0700 (PDT)
From: Andrey Albershteyn <aalbersh@redhat.com>
To: cem@kernel.org,
	linux-xfs@vger.kernel.org
Cc: djwong@kernel.org,
	Andrey Albershteyn <aalbersh@redhat.com>
Subject: [PATCH v3 4/4] xfs_fsr: convert fsrallfs to use time_t instead of int
Date: Wed, 17 Apr 2024 14:52:28 +0200
Message-ID: <20240417125227.916015-6-aalbersh@redhat.com>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20240417125227.916015-2-aalbersh@redhat.com>
References: <20240417125227.916015-2-aalbersh@redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Convert howlong argument to a time_t as it's truncated to int, but in
practice this is not an issue as duration will never be this big.

Add check for howlong to fit into int (printf can use int format
specifier). Even longer interval doesn't make much sense.

Signed-off-by: Andrey Albershteyn <aalbersh@redhat.com>
---
 fsr/xfs_fsr.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/fsr/xfs_fsr.c b/fsr/xfs_fsr.c
index 3077d8f4ef46..02d61ef9399a 100644
--- a/fsr/xfs_fsr.c
+++ b/fsr/xfs_fsr.c
@@ -72,7 +72,7 @@ static int  packfile(char *fname, char *tname, int fd,
 static void fsrdir(char *dirname);
 static int  fsrfs(char *mntdir, xfs_ino_t ino, int targetrange);
 static void initallfs(char *mtab);
-static void fsrallfs(char *mtab, int howlong, char *leftofffile);
+static void fsrallfs(char *mtab, time_t howlong, char *leftofffile);
 static void fsrall_cleanup(int timeout);
 static int  getnextents(int);
 int xfsrtextsize(int fd);
@@ -165,6 +165,12 @@ main(int argc, char **argv)
 			break;
 		case 't':
 			howlong = atoi(optarg);
+			if (howlong > INT_MAX) {
+				fprintf(stderr,
+				_("%s: the maximum runtime is %d seconds.\n"),
+					optarg, INT_MAX);
+				exit(1);
+			}
 			break;
 		case 'f':
 			leftofffile = optarg;
@@ -387,7 +393,7 @@ initallfs(char *mtab)
 }
 
 static void
-fsrallfs(char *mtab, int howlong, char *leftofffile)
+fsrallfs(char *mtab, time_t howlong, char *leftofffile)
 {
 	int fd;
 	int error;
-- 
2.42.0

