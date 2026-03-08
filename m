Received: from pdx-out-002.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-002.esa.us-west-2.outbound.mail-perimeter.amazon.com [44.246.1.125])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 862BF36D518;
	Sun,  8 Mar 2026 18:35:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=44.246.1.125
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772994947; cv=none; b=Le6unNnL82MQQpypEQL6iXb8g4Sj80kfrIAe8iwEGWp9j5KRO5IC+2yIQ/nY38QmixZPCd3rtAqBGpmBulEqhNUtUkZXMjfcjZH72XP8OIU7tov5BOoXcqbiF+3oUgnsftuwxQ0yRo6iaTfkrk4gov1vXdEq0G/BvuDQU3vxhro=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772994947; c=relaxed/simple;
	bh=Lt3jjYlmJitozyiL9EM2J+kmOTasiR5twUGHR/hFuRc=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=DZlrwGigh7lz7NrygZR/HopbxL9598UZ+WSoXobcvEJmv0lJ6j+MW0z1LTTvr04+sANUYamaMa3b9TG1aOnj4r9Kk5RwdlKBOiq45s2kmdkDyUI+3YY7tkAuMYeuLsj7nicxl3udjm+QJScHbCsBmZcnWZjtfR8Jzi4qs7mFDvI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com; spf=pass smtp.mailfrom=amazon.com; dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b=gdnr8Xsk; arc=none smtp.client-ip=44.246.1.125
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b="gdnr8Xsk"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1772994946; x=1804530946;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=7yXuq2gxo8YRyxMgsfvnodiZt07oVdV8r4oFih3MaTw=;
  b=gdnr8XskJZqhndc2ruKtRuXlCxgTOJczU/F0S+HcwAl6e+WQDddAxXC1
   ecmP7S43InBbZB1RdQzbxtnohi8hMGgpQnHgNneP7CZc9+58Ju+aL5ewb
   PEUMjoPWozn9Mi/Wez7cANnecIZQoJ1AyE+9Nyg1mtQ5bpwbea/jTRrrS
   Im8lQ1twml7x/m4LivBkwZuFWhkeHT3rbuyqjnydRbqSfDzK71cvR+3z8
   +aJprVoSNK0XfEdscqPKQTuOKeS2gtnoRsAWEdknQjU1XI/RbeQtABFJy
   oj7gLehGdDA8zE9lbu73sPMR56z/7sR0Mo92VSzV7xTvqP2V6ud8a13b1
   w==;
X-CSE-ConnectionGUID: aZZD2MhVQ1Cs3UA/o0Ddgg==
X-CSE-MsgGUID: DiRaDGgVSD2Ly5ABYDMlrg==
X-IronPort-AV: E=Sophos;i="6.23,109,1770595200"; 
   d="scan'208";a="14566257"
Received: from ip-10-5-9-48.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.9.48])
  by internal-pdx-out-002.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Mar 2026 18:35:44 +0000
Received: from EX19MTAUWC001.ant.amazon.com [205.251.233.105:30378]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.31.3:2525] with esmtp (Farcaster)
 id 3274543e-55dd-4361-8664-4d57466a8ed9; Sun, 8 Mar 2026 18:35:43 +0000 (UTC)
X-Farcaster-Flow-ID: 3274543e-55dd-4361-8664-4d57466a8ed9
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWC001.ant.amazon.com (10.250.64.174) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.37;
 Sun, 8 Mar 2026 18:35:41 +0000
Received: from c889f3b07a0a.amazon.com (10.106.82.18) by
 EX19D001UWA001.ant.amazon.com (10.13.138.214) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.37;
 Sun, 8 Mar 2026 18:35:39 +0000
From: Yuto Ohnuki <ytohnuki@amazon.com>
To: <dgc@kernel.org>
CC: <bfoster@redhat.com>, <cem@kernel.org>, <darrick.wong@oracle.com>,
	<dchinner@redhat.com>, <linux-kernel@vger.kernel.org>,
	<linux-xfs@vger.kernel.org>, <stable@vger.kernel.org>,
	<syzbot+652af2b3c5569c4ab63c@syzkaller.appspotmail.com>,
	<ytohnuki@amazon.com>
Subject: Re: [PATCH v2] xfs: fix use-after-free of log items during AIL pushing
Date: Sun, 8 Mar 2026 18:35:33 +0000
Message-ID: <20260308183532.36096-2-ytohnuki@amazon.com>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <aan6eeNwMnBcRzhn@dread>
References: <aan6eeNwMnBcRzhn@dread>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-ClientProxiedBy: EX19D041UWB004.ant.amazon.com (10.13.139.143) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

> I think this should be broken up into separate commits. Certainly
> the unmount changes should be a standalone commit...

Hi Dave, thank you for the detailed review.

I've split the patch into 4 separate commits in v3 and addressed
your other feedback:

- Unmount reorder as a standalone patch
- Loop body factored into xfsaild_process_logitem() as a
  separate refactoring patch
- Passed ailp instead of dev to tracepoints
- Moved xfs_ail_push_class after xfs_log_item_class events
- Moved UAF-unsafe comments to after xfs_buf_relse()
- Added header comment on xfsaild_push_item() for lifetime rules

v3: https://lore.kernel.org/all/20260308182804.33127-6-ytohnuki@amazon.com/

Please let me know if I've misunderstood any of your points.

Yuto



Amazon Web Services EMEA SARL, 38 avenue John F. Kennedy, L-1855 Luxembourg, R.C.S. Luxembourg B186284

Amazon Web Services EMEA SARL, Irish Branch, One Burlington Plaza, Burlington Road, Dublin 4, Ireland, branch registration number 908705



