Received: from mail-yx1-f51.google.com (mail-yx1-f51.google.com [74.125.224.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4D5D224D6
	for <linux-xfs@vger.kernel.org>; Sat, 27 Jun 2026 22:40:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.224.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782600007; cv=none; b=CDtB2hKQ0kFzjRzUT6hkPCTCXr+xsG7z6wZdTgcUd3fMCHEHiyS6BPcWZAAVpgAECpkXCjRLu1a2PNTqLn34VavK+ma+xWvDJSW3jZBzDawvQVIHLOBipZkT9Q5EM/2/pnjPJzGAqiqH8V30xNYPLSyIlOG8Y7TcSAHcSmzt4wo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782600007; c=relaxed/simple;
	bh=msqn/sn/3OXNeRY6E2eJhfO3k+zQJ3cdVyMfYv3wnhY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=kB9BrL515QdtsPlmP2Qx/6EMk5fEmGclJ8Z90E0bQwD/OUXpO92d4yFnUyQgWcRJV+XnXM/qxIM4Nx1oZdbgCP+AWLwcj5PrslorykZApnokcQ6EwPONX/KZNEagVKX9vAGII0qlmJf+J+SSu8UCFM7KcYIcluSvoVvjqOqlds0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=TB6u0JvS; arc=none smtp.client-ip=74.125.224.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="TB6u0JvS"
Received: by mail-yx1-f51.google.com with SMTP id 956f58d0204a3-660a40aac63so222788d50.0
        for <linux-xfs@vger.kernel.org>; Sat, 27 Jun 2026 15:40:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782600004; x=1783204804; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=LqCZxaZvrdNqF5u+99gx4CKQLMyqgqiSQusoPYhSc+I=;
        b=TB6u0JvSl7w2sKIppCLiueXRvOYysRtpkfXd9CgfZ6+4A3GkJMPODmV1WljnNcNgyk
         ZARJWOueOF4Ef3d2ChBI8M8WY6V+wTagoppHYnHfan+/0hYuUlaeQ2KM1Ehvy1OVK9EL
         J+rrkeDckHX/Mevkpe8NChHipIDWbE2aktRWbjltvbh040stemeuVepTTinGvKrVfHDn
         YXoR7AZMnIY7QhK8B1slpP5BmpER9pexC8kjApaGFQNmZ2bbz8n8m1/cSRyDtfNIlY1R
         3nqVesdhXnpQKI24dAG/VFGrqpNeq1iuoM8T9Z0kPZfeyjDUa2YwJKSBwcOLMCZi0ERh
         ADVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782600004; x=1783204804;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=LqCZxaZvrdNqF5u+99gx4CKQLMyqgqiSQusoPYhSc+I=;
        b=SrQSvMXjK3c3xEezvQHAYasYHbdtuk7UJTo0YBXoAFDGT5Pu14w6WvE7qYL1bgUNfw
         M+lCRM85oZGSDOEgmIPcnTfUvwzrigtXBY99txxhDjlJ8dmyyRiI2aAF2qPrJvkzEAaQ
         x7pbvkTvF8REr0ebDfKZqQ/Cal+59RKjQYHYAr2uHXxTJcYq/DCZO96m0/JCHMnvYKYT
         rei0H6DlsJ2wA5ancqXDKZtlYVCBLGkOVNH249zF7MMcLiuC0SOLWwXfwLwb9xaTleQK
         C/nm4oIuXzp1v++qY01M2yMbZXe32JyKklW4QEIDynj+CMRaCm84I6iHmYlvzsqm4+x3
         sGhg==
X-Gm-Message-State: AOJu0Yxwluk9OXeXnf0er0/9n+eRh2iGYvbwcY8lEyJEh2Gz0Q1ToJMr
	Ph/WkCU0cLVPnUnD9vf2szqA9kMYogM5fKz2aumgmnjKWLEYV/OK6BmQ
X-Gm-Gg: AfdE7cnfYcV2e14N3bCSGIoZ4UV7cYBuMAB5goK2/T1dzRifDnDYzkp3LEE5QM48Lo4
	8RojMF+J97Wnoc64JoRrqm5nV4eelMl4esHNDqX2Y0wJV4y139LYlaM3RR5vghx4NFcZ1mihFKL
	x0DhFmGnzb09ba7ufDEOlyfduv8ZjEEjHSUZY1zEHu8pPy0oDUWRf6dmJdiINARTXkBDE2HbHHE
	YtB6jFrm+b3LJ/iSJ2wqZ6pYawtJPnKqfW3kHOL6wgUvdPxFsITJ8Sq/lynOprAxoEvzfkMk5kg
	ZHO2zErzwDQylOJPutpJOF224lh+dYjT+8PRuat+Ee3qqnceHuc8shR6vCSzvy3RqFvNJsyu6Ic
	2KvpP8p41sqhskV4Pk4mWxu0MBGh1y8pG3czHmQuvnSsE4wtgXdQ5VrUest33Iuj02a3yDGHAaC
	jaMBp95ZDYCfRGJUcqxnSxhOx22rPYVJRZc5RDjAVlj23AXjjtPMFPssZH4ITLvK/8zH8=
X-Received: by 2002:a05:690e:14c4:b0:664:82f9:fbe with SMTP id 956f58d0204a3-66487f2b097mr7942801d50.7.1782600003905;
        Sat, 27 Jun 2026 15:40:03 -0700 (PDT)
Received: from tc-ROG-Strix-G733ZX.lan ([2603:6080:ef0:67b0:8953:b27b:7fc9:19fa])
        by smtp.gmail.com with ESMTPSA id 956f58d0204a3-664ae75ff82sm2082024d50.12.2026.06.27.15.40.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 27 Jun 2026 15:40:03 -0700 (PDT)
From: Tsu-chieh Chen <tsuchieh.chen@gmail.com>
To: Carlos Maiolino <cem@kernel.org>
Cc: linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Tsu-chieh Chen <tsuchieh.chen@gmail.com>
Subject: [PATCH] xfs: clarify sb_qflags locking in xfs_qm_mount_quotas
Date: Sat, 27 Jun 2026 18:39:10 -0400
Message-ID: <20260627223910.129798-1-tsuchieh.chen@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

xfs_qm_mount_quotas() is only called from the mount path, so
m_sb_lock is not needed for serialization when updating sb_qflags.

The code still takes m_sb_lock around the sb_qflags update. Replace the
old XXX comment with an explanation that the lock is taken to keep the
mount-time update consistent with the runtime quota update paths.

No functional change.

Signed-off-by: Tsu-chieh Chen <tsuchieh.chen@gmail.com>
---
 fs/xfs/xfs_qm.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
index aa0d2976f1c3..c2bab12643d3 100644
--- a/fs/xfs/xfs_qm.c
+++ b/fs/xfs/xfs_qm.c
@@ -1663,8 +1663,9 @@ xfs_qm_mount_quotas(
 
  write_changes:
 	/*
-	 * We actually don't have to acquire the m_sb_lock at all.
-	 * This can only be called from mount, and that's single threaded. XXX
+	 * Mount is single-threaded, so this does not need m_sb_lock for
+	 * serialization. Take it anyway to keep sb_qflags updates consistent
+	 * with the runtime quota update paths.
 	 */
 	spin_lock(&mp->m_sb_lock);
 	sbf = mp->m_sb.sb_qflags;

base-commit: 804826eac53cff44f88f42989fcc601c2612c0ed
-- 
2.43.0

