Received: from pdx-out-013.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-013.esa.us-west-2.outbound.mail-perimeter.amazon.com [34.218.115.239])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB7143D6CB2;
	Tue, 10 Mar 2026 17:38:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=34.218.115.239
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773164343; cv=none; b=lwTveBAHXtBbz8o3sKAfwHIvxayvoUbaWb1odN264gN1t8EGlotIcnrTHX1Ovyaz619z8ERCsikc3NqB4ocOg+tnxqYyX2WOkYkQaeY9jX1KLD71+X1tT/1aeQIM0f18VD63Rgh0MeGdLN1QVYpiwtiJSnH+b2uK7QJSV8tWTq4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773164343; c=relaxed/simple;
	bh=V6IjNMBW0S5eKc1YV//lAQ/egCIcxF3tLa+FdpApFYM=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=KjnGel5qxxOtr6ZSAcEqarsIWcB1HIALHzWyFDs4igo6Nw29EbM5CcCqDH2xoia+2/9e0XlClPrZ0qwurxOMsrqe5E2zVXmAZ7qKiI8fZ2e6YyIpvmMjfJ+I2RQaGNv08BsvMCch0YRmm44Ri+18sjtBajR1JkqqsrcxqBKSjms=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com; spf=pass smtp.mailfrom=amazon.com; dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b=Urhb46eX; arc=none smtp.client-ip=34.218.115.239
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b="Urhb46eX"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1773164338; x=1804700338;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=eotE7EGuSQNJY7vzoK04NHfOGDbwjHGzTDQSLYfDwog=;
  b=Urhb46eXVoVqmNHAfIGdCrkgLqFZas+LIMV1lg0CrLz0eJTjpV9XX9dz
   2DUe6bZ9F7tKtUjTNUbnojwuuF2RPuVFWvE5dCafRhvB712I2nRsBuYQK
   HBjXJyDRx+lKCdPKgXl2JbvNW8Ln7MzPH1nNhk/3ygjCGSAMK/oU2xUcA
   VwxKYfymd+LLX1h52SB5CMxnTrlRrZDxUVUZq9OJFgiSCa6+YOsjzsYOj
   LECQcIF8UmAMh9kR+j/ZqkuicFxnVthYoHG+XTWx+0iwHEM/kxpILWlM8
   iz9qUdQujnAfuqK5aHWEIGz2QtnR1Vv2pGYMHNaKyXPcssTmzUvWMyR9e
   A==;
X-CSE-ConnectionGUID: 6j2+BE2ITue4Pge1FLfgsQ==
X-CSE-MsgGUID: zbVhyClYRhesfZF9Rcw7tg==
X-IronPort-AV: E=Sophos;i="6.23,112,1770595200"; 
   d="scan'208";a="14535764"
Received: from ip-10-5-6-203.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.6.203])
  by internal-pdx-out-013.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Mar 2026 17:38:55 +0000
Received: from EX19MTAUWB001.ant.amazon.com [205.251.233.51:18138]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.31.3:2525] with esmtp (Farcaster)
 id 4072b922-e8d5-4e0b-afc5-df21a11ef0ec; Tue, 10 Mar 2026 17:38:55 +0000 (UTC)
X-Farcaster-Flow-ID: 4072b922-e8d5-4e0b-afc5-df21a11ef0ec
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWB001.ant.amazon.com (10.250.64.248) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.37;
 Tue, 10 Mar 2026 17:38:55 +0000
Received: from c889f3b07a0a.amazon.com (10.106.82.15) by
 EX19D001UWA001.ant.amazon.com (10.13.138.214) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.37;
 Tue, 10 Mar 2026 17:38:53 +0000
From: Yuto Ohnuki <ytohnuki@amazon.com>
To: <djwong@kernel.org>
CC: <bfoster@redhat.com>, <cem@kernel.org>, <darrick.wong@oracle.com>,
	<dchinner@redhat.com>, <linux-kernel@vger.kernel.org>,
	<linux-xfs@vger.kernel.org>, <stable@vger.kernel.org>, <ytohnuki@amazon.com>
Subject: Re: [PATCH v3 2/4] xfs: refactor xfsaild_push loop into helper
Date: Tue, 10 Mar 2026 17:38:46 +0000
Message-ID: <20260310173845.73766-2-ytohnuki@amazon.com>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20260309161427.GB6033@frogsfrogsfrogs>
References: <20260309161427.GB6033@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-ClientProxiedBy: EX19D039UWB002.ant.amazon.com (10.13.138.79) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

> Seems like a reasonable hoist to reduce the length of the function, but
> in ordering the patches this way (cleanup, then bugfixes) the hoist also
> has to be backported to 5.10/5.15/6.1/6.6/6.12/6.18/6.19.
> 
> --D

Thank you. In v4, I moved the refactoring to patch 4/4 after the
bugfix patches and dropped the Cc: stable tag, so it no longer needs
to be backported.

Yuto



Amazon Web Services EMEA SARL, 38 avenue John F. Kennedy, L-1855 Luxembourg, R.C.S. Luxembourg B186284

Amazon Web Services EMEA SARL, Irish Branch, One Burlington Plaza, Burlington Road, Dublin 4, Ireland, branch registration number 908705



