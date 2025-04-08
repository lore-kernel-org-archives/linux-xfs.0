Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3B631DDA0C
	for <linux-xfs@vger.kernel.org>; Tue,  8 Apr 2025 10:49:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744109370; cv=none; b=hNN216Y5MBifqX4na8Ek+5NUzqds1AY4mfSMxu4G5/4dSdHfTmDnRNYExGzwoW2GmsrATxVCYdjR55AOi4tEAOZcqYNgeBKk4PBVsx5G7cO0dDaWvkd/GVagjzHglwSLlqpzntn3p+BbmWciIS46I3T7y3hohgDmBfzhZF3Tye0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744109370; c=relaxed/simple;
	bh=DWczXPzGhjmLnCewKu9mgh2aXxpRNcbkXiVhpwcO9oA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=dljki8FfRBDCXDD/suWN3VCx9TcDw5HxEidhcRAIXHqfklcpe3yb5Vih6/HRiiayoD02T5WII44q87lgSZt373XnjGB2qr7fDaxhqnH8JN5XNwdJnXcYMbgFkkzJdeCIqpjuw6dAoyNAFZrKKgStoq0s6n5rs84sLQ/ORhRABHo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=eqKRRFQE; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="eqKRRFQE"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1744109366;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=h/TwfjA1DGrhgcGk6vN8TIM/LavjjXWkekfDYXGhQyY=;
	b=eqKRRFQE/g42E4879CTpVTPTRPbT02rDZ3NsABxUV8H8QXDcd9x1ezej/mSKYyzN3M/hKb
	PxhIXWYDBGNW43cvzuifhNjcHHwe2I7BXTwNeEZ26DqfRvRmfKcDKoCsIlDqqanaw42czU
	rkx6HmJaCVgz09HqrJ2/Sthr9nmjdMA=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-108-bE-tya7yPb2TfW2HJWJuzQ-1; Tue, 08 Apr 2025 06:49:25 -0400
X-MC-Unique: bE-tya7yPb2TfW2HJWJuzQ-1
X-Mimecast-MFC-AGG-ID: bE-tya7yPb2TfW2HJWJuzQ_1744109364
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-399744f742bso1484319f8f.1
        for <linux-xfs@vger.kernel.org>; Tue, 08 Apr 2025 03:49:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744109364; x=1744714164;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=h/TwfjA1DGrhgcGk6vN8TIM/LavjjXWkekfDYXGhQyY=;
        b=jgcguHC36X7GY6cfC/AuSLloXom4pbh3pBUv1QQfaJwBd9SkRmTbu2JqvhRYxHW/gE
         IOojGtSTkFyxr6EYABQW3nobmMco1FVxg0ttlZDdatuqZr8iA8qkHldvlspBzd3f3SJK
         TfceyxU2MzRTbMZIyCLaNcGl9nU9RU/JSzQEGMs6cTE+f3sobVB4zdr9BONGkErO6H6k
         GSdEFnzpyXBMx+jpLyj3WI2JFxJNUTT7OiNLUvSNSpNxzOjlwEFGOGR3kMvrKVeDwMt+
         GjqRGCNCO4OFsm6Qu8jqai6WM/rk1V8sTafrPM/kM0dAhSFy3l3f+Fchq6zeqloteCOC
         fMhg==
X-Gm-Message-State: AOJu0Yyw0TTMaSjpHam9Ifg2w6xXj+jHBS46cOXckyDXJbklgGXHhGo1
	7zs3Ey0YWqJLxy6xcdqjiML/XLTiOyi1G82XssEhULsiIpAIlmDMK1hsQdqOZ7rvhH9tKACNHeA
	wG/4+j+Ugc/x5k4ODWg4rZPOYqXryTXdTqkBcrM+6MZ32EKAORWpAKfLsMrga375WkqybGWSipC
	xYs/LVnE9FtWPIZDH8OZQ/EhJzeHNc/yucvYkagxUR
X-Gm-Gg: ASbGncvx6kT2+O67uGDI+idOcSmcNcWVz8cyRRHAotkqFL0WK2Yl7NkK2iz2+ieWCP9
	ymxwMjiGqTkz5BiVpOiYs0u/SGLod7OQNaQJe+6iu84636jwG+TEkXI/htAxbA72nDdNJ9mnkjr
	uoy7HhK1Hp3FXDDuJa1dGrVf1wUI9mhuS5xx74P2MBBTuGPophUzR07GqP1W1qbmkkWVlpNRT8B
	S/K8jQzf3UADQSJLueI5n2VvvS/4VwcSVVteDQKaHlm60rdwFogQ0HeRZsjnJqQhftO7CXuu3yx
	oJv1TiGXM8SWHZU6uLvN4ygLFojAHiM5SBkjcREspo34Y+56mg==
X-Received: by 2002:a05:6000:42c5:b0:39c:1258:2dc9 with SMTP id ffacd0b85a97d-39d6fd07bf6mr6728891f8f.58.1744109363975;
        Tue, 08 Apr 2025 03:49:23 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHMyJ1SQhrIjGbjTmmlYzL1OZ2k2fIj2G/dDwzEZmwvMxhXUYn9yT8S+TfeEZ5Nm2mKGZcAWA==
X-Received: by 2002:a05:6000:42c5:b0:39c:1258:2dc9 with SMTP id ffacd0b85a97d-39d6fd07bf6mr6728881f8f.58.1744109363626;
        Tue, 08 Apr 2025 03:49:23 -0700 (PDT)
Received: from thinky.redhat.com (ip-217-030-074-039.aim-net.cz. [217.30.74.39])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-43f11eb0511sm12775625e9.1.2025.04.08.03.49.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Apr 2025 03:49:23 -0700 (PDT)
From: Andrey Albershteyn <aalbersh@redhat.com>
X-Google-Original-From: Andrey Albershteyn <aalbersh@kernel.org>
To: linux-xfs@vger.kernel.org
Cc: djwong@kernel.org,
	Andrey Albershteyn <aalbersh@kernel.org>
Subject: [PATCH] gitignore: update gitignore with python scripts
Date: Tue,  8 Apr 2025 12:48:40 +0200
Message-ID: <20250408104839.449132-2-aalbersh@kernel.org>
X-Mailer: git-send-email 2.47.2
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Now as these scripts are generated with gettext.py support they have
.py extension. Add them to gitignore instead of old ones together
with newly added gettext.py

Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>
---
 .gitignore | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/.gitignore b/.gitignore
index 5d971200d5bf..6867d669c93d 100644
--- a/.gitignore
+++ b/.gitignore
@@ -65,13 +65,13 @@ cscope.*
 /mdrestore/xfs_mdrestore
 /mkfs/fstyp
 /mkfs/mkfs.xfs
-/mkfs/xfs_protofile
+/mkfs/xfs_protofile.py
 /quota/xfs_quota
 /repair/xfs_repair
 /rtcp/xfs_rtcp
 /spaceman/xfs_spaceman
 /scrub/xfs_scrub
-/scrub/xfs_scrub_all
+/scrub/xfs_scrub_all.py
 /scrub/xfs_scrub_all.timer
 /scrub/xfs_scrub_fail
 /scrub/*.cron
@@ -81,6 +81,7 @@ cscope.*
 /libfrog/crc32selftest
 /libfrog/crc32table.h
 /libfrog/gen_crc32table
+/libfrog/gettext.py
 
 # docs
 /man/man8/mkfs.xfs.8
-- 
2.47.2

