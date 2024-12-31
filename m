Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 910E22A1BA
	for <linux-xfs@vger.kernel.org>; Tue, 31 Dec 2024 22:11:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735683095; cv=none; b=LUXGb7RGX+8mvLmSapI8rkKMq/4cXn/yg5zRAESmYI8adKKPgSwNps1wa3lCPv/g1d/nHufQJcMQ20IHvg9GJFUAAWaYygwUg6U5Qi+7tjz2ZnasCTzzbz2+1Wh7FwWlQ7bJs7rqG4AGVLquDuyvhmGUVz4EwR41fsy7cOq7QwA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735683095; c=relaxed/simple;
	bh=ZVaNg3S6UjpGf3VoDIcfaUivNWRYRH8ar0eusUvKQyo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Dt46nybJ2PmZcmKK/MO5Wexu6qTexGk8ATLXlYyND+aR/LQnI2B7m0sOg0/2ZoP4BQyPsL189/BGCxIQiBRbuYCuZgrjRkaQs2QsTXZlIWvz6XZm0taryaonsYf7UCG6LKLxpUauguwIbYxJX3dPn1PGcfZOGfu/9wwvTAZe9iw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=FV3/JQw8; arc=none smtp.client-ip=209.85.214.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FV3/JQw8"
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-2165cb60719so139176065ad.0
        for <linux-xfs@vger.kernel.org>; Tue, 31 Dec 2024 14:11:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1735683094; x=1736287894; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZVaNg3S6UjpGf3VoDIcfaUivNWRYRH8ar0eusUvKQyo=;
        b=FV3/JQw8zMBWHOLmRn4jXA0Es344LrOu4PYjCA4ABdfDw7GZIUd56jEt8p9QH0HjSt
         E5ACBmXredeGz6ugZedw4+SKA99NvYbC1lTiTZaWpAO8IDd0USgcQshV61eucXdMlism
         LujIpcLpadAqoeFd+l4AzHi+rgg2pfjclc59zx12VykrvBNfGIU9ap11N+r8B1XXihnG
         GBgfMPO/IgnDKxWUHMdCEC6rdFmkDsTwh/J6p28fcAzDdnWKA7gAdyi1ZO47OWj8xkpy
         eJ14t6umXUqwk6W38sfwhk/hFvkwepoARVFqd9Nnfk/Uhko49ZT49ixo20CcSf4F3WPY
         jBIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1735683094; x=1736287894;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ZVaNg3S6UjpGf3VoDIcfaUivNWRYRH8ar0eusUvKQyo=;
        b=KivhETSnYmwDy6sQhT0okH9wa4g1Q30smL/6f6SxZGY7Uflw3bGvV/oJ2cDHuOLqi/
         xeLtJHLwlBo1kJ234RiatkQS1sFj5ybCaAgLKxn8JaMMLzM7VpnKgLN2ZesDmU+6bPrk
         2k/W2a/usAXH9H3X1ZDlB/snT0oirAtF1VnLEVqi12OTaW+dSsZI+XQY429hS9aUySQj
         65ljd58ljmSYDpUGPzlkLGA7BuQJRo5hcgv3wR/s1bKQeWBYqOVSQ4teoBaKIe9+EVnl
         yxIC6Te/zHCEqjxQqClghVZOLnf9TuHZzXnNCw2b2EB2hO7sPp2v/savqAnv8S/QwrSl
         Z5GA==
X-Gm-Message-State: AOJu0YynGGLnHkW7V4PFCAvkKeKpnsJMjXBy3g60wcQ3x1Ml/zfJmIiF
	/ucmRWw1FDsPLtKXHcJR+ZEnuYwrbgayHFmKXOGNdLHS7d2YlTPV
X-Gm-Gg: ASbGncvBY/XCfztD8W1r3ziQ7dJPZ1zQ77Nfbwo9L9dqikKzrfIh75+R1mmUz99U0Xd
	+pVcCltrOPSgQYzlHzcVB9nvUiDDUzinNCzLJRbFZMcg+moj4uZS3ynaDSyCwFO2R238HvZ1PRb
	C4Ipmj0mntjMD33jZ2W6Bn2+UgJRrZh4ebyvTIrFc0IuVNw2o7g/rlCl1edJQWPW0nA0osaai4h
	KBr/ZJZz7koiE5kX7HdifNktjkTStFOYpXcSckBAA/4TCQisGln6/XVjKMgCdaJRKi66P8wfDVl
	U18YNRrwiEYmbcA8Tu/a9PM=
X-Google-Smtp-Source: AGHT+IFA9KCNeN1Xw/pvlyiq2Go4E1Z7nzM1WpdRVcEKxqYrhT5Klgim8x4QxdxmvP4P04GrKLxQPA==
X-Received: by 2002:a05:6a21:8dc2:b0:1e1:ccf3:a72 with SMTP id adf61e73a8af0-1e5e07ffd40mr61162084637.28.1735683093679;
        Tue, 31 Dec 2024 14:11:33 -0800 (PST)
Received: from perforce2 (75-4-202-173.lightspeed.sntcca.sbcglobal.net. [75.4.202.173])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-72ac3214f81sm19376795b3a.166.2024.12.31.14.11.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 31 Dec 2024 14:11:33 -0800 (PST)
Received: by perforce2 (sSMTP sendmail emulation); Tue, 31 Dec 2024 14:11:31 -0800
From: Marco Nelissen <marco.nelissen@gmail.com>
To: bugzilla-daemon@kernel.org
Cc: linux-xfs@vger.kernel.org
Subject: [Bug 219504] New: XFS crashes with kernel Version > 6.1.91. Perhaps Changes in kernel 6.1.92 for XFS/iomap causing the problems?
Date: Tue, 31 Dec 2024 14:11:31 -0800
Message-ID: <20241231221131.1058759-1-marco.nelissen@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <bug-219504-201763@https.bugzilla.kernel.org/>
References: <bug-219504-201763@https.bugzilla.kernel.org/>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

With the big caveat that I'm completely unfamiliar with this code, it seems
to me the problem is that here:
https://github.com/torvalds/linux/blame/ccb98ccef0e543c2bd4ef1a72270461957f3d8d0/mm/filemap.c#L2989
"bsz" is a 32-bit type on 32-bit kernels, and so when it gets used later
in that same function to mask the 64-bit "start" value with "~(bsz - 1)",
it's effectively truncating "start" to 32 bits.
This is more or less confirmed by the actual values of "start_byte" and
"punch_start_byte" when that WARN_ON_ONCE in buffer-io.c triggers, with
one being (close to) a 32-bit truncated version of the other.
Changing bsz to a 64-bit type fixes the problem for me.
