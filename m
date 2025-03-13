Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 522D0261566
	for <linux-xfs@vger.kernel.org>; Thu, 13 Mar 2025 08:42:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741855359; cv=none; b=jgQOYRhVgC9r0EGPnslbY0xIYXPJanfx1aKbnx7RPYNWS19SrA4p7tZJTFU5F68FrAzGo6StHj5FpNButj0tVzxCoUQESHPAp5AjqyhUZqnkuiYXWpDPCVwg8Urn5j4BcdjCVWptaoof4Hl3/womAH14VwQ2Q7lEY1xgIaw2bmo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741855359; c=relaxed/simple;
	bh=aS61ioQi1gnMdkPKHjT6FnpW+xtQHN/7eJe8MYOwcR8=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=ndkgsHa8LNpsUSnto+KvKh21WPcX4bPZhgcXlp78GuXjH4BVPyI/vV4L/4vVDTOeuIcnRmbGz1tKqvuIPNSX+JpNO6JY/UlO1i/VsXqhqulE7N4RrwXICtbLZ5X9yfRoEy8u4Q84AXhW0Lg1PiB7GeN0+vDLQjXJDk6ZjbivQYA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=dcc+KAxd; arc=none smtp.client-ip=209.85.128.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="dcc+KAxd"
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-4394a0c65fcso5790445e9.1
        for <linux-xfs@vger.kernel.org>; Thu, 13 Mar 2025 01:42:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1741855355; x=1742460155; darn=vger.kernel.org;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=0MZGkszoRuTLbkn8zrrkh53F8kMZ/UeRg8luwnC8cKM=;
        b=dcc+KAxdk8pBna0bDMAnQ9CYIZe160tOn/9aAB17bOrmkx7ndsiJeZWut2Q9mnOJs+
         dleMqwglnaDYyZ2dUfZrr/PsjHBTMwnlmwh2SLfAgysQ/0vfJ27Sn2gw6k1En00SKvOX
         rWdv8H/g2jLTK6Lu5CWf5+3/oG4zCxXykfRBSpxr1JDVyWJYzSZJ8e4hEU/M0Eglsb+M
         5LCJ6Wg+Lxp6nfs7FIXJZEbryvQTVzQ7bPZf/b855kwQ+GaY7aU6wALmmi/Cbn6NuUGn
         jzOLetPW0ZuE0CQCeHPdmGWgAuEE6ib45qIpy6EPUtKaSkHlO8JX9fnNIzb0yqxNxRX2
         Srbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741855355; x=1742460155;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=0MZGkszoRuTLbkn8zrrkh53F8kMZ/UeRg8luwnC8cKM=;
        b=BKWdzRB98vAjAolGva7xaoDL+/2AwxhweOcnM1dykza2Jo3XO53H8DbJWWCJ0QGqjx
         hyppMU/ZWSPbuqtdxTeQcAnW63+nVzZrEGt/eucJyQKy0BIiGTTtXR48Igo/yliKmvIA
         nJGg5Ar0Si9CjovAQiexmsup/1wau060b7wVAm6mFffH0w6ADKhF717GLBuYW7Q20+84
         FTTdHcps+YDYoJcuvVUU8XfoMPMiqsBp/SrahbwwuYbR2B43zULxSwvU5IzsKeR9JfS/
         Th7jzWv0DaXY1Fyk95QJSFFJ4ZIM1rNJfgG1N2ZYn3hKt5abVTvsFE04Iy/yAtBrIWhA
         K7pg==
X-Gm-Message-State: AOJu0YyuRWJaRxyiCa9+22XIKmdtdTyOTFtwUDMB9W8eoVEbunwOAi9X
	uc9ljv6jiiSzyfDMjdZ6ERmMKKICQ6a45TSSEmhZhK9M0mNhqjC7ClkXjglnZzU=
X-Gm-Gg: ASbGncv0t/oJURd+xVq6V5AfXQ6ULpiCwZDz/S1jir504iUUChNQO2RSbU4zXLGDP07
	DGqCMJ3/8Kazqls6m0qfCwkiA3acYy4X0ge9T+YGRvl/5t4zm6fqKg7BLhsgA5c1KYuqOaPkUM4
	MtYSvkzfk8IDmTZNhDqgQIORMCXEweGtlbA81iipT5qIu9FGRijKUbof8K3wJmKIyxUz+LpcBRv
	Sd6t4mocGBbglVjv69gB+LEVUynsin+kR4Crrtw28AnCEytQX9Le8kXe9BeWc5Kgdj2iOOOTmfz
	NyODIzUtjy87jNzfbGD9gy5senRZ0lawqiLIT4D/JGyDF9SzfvpjUTiwglLL
X-Google-Smtp-Source: AGHT+IEILrpqhFZ99Og63w9nZ0cErjvDxO4ydhqoeXUH0iqkJ/H3snuycM6VV6PrHVSajrdloqrhIg==
X-Received: by 2002:a5d:47cc:0:b0:391:3049:d58d with SMTP id ffacd0b85a97d-39132b58ad8mr23044841f8f.0.1741855355369;
        Thu, 13 Mar 2025 01:42:35 -0700 (PDT)
Received: from localhost ([196.207.164.177])
        by smtp.gmail.com with UTF8SMTPSA id ffacd0b85a97d-395cb7ebaa5sm1307019f8f.87.2025.03.13.01.42.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Mar 2025 01:42:35 -0700 (PDT)
Date: Thu, 13 Mar 2025 11:42:31 +0300
From: Dan Carpenter <dan.carpenter@linaro.org>
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org
Subject: [bug report] xfs: allow internal RT devices for zoned mode
Message-ID: <8bf5094d-8e92-45d5-885d-71369fe4aaa2@stanley.mountain>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hello Christoph Hellwig,

Commit bdc03eb5f98f ("xfs: allow internal RT devices for zoned mode")
from Nov 17, 2024 (linux-next), leads to the following Smatch static
checker warning:

	fs/xfs/xfs_fsops.c:347 xfs_growfs_data()
	warn: inconsistent returns '&mp->m_growlock'.

fs/xfs/xfs_fsops.c
    299 int
    300 xfs_growfs_data(
    301         struct xfs_mount        *mp,
    302         struct xfs_growfs_data        *in)
    303 {
    304         int                        error = 0;
    305 
    306         if (!capable(CAP_SYS_ADMIN))
    307                 return -EPERM;
    308         if (!mutex_trylock(&mp->m_growlock))
    309                 return -EWOULDBLOCK;
    310 
    311         /* we can't grow the data section when an internal RT section exists */
    312         if (in->newblocks != mp->m_sb.sb_dblocks && mp->m_sb.sb_rtstart)
    313                 return -EINVAL;

goto out_error?

    314 
    315         /* update imaxpct separately to the physical grow of the filesystem */
    316         if (in->imaxpct != mp->m_sb.sb_imax_pct) {
    317                 error = xfs_growfs_imaxpct(mp, in->imaxpct);
    318                 if (error)
    319                         goto out_error;
    320         }
    321 
    322         if (in->newblocks != mp->m_sb.sb_dblocks) {
    323                 error = xfs_growfs_data_private(mp, in);
    324                 if (error)
    325                         goto out_error;
    326         }
    327 
    328         /* Post growfs calculations needed to reflect new state in operations */
    329         if (mp->m_sb.sb_imax_pct) {
    330                 uint64_t icount = mp->m_sb.sb_dblocks * mp->m_sb.sb_imax_pct;
    331                 do_div(icount, 100);
    332                 M_IGEO(mp)->maxicount = XFS_FSB_TO_INO(mp, icount);
    333         } else
    334                 M_IGEO(mp)->maxicount = 0;
    335 
    336         /* Update secondary superblocks now the physical grow has completed */
    337         error = xfs_update_secondary_sbs(mp);
    338 
    339 out_error:
    340         /*
    341          * Increment the generation unconditionally, the error could be from
    342          * updating the secondary superblocks, in which case the new size
    343          * is live already.
    344          */
    345         mp->m_generation++;
    346         mutex_unlock(&mp->m_growlock);
--> 347         return error;
    348 }

regards,
dan carpenter
