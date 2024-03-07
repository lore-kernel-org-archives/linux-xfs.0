Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18B0982D76
	for <linux-xfs@vger.kernel.org>; Thu,  7 Mar 2024 08:39:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709800766; cv=none; b=qDK+tu7qKtpY71TjqX1up0NP6445EIenmA1OtNjw4AuwLHSJOXSvKidFcY2qko7dZfBzLYHu1XAwLuFcpDttnS2eIIZrS5uu5d5Q2VSugxUuF2QXAWpqJY7SFz4v7dcKqY5Uo1Xr5i6UIr98BRHocuNk/Uitowaim/DgmG7LQT8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709800766; c=relaxed/simple;
	bh=EajkfPF4XOdvGbZOn/CrnjZTPHr/uf5N7kNuu1geeyE=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=gKDXPMUIEZSy3JQvPyU6bg1NWcauYcamYPY9QkMfVdqWhFAbajV6XRl/knOSPDN318kFYdPoNomHRgOgFNZU1RR9OjWOONs00NB2P2BvhRpUrixu7UtKYfPT+LFIRaF1P/rM9mTw/IS+PvZhwa5/anGCmvW0qFxepllzJmTIkRI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=VroM5gZ1; arc=none smtp.client-ip=209.85.128.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="VroM5gZ1"
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-4130e293686so4297755e9.3
        for <linux-xfs@vger.kernel.org>; Thu, 07 Mar 2024 00:39:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1709800763; x=1710405563; darn=vger.kernel.org;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=PnvP01sqSCbkr/XzKyXEVDF7n+8RZwMaxaOyNtLHfAU=;
        b=VroM5gZ1qWRhbOxriUTXdBQ2gAygf0XrgOK87sdW7RD3tjHTKTE1hlKbFHoo+hdQQW
         N7kFYvM0Ss/CtdkX3FWKfHO5wpiM1C8Srthe82PPFr0HlKJN4XDLKeJM8ejSMCxLcZMx
         aBfdcCQGZiK2AigwIadrBDKfOCyjFH88+7Tojjeb276zslrnFxFjyKpoCiUlw3bs0WGH
         fOIcxHNjlB0JhnSMeCukz4BnB8nP+anXIe8+8w9U2BkIliOFwcESu+qU7pYBpa0Gj13l
         ZLZr3oZsiGaF0Dz4H2hkR3Fgl5qK7o/usI+M1dxPj43ZimEypJ43rRLhZiWnAU45miyW
         uiTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709800763; x=1710405563;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=PnvP01sqSCbkr/XzKyXEVDF7n+8RZwMaxaOyNtLHfAU=;
        b=efRPKirM0k6olb3NSFxPIfDImokOmy7iyNfc3sIeAVMcGkc6Z1y/gz3MSX1N605yXJ
         CRUEG2OpOCrzBYFBTNISSqGIB7HurfYrmiEnxEKXs+7pwnLETnBVT2jeJ7BI/vAz1bYu
         sDSOztSWo/a4AvUNR07ZfdvwS0NbjDfEUHrJmajNugTUTh1/nK95JzPxYJJV8DiJpcQA
         a8COuBSZ4Ic7Di1SX48ASVpuqxziGiDefOTYm+vrtruut0pwprhlo494vL7cc3i3VPkl
         qgQHYdS7PKduVXH83ZGWCdPliECGQqJ6L256C8Fi2Xw29kAGAFKPsoHCBePLhVYTaZ4e
         u91Q==
X-Forwarded-Encrypted: i=1; AJvYcCVzaAwVzdAvYrEi3xdNu//l+yn4iSpFVAE4wkT02suOUS24vgIvYu77ROqQbm7Mu6zoP0M+kJy6tdaOtKj3RnNUVWF5jmB4LHGP
X-Gm-Message-State: AOJu0YxYLm1xsV4AeLCi7EtFqnkpnD3zjOdIuO0KvlzcVlHW6saU2AlC
	SZ9Mk0oUbOFzuArBrqrjIuT+XGGlJxRBAutuB16rz+sydGCxlWywjx3krB+o2AY=
X-Google-Smtp-Source: AGHT+IHwdVJnLyPhxmA+xwcyhbQLGTYcljpn6bF2PF7D+cZuR+YCWXwL5IVs0ZpL20zkc42ROTpCBA==
X-Received: by 2002:a05:600c:154d:b0:413:1012:5b6 with SMTP id f13-20020a05600c154d00b00413101205b6mr1063558wmg.22.1709800763188;
        Thu, 07 Mar 2024 00:39:23 -0800 (PST)
Received: from localhost ([102.222.70.76])
        by smtp.gmail.com with ESMTPSA id fl9-20020a05600c0b8900b00412eff2eb5bsm1910902wmb.13.2024.03.07.00.39.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Mar 2024 00:39:22 -0800 (PST)
Date: Thu, 7 Mar 2024 11:39:18 +0300
From: Dan Carpenter <dan.carpenter@linaro.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Chandan Babu R <chandan.babu@oracle.com>,
	Dave Chinner <dchinner@redhat.com>, linux-xfs@vger.kernel.org,
	kernel-janitors@vger.kernel.org
Subject: [PATCH] xfs: small cleanup in xrep_update_qflags()
Message-ID: <72f966bd-9a5d-4f57-93fe-c62966ae6995@moroto.mountain>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mailer: git-send-email haha only kidding

The "mp" pointer is the same as "sc->mp" so this change doesn't affect
runtime at all.  However, it's nicer to use same name for both the lock
and the unlock.

Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
---
 fs/xfs/scrub/repair.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/scrub/repair.c b/fs/xfs/scrub/repair.c
index f43dce771cdd..8ee7663fd958 100644
--- a/fs/xfs/scrub/repair.c
+++ b/fs/xfs/scrub/repair.c
@@ -724,7 +724,7 @@ xrep_update_qflags(
 	xfs_trans_log_buf(sc->tp, bp, 0, sizeof(struct xfs_dsb) - 1);
 
 no_update:
-	mutex_unlock(&sc->mp->m_quotainfo->qi_quotaofflock);
+	mutex_unlock(&mp->m_quotainfo->qi_quotaofflock);
 }
 
 /* Force a quotacheck the next time we mount. */
-- 
2.43.0

