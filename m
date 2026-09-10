Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 773214AB1CB
	for <linux-xfs@vger.kernel.org>; Thu, 10 Sep 2026 13:31:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789047094; cv=none; b=nDg1IZFU/WHKuM/RFvzQLM9LUkNq8YJNwU5pW4C8wbzjb5rmqKIP/inPdwB3Gw2rMVxinBSUFiNTxI5xzXqFalPpLZ+3qmPb0FDIfeSYhCV3p1S1/NkgOAm9Sd8jG7sISwgYeKS+50OlzNhz/sAyYvt5g50KtJm3bG6pPAkAgVE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789047094; c=relaxed/simple;
	bh=9aWxhq6aPkbkBA5Bm034rqeiube8V2OfXvl3w7mnWNc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=E133eszZTt5wpWV0xFAC8sINFQ8TAQjVeg8avdXObyuVXNc93sOCKy1rPb0PeEr/0emRWfsIcmn/bI/jA7geL48AwUHM19YfTS+J8MvozfnO+TafTZwDv5saXKNMsKpji7WYC/U2Enp7RRlOCyYriNeiLA0S7LKLIgXvI3Xs3ZY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=aoZrjCzy; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=bBR9se2t; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="aoZrjCzy";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="bBR9se2t"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1789047092;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=GrVnlBtAuLm+sbH5l8hpM9T8LdGQ5QcnQOqckPlEqwg=;
	b=aoZrjCzya6VwkK2vXPUhRmPINbdwV/3bNdpRkXvoBi0FwsSfTxgRuekbZMrs27Ut62WRfG
	HE1vz9ydHttw0NF00SKNzgKY5TKRHF7DCa2FCipLTIHWfv3mjO5kqXk48SRRjrW4ISNCcw
	yfUWYXsg/VRgClGvIqedtQXjYWuvQeY=
Received: from mail-pj1-f70.google.com (mail-pj1-f70.google.com
 [209.85.216.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-589-ECN3-zx4NtuGzjTfo3u_DA-1; Thu, 10 Sep 2026 09:31:31 -0400
X-MC-Unique: ECN3-zx4NtuGzjTfo3u_DA-1
X-Mimecast-MFC-AGG-ID: ECN3-zx4NtuGzjTfo3u_DA_1789047090
Received: by mail-pj1-f70.google.com with SMTP id 98e67ed59e1d1-3965ba1ba3eso2920005a91.2
        for <linux-xfs@vger.kernel.org>; Thu, 10 Sep 2026 06:31:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1789047090; x=1789651890; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=GrVnlBtAuLm+sbH5l8hpM9T8LdGQ5QcnQOqckPlEqwg=;
        b=bBR9se2tJfGo1fA5NEj6DkKfhAQXPH97nsmwaKkgIng/6M6t8dF8xMVH2DlidZncRg
         UmToKc2A32HGQ0hQhorsMlLt06aU7EEl41ige/lTEjFWojhby32Ss4n9q7VTnCjj20aC
         GMN2M+Lmmc1OBowM//pukyCQw/7KVUXSGMBSR0AWQjHcEQdhoHkpw0L+00QneG9X2073
         yryPDVUAv0Ru5tTumJxGvDVoFwsjPMyUO+rI1Z7m0LQc6VTdzcpXYQdAfsDIWp7VBaA4
         ENQYbBUZfeCKJ2jr7Hk9v0yPzG5b6W1JSuenhfj5n8amwrHvSUx0Au4RDL5+bOaslrIK
         /Pqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789047090; x=1789651890;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=GrVnlBtAuLm+sbH5l8hpM9T8LdGQ5QcnQOqckPlEqwg=;
        b=rn8xhEfSR9MGrt1f4lNDjx9Nl46zQt4dDIxH917zzynHgqls79C5b5gXHVFcwJeQJ5
         GVjD0d210CivvCYVumiIFtzfESZypaHIB+fYQ9a8lKEcnBpl7aUbpylsIvf+qFeqpXjl
         SIx3HL1yI0Yhs5I9aFCbSmmzo+op+xwr9W+o4TVhGMPYNXEbQkbJ6gCy2IGsBTE8Lufn
         xDg9oIxm6mreQrPnT+sYeSv3IC2FniXusGPUUWhOhYDij1kTbEPD+0tyLYVmO76LVv8t
         Y1j/SWp/OagG7ICVuhciKw7wEZtkchpvNUxhFJXG/zIKYdte6X2dclLPTjeVNVopLg6f
         cFxw==
X-Forwarded-Encrypted: i=1; AKwUvBwZ9DoW+6kyDR2WeX3FVmzgtrJiS2nIYYt26FZDouKHphY4qkSw8eyuCBk758BSv7FpWwyTT27AMoI=@vger.kernel.org
X-Gm-Message-State: AFuF++nGFgEZL38umzgaxXlwb7ipGec+NSBvC81BmT/+raxCk6QQ1BRl
	Xd9W9oRsQdFfQC9t5ubG8S2jz+s/FfDsFoLPcdZ52zFv59TTERfjDDvCVf6RVOdbtRL1RsSfCsa
	Z2Obwyw3Jj14sSRmdhQAxIUA+vuVM1Writ0/zgqrnTLigrVGiDi0gXuhGc8TXAg==
X-Gm-Gg: AYBFou2kHn7MMwoQ7DPCJyUpj0t6NKD3nNe+dOw2JzUKjIDJaPsNm6vYwnyw1lrQvSf
	tk2gKfOgPTRdV/VHJzZKMS0qZY/8cp64Gka7TpSccxPnsgDTDZQ9cPdWwATZuxA6a47MetXTK+Q
	bptOnsIqpZoqhH/UuH1pNrxlmhoK4pUKAICaGXfsWyn6zIKbHbJ27Fklq+nobP+Vky7bFbxhbz0
	cVU24OD88NV/IYDErlltZYHNJJ8xNlg6Ffv1GiSfqc7wTgV3ZUNnUV/5vUZsvolLEhCCbOz//81
	tol8my6GaeiBaY/OrNnJUuO0uufurm2y3LK82IcGIokb8AoUKx60508SjD+dBI+GvGEs6KfpfuO
	rRsYFmwFRFFvePJg6ifureEwY
X-Received: by 2002:a17:90b:384e:b0:366:3517:1aa2 with SMTP id 98e67ed59e1d1-39d707b291amr10389485a91.0.1789047089871;
        Thu, 10 Sep 2026 06:31:29 -0700 (PDT)
X-Received: by 2002:a17:90b:384e:b0:366:3517:1aa2 with SMTP id 98e67ed59e1d1-39d707b291amr10389329a91.0.1789047089066;
        Thu, 10 Sep 2026 06:31:29 -0700 (PDT)
Received: from kernel-devel.tail62cea.ts.net ([240d:1a:c0d:9f00:be24:11ff:fe35:71b3])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-39d7e77b1afsm5032004a91.5.2026.09.10.06.31.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Sep 2026 06:31:27 -0700 (PDT)
From: Shigeru Yoshida <syoshida@redhat.com>
To: Carlos Maiolino <cem@kernel.org>,
	Deepanshu Kartikey <kartikey406@gmail.com>,
	"Darrick J. Wong" <djwong@kernel.org>
Cc: Shigeru Yoshida <syoshida@redhat.com>,
	linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] xfs: fix double mutex_lock() call in xfs_ioc_health_monitor()
Date: Thu, 10 Sep 2026 22:29:55 +0900
Message-ID: <20260910132956.538828-1-syoshida@redhat.com>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Commit 4870da4f49ae ("xfs: take hm->lock in xfs_ioc_health_monitor()
before insert") intended to protect the __xfs_healthmon_insert() call
with hm->lock, but the second mutex operation was accidentally left as
mutex_lock() instead of mutex_unlock(), causing self-deadlock. Change
the second call to mutex_unlock() as originally intended.

Fixes: 4870da4f49ae ("xfs: take hm->lock in xfs_ioc_health_monitor() before insert")
Signed-off-by: Shigeru Yoshida <syoshida@redhat.com>
---
 fs/xfs/xfs_healthmon.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_healthmon.c b/fs/xfs/xfs_healthmon.c
index 6dc3f69d6798..c3749675ef19 100644
--- a/fs/xfs/xfs_healthmon.c
+++ b/fs/xfs/xfs_healthmon.c
@@ -1225,7 +1225,7 @@ xfs_ioc_health_monitor(
 	running_event->domain = XFS_HEALTHMON_MOUNT;
 	mutex_lock(&hm->lock);
 	__xfs_healthmon_insert(hm, INSERT_HEAD, running_event);
-	mutex_lock(&hm->lock);
+	mutex_unlock(&hm->lock);
 
 	/*
 	 * Preallocate the unmount event so that we can't fail to notify the
-- 
2.55.0

