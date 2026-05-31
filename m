Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1986E3AC00
	for <linux-xfs@vger.kernel.org>; Sun, 31 May 2026 19:45:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780256760; cv=none; b=Bf6OQOmrjbV5v/IoTrsYMS5V7bbWZlGF1rqYZ6NzvAqRVDTmAHlsvV13O5LoqSZZB7Xbs/qp5UeegphoL/6xcoZHuX4qxMq0RuIQX1B2nFVV4tbuxbj7C5b0af4ED02eHDL8Cz2YOZQZFOKhyzWMCvEmVBUZxrtbLfTIuKjj/Xw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780256760; c=relaxed/simple;
	bh=1tB3kX1gxlJyoBzABdMwFNTu3Ke/NjWR3py/3pzYh+Y=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=WvemsNg8g7lK9fYDy/wa4YL+Ru9XQw5Dabs8apRVeeaRSARQFAOMPt11vyBru0DFyyTc561pawOoJ1wQiAvTrHKBDUO29Ula7eAFwDmaqc740rdlQx5rFDevgAjEyy8CZDgH2whZXTzb5eyoKk6i1dxhvHxCi+kxoWa97ene6FM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=smile.fr; spf=pass smtp.mailfrom=smile.fr; dkim=pass (1024-bit key) header.d=smile.fr header.i=@smile.fr header.b=n+94S3Vf; arc=none smtp.client-ip=209.85.128.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=smile.fr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=smile.fr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=smile.fr header.i=@smile.fr header.b="n+94S3Vf"
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-49048e043e5so73691065e9.1
        for <linux-xfs@vger.kernel.org>; Sun, 31 May 2026 12:45:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=smile.fr; s=google; t=1780256757; x=1780861557; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=fwmMYcUNyOrjpk0iGZeW8Te3Zku+X3AwG465ob8KzzU=;
        b=n+94S3VfXSoTz7yV9ReFxXughhb5iNoFquSWV+1PBcPWYi5R5nhfWP+W1Jq+3yeQWf
         ZaGGHj6Q/RkUVmpKt+yh7YPQs8WZOTLxSG5MtFCnuAqqBpwG38xgqH8aVCDaXTp8yAsK
         yAKYqXsFruWEzy8MdbXZZMDBhqRRMV/F3fDl8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780256757; x=1780861557;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fwmMYcUNyOrjpk0iGZeW8Te3Zku+X3AwG465ob8KzzU=;
        b=smW3LdeutARzRlY/Vn1qDtIndHmmY+hRHBIiwA/hgM6UBSOwSB0pcYBsnY68lfA8ZH
         43uhA+U1HNY6B8V1acEMk+IeUfZxTswcHlhGC4cBVGmTpg37Rzpz1HtX97GWd2P6YzJw
         wFNvhuFvpd+E4nHu6d7CmJeQUPpRMDoLrS3k/5kxfYsflHCwJrynpcNpqUdSc+mk9Kv6
         qWiQJp2JxHsqJorMj6NkzxS/fht5Rd3G3sUixe9xXflvZ0+zHT1BL2d47DOfjSF8TtWd
         OZvbiFthtpCk2KAE8IRq8FiE2afo/WTdzgyrf2ITMLo/VCBIElYoIGyMNSzHRBqS1PAa
         4fTw==
X-Gm-Message-State: AOJu0YwwXDAbr2yks+oh+4WbGHVMvqhJRWUuQUHkulelo/hal87yy8RX
	ZVTxcf279tWMbNdb5oBAl9EUA+0aSbOw/eGmRp3yMTIkfRtoGDxB+DOYotWwpNd8eW0yBXZEbP4
	2yYAy
X-Gm-Gg: Acq92OGv2nLUx0zR0pR6s1YhvH8mczz1TVsYRyrzBi938JpQ3yaR58T6k2kjmbD9Sda
	FuQaxzyS3nPZCuTwVVyyC58BLzKHikcCAjCkyNOrHloCKHOWk9eVfOdkmzadIooq4468sKMpN99
	v+XXRfKkPDoExcXh3tGr1nEeGH96B0hAYarsCHqYyvECzm0MpVg5Hgrso/5VHFoeKJFqYxsMAm3
	mKzGtNConG4othkeeI/TAuMZ03JMX3SuXdpoDhIH8+o7fjIYJ3Dbeb5dUNgh6XdNV6kH7fpl7T3
	WGYy01mym0/mgRYKahgkrgsW3SQI/51I2LLufr0DE9DhvS25NIe3szsZlKVZWy2za4/uGQUlPXb
	iue8c+OVIdtiKTi6aYtSwRix165aoIZs5OE7X7OUY7o8JINQSKURjNuE65pNUdJ2gPjAb37CDWf
	/WTAi2YFqHKuQJxxZzwRurJNOJhR1fxvoqsAHTPYVZ2YKzLTFHam3gn7er4j7KGWiiZOMXEoc5A
	N5QVq9uRUMqimgfrKWWFBq5ywjqtdOVB7dH
X-Received: by 2002:a05:600c:1d86:b0:488:8bdd:cfcc with SMTP id 5b1f17b1804b1-490a28ab3d7mr163304275e9.0.1780256757407;
        Sun, 31 May 2026 12:45:57 -0700 (PDT)
Received: from P-NTS-Evian.home (2a01cb0594a2a2002ad9827a59cb148a.ipv6.abo.wanadoo.fr. [2a01:cb05:94a2:a200:2ad9:827a:59cb:148a])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-490aab4f87esm1192745e9.22.2026.05.31.12.45.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 31 May 2026 12:45:57 -0700 (PDT)
From: Romain Naour <romain.naour@smile.fr>
To: linux-xfs@vger.kernel.org
Cc: Romain Naour <romain.naour@smile.fr>
Subject: [PATCH] xfsprogs: include/buildrules: fix ltdep
Date: Sun, 31 May 2026 21:45:53 +0200
Message-ID: <20260531194553.1378795-1-romain.naour@smile.fr>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Our CI uses "/builds/buildroot.org/buildroot" as build directory.
Unlikely the xfsprogs build system misbehave when a directory in
the path contain ".o".

While generating .ltdep, the sed command used to convert object file
(.o) to libtool object (.lo) replace buildroot.org by buildroot.lorg.

  .ltdep: $(CFILES) $(HFILES)
    $(Q)$(MAKEDEP) $(CFILES) | $(SED) -e 's,^\([^:]*\)\.o,\1.lo,' > .ltdep

Building libfrog
    [CC]     gen_crc32table
    [GENERATE] crc32table.h
gmake[4]: *** No rule to make target '/builds/buildroot.lorg/buildroot/test-output/TestXfs/host/include/urcu.h', needed by 'avl64.lo'.  Stop.

Update the sed command to avoid this effect.

Fixes:
https://gitlab.com/buildroot.org/buildroot/-/jobs/14607335648

Signed-off-by: Romain Naour <romain.naour@smile.fr>
---
 include/buildrules | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/buildrules b/include/buildrules
index 871e92db..3fabbe5a 100644
--- a/include/buildrules
+++ b/include/buildrules
@@ -140,7 +140,7 @@ rmltdep:
 	$(Q)rm -f .ltdep
 
 .ltdep: $(CFILES) $(HFILES)
-	$(Q)$(MAKEDEP) $(CFILES) | $(SED) -e 's,^\([^:]*\)\.o,\1.lo,' > .ltdep
+	$(Q)$(MAKEDEP) $(CFILES) | $(SED) -e 's,^\([^:]*\)\.o:,\1.lo:,' > .ltdep
 
 depend: rmdep .dep
 
-- 
2.54.0

