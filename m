Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 374625FEE3
	for <linux-xfs@vger.kernel.org>; Tue, 16 Apr 2024 12:35:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713270934; cv=none; b=qHs3NaiF5yyYwtjiQsio52oH0ynIUoi/OUwPlQAv+wEiiuOOjZc9h9psKiRhns682GdllcQJMeouQV/Av/xZOit56ybyK22eZSFldxiD76aZ74XX/Y/wOEiP1VfpoafiQVR50Gz58i3e+Jj3aMiXjy3GWwG2KkDCVwZ0aUNxStM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713270934; c=relaxed/simple;
	bh=Otonp36A4CFHFhtku/XaBP+q7N6ndudpSwqeXzv6kfs=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=WuXzZXTSFwh3EAho+OWJ566c35Pxet0pMH2ujkLtDf3dqM4jehB0WNnbo3h/xeqWbuoMnPELrm7kEkrNAbVqzFLvo2UhNLu7OToGZc7GcUF3iv4CXE7t7twbJ7DP/pmHXjXxkvkTqwf+8kyC9Lr2/El7ZJiJGjfJiY5Nn3K5TXM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=a8dj//SA; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="a8dj//SA"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1713270932;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=ilaCBCSVw+rfRJPGDxpVmzC2ZCn4w04I8oG7vFJ1ScA=;
	b=a8dj//SAQpty13RvKsrrfOU4d69WemIqvIbqK+vPOS028zHPqFBWWMZzsexy+xeaaCFvYu
	64vSwCIDVrC6T2Fi2nkrb73QrRzBw7nj/qp+GGx1wCzlveDupVzvtm1UmxhYObpJZT1sug
	o6aXvhYA6tY/ItlTa07W+I8ibPOTJ10=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-88-l2KWRRkWMOG8qm8tGG-CoQ-1; Tue, 16 Apr 2024 08:35:30 -0400
X-MC-Unique: l2KWRRkWMOG8qm8tGG-CoQ-1
Received: by mail-ed1-f70.google.com with SMTP id 4fb4d7f45d1cf-56e40f82436so1746009a12.1
        for <linux-xfs@vger.kernel.org>; Tue, 16 Apr 2024 05:35:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713270929; x=1713875729;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ilaCBCSVw+rfRJPGDxpVmzC2ZCn4w04I8oG7vFJ1ScA=;
        b=H7Aa35DIQlFwV40oYnJIPdwvztmIPKh96pgPzBDKfinKIZe7OTxnwuQYin7CZIVvds
         8U7DkrCzy8qog4K2pzH3klLfv/08gNK28C+kP5xLXdPIUlgrQTyabMXwN6Uk7zyV8y82
         oxqOcQ3ewq1SwtHfnU7g6sBo4fxL35YrUisgDkAWdfGZpsXbXHwQYcru/gFRYrU6+7XC
         erYWJvLJAWHXcB5IQR5EI/2uCQChaAObonpzoeKHZBVnimuY7xlJNeoHC2sa5CosVDPX
         rDMp8U9p1e4Y8EQCtz6saNCQAjxFpWXPlgwz2bd/4aWmvXtEpj9WFJ2IWVbnyxWrDl7/
         E0EA==
X-Forwarded-Encrypted: i=1; AJvYcCUmxOX2M8pb3Mp/T3Kyn8BdUa88KTXXVamCVHqKEqgKYLUXLImBxe0C4DhpRkJ89jm+GRxARnxDIN4+M0Jn6rVs4A1wmuDXZx2K
X-Gm-Message-State: AOJu0YzBrD36g3NXrSj/i9fKMsZ3XsOeTIp3Fk39RXGpgGxkVx8BmYL2
	jwhaOD2Rxj06uBo4EOR0FmzSyRQnZyVuXubv96ylXLLfMnr6qBFOMFuGiCKXASoAXo1jJKFF5Qq
	DcaAzQlHkPC58faTvPXroTJgltsXnNZMGE2Sx+vKAWyBFKksnJs85+MdD
X-Received: by 2002:a50:8e12:0:b0:56e:2433:a0ab with SMTP id 18-20020a508e12000000b0056e2433a0abmr11502657edw.34.1713270929384;
        Tue, 16 Apr 2024 05:35:29 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IE3lY7ewIZHClf4XpOpKtdCZ4mOQaE7j2xtcAe80NB1Dp/nR9NX0kvVON9Dxr81ZJ7B9131ew==
X-Received: by 2002:a50:8e12:0:b0:56e:2433:a0ab with SMTP id 18-20020a508e12000000b0056e2433a0abmr11502641edw.34.1713270928930;
        Tue, 16 Apr 2024 05:35:28 -0700 (PDT)
Received: from thinky.redhat.com ([109.183.6.197])
        by smtp.gmail.com with ESMTPSA id p8-20020a05640210c800b005704825e8c3sm465584edu.27.2024.04.16.05.35.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Apr 2024 05:35:28 -0700 (PDT)
From: Andrey Albershteyn <aalbersh@redhat.com>
To: cem@kernel.org,
	linux-xfs@vger.kernel.org
Cc: Andrey Albershteyn <aalbersh@redhat.com>
Subject: [PATCH 0/5] xfsprogs random fixes found by Coverity scan
Date: Tue, 16 Apr 2024 14:34:22 +0200
Message-ID: <20240416123427.614899-1-aalbersh@redhat.com>
X-Mailer: git-send-email 2.42.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi all,

This is bunch of random fixes found by Coverity scan, there's memory
leak, truncation of time_t to int, access overflow, and freeing of
uninitialized struct.

--
Andrey

Andrey Albershteyn (5):
  xfs_db: fix leak in flist_find_ftyp()
  xfs_repair: make duration take time_t
  xfs_io: init count to stop loop from execution
  xfs_scrub: don't call phase_end if phase_rusage was not initialized
  xfs_fsr: convert fsrallfs to use time_t instead of int

 db/flist.c          | 4 +++-
 fsr/xfs_fsr.c       | 4 ++--
 io/parent.c         | 2 +-
 repair/progress.c   | 4 ++--
 repair/progress.h   | 2 +-
 repair/xfs_repair.c | 2 +-
 scrub/xfs_scrub.c   | 3 ++-
 7 files changed, 12 insertions(+), 9 deletions(-)

-- 
2.42.0

