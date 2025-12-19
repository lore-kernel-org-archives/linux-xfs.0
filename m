Received: from mail-wm1-f66.google.com (mail-wm1-f66.google.com [209.85.128.66])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D93122D7394
	for <linux-xfs@vger.kernel.org>; Fri, 19 Dec 2025 10:33:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.66
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766140438; cv=none; b=mfCjMHB8CTpbt1KJDiMWJbhUq2CSj+vXJOievIr6JDsuuHWXhdWWbY1tniKmb3KH4VfEMQmoBx7Iwn0V/c0Pm/XljvgbNJ8cD5JqDnFmOH+s0dCNFA0kv5Hmhnc49ioAGkdOtOc9CNbe93jvlVQw56zxALKeA17Oui8etJBCay0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766140438; c=relaxed/simple;
	bh=UDuRjaW4UHD1XjxUMKeFo2Bc9z32SZef334KEZG0PAA=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=VvHcFEfXMnCeifLINV5qEMXW7XhjqdG4A+gKIwRiEnMBs7zmePrTLTYoOc/Og4Bsi5tGGSM6LAdY1VxvDK7IxCluD+ACaejTJpsvFRlNGOPOWyeJorqy1ruJ7QHfCUF6pGIl5DZP9rLqtVlDhHBHqI/+EYULZcojO7TpA7YhYhg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=h6shGhl6; arc=none smtp.client-ip=209.85.128.66
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="h6shGhl6"
Received: by mail-wm1-f66.google.com with SMTP id 5b1f17b1804b1-477ba2c1ca2so16225335e9.2
        for <linux-xfs@vger.kernel.org>; Fri, 19 Dec 2025 02:33:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1766140434; x=1766745234; darn=vger.kernel.org;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=1wJvVM05EsH+BpysKJZDNgRttkxy9i5ad4KGF/bGMt0=;
        b=h6shGhl6QEoWm4MS5sh5sy9Q1Cc3fX/9lpKauzQ6MdJNL3KNWrxlqFT3Y94E1UlXj8
         XdmHjZ1pEGjXK5oLSGjv904z2dm7UQ076knPCUPMyfs9Jr0SCH+P6QU/gT507lf93jsL
         FOceCe9WjUYLMRNL4RoVr2rX5De+DEvVeflIWGcUbOiiLrv8Gpk1KeL5tBU3gPdsQYiP
         dnzBPq5jgVQVuF/IJAEHZd1V9sSX1bVK2uP/rtB6PhZEMq6VhzU30uDuSSVrtz+f61JO
         RyBdtZQ4BEXZGcp3p4B+TEtZ/CHTX8VP/o0Ed5mU2epMjbHJjDn9qbJDqMmryEbmpsKs
         d8tw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766140434; x=1766745234;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=1wJvVM05EsH+BpysKJZDNgRttkxy9i5ad4KGF/bGMt0=;
        b=THNH/79DSBrDRj9js/LUWkM01I1rV7yjN2He4hGin44VAtOAVD0CGb5m8Db5RnPRM+
         Qp2plEHUoZd/KZbAzfjFVshTZEPOeRiBtEt/I++gftMyMilVK3FqTzXLAkfpEIJcscop
         gUN50gkjKDS+4r1pRHU+o8eQTLhwvAnyCSZI2zzjPDyntt4x1xxS6CpUo6+yJSlM8KNy
         xzbF3oCr6VoKKBfdArey58jGIDyX2zU+EoxDooweEbK6M5+kSwXDwXsUwHg5e2+1nt8E
         K2axmFo3WPqf7CCd+eI5i2mz266DFirs5v6/iJyuvRS8ssnWrXtTiRcSpYt2A5johS6a
         j7CQ==
X-Forwarded-Encrypted: i=1; AJvYcCU3qs84jE4OW+aJLfQtpwApVDZ81hqptMkPpVaHovkeitFFG3hbFPXqnDTp9YCxXRv+JNuf4OWXEMI=@vger.kernel.org
X-Gm-Message-State: AOJu0YzLUTqSVAuW38hZGC6gt2R5c8q0QcNEkLKYjLNFtjSs9d+RoyHH
	3GG8RnJXdCyAh0WU1qt4J1LZcLNnaFQDEkvV6w5TdY1G1aal8Alk2s53dCXH01d1iF0=
X-Gm-Gg: AY/fxX6pzIewOYrHekmHxHXnUuVooDX/DxQ1CW56BuP93/O8Y8HhnTR0BF3QFBxjE2U
	0CD3tr2we3ZOvZgxLPtFj9cvMslIPPGgqlHCys0z9hKTw6yAscbibEnysyoiN2XcWojO8/QEAKE
	zbQQM2lyxdf54ftb3E+Gm/ffmR/lXvJQh6Jywu1Mvx3POZH/0GVC1NNIKGD871o2AJD+c2DhnRy
	giW6/QDR4WuF5yYD5FNQ/RHO6ng4BpKsW3YyMzEoaEeYzzcC7L7dMKOkrx7P50p/Uh0bvQfLPSh
	ne2CIGTtR/MNlv5Q/0XR9G7TQDNtPcU93C0rADBY0bKwp7VhjV7Sbbhs1QzO+1Zvn0nzEKq/t8c
	Qp2o8YjAlKY4sB93MkIKSns2qpGO7hgwEAArWuz6SnoWOCYlocaeA/1wfaeaj9a09m5SsUnCKVg
	c+jKyk3DJCG5+enm4Y
X-Google-Smtp-Source: AGHT+IHiqVq0rJ/auLlAHgLqJJMP2FoFH8HfQSTnPppwr65hFDgnc6phLfstgUGrNAed4ocU7KP+rg==
X-Received: by 2002:a05:600c:3b8f:b0:475:e09c:960e with SMTP id 5b1f17b1804b1-47d19593d0dmr26265495e9.32.1766140434206;
        Fri, 19 Dec 2025 02:33:54 -0800 (PST)
Received: from localhost ([196.207.164.177])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-47d19346e48sm36722545e9.2.2025.12.19.02.33.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Dec 2025 02:33:53 -0800 (PST)
Date: Fri, 19 Dec 2025 13:33:50 +0300
From: Dan Carpenter <dan.carpenter@linaro.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Carlos Maiolino <cem@kernel.org>, "Darrick J. Wong" <djwong@kernel.org>,
	linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org,
	kernel-janitors@vger.kernel.org
Subject: [PATCH next] xfs: fix memory leak in xfs_growfs_check_rtgeom()
Message-ID: <aUUqDiGqwfmDcY_p@stanley.mountain>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mailer: git-send-email haha only kidding

Free the "nmp" allocation before returning -EINVAL.

Fixes: dc68c0f60169 ("xfs: fix the zoned RT growfs check for zone alignment")
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
---
 fs/xfs/xfs_rtalloc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
index e063f4f2f2e6..167298ad88dd 100644
--- a/fs/xfs/xfs_rtalloc.c
+++ b/fs/xfs/xfs_rtalloc.c
@@ -1265,7 +1265,7 @@ xfs_growfs_check_rtgeom(
 		uint32_t	rem;
 
 		if (rextsize != 1)
-			return -EINVAL;
+			goto out_inval;
 		div_u64_rem(nmp->m_sb.sb_rblocks, gblocks, &rem);
 		if (rem) {
 			xfs_warn(mp,
-- 
2.51.0

