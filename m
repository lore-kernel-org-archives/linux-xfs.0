Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 787BF285044
	for <linux-xfs@vger.kernel.org>; Mon, 28 Jul 2025 20:31:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753734712; cv=none; b=pL6R5e4ILvZI5qVSubHksrzQsb4r6Gk/H6EnfYkYVLPkSTm66Qafed8hgjOdm6tek11CMpzoxHpSR7vznmdipe2zcFMzq3HXa17r41dvmOgji2031287PJUtvSJ10cIDLu3nlOtm7uGhtvpR0NIltV/5KeX4Px3M4Y8srIxTlJI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753734712; c=relaxed/simple;
	bh=4CpWmxTo2hLmGYDDA8Lp7aLfPM6yv41pw1diCtdXE1Q=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=Ct3JIgUSab6HkhsoaKUTlDEaIkPbwDsfcQ8o1YohfHB3C4LhKlFRTAYor49+LYvB8GGOMubymSGjILve5dE1WQDwmOhIjg9v2aKVnBgyQgKC781TjKSI4DhFCx6V4QEMKEuKOHdG6eNcuQsWsu+ty8tSZexHpjiQTsy7VnGoYSA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=HOqAAQOI; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="HOqAAQOI"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1753734710;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=UboS3qfLDBc+qi6WxzczFNpJ8WP4O5vMDtMD40JSNis=;
	b=HOqAAQOIjURFrb/PnEaRFoPpNZBLJq9T2wO5QPzWsPyYj6oHWEW2MKz8z+ejBX5vcfLBtY
	/u1s1kJXAaV3gKMus8+Xb1AVghdfKDucqXuETrDAux0mRIQtTlDnBavQmd6dLMYyW3WicY
	szL8US8qhGBqxF/4mhsh7pn4OVeOeAU=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-407-g3tPOLirNMqf5bdVz44fgw-1; Mon, 28 Jul 2025 16:31:49 -0400
X-MC-Unique: g3tPOLirNMqf5bdVz44fgw-1
X-Mimecast-MFC-AGG-ID: g3tPOLirNMqf5bdVz44fgw_1753734708
Received: by mail-ed1-f72.google.com with SMTP id 4fb4d7f45d1cf-607c239c7f0so4481279a12.3
        for <linux-xfs@vger.kernel.org>; Mon, 28 Jul 2025 13:31:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753734708; x=1754339508;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=UboS3qfLDBc+qi6WxzczFNpJ8WP4O5vMDtMD40JSNis=;
        b=hKgOpbEozRtE9fWJ7DTthaJ8TyN4aRejzwM/LPhSAtZ02QLSmYQQIGTwy2555Qrpli
         GiS3676OsPz9z4R2v6FZTGR1sKUKal2IcDmbJ8+jdEGURi/C4nJH+7qzOELxWlneRrbO
         1hm9Jhfpi+cNy3KqBsSwScrwOqLEQsWJYI4JnFAY8UP1gEzH1G2EEbYdvsiBATjTS4/z
         rs/YBNV+8uX8/l3LVBmNVwUCWfM6Cpy+yQ8divlViCi32+wdCxrOh5oOkRSYyhalkZr8
         8EghKP81prma71cwyH/B/5j8y1hdkTNmiHDGh56AmL32d9SdzHPhfB1ynYB4CWWe5hh3
         YiSg==
X-Forwarded-Encrypted: i=1; AJvYcCU+EeRoTB5HWovmo/gSN7BV31XGLHRz3ufh26SIf7wKxEDT4SgnKBj07INl1mdl+b/3Q5auBXGhZd8=@vger.kernel.org
X-Gm-Message-State: AOJu0YzEpwo03tRiHrhaMTADBjr5UO+455W9atFbtK9eUUFGMz03/eiM
	WeIlUsUpk13k0QNkBHe+o+EWnY47lU2EzpEHoYTCmnm+T/BxxpxF3vpsDpOoYRHbo3EJDh15jHG
	/x1UfeogA6Xmg0oqc/le29kC+Xbc8kbNCIWkSE1AIG3ORlSASHMTjZ5IlkEtG
X-Gm-Gg: ASbGncvbicKO1uF0PApKJqV6X5ASVigzdtngLhX57+ZDEePK4Sc4WyqIwtpl6C+lDfL
	eVsnuqCXgFCcLzWSFfcsyhRdO6VWZzOtCXXv1FWWBOFrExB3D9qHxv7TJMr5ht/+5lIHE6XTx0x
	ezRqWlNgu+cY42YUorNbExBGMSDFRLGkBzJhryLwR5jRXjtUhyC5JgUDzQPGhsJc8OZ5uKGSYiF
	KTydWnei+Z84YUlA+yOPbTY6GMoAaZEzvMlK2mS6nPhjEKSsqO/Jz1fK9Nj5XObn6YRbfCZXi4l
	4pjX5nVrMoC89dcELDO45nSfBgX3aeRwK0EUE22VAri97g==
X-Received: by 2002:a05:6402:348b:b0:615:41e5:cfda with SMTP id 4fb4d7f45d1cf-61541e5d4admr4626008a12.22.1753734707692;
        Mon, 28 Jul 2025 13:31:47 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IH7NbV31Mm8G/xBUFv0BekV/8LN0fAoNrs1I+/WZVoZ8FMzVU2xsjyF09u66gqCrOLV/426wA==
X-Received: by 2002:a05:6402:348b:b0:615:41e5:cfda with SMTP id 4fb4d7f45d1cf-61541e5d4admr4625990a12.22.1753734707333;
        Mon, 28 Jul 2025 13:31:47 -0700 (PDT)
Received: from [127.0.0.2] (ip-217-030-074-039.aim-net.cz. [217.30.74.39])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-615226558d3sm2730656a12.45.2025.07.28.13.31.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Jul 2025 13:31:47 -0700 (PDT)
From: Andrey Albershteyn <aalbersh@redhat.com>
X-Google-Original-From: Andrey Albershteyn <aalbersh@kernel.org>
Date: Mon, 28 Jul 2025 22:30:30 +0200
Subject: [PATCH RFC 26/29] xfs: fix scrub trace with null pointer in
 quotacheck
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250728-fsverity-v1-26-9e5443af0e34@kernel.org>
References: <20250728-fsverity-v1-0-9e5443af0e34@kernel.org>
In-Reply-To: <20250728-fsverity-v1-0-9e5443af0e34@kernel.org>
To: fsverity@lists.linux.dev, linux-fsdevel@vger.kernel.org, 
 linux-xfs@vger.kernel.org, david@fromorbit.com, djwong@kernel.org, 
 ebiggers@kernel.org, hch@lst.de
Cc: Andrey Albershteyn <aalbersh@kernel.org>
X-Mailer: b4 0.15-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=702; i=aalbersh@kernel.org;
 h=from:subject:message-id; bh=4CpWmxTo2hLmGYDDA8Lp7aLfPM6yv41pw1diCtdXE1Q=;
 b=owJ4nJvAy8zAJea2/JXEGuOHHIyn1ZIYMtrvSezXTDTT+zVlsmy5qlDdVOUb/ed2xV/6HHW5Q
 FG0P317j3dHKQuDGBeDrJgiyzppralJRVL5Rwxq5GHmsDKBDGHg4hSAiQhtYmSYI/6O+d+5oz0V
 /X9FVJIaW/pkrXe1Bp72jDwwPZPHJHkdwz+rn1bOZgXH6pQ0/Q6w/8g0vunFt+7gDf6g2SmWhhE
 nPzIDAMKNRVQ=
X-Developer-Key: i=aalbersh@kernel.org; a=openpgp;
 fpr=AE1B2A9562721A6FC4307C1F46A7EA18AC33E108

The quotacheck doesn't initialize sc->ip.

Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>
---
 fs/xfs/scrub/trace.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/scrub/trace.h b/fs/xfs/scrub/trace.h
index d7c4ced47c15..4368f08e91c6 100644
--- a/fs/xfs/scrub/trace.h
+++ b/fs/xfs/scrub/trace.h
@@ -479,7 +479,7 @@ DECLARE_EVENT_CLASS(xchk_dqiter_class,
 		__field(xfs_exntst_t, state)
 	),
 	TP_fast_assign(
-		__entry->dev = cursor->sc->ip->i_mount->m_super->s_dev;
+		__entry->dev = cursor->sc->mp->m_super->s_dev;
 		__entry->dqtype = cursor->dqtype;
 		__entry->ino = cursor->quota_ip->i_ino;
 		__entry->cur_id = cursor->id;

-- 
2.50.0

