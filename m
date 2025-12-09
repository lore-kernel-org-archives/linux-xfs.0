Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04F5B27E074
	for <linux-xfs@vger.kernel.org>; Tue,  9 Dec 2025 20:27:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765312028; cv=none; b=HAUnI3WqfA9CfZgxl8zNnEcGLFb3S2Y03VIVw68SV3YOl1FlrIbqpESMEgkYvvgYi4NUKRgycsT8Moyc8yaG5QF+MyVOFLowRhWbo3ZL/4vpKJhFqh9IbvlnBwsyTysT71N8VSTlZc/mSV7G2laMoNwGbYuRRImeOY4Ggh9NKP0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765312028; c=relaxed/simple;
	bh=qLRil2tXaboFFhUihmyZ4F0ftS0awq6m+niWSF1Okr0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Bk2d+UZUkZ7P4oluD1QQTRJnNZXrZJYq75Akp+knMW23STAKGXLlANcVo2nmExzjZCBy7cL7ndJcBckEKav7gUGqPzrkRWZnM7ddCAbCntiGrsdQPXrn0Y8Fkp5njfo8xfi22nYYv/wFgxYxh2CObX7RgSIG7D/PeK8Qj/HcCiM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=bjnV7B7t; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=cHmzUqlV; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="bjnV7B7t";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="cHmzUqlV"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1765312026;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=AQvmCwl4CIfN0sqRarfPdf8b+xe20wglB7RcUwx2MRY=;
	b=bjnV7B7tQyCMgJRwEecTTSW96LFhnmJvUTcDCrBpch68xoO/OQmT5v0GtNKdpNM+/0/ZMa
	AJuHbwT+NIs1dLn11Idqc2miSfQJE+cQcRdhtYubq/HZZKi7zWDPG7n+OIAdx0BVTiIvKQ
	mAIu0WT6NyQiasypOaUXGQ6fCQVgfkg=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-172-R3XAmBp9M9W5oI5ItunFBw-1; Tue, 09 Dec 2025 15:27:04 -0500
X-MC-Unique: R3XAmBp9M9W5oI5ItunFBw-1
X-Mimecast-MFC-AGG-ID: R3XAmBp9M9W5oI5ItunFBw_1765312023
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-4776079ada3so57489895e9.1
        for <linux-xfs@vger.kernel.org>; Tue, 09 Dec 2025 12:27:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1765312022; x=1765916822; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=AQvmCwl4CIfN0sqRarfPdf8b+xe20wglB7RcUwx2MRY=;
        b=cHmzUqlViGFW0TK6LYTLWaPvC3UIMpz6gd4oHZZrl/F0bEpedsXwTRt+jUTNQARiDn
         ARD1qtEAuDF/klc+Cq2inZIDb1j+mkCP/jPVTJel8DeR30KnTC8kCVdF4NdDEIW5ZWH+
         qey04FyJcw0bUOIlYmgJ1Lpn082tujGM1RQREXoG3pb5CQD6HQlvthzsKN9OztxTSjbP
         ZwMAj4eEnoNFL7hPDVp0q3nMXWFr5Sr7Siaf/cCk637+y0eqP3pbrxltecC/ZhR0K1B5
         pP+KkybbW2RU8qcN5hcEqJHiofk6E1UEyLHdHLjNFN7CD3DbFPpARP7veGi9JKAqiF1f
         XwTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765312022; x=1765916822;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=AQvmCwl4CIfN0sqRarfPdf8b+xe20wglB7RcUwx2MRY=;
        b=S0Hz+j5FwQEFXp03w8PsQlMF47QeKdLjgvTvW23Gq0ST3A89doSXG1Q2/IsQUepoXU
         d4PKxNkVUzWjwhF6eVdjSj+bmPGn+Ro6gKICGkkxPErvj1Rgr73EU6/dfDjaIAg0MlFQ
         zE3X4RjklbEKQupSOJnhpdryzh4Rz5g/ZBoLnPyWkKQpi//5t6EAY8xovzoYy/hUf5mx
         xpG6YhDrgITcqK/m53tT25XrdBvfYuYiJdu7AyjCnv/4au6wW+Feu/HgYv8XspfozjMC
         J5enDgFzucxxMmPMpmaubIXcOVrOz+fbATjfrTbk4BHMdyvv1y/aFRi1ZnXpK78U6pdT
         i2Vg==
X-Gm-Message-State: AOJu0Ywm/eRQpV8Yar4h1vVQblEYRny7yHZ/wdl0ZonCeU4WVkSjL0V4
	QMxGJ6QX/8m4fwrYVXfAAWxSgyNv4GhLmcQl6ed7w8usIhFkdaF4PtWUGsOzTSL/ZM/ygozY/1e
	oly8SqjxVw2AgaMwGu9KFotgAk5HH5lInlInpeFz9q+52aP59VkrOvpc6vhO+SQW4YRSMySlk3W
	VtDeaPFJCwygilzoL93BKDhsiauCZi3RXsKDWGJxLp4spy
X-Gm-Gg: ASbGncu86Cyu1ERZmn6g6L1sMbbcRthqZ8KZL4ubc/SKu+WM6/pQ2l283tD1pa8VUel
	gCZOlS/i8Sz+idKVjoM4PQYqrq0e8Qjk7wHFLvgpt1pbxPD62FxkqvnIh/UKjfutb1F9CkauAc2
	JgSjPFN/Jq36GvHPcyLjRHCgPaWV9Iz/ZcUD69tm6PAMVG6F6DM5xHq4q5J23EMUQZ8O/JGyBq1
	/6fhlBLnvzsxGdvy6pmF0DE9PJ/v2ueueLBFhGrFXuxG0PNnpLaWMAj65ZFgW3PXo7zSu/zPRPX
	0rxJgxoqRw+I2C+CsbcFHL2xZyhXJ6xgICsrhmyX7KJCAxSnhos+qykkJnbhT+A0nTg55KZvnai
	B8IL9ynUOYDtuT+3TZD+eIDfIEFwpm0LoBR/ox5HuTfMOObQ=
X-Received: by 2002:a05:600c:c171:b0:477:79c7:8994 with SMTP id 5b1f17b1804b1-47a83795f6emr1598645e9.30.1765312022510;
        Tue, 09 Dec 2025 12:27:02 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGXIJsFvGyu/J7qpmhLjSryzDEwE/uSPpAUJ8pYzX1quLZtl2GwaBcv4X74/J67raO1Q2F6cA==
X-Received: by 2002:a05:600c:c171:b0:477:79c7:8994 with SMTP id 5b1f17b1804b1-47a83795f6emr1598405e9.30.1765312022107;
        Tue, 09 Dec 2025 12:27:02 -0800 (PST)
Received: from fedora.redhat.com (gw20-pha-stl-mmo-2.avonet.cz. [131.117.213.219])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-47a7d2ec650sm25335585e9.0.2025.12.09.12.27.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Dec 2025 12:27:01 -0800 (PST)
From: Pavel Reichl <preichl@redhat.com>
To: linux-xfs@vger.kernel.org
Cc: chandanbabu@kernel.org,
	sandeen@redhat.com,
	zlang@redhat.com,
	aalbersh@redhat.com
Subject: [PATCH 0/1] mdrestore: fix restore_v2() superblock length check
Date: Tue,  9 Dec 2025 21:26:59 +0100
Message-ID: <20251209202700.1507550-1-preichl@redhat.com>
X-Mailer: git-send-email 2.52.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi all,

On s390x (big-endian), running xfstests -g metadump currently fails
6 out of 9 tests. The failure is triggered by the superblock
extent-length validation in restore_v2(). The code rejects
xme_len == 1, but a length of 1 is the correct and expected value,
since the superblock fits within a single 512-byte sector.

On big-endian systems, this length decodes to 1 and the check aborts
the restore. On little-endian systems, the same on-disk bytes are
interpreted as 16777216, so the faulty logic never triggers there.

The patch removes the incorrect rejection of a valid extent length of
1 and applies proper logic so that the superblock extent length is
validated consistently across all architectures.

The outline of the fix was discussed with Chandan (thanks).

Pavel Reichl (1):
  mdrestore: fix restore_v2() superblock length check

 mdrestore/xfs_mdrestore.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

-- 
2.52.0

