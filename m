Received: from mail-pg1-f179.google.com (mail-pg1-f179.google.com [209.85.215.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C00C33F589
	for <linux-xfs@vger.kernel.org>; Sun,  6 Sep 2026 14:46:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788706004; cv=none; b=WxF/Sx6HKknmZkOTLGHQ6/yvhzQy/Ea/LdRMGrN2vDQIVppB4YajMH7q65gUDoUZ6KveYzv/NArqqT7HM0VDGu1avBqyYbWaKM9yVQ1tSBc0/ViZf8WBFVjEbkCU5+HEKirTaXLeZXV/iji4hg/YCLBw6E5bcLiVf6tfeJnovdc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788706004; c=relaxed/simple;
	bh=AkmsPhY2nykw/qElY1cGWx8CQD8WQMtwPEwX3DiduLA=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=V0SUvy3WJ7mCzbrtUMznWaIROePbjaGQhLsDNQjNtGJHmRzVs5zhuqtIkMQk1U6KpoRFIO5kyCqDHNos3qgZYfhP9al1S99kDCPyup+TcUmfd3kIIx1T6gqurzmAiBjKXAwryG3f9a4kx6wuf8uJ+wRs7w3tUlZ1+8Ds4LtaQv4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=soUMJy+/; arc=none smtp.client-ip=209.85.215.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="soUMJy+/"
Received: by mail-pg1-f179.google.com with SMTP id 41be03b00d2f7-cc1c73645a1so2006127a12.1
        for <linux-xfs@vger.kernel.org>; Sun, 06 Sep 2026 07:46:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788706003; x=1789310803; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=I/NA40pHs0mAdUAHdhoal9SiaLl11w46qTtr/hZ4eJU=;
        b=soUMJy+/Bmn503vigVXy7VIsxAQIsXViLhuRIIXzsR5ZEHFp28hVtPq2eg/Dw9LQhg
         hRW3g41vncs14wY8iGd6ErP+NWQT0px+wm/p0U7w3XUcgym97jlKu3DtPk/3GIvFOsJz
         /e3x/jAtn1SP4zL1xprkBzdDebotthlN9IXCpZvpVFr1NvNrCf3KFmE8Fsa6I9cxDiA/
         e/CTs+fA2ISbOkETMX99bc4uV84pkMvXbS1GHfMutG3xODKO3axc4kV/WkGR1ZkPivae
         UJVmBwr0jgNPn1r4pOALNKWOe4sF2dNom/1pw2HNLwPqBkluDxR1obRZ/MJbDD0ZnUR+
         p7Kg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788706003; x=1789310803;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=I/NA40pHs0mAdUAHdhoal9SiaLl11w46qTtr/hZ4eJU=;
        b=hlW/7pMBkw844YulLUoJeWlWn3l4zlquuAysZGiNgdgMcZxdXwpY4G75MBeCre7xc+
         +EnwYGMdyMd8gvI6VrUH6cS2+RkqKyFPIIE0z/2YafscWm69ZdLJxBvR+z89ZUulMwSR
         Ric2eLGpsrxxfrFT5yZvJxtRMJAPvkU7WgotrrBefxHk/wDr+QoZgOMPMvuqrNk4m1YG
         es/v2iJPL7gw6DraiPRUvzaCfUomKMZyGpDh7jj6+mN8weGZtb5vrHraCuZrI+S2lJY1
         iNIfoUK0ZgZjyKNWyvtcEH6o12ZitFZLGW5LQz07EcBB3ua9ShM7CO3xe0NwlMFVcmZn
         WJsA==
X-Gm-Message-State: AFuF++lJNeywH2XRruCllGSOrb6HihWK5bOdraTIphm15qtDe0Z3CCkL
	j1cz3JhetbCSp9RlvDms+i5JSAtZKa4WDIq7HpjFT53GcnM3GF7kiw6V
X-Gm-Gg: AYBFou2EsQTUB4pYjJMqFTtEqNS2v/3kcCJwLFbm8a8fxwdu/qajOxwMNx628wBHyMB
	liQiotWTqdVanlah3PkHUls1iSVXTH2XjUFFvX8cJlGLJZn0+09g59z2M1MR2GBxG0Xo6HSqqOl
	w1p9IKiUJ21U8fqwhQ6oTkW8wb1zkE3Q9jjzVUFoj5F6C3KGPfsoNdb9Z9Tmn/agZT9iRPAo1cS
	ld2TYgCvlIAcoD3qHWYF0BNINw/QjSGx46uRuupxaFz8jzAwgKn9zhlak6SXlUvqkJHHBEKrFaM
	loJyXyOIzmje6fBKhPVdJ7bRBkgbN6abMApEJYbG6oFDx9P0YUSi62GQF7RojdQboZTE5Z+vSAV
	+lDoG/wKrbf70+rqR1CQYzSXbh6HAPxGj5DEuE/J7GkkZr8nkEPQAIm38UzYJlGH6RKp3k3d8Dt
	rFbdH/K8Oq4jY6ZmQQAA7Zr+/OL8XpX9jw6qJ6lhJxKZp0t66QObcX+meQMzJyzGCe6xmAld2K1
	zukvh2xiB0SnU7sqKfrcTl2HxSonUSJrVhw
X-Received: by 2002:a17:90b:560e:b0:38e:2e86:ed02 with SMTP id 98e67ed59e1d1-39b261e7931mr27948816a91.14.1788706002833;
        Sun, 06 Sep 2026 07:46:42 -0700 (PDT)
Received: from deepanshu.. ([2405:201:682f:383f:111b:b40c:2146:f791])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-39b08d0d7e8sm22758239a91.16.2026.09.06.07.46.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 06 Sep 2026 07:46:41 -0700 (PDT)
From: Deepanshu Kartikey <kartikey406@gmail.com>
To: cem@kernel.org,
	djwong@kernel.org
Cc: linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Deepanshu Kartikey <kartikey406@gmail.com>,
	syzbot+ccdf3469f5f653bff7ac@syzkaller.appspotmail.com
Subject: [PATCH] xfs: take hm->lock in xfs_ioc_health_monitor() before insert
Date: Sun,  6 Sep 2026 20:16:29 +0530
Message-Id: <20260906144629.17009-1-kartikey406@gmail.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

__xfs_healthmon_insert() asserts that hm->lock is held
(lockdep_assert_held), but xfs_ioc_health_monitor() called it right
after allocating hm, before ever taking the lock, triggering a
lockdep warning.

Take hm->lock around the call.

Fixes: b3a289a2a9397 ("xfs: create event queuing, formatting, and discovery infrastructure")
Reported-by: syzbot+ccdf3469f5f653bff7ac@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=ccdf3469f5f653bff7ac
Signed-off-by: Deepanshu Kartikey <kartikey406@gmail.com>
---
 fs/xfs/xfs_healthmon.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/xfs/xfs_healthmon.c b/fs/xfs/xfs_healthmon.c
index 3ae5f4496ad1..2f762f90d329 100644
--- a/fs/xfs/xfs_healthmon.c
+++ b/fs/xfs/xfs_healthmon.c
@@ -1219,7 +1219,9 @@ xfs_ioc_health_monitor(
 	}
 	running_event->type = XFS_HEALTHMON_RUNNING;
 	running_event->domain = XFS_HEALTHMON_MOUNT;
+	mutex_lock(&hm->lock);
 	__xfs_healthmon_insert(hm, running_event);
+	mutex_unlock(&hm->lock);
 
 	/*
 	 * Preallocate the unmount event so that we can't fail to notify the
-- 
2.34.1

