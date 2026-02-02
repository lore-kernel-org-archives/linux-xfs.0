Received: from mail-pf1-f182.google.com (mail-pf1-f182.google.com [209.85.210.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC8B419E819
	for <linux-xfs@vger.kernel.org>; Mon,  2 Feb 2026 13:01:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770037266; cv=none; b=XpBith9cZE94Ijdz1oQclAsuWUW9bcA4perKIkLL6DJZNhAjUn13Gq5J3QlHShLIBEh/+DgbgpVSIWesItu4pRcMVkssXj3LvbXHmJrwBDXJ+RDlQf2uxU/TTZ3J5HvZmN/szqzxoBqZTCvXLa81Qvx7bMx5IZmBQd9UxApA3lU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770037266; c=relaxed/simple;
	bh=RP6S1ivaYAK6Fs5+VhDcT3M8k5FicM0n51mqRABDv7k=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=Bdi1CtzBcDdZaUoSrGBPPjJh9hj6O4EPjNpJ+YiMVRwIpmnbtVVthYec8X/Ma9Id9SsG47Jau8VOD+HJ3teOoNvBzOpDtX2j5/XT98ADYt+dzanrQcspE34EAehHsm1RYQ84DWYD3ovlyYTQerHHQPrA0A/eTQbz3k1JGiinjaQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=fddfBVP8; arc=none smtp.client-ip=209.85.210.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="fddfBVP8"
Received: by mail-pf1-f182.google.com with SMTP id d2e1a72fcca58-81f4c0e2b42so2488767b3a.1
        for <linux-xfs@vger.kernel.org>; Mon, 02 Feb 2026 05:01:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770037264; x=1770642064; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=n05z2JgZ055VI92yGkVjhSrgVttdCiXX4GMR4DMFah4=;
        b=fddfBVP8UIFQqZbOTkv2622/ujj7xN6O5ywbBO2It8D89SfN0y7G8RyqQvqDdBJV4O
         j40HB9YGKNcXxPk51dkhJAgvQmeoIRBf7nheI2FpJc33HvEh9Zu0UM+kMxHo3Y62wLny
         yd0Clmi9Q7jkMGgIi0DTp0J1/z+LXFt/2gF+K0dnmqH3exi5yPfuSaLw37jN+qiqAnJ2
         1hIQoJdYN5QNefGZd1kvZjn3S7LjjnbOXGV0XpqJVFB+8yrkQpE7HSiVvvGs3a66CSLg
         zWBjjy1yuOhoBqpVIokNPRY0tNE/VZoLiBBchRvtUiiP4xcVOy3CRajNufMQVQumoazB
         bVhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770037264; x=1770642064;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=n05z2JgZ055VI92yGkVjhSrgVttdCiXX4GMR4DMFah4=;
        b=jy5cF0TbIK0KPOqkqo37OBb18dkNwGl6Jm4Bhr4/O8bIkAbl7SoVcxM1MOWQEIlr+x
         hRPKS0xPHF7wBDjpx/aIfD9QLoUr+uF9oAnoKU/FZL5yYaTj1uTIo7r5PUXBvc5PAR/Q
         F4JmUZ44yts7pITWLbnu2h3Rzd42mslgxvX0JI0I4ZniOf4eGYAwe/dLOjmlCEVA2FzB
         I5o/zF+4e2x97Z/ZG2tQEPjA3gwofHxa4uGmW3qsGI6QPLopaWv5cZY4CrbwUKpoTcl9
         bGDZJRoRCPuzMBy172lPj3OoLJteVdxDBHAsB44Bx2ZsiSQnuMLmum9mR1NOmFnOuNdP
         mj6Q==
X-Forwarded-Encrypted: i=1; AJvYcCW2KEyhjjlPM3BZYrNth9U8JnVExMMklPkalqstpvu+L31CGiCYKVxm+Iq6FjwimJaJt+saYo81G6c=@vger.kernel.org
X-Gm-Message-State: AOJu0YyLYnKxKLJT9XW5bDGsjYah16qhW0H6ZoQL2wSNDr6XkZL/xJES
	dMqNkhgwJd3tk39q7bXDRw6/R7Vbzs7YzfKYfwyNZF9SaeX8pXF3bHCE
X-Gm-Gg: AZuq6aL/E8ouAqBzcofApeSB0I+bppe8yS23gvXIfcZDMJTMu36jExSmzY7bqltDOKo
	4MFhufg+uPpYt4ikMbKwHFd/CyxDzY+MkaPIMddftqwkq/BL+AktQThk07q/YwiNEclPv7smCxg
	9JmOsFBsD2442QgvWsPBaWs9Hog08+928J0/hQy4/wcFagb3aPX9nXc0SZWhYHknzF4mFyoYhq7
	WzWbEt460yN30GYQbMLvPJ9dV34oE2fQei7kRbcZkWPozHWleStUr6XcKyw5iHqqCUjR0mrVWYQ
	Jqjvq3KItI6eIICoYaRAEmd4sIe+Mbs8CPMfIevyIzQUjezTW4JQY5HrN/3YKEAchmggk3mwxuk
	AQg6Yu2M8zftIzp4ZGms5wgJ0N6hUnthAgL+PwbE1tjyPW+RIvkf5Rf92n0bliBDBSGmftqdx0G
	mIIUjnaN7+hqljiV1Kd8/MQKBN7E64WRM1gY3+9iOxedADbJYhL/KmwRUDj+yDULzhqPNVcAIXy
	FNqVYUNASKGPyvtUSKnFuAcwoGRmtW27fti30kedhS6xw==
X-Received: by 2002:a05:6a21:2d4a:b0:38b:e70c:63f5 with SMTP id adf61e73a8af0-392e0163a0cmr11067617637.70.1770037263916;
        Mon, 02 Feb 2026 05:01:03 -0800 (PST)
Received: from lorddaniel-VivoBook-ASUSLaptop-K3502ZA-S3502ZA.www.tendawifi.com ([14.139.108.62])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2a88b6ed92dsm149584745ad.93.2026.02.02.05.01.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Feb 2026 05:01:03 -0800 (PST)
From: Piyush Patle <piyushpatle228@gmail.com>
To: brauner@kernel.org
Cc: djwong@kernel.org,
	linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	syzbot+bd5ca596a01d01bfa083@syzkaller.appspotmail.com
Subject: [PATCH] iomap: handle iterator position advancing beyond current mapping
Date: Mon,  2 Feb 2026 18:30:44 +0530
Message-Id: <20260202130044.567989-1-piyushpatle228@gmail.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

syzbot reports a WARN_ON in iomap_iter_done() when iter->pos advances
past the end of the current iomap during buffered writes.

This happens when a write completes and updates iter->pos beyond the
mapped extent before a new iomap is obtained, violating the invariant
that iter->pos must lie within the active iomap range.

Detect this condition early and mark the mapping stale so the iterator
restarts with a fresh iomap covering the current position.

Fixes: a66191c590b3b58eaff05d2277971f854772bd5b ("iomap: tighten iterator state validation")
Tested-by: Piyush Patle <piyushpatle288@gmail.com>
Signed-off-by: Piyush Patle <piyushpatle228@gmail.com>
Reported-by: syzbot+bd5ca596a01d01bfa083@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?id=bd5ca596a01d01bfa083
---
 fs/iomap/iter.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/fs/iomap/iter.c b/fs/iomap/iter.c
index c04796f6e57f..466a12b0c094 100644
--- a/fs/iomap/iter.c
+++ b/fs/iomap/iter.c
@@ -111,6 +111,13 @@ int iomap_iter(struct iomap_iter *iter, const struct iomap_ops *ops)
 			       &iter->iomap, &iter->srcmap);
 	if (ret < 0)
 		return ret;
+	if (iter->iomap.length &&
+	    iter->iomap.offset + iter->iomap.length <= iter->pos) {
+		iter->iomap.flags |= IOMAP_F_STALE;
+		iomap_iter_reset_iomap(iter);
+		return 1;
+	}
+
 	iomap_iter_done(iter);
 	return 1;
 }
-- 
2.34.1

