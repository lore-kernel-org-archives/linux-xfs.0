Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 797C92D0C90
	for <linux-xfs@vger.kernel.org>; Thu,  9 Oct 2025 12:10:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760011809; cv=none; b=poViWbrMLI2WHrM+M+hROn2COws0VxpJ0A/kuVAVcxs4YBgqizsD7JkW8QGlmTuvJxIqqQIuVukCJuKfVm+F4Q6wl/rwKPHMjhaUIiX9963FrTSUNo4AJy8ToqnMboJprZkidPd5RE+5sWVB9UiBby2g4eoZArGFB/9DDGezeOE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760011809; c=relaxed/simple;
	bh=LKOkiNhJHBadzbsEcYIj+ZC1o23tAOG08XAgkIVV20k=;
	h=From:Date:To:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gjrdMD8ejjVjavxP4FpAwkIgCFXR2sPqWhGelNYRUNakMWh2ljQnrcf6MkkKYog0O+QUp5aUgul9d+OyvauF1jF9PYYLxk9ysjQJa1FBBTu/bo1poYWuZy6vik640emsTURkw+X1RjlfiWfpRoLFVJpb8e8uJnowuyD12gz3lKk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=BLjcS3Yt; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="BLjcS3Yt"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1760011804;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=x2BkDIwmuF/9NxXQ31lparW4KvPe9am//1RBh5rIjbY=;
	b=BLjcS3Yt4De0xl0nbBKdEbCg8XW5MBE2ed+QQ9XyFvwGL35M8MTivGypBnh4XikVynVdAQ
	PAHE8+zMS042QVcBv/Frj7smrZ3ADyRFG03M+ciICrTgzyIYbsVv8AT43ixCQLG9L3AEN/
	5yn3DceWDNFrJ7yR6typF0fnk7nwxow=
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com
 [209.85.222.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-306-6sbFVp1_NE2nX8G9CCQyJg-1; Thu, 09 Oct 2025 08:10:03 -0400
X-MC-Unique: 6sbFVp1_NE2nX8G9CCQyJg-1
X-Mimecast-MFC-AGG-ID: 6sbFVp1_NE2nX8G9CCQyJg_1760011803
Received: by mail-qk1-f197.google.com with SMTP id af79cd13be357-856c1aa079bso340402285a.0
        for <linux-xfs@vger.kernel.org>; Thu, 09 Oct 2025 05:10:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760011802; x=1760616602;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:to:date:from:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=x2BkDIwmuF/9NxXQ31lparW4KvPe9am//1RBh5rIjbY=;
        b=VkmK/XSRyDZbt5vJstOsMZR1GQ58L9GEB8o3Qk3xhcb8znO8x5AIA/OkjtRaxn/pll
         celH9b1VeucYwIkHiJUBJpt8NG8X2FAuHIus/5If/IQMgVNDWMbU3oj1xQGiDpBUX3z9
         lUg0Q95S3ddp3oQkHi1RrDWkjCny2kuiI7fSjFtJ59FU4qNAsXRV5ipszn2vRztHO/Cu
         XlmeFFOYJdXdnl1c03EwHZl3JCPKtjiWQNWXdcuRQdRF6l4+21McZLEoJgLN/Iq61cWL
         kiYWENwIP9yr6pbNK9d1G13USzkmWwtjBNMMxI2QNirze9JcgorrpzXD8WUQQilvAqRw
         URog==
X-Gm-Message-State: AOJu0YxvgceLwQwtM02cUOgEXZhRb+wv5OnVpW9IMHfiyAHF4krbGwo/
	HZ82v7qnNE/4pLAQYLqAWUZ5djpxxI1DPz2FVbfdfFeHljTDF4Qcftzqz0LQV45gi+mIUr8W8bQ
	MrYz6gGSstUb+E3dqllP65srkx24bHOuM2Rj1xBSKSU26g8yrJ0IO4KrM1qpCc5tr/pGrTiMn3/
	33gzMgdDb8EEFBHY4My4DBBkd7pKiAje+Jp3Se9c614HFd
X-Gm-Gg: ASbGncsc+4TEvYsLf3CFKAx1a6XHw4tmkFyaazOCJoi1JLkbp3UgqIcyV6j5PJ1m4dw
	hUd5Yz+wy+smQf6I0dEJvg8pZO8/5sxkLpXdlPkKJ/Yx2vI28k5NJV63oLQsPwzao8u6cKMiyBl
	o7ltA0fpKsze3+BE7WbwHmuHfp9MrroWL7jGETekNtjwlmT1PdNmuZQAJ7jARTOUlDs31eWgx0X
	3+u1D4HAFxJIDoqNoxpbUWfq0rxjBcIH7VPRGCySwvBIqSV4Z3+m9rGmP2o4WZYZ1s8S8PjKf/D
	IZKGqXzgtufRZb+kjaE4NcHzVvPHLyMYI3nB5W8NfxVDDXf1qqmM8g==
X-Received: by 2002:a05:620a:2547:b0:852:b230:220e with SMTP id af79cd13be357-8836d7429femr947120885a.2.1760011802006;
        Thu, 09 Oct 2025 05:10:02 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFT+k4TbtAmyF0ebXSv5ub+FNqt3tdKyhrrxMG12hnUSycEXYSF6UM6VPO5QzqTe7xGLL7NJA==
X-Received: by 2002:a05:620a:2547:b0:852:b230:220e with SMTP id af79cd13be357-8836d7429femr947110485a.2.1760011801230;
        Thu, 09 Oct 2025 05:10:01 -0700 (PDT)
Received: from thinky (ip-217-030-074-039.aim-net.cz. [217.30.74.39])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-884a1ca2f1bsm181328885a.33.2025.10.09.05.09.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Oct 2025 05:10:00 -0700 (PDT)
From: Christoph Hellwig <aalbersh@redhat.com>
X-Google-Original-From: Christoph Hellwig <hch@lst.de>
Date: Thu, 9 Oct 2025 14:09:56 +0200
To: linux-xfs@vger.kernel.org, aalbersh@kernel.org, cem@kernel.org, 
	cmaiolino@redhat.com, djwong@kernel.org, hch@lst.de, pchelkin@ispras.ru, 
	pranav.tyagi03@gmail.com, sandeen@redhat.com
Subject: [PATCH v2 8/11] xfs: improve the xg_active_ref check in
 xfs_group_free
Message-ID: <5gged6sn5nogfoxdm4lvzmw2gvo4q52lkaqsfidkbcaqk6shrv@xijsb34677ly>
References: <cover.1760011614.patch-series@thinky>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1760011614.patch-series@thinky>

Source kernel commit: 59655147ec34fb72cc090ca4ee688ece05ffac56

Split up the XFS_IS_CORRUPT statement so that it immediately shows
if the reference counter overflowed or underflowed.

I ran into this quite a bit when developing the zoned allocator, and had
to reapply the patch for some work recently.  We might as well just apply
it upstream given that freeing group is far removed from performance
critical code.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
---
 libxfs/xfs_group.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/libxfs/xfs_group.c b/libxfs/xfs_group.c
index b7ac9dbd8e..03c508242d 100644
--- a/libxfs/xfs_group.c
+++ b/libxfs/xfs_group.c
@@ -170,7 +170,8 @@
 
 	/* drop the mount's active reference */
 	xfs_group_rele(xg);
-	XFS_IS_CORRUPT(mp, atomic_read(&xg->xg_active_ref) != 0);
+	XFS_IS_CORRUPT(mp, atomic_read(&xg->xg_active_ref) > 0);
+	XFS_IS_CORRUPT(mp, atomic_read(&xg->xg_active_ref) < 0);
 	kfree_rcu_mightsleep(xg);
 }
 

-- 
- Andrey

