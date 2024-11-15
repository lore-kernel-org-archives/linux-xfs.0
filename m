Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 016B218BC36
	for <linux-xfs@vger.kernel.org>; Fri, 15 Nov 2024 09:10:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731661811; cv=none; b=ixiGH/tjlcKcs67wpbFCBA48V2oGDdQB/D9fnvna8zC/zBGEGBIwhprpndnvPzXCBzYUfTTCrDMqVLjOhCvpwkp+lsPabkg5OGKuHggFIlPrIAB3S8bOh4ZODYQ/cUJAe4MvvoJej4LIyrCVy44Dzw2l5PDBoZ+6bKqmIJzL9qc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731661811; c=relaxed/simple;
	bh=JprPG9bBe6n2IC48X1cBeM9MJEuZ8eUnZ8uBihV514w=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=JcQSurBdWk3uA+Ss9I+PKOQJwWN/iwW8NOyGbaw67NGxflWC7ED/haJYXG9sFdR8VCbIfQ9Sz/aRzFYYsACiWkF3UbwUQ0He4vWMRcjXPuvsDz7e5KUk28pCVVML5tkyCzDR24oiSJ6tC+YHUp8bYL8R10mBO98cHNgHBYf7a3Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=roMal1RN; arc=none smtp.client-ip=209.85.128.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="roMal1RN"
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-431ac30d379so13151845e9.1
        for <linux-xfs@vger.kernel.org>; Fri, 15 Nov 2024 01:10:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1731661808; x=1732266608; darn=vger.kernel.org;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=5vhvDtRopXHPlFESh70mDjrz60yPx72OebYVfi0/Bwk=;
        b=roMal1RNfOb6e/erG3BzY9jWTWCOOGrRDUt3p7k0jd31l1m0ts0BS8B5oBNRsgQVEn
         J/QHVejrUp12Cp/T801gUw2f8RNRhEfu6X4ybhFkTpqRe8Ujn95pWjG6dkPjYlATk8ck
         VqY9YLeKtPNLRSGPNIXBNASTw03UAOVIC5/NtIQWc1kGhkpXxS47r8H/owulZe10SxHM
         z5ORNSBkl0SShAi7yEdzhd2wt+e+CvwaVFoY2utTTAvwl8YBpfvClLZzClSzv/qgG+kq
         o7hzYQXVyLfNkvvgQyq4NfwHoWazRtapsMC9AvDeUUNhOs6GYQEopUZpcl2iIOv+uF6c
         ANFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731661808; x=1732266608;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=5vhvDtRopXHPlFESh70mDjrz60yPx72OebYVfi0/Bwk=;
        b=GK/k+6JsdBdsSDnlejnbHRzU2THabAidShuXEki4x43+PPH6lS9qyytnwQo8mXTGPz
         7RovibgmsD2oyJgIZ4x40ERilMr0Q415qil0IYxni9UQP4XFlb4FhJQvcvbxS1zw/aip
         zZ6plr79uGq3WKldOXBO2riVHi6bm/A6JxB665v3aHRE7winsRYb5EmfSuqDiIdQDafr
         TT4mKb2dh5hWS3+2EF+AfOIobZ5NUbxxcKpEWOuzzei/xoPAnjj7r8wsZE9phtPTD7KV
         O5jSf2lGD/k4HVeWdwpyfEADHGMPBPscNzz3PM986Wo8lvZ46Ap9bCVLNgNIDavR5/aO
         hilQ==
X-Gm-Message-State: AOJu0YxOEh5X5LG+rdylDcrDWPUT8cq2sUprOSBI/zcP71+XIjl0CRdt
	CGLD0Pl4DijhVvUTgYYQh4J/LVr+aGBwFikTizrT2jE5bIz91CToSA++tErjIrg=
X-Google-Smtp-Source: AGHT+IFRRwm6q5UbOuxJ2dnytS6au9zHBwL7o1R2q673GSu4g/3y986HLfDP4ClAHbTHH+R0xqj3ig==
X-Received: by 2002:a05:600c:46c3:b0:431:40ca:ce44 with SMTP id 5b1f17b1804b1-432df7906e3mr15601925e9.30.1731661808347;
        Fri, 15 Nov 2024 01:10:08 -0800 (PST)
Received: from localhost ([196.207.164.177])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-432da29ffe9sm51475385e9.44.2024.11.15.01.10.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Nov 2024 01:10:07 -0800 (PST)
Date: Fri, 15 Nov 2024 12:10:04 +0300
From: Dan Carpenter <dan.carpenter@linaro.org>
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org
Subject: [bug report] xfs: support creating per-RTG files in growfs
Message-ID: <9c8c3f8e-80c0-4d78-8cc8-1e4d055452ab@stanley.mountain>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hello Christoph Hellwig,

Commit ae897e0bed0f ("xfs: support creating per-RTG files in growfs")
from Nov 3, 2024 (linux-next), leads to the following Smatch static
checker warning:

fs/xfs/libxfs/xfs_rtgroup.c:499 xfs_rtginode_create() warn: missing unwind goto?

fs/xfs/libxfs/xfs_rtgroup.c
    467 int
    468 xfs_rtginode_create(
    469         struct xfs_rtgroup                *rtg,
    470         enum xfs_rtg_inodes                type,
    471         bool                                init)
    472 {
    473         const struct xfs_rtginode_ops        *ops = &xfs_rtginode_ops[type];
    474         struct xfs_mount                *mp = rtg_mount(rtg);
    475         struct xfs_metadir_update        upd = {
    476                 .dp                        = mp->m_rtdirip,
    477                 .metafile_type                = ops->metafile_type,
    478         };
    479         int                                error;
    480 
    481         if (!xfs_rtginode_enabled(rtg, type))
    482                 return 0;
    483 
    484         if (!mp->m_rtdirip) {
    485                 xfs_fs_mark_sick(mp, XFS_SICK_FS_METADIR);
    486                 return -EFSCORRUPTED;
    487         }
    488 
    489         upd.path = xfs_rtginode_path(rtg_rgno(rtg), type);
    490         if (!upd.path)
    491                 return -ENOMEM;
    492 
    493         error = xfs_metadir_start_create(&upd);
    494         if (error)
    495                 goto out_path;
    496 
    497         error = xfs_metadir_create(&upd, S_IFREG);
    498         if (error)
--> 499                 return error;

I think this should go to out_cancel?  I'm not totally sure.

    500 
    501         xfs_rtginode_lockdep_setup(upd.ip, rtg_rgno(rtg), type);
    502 
    503         upd.ip->i_projid = rtg_rgno(rtg);
    504         error = ops->create(rtg, upd.ip, upd.tp, init);
    505         if (error)
    506                 goto out_cancel;
    507 
    508         error = xfs_metadir_commit(&upd);
    509         if (error)
    510                 goto out_path;
    511 
    512         kfree(upd.path);
    513         xfs_finish_inode_setup(upd.ip);
    514         rtg->rtg_inodes[type] = upd.ip;
    515         return 0;
    516 
    517 out_cancel:
    518         xfs_metadir_cancel(&upd, error);
    519         /* Have to finish setting up the inode to ensure it's deleted. */
    520         if (upd.ip) {
    521                 xfs_finish_inode_setup(upd.ip);
    522                 xfs_irele(upd.ip);
    523         }
    524 out_path:
    525         kfree(upd.path);
    526         return error;
    527 }

regards,
dan carpenter
