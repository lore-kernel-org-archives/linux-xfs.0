Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62CC7139D1F
	for <linux-xfs@vger.kernel.org>; Tue, 16 Apr 2024 20:29:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713299371; cv=none; b=RU6DkMiEDca+te18O9n2tYt1DBuNWvtlMB8SR7iq1F9iY/fHsvSoFJ4HwG1NIUrXd70lBJuY3DsdIIF3i6qU3vpS8XN9yRqFvGEqOHzfGrA2jgjYKoix0HjAsp0x9Q5Qa6gM8LcDpCeduPtsi57rBqbmMSJIKzsh96AFvqhheLY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713299371; c=relaxed/simple;
	bh=yQFOXcXEMnq6ykopaHtgZfuvGKRa/d4rd6SyRslsHm4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=QF3pf9mAKw+eoe4c7KrAAGxPKzwXQwp0ehtbajIvnXnVAggfo4mTW4DvnpQwVXWN8z0Ss5AU6bUrs0gdpWvWhRn7Uo8Fq/MBCK7iv4oLYQK4edTg6CNXL9S/EbBBcVtgeOJKDuLxSbwo3hYVDCm2T1bChy8nNTCS1lNUgRQL7/c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=LmiiO6Bu; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="LmiiO6Bu"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1713299369;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=dEETPJRpfpMn6oUJs+2QPjwfCICyGXCmcrWUgfsOMJE=;
	b=LmiiO6Bua/vsG818GdALfUN5QR66Q+8A7jF8gm1khw8ge2GxAzjSJf0bcAnYLpAAngJwzT
	7kEJi4m0GSkQMJ2hH1sF/R+gH0qRKFoYUdHu8GOPkZbj9GDk4+xXaBk+cviSugoZdM4DAS
	sVb13bLbHQzuX4qSi/WF8WOWUngEpJk=
Received: from mail-lj1-f197.google.com (mail-lj1-f197.google.com
 [209.85.208.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-557-CcFa0NBpNfSXY1Io8NSXPw-1; Tue, 16 Apr 2024 16:29:27 -0400
X-MC-Unique: CcFa0NBpNfSXY1Io8NSXPw-1
Received: by mail-lj1-f197.google.com with SMTP id 38308e7fff4ca-2d87f4226b3so37519391fa.0
        for <linux-xfs@vger.kernel.org>; Tue, 16 Apr 2024 13:29:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713299366; x=1713904166;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=dEETPJRpfpMn6oUJs+2QPjwfCICyGXCmcrWUgfsOMJE=;
        b=IRV7If7o/b9nq/r8zqSwh9vDRySD2xDfGpiFDLCWa5omkQoAyb51BZftiSGXd/73IY
         iHtdNpFgt9zgWOszZRhPbf0ZE6dxiFCfzkW5WuuIil5RtnJ/ASVWXjLEN1oWrgVYaGQk
         5Yb59ilrmyUw3NgDVTxebgWTmq68E0j0FgFv+Z8/Q5XN8GAADHG7eqzRPgH4+1so23GO
         PtRwZkPR8U+FNbH2exrCdJ14XLeL7Yg/R77zF3lmZfjli6qLnsiqovwPJWEZUJjYA1bM
         WtctDetVe8pRkd5kaQaPXgOGkHTt0tmxv3BNc8Ekdd4nrZ3NVsozspKFWKlqQ3I1W7kV
         Uykw==
X-Forwarded-Encrypted: i=1; AJvYcCVEOhhaKJ4mKitAhawbxpFFo4sMarPYUgeImKqTXdQcNgTHIaQO+TmZBZ5/PbgSQqnoA0kbm4bPUHscDnpIV60nXaeVQmaMpBTf
X-Gm-Message-State: AOJu0YwRn++GzYNg/l8RIrwalHI9SypS5qXXxYemszqdUBK90t8FywAk
	eiafa1JNTbxhiU6vgiCb8qTXy8LqCe+LolCkEltJsCApfffQBOiimlVIUbbZMFeXz3TKbE0uC4Y
	Aajqou49tFgBac1jI2ged5ERY2zAple9k+6WAcZwqQLuw3s5TEBngTPOr
X-Received: by 2002:a2e:bc14:0:b0:2d8:6e0b:8166 with SMTP id b20-20020a2ebc14000000b002d86e0b8166mr13085477ljf.53.1713299365972;
        Tue, 16 Apr 2024 13:29:25 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IE9edyAbKPj4hPmwFGp9u3puy/zMuyY888gKMHZVzspKUso2U7Eg765A33Vyo+3qSZ8gIj7hQ==
X-Received: by 2002:a2e:bc14:0:b0:2d8:6e0b:8166 with SMTP id b20-20020a2ebc14000000b002d86e0b8166mr13085454ljf.53.1713299365398;
        Tue, 16 Apr 2024 13:29:25 -0700 (PDT)
Received: from thinky.redhat.com ([109.183.6.197])
        by smtp.gmail.com with ESMTPSA id e21-20020a056402105500b0056e685b1d45sm6488423edu.87.2024.04.16.13.29.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Apr 2024 13:29:25 -0700 (PDT)
From: Andrey Albershteyn <aalbersh@redhat.com>
To: cem@kernel.org,
	linux-xfs@vger.kernel.org
Cc: djwong@kernel.org,
	hch@infradead.org,
	Andrey Albershteyn <aalbersh@redhat.com>
Subject: [PATCH 0/2] Refactoring from Coverity scan fixes
Date: Tue, 16 Apr 2024 22:28:40 +0200
Message-ID: <20240416202841.725706-2-aalbersh@redhat.com>
X-Mailer: git-send-email 2.42.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi all,

Just a two minor patches from feedback on Coverity fixes.

--
Andrey

Andrey Albershteyn (2):
  xfs_fsr: replace atoi() with strtol()
  xfs_db: add helper for flist_find_type for clearer field matching

 db/flist.c    | 59 ++++++++++++++++++++++++++++++++-------------------
 fsr/xfs_fsr.c | 23 +++++++++++++++++---
 2 files changed, 57 insertions(+), 25 deletions(-)

-- 
2.42.0

