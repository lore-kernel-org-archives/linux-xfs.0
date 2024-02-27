Received: from mail-pg1-f175.google.com (mail-pg1-f175.google.com [209.85.215.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B855A36E
	for <linux-xfs@vger.kernel.org>; Tue, 27 Feb 2024 00:11:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708992703; cv=none; b=L10DJjRRQBCUZfz1taTXoQMoY/1ZQorTudjYhEhvq3i/04Mx20//6fbih/1jhrXy0VIZXJdiH38BPAFpBuOd9he0MO1cW8pcwrTOFORZQRTFzkf6VVSeHrDk86APS1Rq1da/ednPWvZabG2rDkd11jDThFzYL/v1jT/mpQoPgUE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708992703; c=relaxed/simple;
	bh=dEoBz9m0slFVgcoXqGtlcJrDCx1iq6SVFOW/0O52FIM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Jtp98pXBrBYkQnm/IG+XqssfrpSKIMW17mkFoNqe1cf1Q4KKlMpDV9y48QFE+ULAyqm4qs1Ib7FiTAsg+7xFoMI429r3oXo0bDRqRULGRM3lRD3zG8q7pfMh69g3Zaam4/ceLyTMUsnjJ1SQo0xpvZsJTJMtgphEAG3nLXbwt0s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=YYm0IyVm; arc=none smtp.client-ip=209.85.215.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="YYm0IyVm"
Received: by mail-pg1-f175.google.com with SMTP id 41be03b00d2f7-5d8b70b39efso3781827a12.0
        for <linux-xfs@vger.kernel.org>; Mon, 26 Feb 2024 16:11:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1708992701; x=1709597501; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=dEoBz9m0slFVgcoXqGtlcJrDCx1iq6SVFOW/0O52FIM=;
        b=YYm0IyVmVexEK/75LfR4w5bpjgHdYMKbh0y/MsOQqO8biUoPnbWdJE25fksnANo7WZ
         uY6v68GdLCJ9TDHNv437kl2LchyMCrKZMFN97uD2mhYRdmmGoZqZ5DDYRSe7LAZBK9uS
         r/Dia88wTmdvrRWiX9ckI/acsMZ9s7TfSGl4XdynUsJJyQgpOcFu6FKFWm+Qmh7PDnGi
         v924shzI0/x6iH0v0uImo8qkVoS00FgQicTmLziKfd3dCkDAqkpvFwlKVVIyu6BOuwuy
         8ZDaA+Xmjku0gmXH2eWScD9ao3lvWn4LCA/CcmBcL49Ymy29wTExGGG5CQSfHxEM5Zb3
         5dDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708992701; x=1709597501;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=dEoBz9m0slFVgcoXqGtlcJrDCx1iq6SVFOW/0O52FIM=;
        b=CElgk6OccQpM250AQT6RG8NZkyOumg7YLjGjj2ZqBPraWNt9YBbOMcKsnuHF+1PBHm
         HJq2Ok6mVDHBcsi1g7vg6tyMbA86URW0PO0K0AysXxh6S01yICQjnpaIgmph7khBvm/1
         YOL/Sr9ts3VU8s9EXgTC+qRLGmeBd4wCIKuJrIwbCAXQhgbUctbUxxjhT/FG9/WhbitG
         E0hTn+lfJBj3B4607aVgTx8WC80RPXqJNwDepa0Ia004Ps5mP9onFbWT3ilTR777TIJ+
         dntf6OsDZgHEp4aask//vzqZlc/ilxNZTVuepSm7gCwF0j8OWfaFschKp02vW3BbIw5e
         Zimg==
X-Gm-Message-State: AOJu0YxfH2bNp6A0u5hu7R88748UYntFsyAZzJVb/RJ8cWxFYNSytb+C
	PZqHDVpyswHWKbmRXrE7ZmFPYtxJlQpZAd9ym42th6uFN7bbiVJNWP2KL0gtOeJfnTlWkLOlbn4
	k
X-Google-Smtp-Source: AGHT+IF5Ifj/ewrC/7Q/H9L6lxvw29JhUH4y94uSnw+Tfgb4nuDT2i7PGFA6C/R6LwsLriKaCP/Syg==
X-Received: by 2002:a17:90a:cc5:b0:299:879a:7da7 with SMTP id 5-20020a17090a0cc500b00299879a7da7mr6684725pjt.34.1708992701095;
        Mon, 26 Feb 2024 16:11:41 -0800 (PST)
Received: from dread.disaster.area (pa49-181-247-196.pa.nsw.optusnet.com.au. [49.181.247.196])
        by smtp.gmail.com with ESMTPSA id ci7-20020a17090afc8700b0029996fd70e2sm5138196pjb.45.2024.02.26.16.11.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Feb 2024 16:11:40 -0800 (PST)
Received: from [192.168.253.23] (helo=devoid.disaster.area)
	by dread.disaster.area with esmtp (Exim 4.96)
	(envelope-from <dave@fromorbit.com>)
	id 1rel4L-00ByRN-1b;
	Tue, 27 Feb 2024 11:11:37 +1100
Received: from dave by devoid.disaster.area with local (Exim 4.97)
	(envelope-from <dave@devoid.disaster.area>)
	id 1rel4K-000000030uk-45zh;
	Tue, 27 Feb 2024 11:11:37 +1100
From: Dave Chinner <david@fromorbit.com>
To: linux-xfs@vger.kernel.org
Cc: chandanbabu@kernel.org
Subject: [PATCH 0/2] xfs: kmalloc/kfree conversion fixes
Date: Tue, 27 Feb 2024 11:05:30 +1100
Message-ID: <20240227001135.718165-1-david@fromorbit.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi Chandan,

These two patches are fixes for the two recently reported issues
with the kmem removal patchset. They've passes fstests and fsmark
scalability tests with 64kB directory block size, should should have
been exercising >64kB allocations through xlog_kvmalloc(). These
should (eventuallly) trigger the vmalloc() path and so should
exercise the vfree path through kvfree() instead of crashing...

-Dave.

