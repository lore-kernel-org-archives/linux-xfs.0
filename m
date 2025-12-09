Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6F8826F297
	for <linux-xfs@vger.kernel.org>; Tue,  9 Dec 2025 16:41:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765298465; cv=none; b=ZaIdnfUwrSrHcZhunKdOxHs5LsYMuVo1Di7Bv0S6IcKwaNrzPfykLhBBLcMTzZB0AoI7JiW9bTkMca+q5nvH6L5J4/n8tZp4S8YnYgbcCvhLEbVyMJqBL2xTCrFKSj52YNPXzm41e3e4EBv3bHKRavaEO/ks3BDk4wl7souMp6w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765298465; c=relaxed/simple;
	bh=Ncfe2qvI/tviugqAdZwmu4MYc7J0ebvsLPLAZCq0vqk=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=Lkf4JhBO1TefKf3VEIq9HwNWHA6nBFUf+O3Zcss0ayWjaedr3iXwH/4cTUrRbWKKdUsT0FeXrLCccN/RSNbko8axgo9NCQHMqtYRZfJG6WLiRddyTPU0660Y4Mq323dqCUxKOkxJc1O8WD4uqwPvcdgAzT11PPmj2UmvHOBoCUg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=N//G8k6m; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=gY7Sf9/5; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="N//G8k6m";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="gY7Sf9/5"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1765298462;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type;
	bh=j2L0apOZ3jdXK3W1kCNFWI/bZbScm9nxXGr6mu152EY=;
	b=N//G8k6ms1Rx78fM+JflrTdeT0/0J3opWUl+Etxd9F7Nr4L7EffdZGn6MDE5u/p4T+jDHj
	yxHuXBtdRHviWL9T8DaVCNhVCNC+2+LAQdGLSMu/9szqCpg4pMiKhEui/5bQBnTzGxWDgh
	Vlqj/HFpRDNt1Drv7c/RnDuUg/7E0Y0=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-584-9ygC86hEM1edDm53u-3z8g-1; Tue, 09 Dec 2025 11:41:01 -0500
X-MC-Unique: 9ygC86hEM1edDm53u-3z8g-1
X-Mimecast-MFC-AGG-ID: 9ygC86hEM1edDm53u-3z8g_1765298460
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-47918084ac1so52019855e9.2
        for <linux-xfs@vger.kernel.org>; Tue, 09 Dec 2025 08:41:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1765298460; x=1765903260; darn=vger.kernel.org;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=j2L0apOZ3jdXK3W1kCNFWI/bZbScm9nxXGr6mu152EY=;
        b=gY7Sf9/51NT/M6voLIys07jewvJUlI0Lenv9S3739FdYp/wgUIlIOAhno6kCgpQ+9M
         W6fDqPvN7yjwWwiqFIeVRltYapiBDdTbvCqnv91vSvA8jhWPbunlJMGrsUL5NbLcFv6M
         8n56gTsugTy2G5niOJa9pD+BItka9Q3iWOiYYJ9fclqwxNw80BNaIewcXeCsevtyxpTa
         l8EIrDe/Upw69C6QARVOfMfq+9LNGCpHhrCWWzNZNR+yHNQ7E0b4lae/QnRNLMw4wE2s
         jRADa/oIwH/DoYLYZRrIXsqvhZgw1cDNf8qewmv5Y285/FSy5RxrC73icyqZD/5sULmO
         nacA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765298460; x=1765903260;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=j2L0apOZ3jdXK3W1kCNFWI/bZbScm9nxXGr6mu152EY=;
        b=JDinAWwif51lvrV+EFp+Nco0AP6JBLxjnRUvvJf69rcQyvYvCMI0cR/xtTnT5TGKXV
         CwJt8WIv2aEfcWyka+R9U9WzgsqaS8IoUkNhtvr/ILo9b4XBNJlzjIwyprQGuCZbzZ07
         QiKYQDXngD5uJ9LcGWs/z+ZAdj9dHT6rnVK+sXQieaz8SXXPwo90f4MczE5OlAqGg23M
         sahGNgZj093/WYozsFIXDdEIKVc41h1rox7N/EVGjQ3z/sxuqiRzY/BxzEktw/jFdmaE
         u1OrzjZu1zZ8N0HW7QC5lufCuI66BysE0ZiEM9CNh3ytNMQ4BVumix23VDca0sDgCvFF
         6cFw==
X-Gm-Message-State: AOJu0Yzzpq820+7gUg+P+hZzftrE5mxgsj50osjYiQ7PpbK1YR4eFycd
	C5HWpQh6WZp8kWZEwfSY8VN5CjcjQ4yPZcKlxnNRYHf0NfBxd4W0s5i42tXd3lJ8WkyLdbxLEoH
	WW5yhBslGmTTZDHycN7S/zgqHQmZdFAQKpnWcroiUJhDk/RPhJW93TJBNFtoo5OlBQ/dgbOT2x2
	B6SsewvMsheYBaqYsWp3CG5bLZQYSNAAlFUSfU8n2lk6zu
X-Gm-Gg: ASbGnctEO4UqA/PAhyj9Rn2gayUaMy2h88W8aBjkBqlYUWgYC0q2S7wicmbnwQfiXXU
	HuAqhNfomVMWNSCkvNaxCEu5dqMjWNI2hqnKU1q5z51kx2xfTzQQueMk18iIu9jUOKxlztYldu9
	hL0gOc9JMWTAgdrxIq1/RiBW4lyJZ+9bBJmSQt7rfrARERaQOQ4EIuibBOnkdGGoHopF+8TtMKf
	WgnWqZXHgGwtBz6L60vxdb6qYluiyw+9aDX1lFBvKH86z32VmUqTbU0b8WmAf1ztNYNVLazL6OP
	GOlr+j4VUhvvMB/Z22XH2VjQzfhpnvdxA6KtOnwXu8XiBirHRb+Zs1xXmH4PVXQfo1PpDXHFNUI
	=
X-Received: by 2002:a05:600c:1ca4:b0:477:a978:3a7b with SMTP id 5b1f17b1804b1-47939e27832mr141901805e9.22.1765298459766;
        Tue, 09 Dec 2025 08:40:59 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFRzryXlrjztoYvyLl2qyEIfR3xoLBRpok5jajpEIr2aVITatxNjAXq4W091An6IIbrpo0cZQ==
X-Received: by 2002:a05:600c:1ca4:b0:477:a978:3a7b with SMTP id 5b1f17b1804b1-47939e27832mr141901425e9.22.1765298459298;
        Tue, 09 Dec 2025 08:40:59 -0800 (PST)
Received: from thinky ([217.30.74.39])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-47a7d696a57sm47862695e9.13.2025.12.09.08.40.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Dec 2025 08:40:58 -0800 (PST)
Date: Tue, 9 Dec 2025 17:40:58 +0100
From: Andrey Albershteyn <aalbersh@redhat.com>
To: linux-xfs@vger.kernel.org
Cc: djwong@kernel.org, hch@lst.de
Subject: [ANNOUNCE] xfsprogs: for-next updated to fe1591e7d03c
Message-ID: <cx2opu3kjsxfplkum7cqgupd34u5rili5yn4dsrsyckkllztct@g33npmtk77fh>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi folks,

The xfsprogs for-next branch in repository at:

	git://git.kernel.org/pub/scm/fs/xfs/xfsprogs-dev.git

has just been updated.

Patches often get missed, so if your outstanding patches are properly reviewed
on the list and not included in this update, please let me know.

The for-next branch has also been updated to match the state of master.

The new head of the for-next branch is commit:

fe1591e7d03c3a3ede60df079936b9002fa314dd

New commits:

Darrick J. Wong (2):
      [54aad16b4b9b] mkfs: enable new features by default
      [fe1591e7d03c] mkfs: add 2025 LTS config file

Code Diffstat:

 mkfs/Makefile      |  3 ++-
 mkfs/lts_6.18.conf | 19 +++++++++++++++++++
 mkfs/xfs_mkfs.c    |  5 +++--
 3 files changed, 24 insertions(+), 3 deletions(-)
 create mode 100644 mkfs/lts_6.18.conf

-- 
- Andrey

