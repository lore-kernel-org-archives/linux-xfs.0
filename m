Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 919CC23A0
	for <linux-xfs@vger.kernel.org>; Fri, 22 Nov 2024 00:38:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732235905; cv=none; b=Ee1gUZM/dNcgXrHBK99cJLJOsKfCAYoG6iR4L3kl91KHlNElw1a/IPa096w4LC2g2MeYV1HJWkKRTWpkwfTXzmD6++t0kYMx0e0sRjqJwO6n84FDQcVq7Q/O6vTrUcF3Y2DgciAdLel0kdLishMeYFD5m3NtFVl7fw2tLGj/OHg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732235905; c=relaxed/simple;
	bh=CUn/8AoVUdqGe63iXVgn6W8STEsMXtdlSWaKrQ7VBAI=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=TWdFXsqJf37KEJjH9oVN8WnZc8gWyzH+wTcJBCS5iH+MUHDGh9RaDMbgMpwBdw9AaaVVplA2MyLMTD9iBeOj/PywE+VnqGg7j1huJsq1R7qxidU4aLYFoJPS5ODQd6g+V/cgiJVzsj/oZFO0qgxur2g5/nRcvn1OUDfgeWhVQMw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=w/HLSpLD; arc=none smtp.client-ip=209.85.214.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="w/HLSpLD"
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-21288402a26so14937615ad.0
        for <linux-xfs@vger.kernel.org>; Thu, 21 Nov 2024 16:38:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1732235903; x=1732840703; darn=vger.kernel.org;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=euQjyuysLmVUON2mma2PXq1DIxhtsHOVVdn+yDy0Zfk=;
        b=w/HLSpLDYHewvNtLAQb+T0uhjU7WJegHa1Xqn+UVxW9HGZGm2ORT3rxtZeSIv61fdb
         efxED4asEFZ6owJAqv1KshMY4zhEyNCzt90Hh9RHotFNQKR+2NOrt/E6QXTrwGcZGkae
         zltFOiQklcn8AfmQS50uob2KWEkWeyhRyfL/kkGE4XWwrBbe8clL03ZXOnxmlLyZl2oa
         WG5++DHh5t278MSr/k4NjMne+mrd4Tx5QUZGjWrGUfaSGlHrWY5ksJ1F+6zvqiHPYkny
         8XRF84HX/HPzpH6IHYYHYCDU7acPFsVbRlKb865XDOQXr7Acx3UYsJkCb5rNry0wEr7k
         HJ0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732235903; x=1732840703;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=euQjyuysLmVUON2mma2PXq1DIxhtsHOVVdn+yDy0Zfk=;
        b=lmZRiKFBzv6B01JIOwN9OCiCN5L2GhQTkNPp5D3r4q4jVa7Z7+/dcZzaZFKUlrVLgH
         7/zGR4ZjcEj9/H5JQBYoVmFdoVzsX4x7pCmEKh3Y/mMm8axk+TmoLaamVyqUIGvPGpR9
         mYJmKWL+a5P3qiNk4Gsf2u3utKIjLEpu2Ds99vlXIymUAXcafD4OnK0W9tZK1FCU7YpA
         6hf75rFqZUvBIsTpC97+Blv6Sdquu82CmHCYxuNPZwfPbG+ovvvvx7D7YFDnmhtH1SZo
         /lCYjioSatw1e61hqAdEzICqqb1b+mEgOLdvmY7bMtH1Xf6mj7UE39asjum/XFyUrS23
         TgeQ==
X-Forwarded-Encrypted: i=1; AJvYcCXbzNxF+lOP4PAaYstqefgnMfKu8/TDzR8rtUHr7p7rBr9qXAgCyK3e1KxX6Bh3THskzyGnYQKqbjA=@vger.kernel.org
X-Gm-Message-State: AOJu0YzIko4zq8p0tYPJvHjU5sR4h92l+80u8RmxDbYG4k+dLwqc/WV9
	Aj0PkTNZW1NCOOfLkdWR1u4OgxXG/JDNUXJHagfvjuhWZcco0wpAO/k6dKp4Amf6Wdx0+/UI3ga
	0
X-Gm-Gg: ASbGncufixlvnlaPxtk3knyaMqMAXovgoIdwtxMRYfSMAdToLpTMy51Z+FFyzLEIdKB
	Cxbr0YxEsCSizfL4mxGQC9XvlUi9khN2pet3us0q8aRigBQqeD86MIeSpkf7dnufBTU4s8lBcTI
	8fmcYgn45K0S+1GF/cK8+Q61rTWIsxDERF3WA/0mcrkA125sUDNKFKRdwCwpnXiKzRyxpY5kR0R
	gYlMwol7Wje53xey/hyufLgHjRcijtskxduqmEpr48ia6w40DPjgz2RBnZTNIr6/BqfcYE8p/hF
	7JpyljEGggboRBbfxdfuVXcMhw==
X-Google-Smtp-Source: AGHT+IEtsCMA5DkH/hBCDguXTsXBOnpNubY+yrdtT4NJpn3WLPOXSejPTmNhGZqPInD5aFhQ2jONhw==
X-Received: by 2002:a17:902:cecd:b0:212:5b57:80eb with SMTP id d9443c01a7336-2129f21a124mr16235255ad.1.1732235902872;
        Thu, 21 Nov 2024 16:38:22 -0800 (PST)
Received: from dread.disaster.area (pa49-180-121-96.pa.nsw.optusnet.com.au. [49.180.121.96])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2129dbfa1edsm4289335ad.158.2024.11.21.16.38.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Nov 2024 16:38:22 -0800 (PST)
Received: from dave by dread.disaster.area with local (Exim 4.98)
	(envelope-from <david@fromorbit.com>)
	id 1tEHgh-00000001U2R-1kCC;
	Fri, 22 Nov 2024 11:38:19 +1100
Date: Fri, 22 Nov 2024 11:38:19 +1100
From: Dave Chinner <david@fromorbit.com>
To: Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: [6.13-rc0 regression] workqueue throwing cpu affinity warnings
 during CPU hotplug
Message-ID: <Zz_Sex6G6IKernao@dread.disaster.area>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Tejun,

I just upgraded my test VMs from 6.12.0 to a current TOT kernel and
I got several of these warnings whilst running fstests whilst
running CPU hotplug online/offline concurrently with various tests:

[ 2508.109594] ------------[ cut here ]------------
[ 2508.115669] WARNING: CPU: 23 PID: 133 at kernel/kthread.c:76 kthread_set_per_cpu+0x33/0x50
[ 2508.125271] Modules linked in:
[ 2508.131000] CPU: 23 UID: 0 PID: 133 Comm: cpuhp/23 Tainted: G      D W          6.12.0-dgc+ #296
[ 2508.142954] Tainted: [D]=DIE, [W]=WARN
[ 2508.148153] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
[ 2508.148158] RIP: 0010:kthread_set_per_cpu+0x33/0x50
[ 2508.169229] Code: f6 47 2e 20 74 24 48 8b 87 58 0a 00 00 48 85 c0 74 11 f6 47 2f 04 74 16 85 f6 78 18 89 70 08 f0 80 08 01 5d c3 cc cc cc cc cc <0f> 0b eb d8 0f 0b 85 f6 79 e8 f0 80 20 fe 5d c3 cc cc cc cc cc 0f
[ 2508.187728] RSP: 0018:ffffc900068c3de8 EFLAGS: 00010246
[ 2508.192758] RAX: 0000000000000000 RBX: ffff8888d4295680 RCX: 0b0ee35baf810600
[ 2508.199999] RDX: 0000000000000040 RSI: 00000000ffffffff RDI: ffff888866aa0000
[ 2508.208341] RBP: ffffc900068c3de8 R08: 0000000000000001 R09: 0000000000000001
[ 2508.218878] R10: 000000005b5d0000 R11: ffffffff8118d8b0 R12: 000000000002fef0
[ 2508.226572] R13: ffff88901fbefb88 R14: ffff88901fbef8c0 R15: 0000000000000017
[ 2508.233346] FS:  0000000000000000(0000) GS:ffff88901fbc0000(0000) knlGS:0000000000000000
[ 2508.239695] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 2508.244123] CR2: 00007fbaf43c0004 CR3: 0000000003256000 CR4: 0000000000350ef0
[ 2508.249599] Call Trace:
[ 2508.253909]  <TASK>
[ 2508.311972]  unbind_worker+0x1b/0x70
[ 2508.315444]  workqueue_offline_cpu+0xd8/0x1f0
[ 2508.319554]  cpuhp_invoke_callback+0x13e/0x4f0
[ 2508.328936]  cpuhp_thread_fun+0xda/0x120
[ 2508.332746]  smpboot_thread_fn+0x132/0x1d0
[ 2508.336645]  kthread+0x147/0x170
[ 2508.347646]  ret_from_fork+0x3e/0x50
[ 2508.353845]  ret_from_fork_asm+0x1a/0x30
[ 2508.357773]  </TASK>
[ 2508.357776] ---[ end trace 0000000000000000 ]---

I have also seen similar traces from the CPUs coming on-line:

[ 2535.818771] WARNING: CPU: 23 PID: 133 at kernel/kthread.c:76 kthread_set_per_cpu+0x33/0x50
....
[ 2535.969004] RIP: 0010:kthread_set_per_cpu+0x33/0x50
....
[ 2508.249599] Call Trace:
[ 2508.253909]  <TASK>
[ 2535.969029]  workqueue_online_cpu+0xe6/0x2f0
[ 2535.969032]  cpuhp_invoke_callback+0x13e/0x4f0
[ 2535.969044]  cpuhp_thread_fun+0xda/0x120
[ 2535.969047]  smpboot_thread_fn+0x132/0x1d0
[ 2535.969053]  kthread+0x147/0x170
[ 2535.969066]  ret_from_fork+0x3e/0x50
[ 2535.969076]  ret_from_fork_asm+0x1a/0x30
[ 2508.357773]  </TASK>

I didn't see these on 6.12.0, so I'm guessing that there is
something in the merge window that has started triggering this.

-Dave.

-- 
Dave Chinner
david@fromorbit.com
