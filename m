Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=170.10.129.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795556354;
	b=F/nbbCkikag4tm38yIJPk8oa1OJQDz+dNliGacjOcMDtvRZhxXyl19e7e1FqEuYO0JPK
	 hiQfHjuptEq4a20NWGNZx53CeuNVBBx2Ru3BxNY+nNzc0Kd4kx+vG99Rc8T/s+n8sIX4C
	 mguwHv/0xpzL1iAeL8uNJKF7Y7sWSTgKqalituKRjmykT+aGjPCPAOkq1qerMDSWvJfJ4
	 StR2s974iLfq1hfcUuVfv1Zy9WhL+VFxOzV9W3IQ6Jzi+aH0IJ5Bp7dXVznAEghIXAOxS
	 ZvyG8gve8oDIH6vcSKpl4mXeUgTLgyrZctccCDBD5LVbNQ19wGIvcNhKyZiSaAqnJMA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795556354;
	h=DMARC-Filter:DKIM-Signature:Received:X-MC-Unique:
	 X-Mimecast-MFC-AGG-ID:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:X-Received:Received:From:To:Cc:
	 Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=LVgQqnpL+h00XyOg/o/KxfVMEUPlAZOKEJ7jJpUQWfk=;
	b=N+4Yk9G/lokoqsMz6zDgw0wViQJw36MF+ZJSQ3BhUCuwgdLOSPiELFOBPAXzcyrt1E2K
	 VBLqw6C9+iOeL/KLBIA0YDBj6ZgMneBNX394HdnQMTv3oN7LtX49903GioG6x4i/h2ZRg
	 nsSD4rab9iigJcJ8kae5e1Xty978H7rkJ8dOp8hUcrAyga9Z9MnKGjdqfoZHmQDGsHuTa
	 9mINzEK6P1X0Ua+jEAILIJsiNXbHiix6iyuFbvZGA3Ect0yknmCWzmH42XOPRl0nsE7Ig
	 hGmJQh0ueQekWpC182e+mStl30jbLTsbT6HLA3OqeCBGJIk/Z+MXmDzqzSNfUDRW03w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=redhat.com;
	spf=pass smtp.mailfrom=redhat.com;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=ATrI6JA9;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=google header.b=s7mSkOnT;
	arc=none smtp.remote-ip=170.10.129.124
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38857606A33B
	for <linux-xfs@vger.kernel.org>; Tue, 24 Nov 2026 21:39:13 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 38857606A33B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=ATrI6JA9;
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=google header.b=s7mSkOnT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1795556353;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=LVgQqnpL+h00XyOg/o/KxfVMEUPlAZOKEJ7jJpUQWfk=;
	b=ATrI6JA9ziiKpvhNw9fMlgbjoJb6avQKyIficQt+JWwNsv3voyJCwkGjhWRNsU7v0ZtyXz
	02FwpYIcAY+4xa7VVZb0d7pjGZ+PNEy5tzibcac0oz4l+KMXmk8jeTlT+SZjFB6cgf7ZC7
	yxA5P3/qceOydUFKtRdH3KcZ9pmWFBk=
Received: from mail-ot1-f72.google.com (mail-ot1-f72.google.com
 [209.85.210.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-575-mBDgeRi8O6CvNiUbn5WAEw-1; Tue, 24 Nov 2026 21:39:11 +0000
X-MC-Unique: mBDgeRi8O6CvNiUbn5WAEw-1
X-Mimecast-MFC-AGG-ID: mBDgeRi8O6CvNiUbn5WAEw_1795556350
Received: by mail-ot1-f72.google.com with SMTP id 46e09a7af769-8632a144987so2753685a34.2
        for <linux-xfs@vger.kernel.org>; Tue, 24 Nov 2026 13:39:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1795556350; x=1796161150; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=LVgQqnpL+h00XyOg/o/KxfVMEUPlAZOKEJ7jJpUQWfk=;
        b=s7mSkOnTdj/5QNW2UGA4kaWKJX+XiTzoaB3dfGsTUEttK1Fx0f5UajtDB0B/mlOkzK
         bPfPIRXcjbm9lXbxpIVm5BwLyb+cOM/2JNxzMVCERFt10K5d4/JBXXYqbYKkeagWkN69
         6m/+pDBDACoX32aaxRwmOmozIEbOSa5hpFrWKiQLNlW6dFA5XlEicJCBCNSSzl9gRnLV
         hUKnc5znp0QN7yFyr5pqkty80S1yEEsaZuW5reT1GBAQsH8WyGdmHBFH4DajeC3leL36
         /hPYa5PrXbyUj++3uZt7pmGTfbY3EHN6XwoPSENVMzsUBIUy0ZHRZ+t691rTA8PxXW8D
         bawQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795556350; x=1796161150;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=LVgQqnpL+h00XyOg/o/KxfVMEUPlAZOKEJ7jJpUQWfk=;
        b=XxRDzQf7BcNyC1pyQmSsrvPZvzyFyPlLIelQ7f8Ems2XkV6CRn3fhMbzGiUZdED+GH
         7UnCvGREIS0MeAyOVph0CceXjPC4Dd1rgeRCdRvf9MGMa4YYqA3wwnN2yBGI6RfMB96L
         g8+4myWQAq1k0NEglTUmaYZsrene2G5Jj/fyz8gPnt9MeD0+noOxakPHrmGQY3OExqWv
         SFRuEn91jIeiesPSds3NlcxNygOTpGZNQN2DjNg8nSmCJtBU9k1jj6WjLs6uGhSm445l
         A/K6No8RjtEyQdygZzuik+/d0UDn9GMq+WfDZPgFRt5qfeMYpsfUXq2o0Nwd5Lw2wjz/
         ZX7Q==
X-Gm-Message-State: APuU4Z8g40rqtEyfgpuNcBE3e6vZG9tsy/myEVssk36aqfxZCo4bE04j
	uGxS0hkjdjfJNK7B0bYlkiQTLoJRZnRK3UnnP05cQK7vZbaNt5XNRWQ8sgEmFl4yIh43GDZcvRq
	A4vTUn57kIBc2dBnddmXBSNou4toIEFezgzWSG9/Op391GQK28dUo7gn+Dc9KkwpMFeLLS84sWN
	iwqNQ+fnF0vrcyrIN0IzHnGBVwlNWrh7SNWsskdhX8bLM7
X-Gm-Gg: AZFdTZd45DUI2IVbb8l0FC3elw8npYRCkXtYa2QxZhw479ElTvz4/vd5EZojXOCuzet
	tGizi7wWFD3iixhHwuGV+a4y+Vm+jsHcSJDGyp8glP88NnJ8N7F6c47DAVmZAaA7r6UJ9HXGyWS
	N+83HW/7fzb0V8pm3gZYOshauNSTSyJpX/9AG9EmBIPErCO4kEtRSBIJpVfmM8jj8jISYgubYYQ
	cAQXJOTIL29kO+YdI/P136BXG6AlU6Q5b1H+lH30B0+kaubMnnLdARXvplRC9SuUzrRdtpYe/X7
	VUBD+06V+0N2DCT4gUvaxU3MNFkhuGP7JoUclBtH8FwHV+n0Xa4DjZtu+/S43ga0ZjgiI4oGTUa
	WdbH7r9Fk79B4/j/qbQWrccK49YrUZcosYZyD272+RoaTNVTy4C6xjMRUQOsb32iszystS7gz4B
	kQw0JokKgqfyDmAw==
X-Received: by 2002:a05:6830:4ac2:b0:862:cae6:db3d with SMTP id 46e09a7af769-863156703c7mr20570809a34.11.1795556350201;
        Tue, 24 Nov 2026 13:39:10 -0800 (PST)
X-Received: by 2002:a05:6830:4ac2:b0:862:cae6:db3d with SMTP id 46e09a7af769-863156703c7mr20570789a34.11.1795556349749;
        Tue, 24 Nov 2026 13:39:09 -0800 (PST)
Received: from big24.xxmyappdomainxx.com (174-20-5-40.mpls.qwest.net. [174.20.5.40])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-863168dde05sm12341738a34.13.2026.11.24.13.39.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Nov 2026 13:39:09 -0800 (PST)
From: Eric Sandeen <sandeen@redhat.com>
To: linux-xfs@vger.kernel.org
Cc: cem@kernel.org,
	Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH] xfs: pass proper leaf argument from xfs_rtrefcountbt_broot_realloc()
Date: Tue, 24 Nov 2026 15:39:06 -0600
Message-ID: <20261124213906.2130272-1-sandeen@redhat.com>
X-Mailer: git-send-email 2.56.1
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

xfs_rtrefcountbt_maxrecs() takes a third boolean "leaf" argument, but
the caller in xfs_rtrefcountbt_broot_realloc() passes level directly,
rather than "level == 0" as is done correctly in
xfs_rtrefcountbt_get_minrecs and xfs_rtrefcountbt_get_maxrecs.

Fix that.

Fixes: f0415af60f48 ("xfs: wire up a new metafile type for the realtime refcount")
Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---
 fs/xfs/libxfs/xfs_rtrefcount_btree.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/libxfs/xfs_rtrefcount_btree.c b/fs/xfs/libxfs/xfs_rtrefcount_btree.c
index 697f5e622685..18bc30897189 100644
--- a/fs/xfs/libxfs/xfs_rtrefcount_btree.c
+++ b/fs/xfs/libxfs/xfs_rtrefcount_btree.c
@@ -237,7 +237,8 @@ xfs_rtrefcountbt_broot_realloc(
 		 * realloc it and possibly move the node block pointers because
 		 * those are not butted up against the btree block header.
 		 */
-		old_numrecs = xfs_rtrefcountbt_maxrecs(mp, old_size, level);
+		old_numrecs = xfs_rtrefcountbt_maxrecs(mp, old_size,
+					level == 0);
 		broot = xfs_broot_realloc(ifp, new_size);
 		if (level > 0)
 			xfs_rtrefcountbt_move_ptrs(mp, broot, old_size,
-- 
2.56.1

