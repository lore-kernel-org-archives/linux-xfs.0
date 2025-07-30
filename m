Received: from mail-pf1-f180.google.com (mail-pf1-f180.google.com [209.85.210.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A05DB27726
	for <linux-xfs@vger.kernel.org>; Wed, 30 Jul 2025 02:16:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753841797; cv=none; b=WfVcubpqDot+VdPOM7voBFex+6yxflXKd99Ww0T0g3IGA6Ne4MyfeCf3JwhXysSzrWU8+t028NMBh9BGZtrrId2L+yjuUFYtiMDgimJVGUyUdm65EptMbhc+rJcL4C6oR50AVxpb2aAwoKvXFrzZVgub7iTTZBiTmUaeckFnx/w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753841797; c=relaxed/simple;
	bh=NdcEv9vL9+iqZobzb+0hMtHFQj0Vvu/4WBNU1SU+No0=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=If0d8R5WKym57sJgKst4DS2yM+F9q3bskxiWws5MttFWsJQyD5xz+iuoXmThErrNss5XrsZkXMV+x3L47cjlz1HXjT6bMSmqSel3ns4efAHE2cAirazWxhZQZ8ak37dX+29JxbiBCrzqMP1oqWZAX+90XT9PkI5YENEbzF40CPk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=BTgqaxbf; arc=none smtp.client-ip=209.85.210.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="BTgqaxbf"
Received: by mail-pf1-f180.google.com with SMTP id d2e1a72fcca58-748d982e97cso5756068b3a.1
        for <linux-xfs@vger.kernel.org>; Tue, 29 Jul 2025 19:16:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1753841795; x=1754446595; darn=vger.kernel.org;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=5Bf1JLX3RLa9/lPoTn5oCa2s9cw86Hf3zqIJpbIUcpE=;
        b=BTgqaxbfWLHsWsTZcohhrrSo2BuR8XVaoup3/0AYmqq7LkIHlDs5cV8y0HBdpL/9/t
         u4nH1EPrt8Du4o29+WtqJ1D5TGjQ0/i24VacuCVxc7q927fQDLDDHW799Qgd5aQXGxac
         DJ32k4IiXvtmpRicsH7vs7v+2Txu/3clPMrY64JngeYgpB4o+ZD1df7+eFJ+3/GnO4mB
         3qV1FA7UIaioL3V6+xiRGk89HUYjwlmdguxi4tF32T72Dd6KaulCom8vdrG68UVz9ow/
         Mm8ifyACb4vXNBSGeV8KrOIN++d0mXgmtp/vXx6UTMdnE8O9qJgRUaikOMLliNMEGxXZ
         RxDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753841795; x=1754446595;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=5Bf1JLX3RLa9/lPoTn5oCa2s9cw86Hf3zqIJpbIUcpE=;
        b=sTXlu33Lu2yurrZ9AveOCPXsonw7Pp2RxpeMwx2X3lphBb9wusADNZhFFOqk+/gkG/
         QRIQqVNUIaUc+4FM7C1WXVrxME3F0DnJFIgavqmpgBDRNl5erglDtClh+a9mHdrC08UJ
         fKdFrmIumqmUltVjeuyBmIc5h/G6u0NKVQU/+ODKV3plBWBEd5dEDC+Ia5/3xTnx7e+i
         Dno3Xj/Jzp326Oc0+em77g82YFqZXetPP7BosIg8ZwvNtDMaMXwPQu9pBEIMWn/njl+m
         c/scdOIze76UFuXWU+6N826KoFKAP48y3sA58fs7N/dr8Vc0UzUVAXY1nKvZTCYdKkN9
         lf9g==
X-Gm-Message-State: AOJu0Yy22BRSNRprtFs1D5Gu4YflFbMGeSQ1xjhLf8H8rqVQza1dIKHr
	9OyFhiJJiy7eLCoaqYeVuLxVqqZhR8ULGcm1Fk3JHryek4i6pipTdOlxoW9eeOP3OjuErSXnLsN
	BE2q/
X-Gm-Gg: ASbGncvmQUyAUn8C4HQzv+yXN/IbOSlHTtrNbnqfgfV0EW9uh7f0qoyHA5zK9gIxzxn
	CG23/G+iPd+KMVIgnLXGdJ1hAqdTlss6wQU7tLU1PPAVZ59NWLf4cFsuNWxqG/hId1jrJIhwHqE
	yktTTGICPULRtbnulOmmDslV8iYH2m+npC30D5hFyXD/nQVGJHA87EPLhwO3Do+COgvgQ9gy8+Q
	U6daNHe0I5oPo4Y2a7INTG1e1Ytwd38TBEajtjBpJxTA7sKdMVtkJOFzhVgr0lB6GKmQ55L4pOP
	FwMQtCIOFbtRUslfFTRTdXMDl4D9gV8nbinJ8mFxfsdRQ04/g1sDXa35aMUcdrcyGKhpCOgLfZp
	tQHZ0u7aDq9RnSzvFdBooY43SQByfozXKUqFdx5Wfz8kC/UVPru6tOOdv48XucL2Rbq625JLMUA
	==
X-Google-Smtp-Source: AGHT+IFha5dcHF92WcRMrGk5pjovt09eKJu820EznKEWj5+3hKOvF13ENoP+ay3JJBruSZbV9zvORA==
X-Received: by 2002:a05:6a00:986:b0:747:aa79:e2f5 with SMTP id d2e1a72fcca58-76aae05a757mr2650042b3a.0.1753841794668;
        Tue, 29 Jul 2025 19:16:34 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-64-170.pa.nsw.optusnet.com.au. [49.181.64.170])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7640adfebd3sm9150923b3a.67.2025.07.29.19.16.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Jul 2025 19:16:34 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.98.2)
	(envelope-from <david@fromorbit.com>)
	id 1ugwMp-0000000HOmJ-0pPu;
	Wed, 30 Jul 2025 12:16:31 +1000
Date: Wed, 30 Jul 2025 12:16:31 +1000
From: Dave Chinner <david@fromorbit.com>
To: linux-xfs@vger.kernel.org
Cc: hch@lst.de
Subject: [6.17-rc0 regression] WARNING: CPU: 15 PID: 321705 at
 fs/xfs/xfs_trans.c:256 xfs_trans_alloc+0x19b/0x280
Message-ID: <aImAfw5TLefSY9Ha@dread.disaster.area>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi folks,

Just pulled the latest Linus kernel and running it through
check-parallel on a 1kB block size filesystem throws a lots of these
warnings:

 ------------[ cut here ]------------
 WARNING: CPU: 15 PID: 321705 at fs/xfs/xfs_trans.c:256 xfs_trans_alloc+0x19b/0x280
 Modules linked in:
 CPU: 15 UID: 0 PID: 321705 Comm: kworker/15:9 Tainted: G        W           6.16.0-dgc+ #349 PREEMPT(full)
 Tainted: G   WARN
 Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
 Workqueue: xfs-inodegc/loop124 xfs_inodegc_worker
 RIP: 0010:xfs_trans_alloc+0x19b/0x280
 Code: 00 49 c7 47 20 00 00 00 00 41 c7 07 00 00 00 00 41 80 67 18 fb 41 bc e4 ff ff ff 83 7d d4 00 0f 85 4e ff ff ff e9 5f ff ff ff <0f> 0b e9 b8 fe ff ff 31 ff 48 c7 c6 61 b0 eb 82 48 c7 c2 04 4b e5
 RSP: 0018:ffffc9001b24fd10 EFLAGS: 00010246
 RIP: 0010:xfs_trans_alloc+0x19b/0x280
 RAX: ffff888244cc2000 RBX: 0000000000000000 RCX: 0000000000000000
 RDX: 0000000000000000 RSI: ffff88828f9ee39c RDI: ffff88828f9ee000
 Code: 00 49 c7 47 20 00 00 00 00 41 c7 07 00 00 00 00 41 80 67 18 fb 41 bc e4 ff ff ff 83 7d d4 00 0f 85 4e ff ff ff e9 5f ff ff ff <0f> 0b e9 b8 fe ff ff 31 ff 48 c7 c6 61 b0 eb 82 48 c7 c2 04 4b e5
 RBP: ffffc9001b24fd68 R08: 0000000000000000 R09: ffffc9001b24fd78
 R10: 0000000000343231 R11: ffffffff81abf660 R12: ffff88828f9ee000
 R13: ffff88828f9ee39c R14: ffff88828f9ee000 R15: ffff88828f9ee000
 FS:  0000000000000000(0000) GS:ffff88889a82e000(0000) knlGS:0000000000000000
 CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
 CR2: 0000559141e5a0c8 CR3: 0000000866625000 CR4: 0000000000350ef0
 Call Trace:
  <TASK>
  xfs_free_eofblocks+0x88/0x1b0
  xfs_inactive+0x1ad/0x3b0
  xfs_inodegc_worker+0xaa/0x180
  process_scheduled_works+0x1d6/0x400
  worker_thread+0x202/0x2e0
  kthread+0x20c/0x240
  ret_from_fork+0x77/0x140
  ret_from_fork_asm+0x1a/0x30
  </TASK>
 ---[ end trace 0000000000000000 ]---


I'm also seeing them from inodegc worker threads via:

  xfs_reflink_cancel_cow_range+0x79/0x200
  xfs_inactive+0x188/0x3b0
  xfs_inodegc_worker+0xaa/0x180
  process_scheduled_works+0x1d6/0x400

The warning is:

	WARN_ON(mp->m_super->s_writers.frozen == SB_FREEZE_COMPLETE);

Which indicates that we are doing inodegc on a frozen filesystem.
We should have called xfs_inodegc_stop() from xfs_fs_sync_fs() once
all data modification had been frozen and written back at
SB_FREEZE_PAGEFAULT level....

Ah, just got the same warning from xfs_quota_normap config, which is
running a 4kB block size filesystem. So it has nothing to do with
the filesystem block size. Looks like a freeze regression, then?

Hmmm - this warning is in code that was modified in this merge
window.  Specifically, commit 83a80e95e797 ("xfs: decouple
xfs_trans_alloc_empty from xfs_trans_alloc") that was merged in the
merge window changes how this specific warning is triggered...

Christoph, looks like this is one for you - these transactions
previously got caught in sb_start_intwrite() before the freeze state
warning check (i.e. modifications get blocked once freeze starts, so
never get to the warning whilst the fs is frozen). The new code
checks the freeze state and emits the warning before the transaction
can (correctly) account/block on freeze state via
sb_start_intwrite().

-Dave.
-- 
Dave Chinner
david@fromorbit.com
