Received: from mail-ej2-f12.google.com (mail-ej2-f12.google.com [74.125.228.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FF78442FC5
	for <linux-xfs@vger.kernel.org>; Mon, 14 Sep 2026 11:54:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.228.140
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789386901; cv=none; b=JhnA11b4pU4ORnNO907PZXQJCBsy+kUACbeRQW1s8X0N+HAkXG9PLc4oSm7JXoSyjk0Nm+ir6UDYxWi6aDoeKBcInnGZkO38u3RqXLNDipL/XcoMFH0i7rAcTLrM6/EpBpFajyLB6l6QKhZJ1LbnCpd6Yws/zHTpf3uI76GnWDw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789386901; c=relaxed/simple;
	bh=ARoRgc1fRZn3/gbxAQEAJUyA+Wh/7Y8KgFHy+DHe3Jc=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=ZskytxXi2lkscTyaTmxkv6XjSYwPT5/GM1cjTMO7dpN111Pb4VLmGk65i8l6MZLMXG24z4GkA5DzbgSVZGV3KN/XHfitcjbSnoYK4MCbx61fSXxNsjusViSZzvPTbM1eStFG7cYfbwiIGVCPFO7L1AylnBSOotvlIpo6yWxL+QU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Ra/5C1Af; arc=none smtp.client-ip=74.125.228.140
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Ra/5C1Af"
Received: by mail-ej2-f12.google.com with SMTP id a640c23a62f3a-c294496989aso331941466b.3
        for <linux-xfs@vger.kernel.org>; Mon, 14 Sep 2026 04:54:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789386898; x=1789991698; darn=vger.kernel.org;
        h=content-disposition:content-type:mime-version:message-id:subject:cc
         :to:from:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=FT4ZDDHCGxklLkWI62DOczYl1mLB7HIPw9zlK80hlSc=;
        b=Ra/5C1Af5rs1LULO2SN02tDjrmKx0Qen9DQD2bClKVcjPR3NBXoei1k55Km4ofQWMY
         mPNefS56kPXc6XdIhDJWpTxoAicnKMnu1mD0ntan6+nf16l6BVZnYxF5El4dk58EPF8W
         XS00P0bh8VgbzzCLt9VkHVktHmJeA4hVKtKXjzQ/BNr3aVIrDJPzFwXJRVWxf5VaMM24
         zahquZcuLWkLGH7zozzqQ9j/pWWut3imNp2YQPJY2Lk/mX1sbviQmaLNrT/MKSF6GLok
         ds+wLrE/DOJqeXKtOq4sDiG95lA/TDzf5RozOm43Q2MWglbbj5xhE69q3RNkFsRbrd94
         R2fg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789386898; x=1789991698;
        h=content-disposition:content-type:mime-version:message-id:subject:cc
         :to:from:date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=FT4ZDDHCGxklLkWI62DOczYl1mLB7HIPw9zlK80hlSc=;
        b=SPh4Ywfe4+zgH/ru+DQcEEDwEhgLOHyoWmlle0IOamAaOPfob3+lv5upQz3Ylmc4Iy
         dOdYLYQdKAOEjNmhMn12wGQRNXGxrNEBKBUZwGN3K+ky4iduP4ZmabRatIr8EjvSZDfu
         HsNtLKXtenDUQaTjZrSLJLB4LVHfA+UXdIFP42wkKoawNs6qcxGCIGcJ+wau1z04+4GV
         KbPBIJMy5wUrc9e6B5cxfzovwl3/UzgbZyVfP6WMoGWYnm3W0kkE2t0wdNKe1C/NF84M
         Xo0lXL0oE+VfkldADHmWCYo64wYezQ+lIReqFaAI9KNNPGjxiC7fL6uOU39kG9q5Xpzq
         rIdA==
X-Gm-Message-State: AFuF++ldi9BOGIC2apGLXD1ABe9Zde3k51q2ElpE3C4KN87XyecTDbY+
	CGxEMEc7D5FnaWjHeix/wKYh9X7EOwOoClNUn2TZ2EouTnqcm7X06beR
X-Gm-Gg: AYBFou0w16YT8eNNghCOkyuaW9zO9ZZBxvqSp1+Hr8F34O8JMygPZRUOVDTG8hdFPS+
	wP89ERL/TbmXtrU46+b0MbVMHv69ihdeAfyciiQGKO+SZTccU+qp7vCc2jZYMmlN6QVHsTf/HAh
	zd8MPy9bAcYIOxmthghvcs5HNyjhQmViMURQnlCh51p5rXRnqRsdmmzlRhClA4DGnkP5rKgc7vL
	HFZCJI2CGx4OJofk6pGDY1zhvZIgDBy0DqYUPQRpyhywr3HnBNPb+s5he4FWzrD6VClDnfvXUg3
	Nbh+SW+r4ysog9uxvF3oB0ScKa8KATxrJuWx2HnTz5k40kjOAZCzfWO6LosZsq3p2P30MqguO0y
	Rl/r03K0Cl8f/SFujgMX8Dxkhigw4gxp2eESiXBkSM56y202QbsTNBKsQtZQnuKyzJkCkbSDfjY
	TvuszWG1/nx+tIb5Z/8/p+/7coxr7s+akgxyMJ4HxREGzHYusnrpucfqpiA8uWr/+KfnGE
X-Received: by 2002:a17:907:94ce:b0:c29:5326:5a67 with SMTP id a640c23a62f3a-c29b86362c4mr136500466b.13.1789386897623;
        Mon, 14 Sep 2026 04:54:57 -0700 (PDT)
Received: from localhost ([2c0f:3d00:6be:8900:ce5e:9212:ea4b:f30])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c2965c4e8acsm420760466b.5.2026.09.14.04.54.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Sep 2026 04:54:57 -0700 (PDT)
Date: Mon, 14 Sep 2026 14:54:53 +0300
From: Dan Carpenter <error27@gmail.com>
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org
Subject: [bug report] xfs: fix racy open zone caching
Message-ID: <aqfgjXJ8yANKjlwa@stanley.mountain>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hello Christoph Hellwig,

Commit 2d829cc76777 ("xfs: fix racy open zone caching") from Aug 11,
2026 (linux-next), leads to the following Smatch static checker
warning:

	fs/xfs/xfs_zone_alloc.c:823 xfs_get_cached_zone()
	error: we previously assumed 'oz' could be null (see line 813)

fs/xfs/xfs_zone_alloc.c
    790 static struct xfs_open_zone *
    791 xfs_get_cached_zone(
    792         struct xfs_inode        *ip)
    793 {
    794         struct xfs_open_zone        *oz;
    795 
    796         rcu_read_lock();
    797         oz = VFS_I(ip)->i_private;
    798         if (!oz)
    799                 goto out_unlock;
    800 
    801         /*
    802          * GC only steals open zones at mount time, so no GC zones should end up
    803          * in the cache.
    804          */
    805         ASSERT(!oz->oz_is_gc);
    806 
    807         /*
    808          * Drop the old cached open zone if it is full.
    809          */
    810         if (oz->oz_allocated == rtg_blocks(oz->oz_rtg)) {
    811                 spin_lock(&ip->i_flags_lock);
    812                 oz = VFS_I(ip)->i_private;
    813                 if (oz && oz->oz_allocated == rtg_blocks(oz->oz_rtg)) {
                            ^^
imagine oz is NULL

    814                         VFS_I(ip)->i_private = NULL;
    815                         spin_unlock(&ip->i_flags_lock);
    816                         xfs_open_zone_put(oz);
    817                         oz = NULL;
    818                         goto out_unlock;
    819                 }
    820                 spin_unlock(&ip->i_flags_lock);
    821         }
    822 
--> 823         if (!atomic_inc_not_zero(&oz->oz_ref))
                                          ^^
then this will crash

    824                 oz = NULL;
    825 out_unlock:
    826         rcu_read_unlock();
    827         return oz;
    828 }

This email is a free service from the Smatch-CI project [smatch.sf.net].

regards,
dan carpenter
