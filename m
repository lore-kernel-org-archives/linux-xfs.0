Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE4A4148316
	for <linux-xfs@vger.kernel.org>; Fri,  4 Oct 2024 11:57:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728043036; cv=none; b=JFlzjPGSNSbOQdUwu1+WHf6K9SOzv63pg4mmRDSGkJJqe8hM/M+eqbpEv5rSeG/sq01i+h1sUGkXBBILvJ7DO50HOaal6v4xE/5G5dDWWWqaJbtq6OPfB7HGO2Rpn/MpbzMC3BPG4pLuhNToskkfb5RDWjJlj1zp31B7Dkamwkw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728043036; c=relaxed/simple;
	bh=0ul9v+B3UApWP++wwXhDXQIMaA12/0adKopZLQChiUA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bSRiCdoqV90+VPiz73/K9Loi7qaaUA2FsX33sfdUHJ6ykurOhlBQzutrodjGB1PoniL0W/l3gGtsxSPZR3wsylh7ksTkVC6W+vQ4nk3PzpfGpQFQprG2KIFRhm5Odyf51V5guOuh3Wgm2DT5zWRy/DT+JQnz6ZrpO5hQBILYuLU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=INcMwADS; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="INcMwADS"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1728043033;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=EVg8YE2k3AR6L6CmHT2x5AkJdw/4e+8Fy+vN87hK8sA=;
	b=INcMwADSeGWO7zjZ7Bij686IHXfHScAUAk/eEkrm10Y5pIfMpVhblzuRWrSOqx/E2QHDU2
	ebqksZmcX+TaOlh2MFU6zPiXCYRm3brJymXQQZbaeQacOw7d7nZqzlrPwjAqNjOq9KY9lc
	dSb8UCPvhVAHjT0V299JKLWYhQ22988=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-448-vuv-Mx3vNJioAISOZp0ARg-1; Fri, 04 Oct 2024 07:57:12 -0400
X-MC-Unique: vuv-Mx3vNJioAISOZp0ARg-1
Received: by mail-ej1-f71.google.com with SMTP id a640c23a62f3a-a990fc9777eso144048966b.0
        for <linux-xfs@vger.kernel.org>; Fri, 04 Oct 2024 04:57:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728043031; x=1728647831;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=EVg8YE2k3AR6L6CmHT2x5AkJdw/4e+8Fy+vN87hK8sA=;
        b=gVhKGPjf1C2wpdH0zEqdbOre4KWxbuJFZr4X1ZQ3yDt5iZ6jVvsrUloefXulRGR/D9
         izHadztbrrwfGqBZX5Gr5Pho+9A3b/+rhszwQaRGGlPCe58l2sZnu1Lc/9nR8t07ENbT
         1+YKOYzaorUxvTWq+pTsO+Dq+gWYJsoF6LBIeL83o0Vxr66Zr706OX/z9hqnzOvvlxOt
         P6FQsNZm1DiXWvUyWdQbrUiK6p7h5UTkI1ujE7TBf1YEHY4o33Nk0daR326EnDfvcR+c
         cNf/IxLGTuBhUbh8Hl7x9t6WyB0F8+UG5AFfgm7HZgWJq127O/5YsVGobT6g7iZBvsyy
         7Buw==
X-Gm-Message-State: AOJu0YzH400lTCF0JFYc3nP6KQyLr0Qs6x3oqcMieWPEuz1OXl5s02xB
	NpONas/6+DQsQa3huZkqyMI1E3VDAh1en6CNbEt3fnqccqXq7U02iUmy/T0ZzTEIY3Vc5SfQ1hX
	nf4IvxaB4LAoWJGIJnbOlrt78Jeh1Q6NGFbN8cD0s6q4kqDue4S/2oSgra7dqWITW8ovrELlStL
	5O+9LNwJfpM1C+A8lHhEVQuETopjPN6KcMv9dsaafh
X-Received: by 2002:a17:907:3f18:b0:a6f:593f:d336 with SMTP id a640c23a62f3a-a991bd13582mr262675566b.11.1728043031023;
        Fri, 04 Oct 2024 04:57:11 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGHfcg8yu/3aWkk9m955FCSOcO9VXXU7K2RRYC5arA5iyPvgy5OZjPT+rV06d51vfB7bhDfpQ==
X-Received: by 2002:a17:907:3f18:b0:a6f:593f:d336 with SMTP id a640c23a62f3a-a991bd13582mr262673766b.11.1728043030655;
        Fri, 04 Oct 2024 04:57:10 -0700 (PDT)
Received: from thinky.redhat.com (ip-217-030-065-002.aim-net.cz. [217.30.65.2])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a99102a64a5sm216734566b.76.2024.10.04.04.57.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Oct 2024 04:57:10 -0700 (PDT)
From: Andrey Albershteyn <aalbersh@redhat.com>
To: linux-xfs@vger.kernel.org
Cc: aalbersh@kernel.org,
	Andrey Albershteyn <aalbersh@redhat.com>,
	"Darrick J . Wong" <djwong@kernel.org>
Subject: [PATCH v4 1/2] xfsprogs: fix permissions on files installed by libtoolize
Date: Fri,  4 Oct 2024 13:57:03 +0200
Message-ID: <20241004115704.2105777-2-aalbersh@redhat.com>
X-Mailer: git-send-email 2.44.1
In-Reply-To: <20241004115704.2105777-1-aalbersh@redhat.com>
References: <20241004115704.2105777-1-aalbersh@redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Libtoolize installs some set of AUX files from its system package.
Not all distributions have the same permissions set on these files.
For example, read-only libtoolize system package will copy those
files without write permissions. This causes build to fail as next
line copies ./include/install-sh over ./install-sh which is not
writable.

Fix this by setting permission explicitly on files copied by
libtoolize.

Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Andrey Albershteyn <aalbersh@redhat.com>
---
 Makefile | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/Makefile b/Makefile
index 4e768526c6fe..c40728d9a455 100644
--- a/Makefile
+++ b/Makefile
@@ -109,6 +109,9 @@ endif
 
 configure: configure.ac
 	libtoolize -c -i -f
+	chmod 755 config.guess config.sub install-sh
+	chmod 644 ltmain.sh m4/libtool.m4 m4/ltoptions.m4 m4/ltsugar.m4 \
+		m4/ltversion.m4 m4/lt~obsolete.m4
 	cp include/install-sh .
 	aclocal -I m4
 	autoconf
-- 
2.44.1

