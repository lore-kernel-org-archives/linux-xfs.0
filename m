Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13C7A1531C8
	for <linux-xfs@vger.kernel.org>; Sun, 29 Dec 2024 13:39:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735479555; cv=none; b=ftRwv/g1dI21rytBgwN9Z8Y/pIGON0182cQZnBOQT9P9rL0y9NwbLUL4TzX2LVvug7meGwVolq5LqixdQ0VLLkyiQ+9saTgKuy/zAM+MGD7jyUp8cdmdIilcSPUrUFyCzog6Nw5TWK4jk/rIZVQM5D2BgXW/MO2WPCxRx6QGVJg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735479555; c=relaxed/simple;
	bh=Del7wvDAh5ABN5yFjGB0cyyNSTHG0xUCXAWBpHeao98=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=L7KEj4EhE+1vX/qoHFYnZw+lVj61Yo+Pa1ZAT+eeREqzMp5v6rHQGuUus2X7lMPY+cFJ8Fr9tOyJ+kJPpQa8r9Pq5TvQccmgn7EbF5Sj530WZAyZ3RsMul71Ogex7/hJEKrFfiV++SVrYpICaEo1W/KiP3CSgf4vVOSaja3HsFg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ZVCe0D07; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ZVCe0D07"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1735479552;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=PrI68dIX3adnQHGqL2xOG74NfjAO59Zy47fAa/jnZ7g=;
	b=ZVCe0D07t1jUzS2SQruwnxjlRePVif0J2JBI5Y3jZnen0Av8mYDvwva+XQVK/0UpMgRKnF
	EpMjWimwhFF6EBgOkYpqGItonpcQMocR84SsuUJVpjysFhN8zJ3KjVR9xZnO+9sVBrJQH0
	y1WqDiTKONCa9ANxKiXd105Bua3fH2Q=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-690-hAtrcEeJN8qlB-XfITz4Nw-1; Sun, 29 Dec 2024 08:39:11 -0500
X-MC-Unique: hAtrcEeJN8qlB-XfITz4Nw-1
X-Mimecast-MFC-AGG-ID: hAtrcEeJN8qlB-XfITz4Nw
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-385e1fd40acso4082900f8f.3
        for <linux-xfs@vger.kernel.org>; Sun, 29 Dec 2024 05:39:11 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1735479550; x=1736084350;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=PrI68dIX3adnQHGqL2xOG74NfjAO59Zy47fAa/jnZ7g=;
        b=ZJDpagBNN1JL1cEHu50aoSejw3dCaKYlvwsNpRIffUyTwvRJeieoTun13YzO4IKASN
         eSsdbbru0F6HKAtwZNXYvBGrLUe7g648xeWl2Me4mYqGxh+CKAGTjXu8Ik0m7I/1zEKX
         NiIbO61PRrnIbq8ow9Y+1gRwX+NU/Q9BPDFcdpKzf9WRIsQah+kuE6VD1nKxs5rdH5Ld
         8T3yfitJkx0Ckf52jTqAy8LGeHA/q2tahk/+XgLtznh6TR9SE7sU20GVLsFd8cTXDy0i
         QI3TUDm7IWEip/wD0pT2Kqm/zrGesqiiQvzobLcQXhUajImlclOF2ssYnWnDr8qhBHdb
         lrsQ==
X-Gm-Message-State: AOJu0YzxXmM6/OfhBlf8Ev5VTD2R7sFhBHbES99s9OJMQG23HqgV4hYI
	db2Rd1CnpUGJnzwimIanhPemPWim4I2fiysiqSgv3MJOhIctt6paJHnBiA+PWHE5e/Gzn7xTvC4
	OITC6os8RyCikCcXBLe6onSqSF4uUH+udjm11PSL3t+OBdpdSzsTp20UeSuT5k+yT2Cf1SnyRuX
	wg9pK8/HhrXJyLP9dxYCFAL7ul2y7PwyblqvK4tJ+9
X-Gm-Gg: ASbGncvIj0tx6IbWT+IzLIPC+Pa2cbE+PZFHZNOG9UureaT9mEeXe+5SiIFjzJfmfY9
	3KwsRAsC+VUn3yv8bHvjE8GLU4ETKdoCvFzeTivzPY0e0H4f9SJAZgTuakvVrICG1hsK3gE1+io
	2LmA5yxIHagZNR66iN+EwRTB+g1KY3ibgSLLtJ3KZ59t83wJAoIrNKdFAEDxMQI/ZWHq/HUjuoy
	P+tD4EELeqX/Wd0lnV/SfM5tT0nnggXaERJx2qUYmPW5PVnaL4/ZnQ/w/JdZJAeYS9GJDJks3xS
	T+7R+gN4fu8fgg0=
X-Received: by 2002:adf:cb06:0:b0:385:f44a:a3b with SMTP id ffacd0b85a97d-38a223f75d3mr18260990f8f.41.1735479550180;
        Sun, 29 Dec 2024 05:39:10 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFi4y4KSe8q15B9m2x4QC3C384q9W1DLADKpIpuYvnhlFc5y3oYcSttc5fs5ZzJRiD6pMAVdA==
X-Received: by 2002:adf:cb06:0:b0:385:f44a:a3b with SMTP id ffacd0b85a97d-38a223f75d3mr18260977f8f.41.1735479549806;
        Sun, 29 Dec 2024 05:39:09 -0800 (PST)
Received: from thinky.redhat.com (ip-217-030-074-039.aim-net.cz. [217.30.74.39])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-38a1c8474c2sm27093127f8f.55.2024.12.29.05.39.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 29 Dec 2024 05:39:09 -0800 (PST)
From: Andrey Albershteyn <aalbersh@redhat.com>
X-Google-Original-From: Andrey Albershteyn <aalbersh@kernel.org>
To: linux-xfs@vger.kernel.org
Cc: djwong@kernel.org,
	david@fromorbit.com,
	hch@lst.de,
	Andrey Albershteyn <aalbersh@kernel.org>
Subject: [PATCH 14/14] xfs: enalbe XFS_SB_FEAT_INCOMPAT_DXATTR
Date: Sun, 29 Dec 2024 14:38:36 +0100
Message-ID: <20241229133836.1194272-15-aalbersh@kernel.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241229133836.1194272-1-aalbersh@kernel.org>
References: <20241229133350.1192387-1-aalbersh@kernel.org>
 <20241229133836.1194272-1-aalbersh@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Enabled directly mapped attribute data feature. This features
includes on-disk format change in remote attribute leafs.

Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>
---
 fs/xfs/libxfs/xfs_format.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
index 154458d72bc6..334ca8243b19 100644
--- a/fs/xfs/libxfs/xfs_format.h
+++ b/fs/xfs/libxfs/xfs_format.h
@@ -405,7 +405,8 @@ xfs_sb_has_ro_compat_feature(
 		 XFS_SB_FEAT_INCOMPAT_NREXT64 | \
 		 XFS_SB_FEAT_INCOMPAT_EXCHRANGE | \
 		 XFS_SB_FEAT_INCOMPAT_PARENT | \
-		 XFS_SB_FEAT_INCOMPAT_METADIR)
+		 XFS_SB_FEAT_INCOMPAT_METADIR | \
+		 XFS_SB_FEAT_INCOMPAT_DXATTR)
 
 #define XFS_SB_FEAT_INCOMPAT_UNKNOWN	~XFS_SB_FEAT_INCOMPAT_ALL
 static inline bool
-- 
2.47.0

