Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DF1E54735
	for <linux-xfs@vger.kernel.org>; Mon, 20 May 2024 11:48:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716205710; cv=none; b=UWm1miQxgoCnk7xJwRRB85qVTN+GMZFdQ+cHzxUJkZ5mAapYYGL0+QBMpyG3Iam+nIyApKrw4RvhYy1RO61VN7v28mjCIgf/Ymho9fTDR8yGX9SsPLWolubOD6fLzaLvrZmauCHVp1Mu9dw+YkI6ADw+pTAPe4F+YIfQTE8h0Gg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716205710; c=relaxed/simple;
	bh=Q6m2UQYpRDd0hg/cRH5Bpm3YH4T0bgJFudX++s8qyBM=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Content-Type; b=am6psOKloaGMR6nEJpvsswJBQTtrGW2uBD6Khph69JWM3pLHk811SRO+m618RHmgOk7S0/+OFc64OqkWg8XhfbpPq7FayLH0nx/1SnqydIw9wrRM1L5tf6T9wMWuUtbKA+EuqSrt61uYGh7LzDjR81W5wj3lnCWnRrFjfQYF+K8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=hFwSBYzG; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="hFwSBYzG"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1716205708;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type;
	bh=NGeZ6RpbiUrV4GdTR0tiQ5IN2bFP8h8yymwDQ6mW5UA=;
	b=hFwSBYzG1lG72OTFcAsEdG5YdQ/ugdMYUFGuCkISzJlOIK4k2X69TUpxqioYLjNykJm5JP
	AI4cJS5PeTRZiDpm7OEFHS0ZCfU2qPRbz0teEncKYDPOe9B2I6lT255UesEmsYS62cLmEK
	X2sjLw7Asy92zN/LpZMe+TAkYUb83qE=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-694-eBzV-dgPMp6i6qRtbYMhCw-1; Mon, 20 May 2024 07:48:26 -0400
X-MC-Unique: eBzV-dgPMp6i6qRtbYMhCw-1
Received: by mail-ej1-f71.google.com with SMTP id a640c23a62f3a-a59a0014904so670765266b.2
        for <linux-xfs@vger.kernel.org>; Mon, 20 May 2024 04:48:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716205705; x=1716810505;
        h=to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=NGeZ6RpbiUrV4GdTR0tiQ5IN2bFP8h8yymwDQ6mW5UA=;
        b=t9SBzTsgjd3J7G/lGJzgTCy2dan7V671iUEZGcNA4QxtA4VSG6yV/wmDjR75kIQg/e
         OMax/frSBjjYMjgzqEKpzziaNylYiFplYDYqVTe0HIEEL11Vr50UDyS4BzklOa5wrCRC
         XZhionUpYNAjXJ112u/ld4ZebRzQPnA+11icnltiuwfIHm+hsXLg88cZngq65oPpZ4Rx
         hzD8mnmazaGM4nopJsGknSFHAyhdo9MQRIqyfHZxx7HML914mEhtNEUZscb86AN+ctlj
         NNCuVc9LGT1RDonGv3FAmr4rVoYy0iABHyyUDvqGdypcpWHb9B/jWQmUxZtCwO3kBXV1
         5CsA==
X-Forwarded-Encrypted: i=1; AJvYcCWAAVQuVcn4paz+cTH8f8bK/qXMS2VG7YNsb2p0zrVJSmh5OF3yiwNhmZ1j2hI1EgzIdU823IuAiWRaXpdCVXs+IO3KXMIH5XsZ
X-Gm-Message-State: AOJu0YzOK/cYk0gsmDW7o826MdMupGun2nSqueu+OvxZ2hQK6rrpAepA
	YP34D/NIdAe7XQUMw+nSZIEqrHyB2vau+qj65grKDHAlVUjarjkbVhIuDSsEpQrze9mqymx6XWl
	gx8BKMNmHncZP/x3amg81LcquUOR5cW+bSUAlu8aNEsm4V8tESp3M8FsJlurpbOnrOaRZyMs2Wd
	2nZytUEGSLI4ZRtfCMm+0FftxGqRj3B1g7
X-Received: by 2002:a17:907:928a:b0:a5a:52d0:52bf with SMTP id a640c23a62f3a-a5a52d0532emr1899166466b.33.1716205705372;
        Mon, 20 May 2024 04:48:25 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEjrYcT8taFeKfaKVw0mvrzpcgH3xAuW5EtmE6/Nsr0rDGtD++8mcqQWSuaGn/R0vgBw1jJtidniMan4y+W9n0=
X-Received: by 2002:a17:907:928a:b0:a5a:52d0:52bf with SMTP id
 a640c23a62f3a-a5a52d0532emr1899165566b.33.1716205705026; Mon, 20 May 2024
 04:48:25 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Guangwu Zhang <guazhang@redhat.com>
Date: Mon, 20 May 2024 19:48:13 +0800
Message-ID: <CAGS2=Ypq9_X23syZw8tpybjc_hPk7dQGqdYNbpw0KKN1A1wbNA@mail.gmail.com>
Subject: [bug report] Internal error isnullstartblock(got.br_startblock) a t
 line 6005 of file fs/xfs/libxfs/xfs_bmap.c.
To: linux-block@vger.kernel.org, linux-xfs@vger.kernel.org, 
	fstests@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Hi,
I get a xfs error when run xfstests  generic/461 testing with
linux-block for-next branch.
looks it easy to reproduce with s390x arch.

kernel info :
commit 04d3822ddfd11fa2c9b449c977f340b57996ef3d
6.9.0+
reproducer
git clone xfstests
 ./check generic/461


[ 5322.046654] XFS (loop1): Internal error isnullstartblock(got.br_startblock) a
t line 6005 of file fs/xfs/libxfs/xfs_bmap.c.  Caller xfs_bmap_insert_extents+0x
2ee/0x420 [xfs]
[ 5322.046859] CPU: 0 PID: 157526 Comm: fsstress Kdump: loaded Not tainted 6.9.0
+ #1
[ 5322.046863] Hardware name: IBM 8561 LT1 400 (z/VM 7.2.0)
[ 5322.046864] Call Trace:
[ 5322.046866]  [<0000022f504d8fc4>] dump_stack_lvl+0x8c/0xb0
[ 5322.046876]  [<0000022ed00fc308>] xfs_corruption_error+0x70/0xa0 [xfs]
[ 5322.046955]  [<0000022ed00b7206>] xfs_bmap_insert_extents+0x3fe/0x420 [xfs]
[ 5322.047024]  [<0000022ed00f55a6>] xfs_insert_file_space+0x1be/0x248 [xfs]
[ 5322.047105]  [<0000022ed00ff1dc>] xfs_file_fallocate+0x244/0x400 [xfs]
[ 5322.047186]  [<0000022f4fe90000>] vfs_fallocate+0x218/0x338
[ 5322.047190]  [<0000022f4fe9112e>] ksys_fallocate+0x56/0x98
[ 5322.047193]  [<0000022f4fe911aa>] __s390x_sys_fallocate+0x3a/0x48
[ 5322.047196]  [<0000022f505019d2>] __do_syscall+0x23a/0x2c0
[ 5322.047200]  [<0000022f50511d20>] system_call+0x70/0x98
[ 5322.054644] XFS (loop1): Corruption detected. Unmount and run xfs_repair
[ 5322.977488] XFS (loop1): User initiated shutdown received.
[ 5322.977505] XFS (loop1): Log I/O Error (0x6) detected at xfs_fs_goingdown+0xb
4/0xf8 [xfs] (fs/xfs/xfs_fsops.c:458).  Shutting down filesystem.
[ 5322.977772] XFS (loop1): Please unmount the filesystem and rectify the proble
m(s)
[ 5322.977877] loop1: writeback error on inode 755831, offset 32768, sector 1804
712
00:00:00

