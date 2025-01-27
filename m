Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48D90C2D1
	for <linux-xfs@vger.kernel.org>; Mon, 27 Jan 2025 12:02:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737979364; cv=none; b=H1Ru28x4uAUq7aDmeGMjfiNm2VwrclP4LkRta3SbZ3eh1/t+jVPAe5zmxRdK0YF6v9zhxShTEW12k3yZK08ZY0nf5tKtjWru6PdikfvM4I5JejxSFpJ/NXunrw2PVC1vDUt4/PwuacFTNI8ONKUYAT3wCMD5nuiFG/fZRTw1758=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737979364; c=relaxed/simple;
	bh=Ou2+SdX3dcoD7tgA5vsH2iT6EPFSyo4uZq4YmSRXdsk=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=qfUUajtmb3B6xr85lOL88+m0+KvF/xZtg1urHaAolks/ZXS4VPkzp6xijwvz+QY2/hxNq7CDsEYZR3cBS0mkn/QZO8eMUiQBgyddKRzWUUsd8YT8IQiNPkmw8kDk+2/7fDvj2Dsv/cHJO0k/SgPRUSk13/SeNrXxpVEW4zREdXM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=FqpCefrm; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="FqpCefrm"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1737979361;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type;
	bh=YCbXEHoaXwjfy/72nTqaU8bQPPg85HvyXHNJLwqGBh0=;
	b=FqpCefrmAwBtH7k5+G6tlMAUHUWJ8OV4PxAqyrIu96NaE2cTDsS9++wSEOFXLCE6imILLn
	7TifHrVTRY5Yow055dQSIj/Q2zzhjAY/e/+3W1OYKXmdIbcqhMWU/jaqVym/bCHBMxeTQ7
	mKfgzLe+v3acYwcbj01LWoo54XRf4Mo=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-670-W88HLWfTMxON1Uq0n35jyw-1; Mon, 27 Jan 2025 07:02:37 -0500
X-MC-Unique: W88HLWfTMxON1Uq0n35jyw-1
X-Mimecast-MFC-AGG-ID: W88HLWfTMxON1Uq0n35jyw
Received: by mail-ej1-f69.google.com with SMTP id a640c23a62f3a-aa66f6ce6bfso340285566b.2
        for <linux-xfs@vger.kernel.org>; Mon, 27 Jan 2025 04:02:37 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737979356; x=1738584156;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=YCbXEHoaXwjfy/72nTqaU8bQPPg85HvyXHNJLwqGBh0=;
        b=Mqr8Ng4IRnXza/1Vze/iUe/VHnhRIQ/k8c9THcBfIvDcfwp3WEErAfEc8anmMXspd3
         V/R0DzGstlMXDbwvFTtTiC1eaokssETuAajARAxwdRvw5fWbQBEdnKF+lbUNKieweKI2
         YYS+TK/+1Fg6sZwVlPeMHysV7or1hyqXTCLHge0HhXe0A2Qbff9hnjlI0iM3QIHC3Ncp
         9tIb3ZIRAGpGSrBd3K1d+MITYRhO6walSO03iZT4VfE2+lEzuu5q9vdcWiwottlUD19N
         rvBft6beYpL5K/SOEFw9Ct9TZR6ckTNyusvbhCMl8B7VzcsT56HrujOlCr+Xy0D5cxoA
         0LdQ==
X-Gm-Message-State: AOJu0YybDC1VaJzS5Yz4POaodul636VnOqCRvPQRKa3ffQRIHWXd0ftQ
	9YrHsC58dW316v0ky2lXLrnpyQHby8/0PdtNY4jlGGAZF5Uh3owtd7YSkEjFGhUKIS5LiZnRjlQ
	tEfA6HzI5Cd2Efgtl+wH9ews9tfp+Eow2C1zDj7BhQxI6LIETdjXXioO2wpVOOdM0JBLQNUpA9G
	HsiWDc2hY7ScfiC/B6g0Dhti0qjf0LXnyarLbJ0jPh
X-Gm-Gg: ASbGncsTGrnWZ+aNkl6bkEnEnORiQKOUHQFAzl+iR0IL2OecK0WXorRioM5RxnWUB/M
	xbHtn45ZyurVHjZgUA1jDQrkzJ5j1A+4IjkAWjWBO/IYFPLuNehs1390VAFB9Gwhy1O6gW08iQE
	vpA/dip7kSFz3R10IYKOjIOv4Fqmk9DF47WamVOmEtwSNz5FiAclZGzTqI3WdIZXlJMJMSw7o+R
	VbC65x0Wp88w1lIuoMrL4R7L40wNVOT6RsNnNeIQXBfvIVO5o1yBHYYAKv4Byjdnngcr3FkZcER
	UX/Da9c3TQMrDPBANahyXfHx
X-Received: by 2002:a17:906:7316:b0:ab3:76fb:96ab with SMTP id a640c23a62f3a-ab38b48e1a5mr3974903966b.57.1737979356276;
        Mon, 27 Jan 2025 04:02:36 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFA6Fdyv867hvs0jR8TMaDVBYeqtQ+9j+yUBvzUop6Qd5Ciu+vuI6exvBFNPwNbdPztUgZQ2g==
X-Received: by 2002:a17:906:7316:b0:ab3:76fb:96ab with SMTP id a640c23a62f3a-ab38b48e1a5mr3974899766b.57.1737979355760;
        Mon, 27 Jan 2025 04:02:35 -0800 (PST)
Received: from thinky (ip-217-030-074-039.aim-net.cz. [217.30.74.39])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ab675e12090sm569274766b.29.2025.01.27.04.02.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Jan 2025 04:02:35 -0800 (PST)
Date: Mon, 27 Jan 2025 13:02:34 +0100
From: Andrey Albershteyn <aalbersh@redhat.com>
To: linux-xfs <linux-xfs@vger.kernel.org>
Cc: aalbersh@kernel.org, djwong@kernel.org
Subject: [ANNOUNCE] xfsprogs: for-next updated to 3eb8c349c5cd
Message-ID: <gvdzwfh42prvlr3qr3yqpgasqc4o6ol4ahuf2wo22si4xgzj4g@bobu3e3ymkgo>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hello.

The xfsprogs for-next branch, located at:

https://git.kernel.org/pub/scm/fs/xfs/xfsprogs-dev.git/refs/?h=for-next

Has just been updated.

Patches often get missed, so if your outstanding patches are properly reviewed on
the list and not included in this update, please let me know.

The new head of the for-next branch is commit:

3eb8c349c5cda8f95ef390b1b08cc05328896ad8

9 new commits:

Chi Zhiling (1):
      [3eb8c349c5cd] xfs_logprint: Fix super block buffer interpretation issue

Darrick J. Wong (8):
      [741eb9b6f9a8] xfs_db: fix multiple dblock commands
      [c08fe89d4441] xfs_repair: don't obliterate return codes
      [fe9efcb37d1f] libxfs: fix uninit variable in libxfs_alloc_file_space
      [c414a08700c5] xfs_db: improve error message when unknown btree type given to btheight
      [93711a36ed54] mkfs: fix parsing of value-less -d/-l concurrency cli option
      [43025caf770e] m4: fix statx override selection if /usr/include doesn't define it
      [e1d3ce600d70] build: initialize stack variables to zero by default
      [34738ff0ee80] mkfs: allow sizing realtime allocation groups for concurrency

Code Diffstat:

 configure.ac             |   1 +
 db/block.c               |   4 +-
 db/btheight.c            |   6 ++
 include/builddefs.in     |   2 +-
 libxfs/util.c            |   2 +-
 logprint/log_misc.c      |  17 ++----
 logprint/log_print_all.c |  22 ++++----
 m4/package_libcdev.m4    |   2 +-
 m4/package_sanitizer.m4  |  14 +++++
 man/man8/mkfs.xfs.8.in   |  28 +++++++++
 mkfs/xfs_mkfs.c          | 144 +++++++++++++++++++++++++++++++++++++++++++++--
 repair/quotacheck.c      |   2 +-
 12 files changed, 210 insertions(+), 34 deletions(-)

-- 
- Andrey

