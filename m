Received: from mail-pf1-f177.google.com (mail-pf1-f177.google.com [209.85.210.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35AFA15E5D4
	for <linux-xfs@vger.kernel.org>; Tue,  2 Apr 2024 21:35:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712093748; cv=none; b=fVU7ngHaibxn7civbWE3PxxhFqGBK6ihPmdyD2rQSF9+e8bfnltRLODobu5CRfh4QbJ3eagQRLu3qrQSojqzszxeRSOn6gzu/zCcV/j5i03hkfA9W66YqwlyRTr5CB2i//pCr3G/TQs+4NnhUSyPG7DXL/kaCVvrLWZiv7UWfcY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712093748; c=relaxed/simple;
	bh=J1LgAwkJiSd+UFA6eImeSkCKycabAUA6ppImKrZFHzc=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uwBjtXJhZRjPahV8/HvfLA6W9pNEnevepyjswSjowz1nSrr5wme2yPiNi518Tn8MTwRKdEqKp5d/HHvNhX/DemCecTGGtUsdG5adUeaRKie9wdeSGOBrBqTwSQ2jVl9QFbCS7edZnFUvrcKdDLoXrxQZ9udJsMV1JXOKFgsXuoA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=ArF2H30c; arc=none smtp.client-ip=209.85.210.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="ArF2H30c"
Received: by mail-pf1-f177.google.com with SMTP id d2e1a72fcca58-6ea7f2d093aso5331767b3a.3
        for <linux-xfs@vger.kernel.org>; Tue, 02 Apr 2024 14:35:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1712093746; x=1712698546; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=GzGYnCojsw9DArsoF4xVETsLg5Ux1AXn/v4k9A0FUZ4=;
        b=ArF2H30cM0tYm0diiXOz66MVHH5MkKohdhgv8N5OgsBVxnhgyvL07XCbpcDqVBnhFr
         BW2vyyV1cpcXckdYsCj0bf2arFE8pwvyOcR04H3y/KhZKLvtTOUqd6fSgYIDs2pLXr44
         0WPMeRRrm89cFDFaOILujh+ru14y5bvSTJV3WGBs8FsmhH49wv2W/GjbRNbegqg4eiYO
         ZduKrH5FjyT7jMtaKKT3xvqhWueed1lu5PE5ehInTeDFtASx/qKMeCBAdlFZ0tpARkkK
         iqvWheraxc5YLMjhfK08er9SrxaPjrOoXkILbU7ByX4v14u9u+FWpAe3BGAEhMfMWr9o
         isPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712093746; x=1712698546;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=GzGYnCojsw9DArsoF4xVETsLg5Ux1AXn/v4k9A0FUZ4=;
        b=Jlq2QzytPOctekxRyIj920PULCGwwqvjb5nOJP0gr8BaYRnR7Txy4fo8n6cv39W4BQ
         Ud0LITjM/2a4tYqkPJYRolzzH5W+MtIKoe3tHcsWACpmFEKt64kyUQljTIm6calRWIJL
         ibhKvy2zLLhGBJ+v+gykpJaCjBhTQHXCdQYeOkHNH+Z+8l7CVtUZ+uSkLWSzWuQMwglA
         Fpox1eJkN4FrhgQmIo7sk+0VUYqMwXHZYCU8BT+xHB+6qOaWAiWu3uuYun4hSoome9p8
         HEZ7nQAbD/62qnALxYADVb7sXsSFQsQRx4LBpgBnH/SK6+zWNX5oo3/KXERk7TJig7ba
         c8gw==
X-Gm-Message-State: AOJu0YzLh5RrI84QZOzll82meyMCUs/Da8RsG3/KdGl2B/VgxFdS4t02
	MPMBlF/9PjGtpLM1cVDqRqneeIPCjX8ql5eRbug4p9H6PGyiwk+AfUZ9Hk0RfF3UztApBZVy0mI
	f
X-Google-Smtp-Source: AGHT+IFstVZOeplvE2qokSfFcV07NYzM6zwCO2ZBN0K4vFuPMUfvWOwOl8piT60SLyv+CkRQTP1YyQ==
X-Received: by 2002:a05:6a00:1d1d:b0:6ea:89e5:99a3 with SMTP id a29-20020a056a001d1d00b006ea89e599a3mr1057199pfx.8.1712093746379;
        Tue, 02 Apr 2024 14:35:46 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-56-237.pa.nsw.optusnet.com.au. [49.181.56.237])
        by smtp.gmail.com with ESMTPSA id i21-20020aa787d5000000b006eaada3860dsm10293450pfo.200.2024.04.02.14.35.46
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Apr 2024 14:35:46 -0700 (PDT)
Received: from [192.168.253.23] (helo=devoid.disaster.area)
	by dread.disaster.area with esmtp (Exim 4.96)
	(envelope-from <dave@fromorbit.com>)
	id 1rrlnE-001n7C-0Z
	for linux-xfs@vger.kernel.org;
	Wed, 03 Apr 2024 08:35:43 +1100
Received: from dave by devoid.disaster.area with local (Exim 4.97)
	(envelope-from <dave@devoid.disaster.area>)
	id 1rrlnD-000000052Fe-2say
	for linux-xfs@vger.kernel.org;
	Wed, 03 Apr 2024 08:35:43 +1100
From: Dave Chinner <david@fromorbit.com>
To: linux-xfs@vger.kernel.org
Subject: [PATCH 4/5] xfs: remove unused is_rt_data_fork() function
Date: Wed,  3 Apr 2024 08:28:31 +1100
Message-ID: <20240402213541.1199959-5-david@fromorbit.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240402213541.1199959-1-david@fromorbit.com>
References: <20240402213541.1199959-1-david@fromorbit.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Dave Chinner <dchinner@redhat.com>

Sparse warns that is_rt_data_fork() is unused. Indeed, it is a
static inline function that isn't used in the file it is defined in.
It looks like xfs_ifork_is_realtime() has superceded this function,
so remove it and get rid of the sparse warning.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/scrub/rmap_repair.c | 8 --------
 1 file changed, 8 deletions(-)

diff --git a/fs/xfs/scrub/rmap_repair.c b/fs/xfs/scrub/rmap_repair.c
index e8e07b683eab..7e73ddfb3d44 100644
--- a/fs/xfs/scrub/rmap_repair.c
+++ b/fs/xfs/scrub/rmap_repair.c
@@ -432,14 +432,6 @@ xrep_rmap_scan_iroot_btree(
 	return error;
 }
 
-static inline bool
-is_rt_data_fork(
-	struct xfs_inode	*ip,
-	int			whichfork)
-{
-	return XFS_IS_REALTIME_INODE(ip) && whichfork == XFS_DATA_FORK;
-}
-
 /*
  * Iterate the block mapping btree to collect rmap records for anything in this
  * fork that matches the AG.  Sets @mappings_done to true if we've scanned the
-- 
2.43.0

