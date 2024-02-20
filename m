Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DC6A1102
	for <linux-xfs@vger.kernel.org>; Tue, 20 Feb 2024 00:09:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708387769; cv=none; b=nNIrgtcxum7mKYuSW4S8PK1iBhlO9w7aTIkd+GI3efkb019lhQCaiBUDWUx22LqvOojnIH8aWORewLYqbn+nkqil6ciDaYyJcV9vB6IzX7B0ryUcqHx/f5oDNV4ETKFmQep8CgI4ZdBeRBK4iMpdwNzjxRmmWiyi7vOAQL91iIg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708387769; c=relaxed/simple;
	bh=6XWOjUTHNo91Z6pKpFeVZTziB7f51LuSu17eTY+XMJ8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Yjsed2BNgkKeqeswtQsCOGwK9IqsATJT/7CQ0nv195WWpN15cU5Eg8pzR7lEZJP4cBZnpiW7hDC7W+P1X510WPJZiHCQYQF4SGDNSgXAPBzOxooIyS1PywGLT1bxuZsv7b28DEVn+1fIF17pL8/NxIx9a1ZnKTJ/SQzo441L2zY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=g7n2LKX2; arc=none smtp.client-ip=209.85.214.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="g7n2LKX2"
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-1d93edfa76dso28263445ad.1
        for <linux-xfs@vger.kernel.org>; Mon, 19 Feb 2024 16:09:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1708387767; x=1708992567; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=acYJ1/MSNrCSBXFm2aEZKWqHU89ns8WBIw4bBHWb6UI=;
        b=g7n2LKX2FsKiLz9QvRX8wH9GQBuVbW7E6wfDAjP+JZ825hH+Z0b8Nu3nygoHo+TDqV
         MlYdpJTRFbX0UDPe5FHh5snzl5BXCkUm0wHzkYaEH70altpO6zoXQ1UyW3/W9pNS0WYG
         gjVamhJcspCo13X9pXWm6qAgogarH5TpkdoXr+oZXaD7SNSBRA2XRSk/9inTHlGMV14E
         B4L5W5pqja0CcBQ59AphCQcQ4AhI4S1eYkvUTAZk+370xPdfp+pL/0jhoTLWnXHfCq8U
         k2jKXJDqbXqpT98AmbimH9XEftqp9LTmmAaBKID3JqGdtllS7g8NjFI+leru95raii8R
         IFGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708387767; x=1708992567;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=acYJ1/MSNrCSBXFm2aEZKWqHU89ns8WBIw4bBHWb6UI=;
        b=daE9veEOS/LCU9yBCKV9DDY8L61gVqQK1hNxdgzHCz0LdzKrJKmPSuN121/yXC+u8h
         Vh+aGTNKb4CMkgHOnLjMQZ4sxFA3VzqAJO0TXLglfuuao4UIPQ+BjGSUUiSV9fQcOg2/
         oaCbq/4PEzAJXD7bxtlGHY8ix4SyT1xIeQ5+Ca5LDwaIc3XXzU2UiWZidUTiLjlt01GE
         vzHKshR3Edec3tTO5SQcrEoia3k9+qC0humrDcb2N9sxdVtL1Xcm8NAawI8jMVg6NRy8
         4YN9rKDEdaeeS929S8Eh6qdob4LywHZZM/u9MEyebzycJe9FBWBBRRuKhU21bWdAmmPZ
         eJuQ==
X-Gm-Message-State: AOJu0Yz/8uDRNUFSfr/SHkUpxscj19uy+towQ15dzZwPeRQy8aPyJ9tK
	u5N0IRJEtt2rXeK6K3uP9UpqHf+qiYK3xiKaKpF70LAZFPmSAp2wMc9SeBG7+4rs6xPnVyr1wJs
	E
X-Google-Smtp-Source: AGHT+IGN307LhtXCinuo/Vge2NsUZGzr0ZjPlnwjdyZRxwVR8PQdn1ffyMJMKssboIvqwtdlDr+gGw==
X-Received: by 2002:a17:902:f68f:b0:1db:ca53:41d with SMTP id l15-20020a170902f68f00b001dbca53041dmr10960735plg.31.1708387766904;
        Mon, 19 Feb 2024 16:09:26 -0800 (PST)
Received: from dread.disaster.area (pa49-181-247-196.pa.nsw.optusnet.com.au. [49.181.247.196])
        by smtp.gmail.com with ESMTPSA id x11-20020a170902a38b00b001d8d1a2e5fesm5142718pla.196.2024.02.19.16.09.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Feb 2024 16:09:26 -0800 (PST)
Received: from [192.168.253.23] (helo=devoid.disaster.area)
	by dread.disaster.area with esmtp (Exim 4.96)
	(envelope-from <dave@fromorbit.com>)
	id 1rcDhM-008pup-1a;
	Tue, 20 Feb 2024 11:09:24 +1100
Received: from dave by devoid.disaster.area with local (Exim 4.97)
	(envelope-from <dave@devoid.disaster.area>)
	id 1rcDhL-0000000HEbB-44uc;
	Tue, 20 Feb 2024 11:09:24 +1100
From: Dave Chinner <david@fromorbit.com>
To: linux-xfs@vger.kernel.org
Cc: chandan.babu@oracle.com
Subject: [PATCH] xfs: use kvfree() in xfs_ioc_attr_list()
Date: Tue, 20 Feb 2024 11:09:23 +1100
Message-ID: <20240220000923.4107684-1-david@fromorbit.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Dave Chinner <dchinner@redhat.com>

Wrongly converted from kmem_free() to kfree().

Reported-by: Matthew Wilcox <willy@infradead.org>
Fixes: 49292576136f ("xfs: convert kmem_free() for kvmalloc users to kvfree()")
Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_ioctl.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index 7eeebcb6b925..02605474dc19 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -435,7 +435,7 @@ xfs_ioc_attr_list(
 	    copy_to_user(ucursor, &context.cursor, sizeof(context.cursor)))
 		error = -EFAULT;
 out_free:
-	kfree(buffer);
+	kvfree(buffer);
 	return error;
 }
 
-- 
2.43.0

