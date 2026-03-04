Received: from pdx-out-007.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-007.esa.us-west-2.outbound.mail-perimeter.amazon.com [52.34.181.151])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 886363C2792;
	Wed,  4 Mar 2026 17:41:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=52.34.181.151
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772646090; cv=none; b=JoQv0ENQtnmk3jedPhj03TahgStp6qB/w65Wjv9CJjX9P1TEf8cgL+EXkFsLmuO26rol8HIcaOTayMM83odppVZBXWzpaeXKYTk+sJD/TPQS7vS/JylQXJ908Ww61QNoLXnq7XrZvSTFw7FcZoTkaHNITQLA7RNNusB5carS0xY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772646090; c=relaxed/simple;
	bh=S5+fhQwrYYHlW1h283EAcuFfv9TSlLMI3QiByYoWS8Q=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=OENMIynEUN2OWpPGP9s+jQQiTFNy77LC8M5kEO0iD1RWpPgGXq4YQmMvEiLtWzqfFsNetdqN/u89/Q/NzRRDtspPp4ApSNbjqBXjZsJB58Giwk6qTSlacJqJj1alkTNlGCeqAIsGPOl/C4opXhZFaF4qSCT3cuP8rDEI2NIzxeI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com; spf=pass smtp.mailfrom=amazon.com; dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b=Iap+PwHt; arc=none smtp.client-ip=52.34.181.151
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b="Iap+PwHt"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1772646089; x=1804182089;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=g6dfqGUBRT3ijAPy+6ZYXfBDnxZhw1gL+gagUZeGRkw=;
  b=Iap+PwHtp4sk7uC54bMsYgzbU2rCgxuSuEgGAmcRtFSqSXE8BCAGGQfY
   f/YS738ffmzfpt0kOUkD9F4gg+OOKmRx3BNcDj6O6a4U3F6VHvMdH/xfO
   /QWD8oKqRspvK0TQxxgkL8uxozG7fFnvwEwCD3bVlIzar4B6XAb4gy+ME
   Xsahm8ZE802EqMF98JOh/UQS8EQ2bBU2RuawaOEXoG1YyGbVeaa69nrW+
   mWkqWAr3Qk57Hxew6qOYeBnpaya3egYHGx1QlC020bZuY+UPnW1Aoy4S0
   3iGwIiw2lV4Fu9fAW7DYB/IrwmaPhyCIeBkfP6n4GxtgH84n1a6KV7Pmd
   g==;
X-CSE-ConnectionGUID: f58EkBpjSU28+YueJQTvzw==
X-CSE-MsgGUID: dWr4e1xiT0W3ZgaHAytGFA==
X-IronPort-AV: E=Sophos;i="6.21,324,1763424000"; 
   d="scan'208";a="14296922"
Received: from ip-10-5-12-219.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.12.219])
  by internal-pdx-out-007.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Mar 2026 17:41:26 +0000
Received: from EX19MTAUWC002.ant.amazon.com [205.251.233.111:23287]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.52.102:2525] with esmtp (Farcaster)
 id 5907f8f0-4674-4be8-b323-3bf194da1d24; Wed, 4 Mar 2026 17:41:26 +0000 (UTC)
X-Farcaster-Flow-ID: 5907f8f0-4674-4be8-b323-3bf194da1d24
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWC002.ant.amazon.com (10.250.64.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.37;
 Wed, 4 Mar 2026 17:41:26 +0000
Received: from c889f3b07a0a.amazon.com (10.106.82.8) by
 EX19D001UWA001.ant.amazon.com (10.13.138.214) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.37;
 Wed, 4 Mar 2026 17:41:24 +0000
From: Yuto Ohnuki <ytohnuki@amazon.com>
To: <djwong@kernel.org>
CC: <bfoster@redhat.com>, <cem@kernel.org>, <darrick.wong@oracle.com>,
	<dchinner@redhat.com>, <linux-kernel@vger.kernel.org>,
	<linux-xfs@vger.kernel.org>,
	<syzbot+652af2b3c5569c4ab63c@syzkaller.appspotmail.com>,
	<ytohnuki@amazon.com>
Subject: Re: [PATCH] xfs: fix use-after-free in xfs_inode_item_push()
Date: Wed, 4 Mar 2026 17:41:18 +0000
Message-ID: <20260304174117.88648-2-ytohnuki@amazon.com>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20260304164451.GW57948@frogsfrogsfrogs>
References: <20260304164451.GW57948@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-ClientProxiedBy: EX19D039UWA001.ant.amazon.com (10.13.139.110) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

> > ---
> >  fs/xfs/xfs_inode_item.c | 5 +++--
> >  fs/xfs/xfs_trans_ail.c  | 8 +++++++-
> >  2 files changed, 10 insertions(+), 3 deletions(-)
> > 
> > diff --git a/fs/xfs/xfs_inode_item.c b/fs/xfs/xfs_inode_item.c
> > index 8913036b8024..0a8957f9c72f 100644
> > --- a/fs/xfs/xfs_inode_item.c
> > +++ b/fs/xfs/xfs_inode_item.c
> > @@ -746,6 +746,7 @@ xfs_inode_item_push(
> >     struct xfs_inode_log_item *iip = INODE_ITEM(lip);
> >     struct xfs_inode        *ip = iip->ili_inode;
> >     struct xfs_buf          *bp = lip->li_buf;
> > +   struct xfs_ail          *ailp = lip->li_ailp;
> >     uint                    rval = XFS_ITEM_SUCCESS;
> >     int                     error;
> >  
> > @@ -771,7 +772,7 @@ xfs_inode_item_push(
> >     if (!xfs_buf_trylock(bp))
> >             return XFS_ITEM_LOCKED;
> >  
> > -   spin_unlock(&lip->li_ailp->ail_lock);
> > +   spin_unlock(&ailp->ail_lock);
> >  
> >     /*
> >      * We need to hold a reference for flushing the cluster buffer as it may
> > @@ -795,7 +796,7 @@ xfs_inode_item_push(
> >             rval = XFS_ITEM_LOCKED;
> >     }
> >  
> > -   spin_lock(&lip->li_ailp->ail_lock);
> > +   spin_lock(&ailp->ail_lock);
> 
> Hmm, so the @lip UAF is here, where we try to re-acquire the AIL lock?

Yes. The syzbot report shows a Read of size 8 at offset 48 (li_ailp)
when spin_lock() dereferences the freed log item to get the
AIL pointer.

> >     return rval;
> >  }
> >  
> > diff --git a/fs/xfs/xfs_trans_ail.c b/fs/xfs/xfs_trans_ail.c
> > index 923729af4206..e34d8a7e341d 100644
> > --- a/fs/xfs/xfs_trans_ail.c
> > +++ b/fs/xfs/xfs_trans_ail.c
> > @@ -510,6 +510,13 @@ xfsaild_push(
> >             if (test_bit(XFS_LI_FLUSHING, &lip->li_flags))
> >                     goto next_item;
> >  
> > +           /*
> > +            * The log item may be freed after the push if the AIL lock is
> > +            * temporarily dropped and the RCU grace period expires,
> > +            * so trace it before pushing.
> > +            */
> > +           trace_xfs_ail_push(lip);
> > +
> >             /*
> >              * Note that iop_push may unlock and reacquire the AIL lock.  We
> >              * rely on the AIL cursor implementation to be able to deal with
> > @@ -519,7 +526,6 @@ xfsaild_push(
> >             switch (lock_result) {
> >             case XFS_ITEM_SUCCESS:
> >                     XFS_STATS_INC(mp, xs_push_ail_success);
> > -                   trace_xfs_ail_push(lip);
> 
> Do the tracepoints in the other legs of the switch statement have a
> similar UAF problem because they dereference @lip?
> 
> --D

Thank you very much for pointing out the other switch statement.

XFS_ITEM_PINNED is always returned before the AIL lock
is dropped, so trace_xfs_ail_pinned() is safe.

However, looking into it further, XFS_ITEM_FLUSHING and 
XFS_ITEM_LOCKED can also be returned via the rval path after the AIL 
lock is dropped and reacquired. So trace_xfs_ail_flushing() and
trace_xfs_ail_locked() could also hit a UAF in those cases.

I'll send a v2 that addresses those as well.



Amazon Web Services EMEA SARL, 38 avenue John F. Kennedy, L-1855 Luxembourg, R.C.S. Luxembourg B186284

Amazon Web Services EMEA SARL, Irish Branch, One Burlington Plaza, Burlington Road, Dublin 4, Ireland, branch registration number 908705



