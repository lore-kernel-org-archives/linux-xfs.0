Received: from mail-yw1-f180.google.com (mail-yw1-f180.google.com [209.85.128.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E9ED29E114
	for <linux-xfs@vger.kernel.org>; Wed, 18 Feb 2026 19:51:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771444295; cv=none; b=BmHfEgl17W10hV5bztbzWQdKZPisDWk1Q7RajnYuv4GHruBtwm4W9Qd5QYJB4JMINKXDj6XgjvMLb3sz9Y153WM2MxRPqhwznkB74t26iT9w9LvypzZNCVD1c/bl+XOYiZQqnn+ovGasvGAxkQxIQi9mRmOB+pq6LgIFh5WpoqM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771444295; c=relaxed/simple;
	bh=o14jQr3MK0WAom64yndMqkc/N3aQelcLXwWK3gZYnNc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=ltbSAOZUN4W+cAYKDxQsYsq6ouSp32fTXAJe5gC2MKjL8MSMlTiHwfivwx5K0Uh7q6mlCO63zuH/ZB+VsxWTLa/sJAWXoZPmZyl7EhycGFl9uNHJBP3730OjHNuWdDXhjg0m1PuLU5T+ygffTp5auJRZGWAd1M5Hj4eBi4UscLY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=hmJCZaoi; arc=none smtp.client-ip=209.85.128.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hmJCZaoi"
Received: by mail-yw1-f180.google.com with SMTP id 00721157ae682-797ab169454so2348347b3.3
        for <linux-xfs@vger.kernel.org>; Wed, 18 Feb 2026 11:51:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1771444293; x=1772049093; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=rhei553V0qQizYs5ft2+gJcj/d+TOeR7Ld/V97lPAMM=;
        b=hmJCZaoiY/zYuhlNFOuRi4cJ0Bo6D7bf0FwtLUkE0r9J87ZatltXW98o5yM0PL/LJg
         4jSEP447wXsJgobxv/4dtAH3CvUoHHayL78BxzUTHN90zFJtoKu6yyG3JrFaR2LzdNy1
         81WUL9OwXKB2sScZOX5GiRiboIvjlmPl9BPI1ABLZwEJ9gJFcbHIYNKKAGK5C/2EfKhT
         AEnaIOUNsUCb8msm1THZMlU9Lih+uU8OphgXlrhoAgyzLRxeyNNlZ0zvfNJgnqIx/Y2u
         t2MswnzI9m5rd1P4e8AtcDSSB2e0V80tuHUAZqqvmVpt46QS7DSfvtmrU/6w2Gy7H33Q
         1oEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771444293; x=1772049093;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rhei553V0qQizYs5ft2+gJcj/d+TOeR7Ld/V97lPAMM=;
        b=noqhFO0d69zFx790r23bl186nKUFDAzm5olh5Jd/hdnqFRxTp8My5dLJ4ouuImjYMa
         x0uNnfXCbZ9Y9l0jw05twpIaEIYExkT1MGil7pH+HBx2n33sm8zup1kjQCwwGqaXxrw9
         Xp4HizqcNjCvq2FO3Rya0XRDaEjYwEQm21hdbktuRVzbz7rlHK6G+AfIKzYxpOFo1jiK
         16oJ2kPq2WBalZvgGP8Fp5Y/EbduQGSzYEH5vAUWUgGz2Dt/QMTaMfWkLcJhXO2iTLH9
         ndhErFefxBDqJoxKbGax5T0lp/VedTxj+M4oY3kbXl7E5yFdZKyUvmB83fRfggn+7AwW
         SOkA==
X-Forwarded-Encrypted: i=1; AJvYcCXz5saGTT7Lod6Qpk8q+MGfOpdhbSW4FjOevBhnx7VGS/yR/GXjH6Era1/PdFd2ifTQ/EJ3/QjOyss=@vger.kernel.org
X-Gm-Message-State: AOJu0YzrtHn7L7OXFKJnDSIHuHAiJ09UbIFwSU0ahDWUoWuSSl45rRSV
	1C74yLCEBVPv9BHA2YYEBDc9F78PKgqCod7tAtsRNghKaNxXpLs9eSjJ
X-Gm-Gg: AZuq6aIbT9XcwOZdU/wqvw3a7lQa9D7o78CHqOIwd/ySTTyUBVPPFnu+jb8eAEG4KGM
	0K6clJ8VKwfbmL9RvXxT5rswPu3dV27LlmyFbOgvmnPmW1nSWp4+BGipiwq7U09zEQ1+sB9Kmlm
	HTd4gbnBlHFXLmdyZ/zvvhh8NRPcq7Y19CMCeLMkY33kRzbEiT+i2U0KOwiUthpedFFgiACCtPf
	j+s54IDNPDEnwyI75lJPi137+oR5ygc3PlXVDA+Z2+iW1OYq6hVesHFQmbV84CrXyM1ChohJA+2
	LspZ59fg8bS4CDZnZ6uosJFfZ+9zyujo65VByvK1UKh6jYpLlxP0fJcTUXXVqVUnzVPI+cckfPx
	dUHCKrF/oxwEDETL3A01Xw4XLj+kccEkikS+osKs3r+DdiPL/7HhbJZWzFgl6/DOd0dZAZt+zgI
	mlDzlVy/gZnhisM4n4jHM9JkEND2AW0bWo+UjYUiPYgRD6bh2Xk/heaGHbqT7Ht9h/4j1ro1F4s
	NspuKCYKBrSSqvP8lBYGCiMOEDJvV+WHjM2g96QDxc=
X-Received: by 2002:a05:690c:17:b0:794:8d58:cac0 with SMTP id 00721157ae682-797ac51634amr127805617b3.16.1771444293184;
        Wed, 18 Feb 2026 11:51:33 -0800 (PST)
Received: from tux ([2601:7c0:c37c:4c00:e3a8:26f7:7e08:88e1])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-7966c18b3desm121944387b3.14.2026.02.18.11.51.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Feb 2026 11:51:32 -0800 (PST)
From: Ethan Tidmore <ethantidmore06@gmail.com>
To: Carlos Maiolino <cem@kernel.org>,
	NeilBrown <neil@brown.name>
Cc: Christian Brauner <brauner@kernel.org>,
	linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Ethan Tidmore <ethantidmore06@gmail.com>
Subject: [PATCH] xfs: Fix error pointer dereference
Date: Wed, 18 Feb 2026 13:51:15 -0600
Message-ID: <20260218195115.14049-1-ethantidmore06@gmail.com>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The function try_lookup_noperm() can return an error pointer and is not
checked for one. Add checks for error pointer.

Detected by Smatch:
fs/xfs/scrub/orphanage.c:449 xrep_adoption_check_dcache() error: 
'd_child' dereferencing possible ERR_PTR()

fs/xfs/scrub/orphanage.c:485 xrep_adoption_zap_dcache() error: 
'd_child' dereferencing possible ERR_PTR()

Fixes: 06c567403ae5a ("Use try_lookup_noperm() instead of d_hash_and_lookup() outside of VFS")
Signed-off-by: Ethan Tidmore <ethantidmore06@gmail.com>
---
 fs/xfs/scrub/orphanage.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/scrub/orphanage.c b/fs/xfs/scrub/orphanage.c
index 52a108f6d5f4..cdb0f486f50c 100644
--- a/fs/xfs/scrub/orphanage.c
+++ b/fs/xfs/scrub/orphanage.c
@@ -442,7 +442,7 @@ xrep_adoption_check_dcache(
 		return 0;
 
 	d_child = try_lookup_noperm(&qname, d_orphanage);
-	if (d_child) {
+	if (!IS_ERR_OR_NULL(d_child)) {
 		trace_xrep_adoption_check_child(sc->mp, d_child);
 
 		if (d_is_positive(d_child)) {
@@ -479,7 +479,7 @@ xrep_adoption_zap_dcache(
 		return;
 
 	d_child = try_lookup_noperm(&qname, d_orphanage);
-	while (d_child != NULL) {
+	while (!IS_ERR_OR_NULL(d_child)) {
 		trace_xrep_adoption_invalidate_child(sc->mp, d_child);
 
 		ASSERT(d_is_negative(d_child));
-- 
2.53.0

