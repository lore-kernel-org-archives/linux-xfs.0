Received: from mail-wr1-f46.google.com (mail-wr1-f46.google.com [209.85.221.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A8644CE11
	for <linux-xfs@vger.kernel.org>; Wed, 10 Jan 2024 18:54:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="r0nllWcX"
Received: by mail-wr1-f46.google.com with SMTP id ffacd0b85a97d-3367601a301so4082388f8f.2
        for <linux-xfs@vger.kernel.org>; Wed, 10 Jan 2024 10:54:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1704912842; x=1705517642; darn=vger.kernel.org;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Ss0T+jeGd3iEpXbsD78ddZjuQMQNPqW6KGHNG8S5dhg=;
        b=r0nllWcXuqQ1kAdId1EKxhcATqA+Fyv3U4XFbb674X3AEp/Px2dvj8vNUuudoH7ppw
         RjEp6XYZvn0vwNhRBeins2+SEzqSrXP9uCPG6lJf0m2OHmyNFCFPfxcAZjVmL+f8NQhj
         jm+iduk0mY5py6KqQ8ucR1JepzH6T/CFT2DdJOmtcB3gqZl6oBerTFxw5JZbk7yp4fP4
         iRhxbNOeU+1Fuv1VQVvR4yWAD2s7iYiUhkNZFBaz22XibTkIHY1U7cU30BoQKkdWVzuS
         97euo62T2vtvDlG8mnWtzupKc5isMy1E6+veITvyXTFNhL2GXiI7lzW+zfiHah0YPFr2
         nHdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1704912842; x=1705517642;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Ss0T+jeGd3iEpXbsD78ddZjuQMQNPqW6KGHNG8S5dhg=;
        b=LvhyD9c/YwAhhiCuY92KXfRsMiO9xCk53GdrY2Fnm67LSaG1e/Q6z4dn314Gq9jqI6
         AwZUFkyP3NS4Ekv48PGohMQmRaDdPEZjcCilzswG4nNpzpgYRWXoRBmqnIYh1WP5pa9P
         PuZdgk0Z30YXEChLSpl7ElUjpaPrOjnmoAFPBUJjs8ubFAPYa1MEJrzKSrrSFjStPbrZ
         ZeWrJpJdTOJ5+PJnPhKxIzPsRmjyJPjBls0gbHSh1oaloz1KeJg9O3WW0Pq4PAEYWw4V
         Nw7YNnCudU7+/hiUD9K3UybrEGQpCmkHKEXmlqplDRmTQJyFK/psdgMhja+91Hi5apAJ
         F3cw==
X-Gm-Message-State: AOJu0Yxz1VrMaaKECDX4BZsyN63DxKhPSVLFsLGRTrSV3hEi3UzYjw5K
	YV9iGRI04Lj6TW/hQH8+DfrE267tFwxDaUkWd2/IwQD3ZeQ=
X-Google-Smtp-Source: AGHT+IHgh8MEBBHgsDW6RzyU+WQoeW6nbmU0C3kT7kbCDr1JRNGf3kVKFPfeMfDsuCPh4XkpwetvTg==
X-Received: by 2002:a05:6000:184b:b0:337:6529:1dd8 with SMTP id c11-20020a056000184b00b0033765291dd8mr823385wri.168.1704912842572;
        Wed, 10 Jan 2024 10:54:02 -0800 (PST)
Received: from localhost ([102.140.209.237])
        by smtp.gmail.com with ESMTPSA id dp7-20020a0560000c8700b003366e974cacsm5538195wrb.73.2024.01.10.10.54.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Jan 2024 10:54:02 -0800 (PST)
Date: Wed, 10 Jan 2024 21:53:59 +0300
From: Dan Carpenter <dan.carpenter@linaro.org>
To: Chandan Babu R <chandan.babu@oracle.com>,
	Eric Sandeen <sandeen@redhat.com>
Cc: "Darrick J. Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH] xfs: delete unnecessary check in xfs_growfs_data_private()
Message-ID: <b1708d9d-53eb-4275-82f4-f389f0200a7f@moroto.mountain>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mailer: git-send-email haha only kidding

Commit 84712492e6da ("xfs: short circuit xfs_growfs_data_private() if
delta is zero") added a check for whether delta is zero to the start of
the function and now this check is no longer required.

Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
---
 fs/xfs/xfs_fsops.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_fsops.c b/fs/xfs/xfs_fsops.c
index 83f708f62ed9..6de8c5f428b6 100644
--- a/fs/xfs/xfs_fsops.c
+++ b/fs/xfs/xfs_fsops.c
@@ -180,8 +180,7 @@ xfs_growfs_data_private(
 	 */
 	if (nagcount > oagcount)
 		xfs_trans_mod_sb(tp, XFS_TRANS_SB_AGCOUNT, nagcount - oagcount);
-	if (delta)
-		xfs_trans_mod_sb(tp, XFS_TRANS_SB_DBLOCKS, delta);
+	xfs_trans_mod_sb(tp, XFS_TRANS_SB_DBLOCKS, delta);
 	if (id.nfree)
 		xfs_trans_mod_sb(tp, XFS_TRANS_SB_FDBLOCKS, id.nfree);
 
-- 
2.43.0

