Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1C60139D10
	for <linux-xfs@vger.kernel.org>; Tue, 16 Apr 2024 20:24:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713299062; cv=none; b=rMj9qPhkvdSvUDdf+y+qldAbc3QnbSnFPQyJLPpgmyB7zOewtzZ2xImq6kA4IvXAUECrtrXORjf31Wxw8c5ZN7Za2eWkvnm7tzcVC2XMbaVvEAUFL7BlZS8FWe4oMgZFHMqjSgd2et1qObTn8Ifk4HXw4S1V6xERtIcKjtAv0j8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713299062; c=relaxed/simple;
	bh=/9p8jLxjBvX4RC8/9EQVIoxVTtI4PKoNW7gyJYrNMdc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BbK+VUFEOHXeZxoZbLD0S8O/Zx+T9EYYPfER9w3JLbALOskXOhwMfdAYUkwFC0IE3gM6tP2Fb3fXsgOFSkh3FStMlvjZfSlBgnLPJKecvZdmcheab1pZkBXMY1VvQpj1oJ7OlB2RCH3SRexz2ighSr5frkIJuSMPAk92huXklhs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=EffprIyF; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="EffprIyF"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1713299059;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=5Mo4yrg0kQ03B7AH551uMoxboxf9UooOOFp84HwRh+g=;
	b=EffprIyFPUQ88I6AtjiGv5e13VmbZYHsG8SjwMAtQupLqMSYrRJxd1U6rmxvm6FkRjN9eT
	vAXVP4iRz04n8vOoIfPGloPB9Sv8VoI4d8hmJkwtYezAc/Pyciu/KrgV7As26zWzBfiRXt
	Q/atXnFvd+Cz2tc6zRhBoLiv9s0AtTM=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-580-91eYyz7YMmy-t70wLdL_qw-1; Tue, 16 Apr 2024 16:24:18 -0400
X-MC-Unique: 91eYyz7YMmy-t70wLdL_qw-1
Received: by mail-ej1-f69.google.com with SMTP id a640c23a62f3a-a51fdbd06c8so392233566b.3
        for <linux-xfs@vger.kernel.org>; Tue, 16 Apr 2024 13:24:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713299057; x=1713903857;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=5Mo4yrg0kQ03B7AH551uMoxboxf9UooOOFp84HwRh+g=;
        b=Tncz565bIo7QiXJ0jL4CMLN2HNw3O+2zk+bRrMw5I+3Ms1OodPb9gko1wnFjrV2eJ8
         Vw6k6WeplXGpxBk7vo1bnDOFvtsJqoRVb+T1Dn4UIIDioNeAeEuMFqdmoIvXDHJTCxoT
         T7kt9/x3ZKDTPPDL7nbN5wDRnobyhwE3ubyQXaQyQKh5NCRQaVmJ24quiGXXgw30IBDr
         1v+gXR77ZEMZWbNJhLCXTquCzBLxYK4tz0jA3vFhRBuOqDmfiBO81jzM2OJ9j0W0q9Cl
         PH/wPmvyAfrGnO430y+Qr+1KnaIPfSS1W4VvoxLnOEvuRAZ4NYNOXCQwbV12+jpdKKcE
         6MgA==
X-Forwarded-Encrypted: i=1; AJvYcCWvKD0MXyWTh4KGNAR0s6Nq8XsAllXNfAXaFT26VOM+jkGFMOddFnUNCO7GbMGz7gc5I90ixV30KnLUR4c9B9Zx2r0IS4P2tE6k
X-Gm-Message-State: AOJu0YwHfqLHA9vhPPRu3sc1BwyngSb8w0rDNlB1Ek7K81pJ0V4Noa6Q
	EqaApMv72kfr4Z0OmKzDyD7nZRz72alMfwS5SB7Xq8Z7UX7Z8tRRp2GxG+fFhhUFTstgzTEgRQo
	eghRwEuu1T6hwpizh2jfR7gXddvkAbil1R7LFrilsso7Fwfs5qyETPusS
X-Received: by 2002:a50:d75e:0:b0:56b:ed78:f58 with SMTP id i30-20020a50d75e000000b0056bed780f58mr1608942edj.33.1713299056993;
        Tue, 16 Apr 2024 13:24:16 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFmo4tzuqSbcGfH0UIulx3m6kCuO61LOXWnLcaBW0JT6ZfPmgxROQ3yI9/E6qupqtBpU4FIWQ==
X-Received: by 2002:a50:d75e:0:b0:56b:ed78:f58 with SMTP id i30-20020a50d75e000000b0056bed780f58mr1608936edj.33.1713299056688;
        Tue, 16 Apr 2024 13:24:16 -0700 (PDT)
Received: from thinky.redhat.com ([109.183.6.197])
        by smtp.gmail.com with ESMTPSA id fe1-20020a056402390100b005701df2ea98sm3655687edb.32.2024.04.16.13.24.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Apr 2024 13:24:16 -0700 (PDT)
From: Andrey Albershteyn <aalbersh@redhat.com>
To: cem@kernel.org,
	linux-xfs@vger.kernel.org
Cc: Andrey Albershteyn <aalbersh@redhat.com>,
	"Darrick J . Wong" <djwong@kernel.org>
Subject: [PATCH v2 3/4] xfs_scrub: don't call phase_end if phase_rusage was not initialized
Date: Tue, 16 Apr 2024 22:24:01 +0200
Message-ID: <20240416202402.724492-4-aalbersh@redhat.com>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20240416202402.724492-1-aalbersh@redhat.com>
References: <20240416202402.724492-1-aalbersh@redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

If unicrash_load() fails, all_pi can be used uninitialized in
phase_end(). Fix it by going to the unload: section if unicrash_load
fails and just go with unicrash_unload() (the is_service won't be
initialized here).

Signed-off-by: Andrey Albershteyn <aalbersh@redhat.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
---
 scrub/xfs_scrub.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/scrub/xfs_scrub.c b/scrub/xfs_scrub.c
index 752180d646ba..50565857ddd8 100644
--- a/scrub/xfs_scrub.c
+++ b/scrub/xfs_scrub.c
@@ -631,7 +631,7 @@ main(
 		fprintf(stderr,
 	_("%s: couldn't initialize Unicode library.\n"),
 				progname);
-		goto out;
+		goto out_unicrash;
 	}
 
 	pthread_mutex_init(&ctx.lock, NULL);
@@ -828,6 +828,7 @@ out:
 	phase_end(&all_pi, 0);
 	if (progress_fp)
 		fclose(progress_fp);
+out_unicrash:
 	unicrash_unload();
 
 	/*
-- 
2.42.0

