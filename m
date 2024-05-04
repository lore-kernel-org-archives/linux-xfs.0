Received: from mail-lf1-f53.google.com (mail-lf1-f53.google.com [209.85.167.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36974182B9
	for <linux-xfs@vger.kernel.org>; Sat,  4 May 2024 11:27:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714822064; cv=none; b=g12nN0h10hR5rr+fh1PXkyFHr9+uFHg1wJ4ia7gek1SYamfnO07VREgMBUhO3Ftn2YoJQBMR1TkjhjtxEQSM34HoPsHvz3GmDuxFWPEzgXJMHXS51eUArHVaQZcyJtjOpNTUKHWPa//wKXIwlc/0Di7lwismXJJwik6huots+3g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714822064; c=relaxed/simple;
	bh=mG1J1A2jIPnJf3tOoKB1yMswAzjzXb2TIar27Fc09n4=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=LU8Bsj+839qT1jpRMjXJJkNfCh8cp74EoOWpvy6obXmgib4CwxEcUxF4pMg4pxAkcQcboh+48MOC5RU+xMod+jmMe4t8XSRkE1rKcc1khEEz0sxIHVy5+XhkLRs2/DyEbMnTJQC2XAkZJ49eeRlIMH4GO0UExSd6vxGajTxylTw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=prEqzzzh; arc=none smtp.client-ip=209.85.167.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="prEqzzzh"
Received: by mail-lf1-f53.google.com with SMTP id 2adb3069b0e04-51f45104ef0so472978e87.3
        for <linux-xfs@vger.kernel.org>; Sat, 04 May 2024 04:27:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1714822061; x=1715426861; darn=vger.kernel.org;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=5Pmu0YEcGf7H38ntSIh2K6f/volabjADstC17jZkDWU=;
        b=prEqzzzh0PG+atud1WccLtx4yM4oQ5rlOtPxOzeoTPtfIHmRU3QOYfBR6pc2qZdfyY
         v0cs+dJCN2cdrFTwYrKCRFlQMSNaj75VwVcYHX50qAUypWnZ/MjVdv4CDBg0XBwDa6PP
         8i/ILVY5IJPLMmvs8TbmPCbiC2qgoQi5lleYbHcJoLThbCUxOJN7wWZovhtsVIV9G+A8
         0dKf56jW/qSZgWa5xA07aCSyQ+GV0b/y/JLAlNeg1dCmNveIATC9u48lb8m+igF9bBdS
         IU9JejvTlBM9xShWT/cX6Vx4dIMAQCkD5GE9YGAxYDQXZbpmKVoRilgbbkIAFCYfthQZ
         OoIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714822061; x=1715426861;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=5Pmu0YEcGf7H38ntSIh2K6f/volabjADstC17jZkDWU=;
        b=w7A8lU2TK35EyuxX11DjK2N64SuFHuCf2NlH7zlnxviHqGPOeYJ7OzRTXlHgjEnbGN
         DNG3O+qDwsmojFxOq81oqgcC2jYvS/UQwbX7BHHCiNzbuSAUpPHwuDdR27gUKIFFwC7r
         7qPJatwHqvPGcJvS1i57EFc0FQuwiZPuLqFW/5Ar4zSz5dQxfr2YKCMtym4RLyNTok1s
         gCntxPY53LOeUE1YW61oTG88+LwQbqjn0hjFOY5ZuC3gIRmxK7wGmvQoiLixVQcnN4bx
         mF2s3RNXC5IKNM/9g81A+to5c5Ct9hZ154WK21B5qyYco1w1afG1Zj8fO0XxBBwsrnPU
         U2yQ==
X-Forwarded-Encrypted: i=1; AJvYcCXyNvi4ASt1pcr3y1mLX2PX50aP8R3dMHMgFkl4XYFfrrEXdhPX2hoW9ZMrXkjfZxiqE0fDapxaWU2Me2E0hOSaYS4zJKKOER5Y
X-Gm-Message-State: AOJu0Yyqd6rh7vJDTKhz6tXqdFKNvqesABYAMh0PxYzY2iSf/o8zb34K
	8lt303hPOIZ7Pwo4UW3WsMPTQw/eo51aBhTsWDt+9a7OfGIMiZ9k3yK0wknItec=
X-Google-Smtp-Source: AGHT+IGflfEXs8kdkz28xNJC43CYFzY4D71i04lz4IE4xTdRC7EA2bcfAOv1A0BvNhzHrreOhzAxGw==
X-Received: by 2002:a05:6512:1390:b0:518:e69b:25a2 with SMTP id fc16-20020a056512139000b00518e69b25a2mr4357763lfb.45.1714822060160;
        Sat, 04 May 2024 04:27:40 -0700 (PDT)
Received: from localhost ([102.222.70.76])
        by smtp.gmail.com with ESMTPSA id dd22-20020a0560001e9600b0034d829982c5sm6052982wrb.5.2024.05.04.04.27.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 04 May 2024 04:27:39 -0700 (PDT)
Date: Sat, 4 May 2024 14:27:36 +0300
From: Dan Carpenter <dan.carpenter@linaro.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Chandan Babu R <chandan.babu@oracle.com>, linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH] xfs: check for negatives in xfs_exchange_range_checks()
Message-ID: <0e7def98-1479-4f3a-a69a-5f4d09e12fa8@moroto.mountain>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mailer: git-send-email haha only kidding

The fxr->file1_offset and fxr->file2_offset variables come from the user
in xfs_ioc_exchange_range().  They are size loff_t which is an s64.
Check the they aren't negative.

Fixes: 9a64d9b3109d ("xfs: introduce new file range exchange ioctl")
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
---
From static analysis.  Untested.  Sorry!

 fs/xfs/xfs_exchrange.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/xfs/xfs_exchrange.c b/fs/xfs/xfs_exchrange.c
index c8a655c92c92..3465e152d928 100644
--- a/fs/xfs/xfs_exchrange.c
+++ b/fs/xfs/xfs_exchrange.c
@@ -337,6 +337,9 @@ xfs_exchange_range_checks(
 	if (IS_SWAPFILE(inode1) || IS_SWAPFILE(inode2))
 		return -ETXTBSY;
 
+	if (fxr->file1_offset < 0 || fxr->file2_offset < 0)
+		return -EINVAL;
+
 	size1 = i_size_read(inode1);
 	size2 = i_size_read(inode2);
 
-- 
2.43.0

