Received: from pdx-out-013.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-013.esa.us-west-2.outbound.mail-perimeter.amazon.com [34.218.115.239])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84E843C0612;
	Tue, 10 Mar 2026 17:57:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=34.218.115.239
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773165428; cv=none; b=ihTXAaQDVB5BL/K4RD1A0It5dRPD3I2TQUpJdIXisQD2ClIeE7p0MFolg9ySlzS8apMYRA/1/iz/LMaTnUzWxEEMncCtRSrFekI85HErD/zI5rpqW23kGe3hC0LzslokW+v3dgVMoGzC70t9aNekfJDPA3jAuoyjj0yP7ty21BU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773165428; c=relaxed/simple;
	bh=dE2wnhvT1/jOjYo2r7H6d5SffljydMQYDMzibj2ztqk=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=C9nvQL/KjhgTgKYaJYir7KUVuIrI5xxcsyu4iC4/ckH7R3cZ1I7qU/BMlx9pMejcYBw/SDAAJrNGE17FL50DVDcTes5zmlU2GlSw+iaYrsP3Mmyd9Egq/g+4lsaIQkLG6FShtFZNhWTe3dDS9zORuRRpPKF1Z4huix0kJQsdBwI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com; spf=pass smtp.mailfrom=amazon.com; dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b=DNt2qlJt; arc=none smtp.client-ip=34.218.115.239
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b="DNt2qlJt"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1773165427; x=1804701427;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=vXtjcRARDJJWJjzlBqRUJ7XjkdKoCtgRUPgj1EfuX5M=;
  b=DNt2qlJtIP7iCxYX18l/JSTdalVu/sDdxdhCpkSIc0wDbg4CmBwUnFEG
   KozuGaQCrQojjuwi/BcyQT6R+W3PHNBVYvmEIZ+YKQNv77XSoWs4bjpUT
   bEV4WZIJ4q0fosrInCBG3Og4xOYRcTQxTDnrOmAlEH95PjeYsIRzlhF4o
   Y2TRiTYdlplzcqDE/Gifi4uJvp1E0eo5ih5OU8V75tpiEtbVoLZHJq7BN
   3mPSc14IvWuY3YzATuSX908pTftSMaImE/iOn5haCybUycTHUxk20l65p
   cLnoTKLg3sR1aIKTb5qMXGyUjvwzd/TBT8mGgWnZUoO83zgKq3LnvW/gS
   A==;
X-CSE-ConnectionGUID: dm3G3WkKSLGNbB861GvvWg==
X-CSE-MsgGUID: VEd7LeRQR5WnohhxJ81UMQ==
X-IronPort-AV: E=Sophos;i="6.23,112,1770595200"; 
   d="scan'208";a="14537078"
Received: from ip-10-5-9-48.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.9.48])
  by internal-pdx-out-013.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Mar 2026 17:57:07 +0000
Received: from EX19MTAUWC002.ant.amazon.com [205.251.233.111:3821]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.33.152:2525] with esmtp (Farcaster)
 id 5be03645-ff53-4f3d-84c8-7f837792af6a; Tue, 10 Mar 2026 17:57:07 +0000 (UTC)
X-Farcaster-Flow-ID: 5be03645-ff53-4f3d-84c8-7f837792af6a
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWC002.ant.amazon.com (10.250.64.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.37;
 Tue, 10 Mar 2026 17:57:04 +0000
Received: from c889f3b07a0a.amazon.com (10.106.82.15) by
 EX19D001UWA001.ant.amazon.com (10.13.138.214) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.37;
 Tue, 10 Mar 2026 17:57:02 +0000
From: Yuto Ohnuki <ytohnuki@amazon.com>
To: <dgc@kernel.org>
CC: <bfoster@redhat.com>, <cem@kernel.org>, <darrick.wong@oracle.com>,
	<dchinner@redhat.com>, <linux-kernel@vger.kernel.org>,
	<linux-xfs@vger.kernel.org>, <stable@vger.kernel.org>,
	<syzbot+652af2b3c5569c4ab63c@syzkaller.appspotmail.com>,
	<ytohnuki@amazon.com>
Subject: Re: [PATCH v3 3/4] xfs: avoid dereferencing log items after push callbacks
Date: Tue, 10 Mar 2026 17:56:55 +0000
Message-ID: <20260310175655.80695-2-ytohnuki@amazon.com>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <aa-rqpyApQhssW8A@dread>
References: <aa-rqpyApQhssW8A@dread>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-ClientProxiedBy: EX19D031UWC001.ant.amazon.com (10.13.139.241) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

> > After xfsaild_push_item() calls iop_push(), the log item may have been
> > freed if the AIL lock was dropped during the push. The tracepoints in
> > the switch statement dereference the log item after iop_push() returns,
> > which can result in a use-after-free.
> > 
> > Fix this by capturing the log item type, flags, and LSN before calling
> > xfsaild_push_item(), and introducing a new xfs_ail_push_class trace
> > event class that takes these pre-captured values and the ailp pointer
> > instead of the log item pointer.
> > 
> > Reported-by: syzbot+652af2b3c5569c4ab63c@syzkaller.appspotmail.com
> > Closes: https://syzkaller.appspot.com/bug?extid=652af2b3c5569c4ab63c
> > Fixes: 90c60e164012 ("xfs: xfs_iflush() is no longer necessary")
> > Cc: <stable@vger.kernel.org> # v5.9
> > Signed-off-by: Yuto Ohnuki <ytohnuki@amazon.com>
> 
> Reviewed-by: Dave Chinner <dchinner@redhat.com>
> -- 
> Dave Chinner
> dgc@kernel.org

Thanks for the review, Dave.

In v4, I reworked the patch ordering so that the bugfix patches come
before the refactoring.

Since the context has changed, I've dropped your Reviewed-by from
this patch in v4 just to be safe. I would appreciate another look
when you get a chance.

Yuto



Amazon Web Services EMEA SARL, 38 avenue John F. Kennedy, L-1855 Luxembourg, R.C.S. Luxembourg B186284

Amazon Web Services EMEA SARL, Irish Branch, One Burlington Plaza, Burlington Road, Dublin 4, Ireland, branch registration number 908705



