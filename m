Received: from mail-pz2-f12.google.com (mail-pz2-f12.google.com [74.125.228.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B3BE3E8685
	for <linux-xfs@vger.kernel.org>; Mon, 14 Sep 2026 09:32:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.228.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789378335; cv=none; b=VIYeLmu4uyG/vnks1sn4n08h5a5J+aImCt/m3plGUnT/uverXlaetqt1wLlJYrYcjnY/NlD4EemN9cAzddTrteXvCdEU3EPCsGZoB1k6+aiMLXrc6Fo1Fh/UYASq+InNeaxYr+2wDkpApA6Wgwl85keul44Ro5JNYlW+rdKhD0o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789378335; c=relaxed/simple;
	bh=1IdoY1hiT6PmkTeljw6MT7zrKtvU8liEHU6LWcr8124=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=PXCQvkug8YudQdi6L9KsePyDzkOQcEHgtXJ6VYKOVla321E6eNqRKgvHRBdFmDR0X3vXX8ZECYiAvayAyDJIoszHnJnqttEO1O35yWMk4VNQ2JhkjAdSYyzV4fcn+8d0GAKtDzXvMU22QLurSGhc50DrOU/mvcMPIvpVk13l7EA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Dk8jzMDc; arc=none smtp.client-ip=74.125.228.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Dk8jzMDc"
Received: by mail-pz2-f12.google.com with SMTP id 41be03b00d2f7-cc1cea4bfd1so1310958a12.0
        for <linux-xfs@vger.kernel.org>; Mon, 14 Sep 2026 02:32:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789378333; x=1789983133; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=fUgUbIzBHavhcx103b2rVszh/STl0E/XwGRt39cKnyM=;
        b=Dk8jzMDc1MpJzUyRROkorzogF28rUqt8PpiLyLwdEp3qEOU7h/sGptIbgPtngWs0hb
         sIJFmowjKbL9UUANISSbcv+hepwRfyCY3qYXEzMATdw6aBBeBtqIt8yCTz208fgtytg6
         9KVlmpKw8hCLbNPk5Bj3ngyGTZ9hQZEGy4wDGujp/+laP1rE5RzUcx8gCJHytXeA1wfB
         hbHZQ32YgYSuJgEJQ85voGZqjNYvww3NwR8Y99xcX1/FD031GtAF9RZfuOGkDx89T/wz
         782+G6PuSeL+CvSXBgdL6oQCjz29z7Q8PHPmOrR/YeWB2lKRKsnktaF5ok1nG5cq3ZAs
         L4mA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789378333; x=1789983133;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=fUgUbIzBHavhcx103b2rVszh/STl0E/XwGRt39cKnyM=;
        b=P5KWCmMSpofTFLNcjdBi9nwCxjN2Ip6/n4f2GQArc3F7TcSX9f8eoZlc/GyMcq6S9w
         6fz3yirFda4k9ftZuMS+kEt+vbOR7ui2ak6jokMuY/MaP8H5XJmc//HXejSTrxEPD1TF
         sofZ4KMy5tybhcUiXO7vOK03nRGHC9xkGJ6q6yM8MZaMkz7SaCls3iSbY+mV2R+3fwkf
         Al1G2pAqzdY+5I211usnwdXQN1BKYgvzTSI5/Y0Dt7Q5KYkUyX6de+dbicKJSTlxilPo
         rnrmxjssvFugEs29Scszwu0jx+g64kUKDZMOxblW3U0wWDx1Fvm3XIt4Wg8bRkL0WA04
         1+qg==
X-Forwarded-Encrypted: i=1; AKwUvBw2s8HKUP31sPBqMJbzQrrYKdG5H9v+GZ6+XeeIvCWqiB4P3tv8FdQxxtJNzbMAzg/JMJoCFdwaAaE=@vger.kernel.org
X-Gm-Message-State: AFuF++mUqMCTbRA77AOAybRAZg8+FjyJ+fPYNXFlwaj8kns16jHn4+nY
	QrbXX9VFF8PUBAbD1R06DtTgv3VMip5IVsVWxqhr2/E6e/6229HcrCtT
X-Gm-Gg: AYBFou3auvf+YsH3kw29hpeZSsUZfGHaN40lg7a4P2YFCJjrht+1QwhYORBb76ohKlC
	j9kRwMmdzEdGP9SA99BLOHr6yuMpIhiq21qLhgW5ve40aJF1PwqsVhQKJoCX93oop6JsUXdCeiK
	Dx6Lxm7/B1e+xS5aY5Lusg0Yqd0a9iEjfOiAEyksZNOzVO+Y/Qbmkuo6SV7NV4EQrlvC5yYZxNU
	Cu/mum1OCmYVA7AD8oxLFqpdiFiN1fFDdfEJidwYrZlSd2v27/Qv7ZI8kqjgc00ef6yHrf7YTr0
	LXHnvoYS3iinhURGVUP1IjeYcw8JR2CZlDO0kprD0vGnAFwsmUpesqYXVPnHxxms8O8EZAHMkhf
	HTwLKbp7sRx3pv/lH0A9oWsltG5XNNPK5fOYkuLO0JIy9UlebY8UG924QcI9LhOQCB5G7cwwvBj
	PRJm1VR4rJibQIVCQei7D5HZIfmAbihuHs1d5EXHrqQSPItGmLUDWDXQgI84ePnLsqpZd5rxp6k
	UsGYGnDt+4pjqKke3akG9FBoiROzVCi5Q0F2ITTYPaXqv7TQD+OTs2W7pK7k2uI9PSJLdlxJoQt
	oEp9FMeP6NlJYCA2aZWIOU1W/vrlCnR6M9SGmZ60EdmxFXG/aoxLf0+Y94HqA5JjRetaiT+uofl
	L5AYkqFgcbFM=
X-Received: by 2002:a17:90b:534c:b0:39d:f08e:e6e7 with SMTP id 98e67ed59e1d1-39df08f09b2mr2513332a91.9.1789378333338;
        Mon, 14 Sep 2026 02:32:13 -0700 (PDT)
Received: from cs-1047136853211-default.asia-southeast1-b.c.t54fbfa9bf0658dcb-tp.internal (155.135.143.34.bc.googleusercontent.com. [34.143.135.155])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-39d951d6b08sm20414733a91.8.2026.09.14.02.32.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Sep 2026 02:32:12 -0700 (PDT)
From: Aditya Prakash Srivastava <aditya.ansh182@gmail.com>
To: Carlos Maiolino <cem@kernel.org>
Cc: "Darrick J . Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Aditya Prakash Srivastava <aditya.ansh182@gmail.com>
Subject: [PATCH v6 0/1] xfs: prevent close() hangs on frozen filesystems
Date: Mon, 14 Sep 2026 09:31:50 +0000
Message-ID: <20260914093152.1698-1-aditya.ansh182@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi Christoph, Darrick, and Carlos,

This is version 6 of the patch series addressing the close() system
call hanging indefinitely on frozen XFS filesystems (Bugzilla #205833).

In v5, I introduced a transaction allocation flag
(XFS_TRANS_WRITECOUNT_TRYLOCK) to handle the trylock inside
__xfs_trans_alloc() and propagated it down to xfs_free_eofblocks().
Christoph suggested this design and reviewed the implementation.

However, Darrick suggested that the deadlock can be resolved much
more simply at the VFS-layer within xfs_file_release() by surrounding
the existing check with sb_start_write_trylock() instead of passing
transaction allocation flags all the way down.

This v6 implements that VFS-layer trylock approach. It modifies only a
single file (fs/xfs/xfs_file.c). If sb_start_write_trylock() fails (meaning
the filesystem is frozen or freezing), we simply skip the speculative
preallocation trim.

I would appreciate your guidance on which of the two architectural
paths is preferred for XFS:
1. The v5 transaction-flag approach (centralized within xfs_trans_alloc).
2. The v6 VFS-level trylock approach (localized within xfs_file_release).

If the v5 approach is preferred, I will rebase the transaction-flag
patches onto the current master and submit them as a new version.

Thanks,
Aditya

Aditya Prakash Srivastava (1):
  xfs: prevent close() from hanging on frozen filesystems

 fs/xfs/xfs_file.c | 22 +++++++++++++---------
 1 file changed, 13 insertions(+), 9 deletions(-)

-- 
2.47.3
