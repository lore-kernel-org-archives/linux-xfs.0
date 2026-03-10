Received: from pdx-out-001.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-001.esa.us-west-2.outbound.mail-perimeter.amazon.com [44.245.243.92])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E96DC2D2496;
	Tue, 10 Mar 2026 17:46:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=44.245.243.92
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773164774; cv=none; b=HLpeR6f77d3JqHh1Uwg8xKPeohHk3916J605EikNd3IIfA8YARzyLuT78nvYcfFoLN7QbOwrwBd5gHsXsuwQ+Wr7YRYwZBV6XADHLxz0VnVLxmbmoRBtv55YctLJPu7jFaVEV6AaxGppg0fEeapG35hhHOR3T3+ZvkQyzMzJs/E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773164774; c=relaxed/simple;
	bh=uIUWs+noznTVO5/TSiUkk70+NA0IGhHQuQLdkc68X44=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=PlwGAQM+h4+VpevMr2ynGHQ9cMI9EWJWhzwID6u2HfajGe/xITEGw9tdONB8wO7L8ZpqJwPwtBj29UK8qGD+7v4UjSUeaFVPP/lJtLOLfJ/lG5gaf4qhOzKVK7AimU7gHfOvxwugV4mtCioRJ2ew4Z+fpqsBSjBGofTzJ0kKdVA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com; spf=pass smtp.mailfrom=amazon.com; dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b=ZyWX6vEe; arc=none smtp.client-ip=44.245.243.92
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b="ZyWX6vEe"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1773164773; x=1804700773;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=LLAirha655TV6Rkr//LqjWH4Nchvefj1xA2HILMeZhA=;
  b=ZyWX6vEepBE85f78OFZZUHB3HbvVPbjIMxJkAiJEpH2LTGL0a6AHogMg
   SxJNR54jujqK51atNEehrVN099TUUeDCn3+A2DLuIR4KXmvK43OJzplJH
   hSF+x3F+J14rwQDXiJpZpz4Kb8rEyRXZRvC61kIDJooidqFtOnjBWShk7
   vO4tFgmI6Mbe16k9TjUEb+syfxa1IGvH7JJ4ppke9xHTNk7TPH4xyQLKY
   HJixAv+myzvPuOyB0vIsW5dOe6+IlfsRy5PPDkd5rMikuwrB3jPIP139Z
   Oy+VU6vQNMU+HWcEBADWoNNmRzgYWkeAUZfNUBe3pgAlaeCD7jRXQ8z/6
   A==;
X-CSE-ConnectionGUID: Jk+NSRnrQFW5eHuwgdtvVA==
X-CSE-MsgGUID: wBhRdTwXSKaoilCcWg1gsw==
X-IronPort-AV: E=Sophos;i="6.23,112,1770595200"; 
   d="scan'208";a="14260071"
Received: from ip-10-5-9-48.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.9.48])
  by internal-pdx-out-001.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Mar 2026 17:46:11 +0000
Received: from EX19MTAUWC001.ant.amazon.com [205.251.233.53:7195]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.26.67:2525] with esmtp (Farcaster)
 id bb4cda12-55e4-4c61-9cde-6b0876b0dc1b; Tue, 10 Mar 2026 17:46:11 +0000 (UTC)
X-Farcaster-Flow-ID: bb4cda12-55e4-4c61-9cde-6b0876b0dc1b
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWC001.ant.amazon.com (10.250.64.174) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.37;
 Tue, 10 Mar 2026 17:46:09 +0000
Received: from c889f3b07a0a.amazon.com (10.106.82.15) by
 EX19D001UWA001.ant.amazon.com (10.13.138.214) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.37;
 Tue, 10 Mar 2026 17:46:07 +0000
From: Yuto Ohnuki <ytohnuki@amazon.com>
To: <dgc@kernel.org>
CC: <bfoster@redhat.com>, <cem@kernel.org>, <darrick.wong@oracle.com>,
	<dchinner@redhat.com>, <linux-kernel@vger.kernel.org>,
	<linux-xfs@vger.kernel.org>, <stable@vger.kernel.org>, <ytohnuki@amazon.com>
Subject: Re: [PATCH v3 2/4] xfs: refactor xfsaild_push loop into helper
Date: Tue, 10 Mar 2026 17:46:01 +0000
Message-ID: <20260310174600.76042-2-ytohnuki@amazon.com>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <aa-rfqemHJuWG8VL@dread>
References: <aa-rfqemHJuWG8VL@dread>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-ClientProxiedBy: EX19D038UWC003.ant.amazon.com (10.13.139.209) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

> > Factor the loop body of xfsaild_push() into a separate
> > xfsaild_process_logitem() helper to improve readability.
> > 
> > This is a pure code movement with no functional change. The
> > subsequent patch to fix a use-after-free in the AIL push path
> > depends on this refactoring.
> > 
> > Cc: <stable@vger.kernel.org> # v5.9
> > Signed-off-by: Yuto Ohnuki <ytohnuki@amazon.com>
> 
> Reviewed-by: Dave Chinner <dchinner@redhat.com>

Thanks for the review, Dave.

In v4, I reworked the patch ordering so that the bugfix patches don't
depend on the refactoring patch, reducing the stable backport burden.

Since the context has changed slightly, I've dropped your Reviewed-by
from this patch in v4 just to be safe. I would appreciate it if you
could take another look when you get a chance.

Yuto



Amazon Web Services EMEA SARL, 38 avenue John F. Kennedy, L-1855 Luxembourg, R.C.S. Luxembourg B186284

Amazon Web Services EMEA SARL, Irish Branch, One Burlington Plaza, Burlington Road, Dublin 4, Ireland, branch registration number 908705



