Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EBD71DFE24
	for <linux-xfs@vger.kernel.org>; Wed,  9 Oct 2024 15:13:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728486828; cv=none; b=nF0vujCFWFz++t+nbowpMHR7OHLPoXsmO64cfPYvot3P3jdVusKtgBT8PHAoedGTW60jhgEc+EPIZluFSOeinapVeOm/uDZos9Z6y4e39tvSWCCl1pBowbr38uJ3rVt1lM72BY2sWONkeKV8DNWS1c5DDp6xKPhN5THeRT3sp0Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728486828; c=relaxed/simple;
	bh=HGSYIhTq+9Dhgtng1mFELiXoEplslp0WsiRxNZknf1A=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VrC9EY5Zfb7lmbTzF3qC5s8Ne8/sB1wvUmydAkJiBYtBBFaUiUWRrp7b+xueYZ4SEtK4WwHLcHeHXPma46qG/56cBaC8mCDLJ5aeXsHl71YSXXHjV67kdP2qOarAQukDI7r0T+98ZrHPcc2XdKrOvKOvFGqHP0pxPCZ8O+m7B2w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=D9qwxsVa; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="D9qwxsVa"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1728486824;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=c1oIOYnBaK7+WCGWo1vzRwaiwxVi0iBNUdJsU3Hiu90=;
	b=D9qwxsVabqI9qigFR8V5fHPWBrLzmS+mcRKFVqA32XKVHdtOLtZeTwGPYtPhHeHbzRQ28O
	WajhNE1iHqydzwJC+A+F9o8IFI1AcEhPofMHxy98gzH4ERqv+pHTzSJ95VMYeI0xFUvjCr
	gaD/JXTkvSu/oPwuhICUfuwUTriZq/o=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-16-lI2BqmNrOrK-0nt0L5AdNQ-1; Wed,
 09 Oct 2024 11:13:38 -0400
X-MC-Unique: lI2BqmNrOrK-0nt0L5AdNQ-1
Received: from mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 58E611955F43;
	Wed,  9 Oct 2024 15:13:35 +0000 (UTC)
Received: from bfoster (unknown [10.22.32.133])
	by mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 3CBAB195607C;
	Wed,  9 Oct 2024 15:13:34 +0000 (UTC)
Date: Wed, 9 Oct 2024 11:14:49 -0400
From: Brian Foster <bfoster@redhat.com>
To: Christoph Hellwig <hch@lst.de>
Cc: zlang@kernel.org, djwong@kernel.org, fstests@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: test log recovery for extent frees right after
 growfs
Message-ID: <Zwad6T5Ip5kGtWDL@bfoster>
References: <20240910043127.3480554-1-hch@lst.de>
 <ZuBVhszqs-fKmc9X@bfoster>
 <20240910151053.GA22643@lst.de>
 <ZuBwKQBMsuV-dp18@bfoster>
 <ZwVdtXUSwEXRpcuQ@bfoster>
 <20241009080451.GA16822@lst.de>
 <ZwZ4oviaUHI4Ed6Z@bfoster>
 <20241009124316.GB21408@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241009124316.GB21408@lst.de>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.15

On Wed, Oct 09, 2024 at 02:43:16PM +0200, Christoph Hellwig wrote:
> On Wed, Oct 09, 2024 at 08:35:46AM -0400, Brian Foster wrote:
> > Ok, so then what happened? :) Are there outstanding patches somewhere to
> > fix this problem? If so, I can give it a test with this.
> 
> Yes, "fix recovery of allocator ops after a growfs" from Sep 30.
> 

Thanks. This seems to fix the unmountable fs problem, so I'd guess it's
reproducing something related.

The test still fails occasionally with a trans abort and I see some
bnobt/cntbt corruption messages like the one appended below, but I'll
leave to you to decide whether this is a regression or preexisting
problem.

I probably won't get through it today, but I'll try to take a closer
look at the patches soon..

Brian

 ...
 XFS (vdb2): cntbt record corruption in AG 8 detected at xfs_alloc_check_irec+0xfa/0x160 [xfs]!
 XFS (vdb2): start block 0xa block count 0x1f36
 XFS (vdb2): Internal error xfs_trans_cancel at line 872 of file fs/xfs/xfs_trans.c.  Caller xfs_symlink+0x5a6/0xbd0 [xfs]
 CPU: 5 UID: 0 PID: 8625 Comm: fsstress Tainted: G            E      6.12.0-rc2+ #251
 Tainted: [E]=UNSIGNED_MODULE
 Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.16.3-1.fc39 04/01/2014
 Call Trace: 
  <TASK>
  dump_stack_lvl+0x8d/0xb0
  xfs_trans_cancel+0x3ca/0x530 [xfs] 
  xfs_symlink+0x5a6/0xbd0 [xfs]
  ? __pfx_xfs_symlink+0x10/0x10 [xfs]
  ? avc_has_perm+0x77/0x110
  ? lock_is_held_type+0xcd/0x120
  ? __pfx_avc_has_perm+0x10/0x10
  ? avc_has_perm_noaudit+0x3a/0x280
  ? may_create+0x26a/0x2e0
  xfs_vn_symlink+0x144/0x390 [xfs]
  ? __pfx_selinux_inode_permission+0x10/0x10
  ? __pfx_xfs_vn_symlink+0x10/0x10 [xfs]
  vfs_symlink+0x33e/0x580 
  do_symlinkat+0x1cf/0x250
  ? __pfx_do_symlinkat+0x10/0x10
  ? getname_flags.part.0+0xae/0x490
  __x64_sys_symlink+0x71/0x90
  do_syscall_64+0x93/0x180
  ? do_syscall_64+0x9f/0x180
  entry_SYSCALL_64_after_hwframe+0x76/0x7e 
 RIP: 0033:0x7fcb692378eb 
 Code: 8b 0d 49 f5 0c 00 f7 d8 64 89 01 b9 ff ff ff ff eb d3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 00 f3 0f 1e fa b8 58 00 00 00 0f 05 <48> 3d 00 f0 ff ff 77 05 c3 0f 1f 40 00 48 8b 15 11 f5 0c 00 f7 d8
 RSP: 002b:00007ffc547e52e8 EFLAGS: 00000206 ORIG_RAX: 0000000000000058
 RAX: ffffffffffffffda RBX: 000000003804a200 RCX: 00007fcb692378eb
 RDX: 0000000000000000 RSI: 0000000038049200 RDI: 000000003804a200
 RBP: 0000000038049200 R08: 000000003804a440 R09: 00007fcb69307b20
 R10: 0000000000000270 R11: 0000000000000206 R12: 000000003804a200
 R13: 00007ffc547e5450 R14: 0000000078ba5238 R15: 00007fcb6912c6c8


