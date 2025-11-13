Received: from mail-qk1-f178.google.com (mail-qk1-f178.google.com [209.85.222.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E45F83101C2
	for <linux-xfs@vger.kernel.org>; Thu, 13 Nov 2025 19:01:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763060497; cv=none; b=N5cSiYtkKmfXoPF1veept+UxrBzM7mWM0+470zFMB1PsFIP1XXqLqRmY3ycsgcZyK77zn8SghAzfYCDIXIRk9F2K+Bt5yZE84/B2EWmtqY9JQFwVCtiN1f3dd5BKJ51pbnt+/gn1NXT4pTGWkyDDI8zyWy7+kBzxgAJrpMeWFBw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763060497; c=relaxed/simple;
	bh=fID0wlKsgbuZ7rLqJxq2UYo2wKKAiX+fNDsl08zChrM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=b/Ebi53ofPAXM5s77jMoz487pDrp63GowaEFXJQ3hcGj0BmzCk+Ebh9ga+DoOEzwoutWut5NlALsVfuTG2ln8VUOacn8bBmwwiTyY8A8y/F5F1bwcn5yfUWo9gkGI1k9IgVHgYM7Tg8Xf4vvnyBqDLZxAzMKQAGhYMLMzFQq/2I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=M16P93fY; arc=none smtp.client-ip=209.85.222.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="M16P93fY"
Received: by mail-qk1-f178.google.com with SMTP id af79cd13be357-8909f01bd00so107419585a.0
        for <linux-xfs@vger.kernel.org>; Thu, 13 Nov 2025 11:01:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763060494; x=1763665294; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MUv3ig7gKTZiQnNq1vm5mpP4T0fDG8gYNVbuktfcpJs=;
        b=M16P93fYqBW0HSJJ5ZDgb0J2jgc33AuupzxZ+0eI/Mj7lM5Bg/lEvnqI8THjUDpVjR
         mvTo+Hn9csS4l8irzH1evv3WCcP2/ZVciBhe0k3jFf+A0IZJLJSusCtu/OE5/XvnAuO7
         c6RCW6xFZGHp7wQGh+t/EGGYCboZY6x/8NDEtlEW96RLFx4D+M7BQZ42Y3i8q6c3oHWs
         CdIc+8IcGZruHpInXz9x9aJ3DARMpBbwGVY1ZeV7aSxR8DE3GfXUsNNg12Mr/EzXzR3s
         h9msI7fZ0CoupEgs4SVHQWMlQWDi+wIQT55sxF75lKF+WS1PhQIq9VpKbTZqLvTEQmxY
         imuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763060494; x=1763665294;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=MUv3ig7gKTZiQnNq1vm5mpP4T0fDG8gYNVbuktfcpJs=;
        b=xQ8yKVaMnFh8fQ6zH4i9EYEJCxt1jT9sgaEuI+AhTkv5ItKJR8USrs5eIk4PI48Lf9
         T+wtVmYU1C+cHvhKiSLxH8mk5xUmjzsnu4myfNQ0WvED0L5LEP+RgJQpjh2hNzl4Mz+r
         q20KPJr5fqK73yycDPzExzeaEhwRqJDaPkSFA8IRfe9mincsWmFfxXUX/P4lY+k3MhEk
         p2V29rWcG50vTXWr/ZVkv6Gi/qGtED9iAGMmWnB7EQ9+WYfFI1/NFtc4lxi0wGkSgqOU
         B1pZ3tCCnIV0PbShmIjGijw/letJBHNDNRW+VtEXTMEQJb/T8zRkD4PfT8f8ypiTvFRN
         AAxA==
X-Gm-Message-State: AOJu0YyVOjUBiVrssugMxBZQqKm81Wcd46CKMGA8jlGV6k6+ezEY4htE
	Wbl4TYbBdiAHkGYoBazg/2JpaHfHNEPcBiMro3QtyroNpZvFu7JLjK4m
X-Gm-Gg: ASbGnctTlRX8UAgEMVOINYrU71x2/k28zCaL+hTHAy4i2P1wCRCzEf6xFrhGgtSkB04
	BebdhZ8RfbNTK5zQ7rwzg76OWKxB0+F8A29xkl8t0Wy2Au3hUT2eGB1qL/161IvSj0afebdRcae
	yo1XTS2g8kn35gwAqNFVw11tqjpbTezK40uDJyLbFi2+uzfyU+V3T1OvTzu/fA2KDJGVFUL/zuC
	SpkIYdK6UJesvtEISxwB3I7XKkk6gv15y7Kl7RPJ6g1fG3KzI0KHS+2WQ9w+LglRe5aZE2/h2dp
	SKf7/SfE3sFw0I5KsBiOoz6CP17NsKC9pJTIfg4cJCuK5M+YVeV1aHUWVhSw/CAyYLdg9x4mfCj
	JXVXjtzwgD3Uh7U/uRrEC1FVKr4ianFS5jmUoGqy8dIHcZB20vYrabZWPb3bdDinisyXtJ8of8d
	/gxtVxb61KHVAii8Yuq+uCiaVdRHYIPvI=
X-Google-Smtp-Source: AGHT+IGjX3HXqOY5exKe57ivPtKqQ/8qdqdt8a/LEsPU4MJgln+dlHP9S2HThtsEQtvScJRygs77TQ==
X-Received: by 2002:a05:620a:4614:b0:85c:3bcf:e843 with SMTP id af79cd13be357-8b2c31b46d8mr51876485a.43.1763060490083;
        Thu, 13 Nov 2025 11:01:30 -0800 (PST)
Received: from rpthibeault-XPS-13-9305.. ([23.233.177.113])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8b2aeecb087sm187043085a.26.2025.11.13.11.01.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Nov 2025 11:01:29 -0800 (PST)
From: Raphael Pinsonneault-Thibeault <rpthibeault@gmail.com>
To: cem@kernel.org,
	djwong@kernel.org,
	chandanbabu@kernel.org,
	bfoster@redhat.com
Cc: linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-kernel-mentees@lists.linux.dev,
	skhan@linuxfoundation.org,
	syzbot+9f6d080dece587cfdd4c@syzkaller.appspotmail.com,
	Raphael Pinsonneault-Thibeault <rpthibeault@gmail.com>
Subject: [PATCH v3] xfs: validate log record version against superblock log version
Date: Thu, 13 Nov 2025 14:01:13 -0500
Message-ID: <20251113190112.2214965-2-rpthibeault@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <aRUIBj3ntHM1rcfo@dread.disaster.area>
References: <aRUIBj3ntHM1rcfo@dread.disaster.area>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Syzbot creates a fuzzed record where xfs_has_logv2() but the
xlog_rec_header h_version != XLOG_VERSION_2. This causes a
KASAN: slab-out-of-bounds read in xlog_do_recovery_pass() ->
xlog_recover_process() -> xlog_cksum().

Fix by adding a check to xlog_valid_rec_header() to abort journal
recovery if the xlog_rec_header h_version does not match the super
block log version.

A file system with a version 2 log will only ever set
XLOG_VERSION_2 in its headers (and v1 will only ever set V_1), so if
there is any mismatch, either the journal or the superblock as been
corrupted and therefore we abort processing with a -EFSCORRUPTED error
immediately.

Reported-by: syzbot+9f6d080dece587cfdd4c@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=9f6d080dece587cfdd4c
Tested-by: syzbot+9f6d080dece587cfdd4c@syzkaller.appspotmail.com
Fixes: 45cf976008dd ("xfs: fix log recovery buffer allocation for the legacy h_size fixup")
Signed-off-by: Raphael Pinsonneault-Thibeault <rpthibeault@gmail.com>
---
changelog
v1 -> v2: 
- reject the mount for h_size > XLOG_HEADER_CYCLE_SIZE && !XLOG_VERSION_2
v2 -> v3:
- abort journal recovery if the xlog_rec_header h_version does not match 
the super block log version
- heavily modify commit description

 fs/xfs/xfs_log_recover.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index e6ed9e09c027..b9a708673965 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -2963,6 +2963,14 @@ xlog_valid_rec_header(
 			__func__, be32_to_cpu(rhead->h_version));
 		return -EFSCORRUPTED;
 	}
+	if (XFS_IS_CORRUPT(log->l_mp, xfs_has_logv2(log->l_mp) !=
+			   !!(be32_to_cpu(rhead->h_version) & XLOG_VERSION_2))) {
+		xfs_warn(log->l_mp,
+"%s: xlog_rec_header h_version (%d) does not match sb log version (%d)",
+			__func__, be32_to_cpu(rhead->h_version),
+			xfs_has_logv2(log->l_mp) ? 2 : 1);
+		return -EFSCORRUPTED;
+	}
 
 	/*
 	 * LR body must have data (or it wouldn't have been written)
-- 
2.43.0

