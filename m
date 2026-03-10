Received: from pdx-out-014.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-014.esa.us-west-2.outbound.mail-perimeter.amazon.com [35.83.148.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0D203BE632;
	Tue, 10 Mar 2026 17:51:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=35.83.148.184
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773165074; cv=none; b=YfZWRk6sbHK8M4efoJgF8plL2PoR+4laFx5kGJE8bIDoGMbjLx6LUYHuZradHBjx8oDFfS/fkfxDAZEintW9cagX55RHgRzqWxWu7KRYPaM150wk3JxQEz8UR2Ino7neb9eEyGeVSM9HxKfQAdhPvv8lFEOAxDRDcF6zB1puteg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773165074; c=relaxed/simple;
	bh=78ppUDYxwjxrtt3Sac+CYrvtVAU06fm3GCorvVpvs2Q=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=p0sx8BTFpI6pilYeZbCKrOiEec6Klb55MT6s9nT/wD7zgADV55ZqFfxPXRu8HsgdqZkf6t9TMtuShYb/rdzMkEDnjYTLMV7AXXUELo5uE8SFIdq8ojp5138km8MHGAJaB6+vWEhiJGBRdAq/CepLWL2q84hIjEBNutoKo7BjDIA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com; spf=pass smtp.mailfrom=amazon.com; dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b=hmGMh3xv; arc=none smtp.client-ip=35.83.148.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b="hmGMh3xv"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1773165073; x=1804701073;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=ZfWsd7vnKC7vsBkB8twa0SAeVNN/tV9YfwhYLz2yy3U=;
  b=hmGMh3xvcQXL5eisx8r20QJPlFosm1b5HPz62rQg7JhrrL8w6y8U/hWs
   95IIY4AjNIeYqf+fOiCtEY+3rs0s25h9ki+2923OHLfUggbPm/Bd6LU9M
   Ys58rNspI8AUZErYxFkQhbu1dx0ED+brWzcPJ/JESbU5uYhmYRBKx+Cux
   F3BXkIZDQPAOu/deGdsq3bLPDmPOT6maXVIFPQ86i5f7ewdXIrQ751qZI
   ro1pmS5H0so2uuv1E71M/3p8XEEE1twDOYsEzR6jfxLgcudOdyXY3HszF
   aH1EYPRknRsj4P56BRwiEm/WuLWIJSVqw5IGa8o5Qn4ZuXnDcU0b+BwI3
   g==;
X-CSE-ConnectionGUID: LD9zY2wrQ2acRxIOYavRNA==
X-CSE-MsgGUID: qqUiXotoQ7WssWsZs8gsNQ==
X-IronPort-AV: E=Sophos;i="6.23,112,1770595200"; 
   d="scan'208";a="14506148"
Received: from ip-10-5-6-203.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.6.203])
  by internal-pdx-out-014.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Mar 2026 17:51:09 +0000
Received: from EX19MTAUWC001.ant.amazon.com [205.251.233.53:4343]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.61.162:2525] with esmtp (Farcaster)
 id b39caf10-a39c-454e-8910-6af5901b1a7b; Tue, 10 Mar 2026 17:51:09 +0000 (UTC)
X-Farcaster-Flow-ID: b39caf10-a39c-454e-8910-6af5901b1a7b
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWC001.ant.amazon.com (10.250.64.174) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.37;
 Tue, 10 Mar 2026 17:51:09 +0000
Received: from c889f3b07a0a.amazon.com (10.106.82.15) by
 EX19D001UWA001.ant.amazon.com (10.13.138.214) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.37;
 Tue, 10 Mar 2026 17:51:07 +0000
From: Yuto Ohnuki <ytohnuki@amazon.com>
To: <djwong@kernel.org>
CC: <bfoster@redhat.com>, <cem@kernel.org>, <darrick.wong@oracle.com>,
	<dchinner@redhat.com>, <linux-kernel@vger.kernel.org>,
	<linux-xfs@vger.kernel.org>, <stable@vger.kernel.org>,
	<syzbot+652af2b3c5569c4ab63c@syzkaller.appspotmail.com>,
	<ytohnuki@amazon.com>
Subject: Re: [PATCH v3 3/4] xfs: avoid dereferencing log items after push callbacks
Date: Tue, 10 Mar 2026 17:51:00 +0000
Message-ID: <20260310175059.78341-2-ytohnuki@amazon.com>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20260309162710.GC6033@frogsfrogsfrogs>
References: <20260309162710.GC6033@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-ClientProxiedBy: EX19D044UWA002.ant.amazon.com (10.13.139.11) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

> How difficult would it be to add a refcount to xfs_log_item so that any
> other code walking through the AIL's log item list can't accidentally
> suffer from this UAF?  I keep seeing periodic log item UAF bugfixes on
> the list, which (to me anyway) suggests we ought to think about a
> struct(ural) fix to this problem.
> 
> I /think/ the answer to that is "sort of nasty" because of things like
> xfs_dquot embedding its own log item.  The other log item types might
> not be so bad because at least they're allocated separately.  However,
> refcount_t accesses also aren't free.

Agreed that a structural fix would be the right long-term approach.
As you noted, the dquot embedding makes it non-trivial. I'd like to
keep this series focused on the immediate syzbot fix and explore a
refcount-based approach as a separate effort.

> This is true after the xfsaild_push_item call, correct?  If so then I
> think the comment for the call needs updating too:
> 
>       /*
>        * Note that iop_push may unlock and reacquire the AIL lock.  We
>        * rely on the AIL cursor implementation to be able to deal with
>        * the dropped lock.
>        *
>        * The log item may have been freed by the push, so it must not
>        * be accessed or dereferenced below this line.
>        */
>       lock_result = xfsaild_push_item(ailp, lip);
> 
> Otherwise this looks ok to me.
> 
> --D

Thank you. In v4, I have added the comments you suggested.

Yuto



Amazon Web Services EMEA SARL, 38 avenue John F. Kennedy, L-1855 Luxembourg, R.C.S. Luxembourg B186284

Amazon Web Services EMEA SARL, Irish Branch, One Burlington Plaza, Burlington Road, Dublin 4, Ireland, branch registration number 908705



