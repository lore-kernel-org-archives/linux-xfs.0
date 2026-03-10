Received: from pdx-out-007.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-007.esa.us-west-2.outbound.mail-perimeter.amazon.com [52.34.181.151])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09DBC3D8129;
	Tue, 10 Mar 2026 17:33:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=52.34.181.151
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773164008; cv=none; b=ZIQCYDq9d1F39WV+X/Q2N5SfGgkohr5vPZ9k5BzIAHyNP3DLoVu26bw8X8dQNelNat2xWCkN9loIqPD86ImkLRwo+Fa9nb3P9Ak9DZi379DOHUT8BYSVK1HSnWgIYmV97G6oAdGDniLIP1CwADNgh1CyyVPsfCFvf2+4f3NsvJE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773164008; c=relaxed/simple;
	bh=//CrkQ4G6SBCtaqdSUoXjcR4q+caQPkfIu5ZBOh3Kf4=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=QBKVzlQQ1jqnSP/BV1ECx1bEr50Okz4L8gLC6IHDIf1hMUUU3bIi2waxxdGJqQzV4z4NufUjuqIqw+6TFrg+fDvwCvCna0muQx0tbxdpRHc6lzkhkRDmo2CQYsztY54vqkandiBIi5wseTJULl3g4EHC7jCg1c4bPTwxW18y16k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com; spf=pass smtp.mailfrom=amazon.com; dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b=bq3heuSl; arc=none smtp.client-ip=52.34.181.151
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b="bq3heuSl"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1773164007; x=1804700007;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=JuJr00wp6WVYLKvXWLzydnDEZTCw1hP1uyar6Pvl3jI=;
  b=bq3heuSlPC0ZHsBDbBsjHItBkw60cOvwrrppR0drBovspSh9jC44BUvH
   yngm3i/4bizgv7mtl7+qXe9QO7504LgKkNhulzViUhFjM1oqdo0/Nqfir
   4yQwpS49QaXJzz4MY8Mu91W+SxcBuYEiJGEGJkv9lvgNTqjMtXRRz2l7H
   W6bulT7BOJZu4xqNBI/BJtFCUJAj8nOySmz2vpbMHo+9Bt73atDRD6bgI
   EHRj6RJG2mTUXp7Jzev8ByRLrX3N7H8Uj/MJH2xUNd7nkdbBJEhT2YpuG
   7+p+yYWdvss7lURS2kJ9DRsLDFw1OudadrZfTEw0J/Xj8k8YMhOKKwxXc
   Q==;
X-CSE-ConnectionGUID: gEKmWbqMS6yxgyhYBlhddQ==
X-CSE-MsgGUID: m1K/oxxvQFuNx1hO10W/wQ==
X-IronPort-AV: E=Sophos;i="6.23,112,1770595200"; 
   d="scan'208";a="14720260"
Received: from ip-10-5-0-115.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.0.115])
  by internal-pdx-out-007.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Mar 2026 17:33:23 +0000
Received: from EX19MTAUWA001.ant.amazon.com [205.251.233.182:13362]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.52.102:2525] with esmtp (Farcaster)
 id 6448cfff-a050-4751-8d86-d12b249326ae; Tue, 10 Mar 2026 17:33:23 +0000 (UTC)
X-Farcaster-Flow-ID: 6448cfff-a050-4751-8d86-d12b249326ae
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWA001.ant.amazon.com (10.250.64.204) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.37;
 Tue, 10 Mar 2026 17:33:23 +0000
Received: from c889f3b07a0a.amazon.com (10.106.82.15) by
 EX19D001UWA001.ant.amazon.com (10.13.138.214) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.37;
 Tue, 10 Mar 2026 17:33:21 +0000
From: Yuto Ohnuki <ytohnuki@amazon.com>
To: <djwong@kernel.org>
CC: <bfoster@redhat.com>, <cem@kernel.org>, <darrick.wong@oracle.com>,
	<dchinner@redhat.com>, <linux-kernel@vger.kernel.org>,
	<linux-xfs@vger.kernel.org>, <stable@vger.kernel.org>,
	<syzbot+652af2b3c5569c4ab63c@syzkaller.appspotmail.com>,
	<ytohnuki@amazon.com>
Subject: Re: [PATCH v3 1/4] xfs: stop reclaim before pushing AIL during unmount
Date: Tue, 10 Mar 2026 17:33:14 +0000
Message-ID: <20260310173314.71923-2-ytohnuki@amazon.com>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20260309160235.GA6033@frogsfrogsfrogs>
References: <20260309160235.GA6033@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-ClientProxiedBy: EX19D043UWA004.ant.amazon.com (10.13.139.41) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

> Is this a general race between background inode reclaim and AIL pushes?
> Or is the race between an AIL push and the explicit call to
> xfs_reclaim_inodes below?
> 
> I ask because there's a call to xfs_ail_push_all_sync from various
> places in the codebase:
> 
> - Log covering/quiescing activities
> 
> - xchk_checkpoint_log in the online fsck code if the inode btree
>   scrubber thinks it's racing with inode reclaim.
> 
> If inode reclaim happens to be running at the same time as these AIL
> pushes, won't the same race condition manifest there?  But maybe you
> meant the race is with the explicit xfs_reclaim_inodes below?

The UAF itself is a general race between background inode reclaim (and
the dquot shrinker) and AIL pushes, not a race between the AIL push
and the explicit xfs_reclaim_inodes call below. The syzbot report
triggered it during shutdown because aborting dirty inodes makes them
reclaimable while still referenced by the AIL, but the unsafe
post-push dereferences fixed in patches 2/4 and 3/4 in v4 are not
shutdown-specific. Those patches address the general race by
capturing log item fields before push callbacks and saving the ailp
pointer before dropping the AIL lock.

This patch (patch 1/4) is a separate correctness fix for the unmount
path. As Dave analysed in his v1 review [1], the unmount sequence is
broken independently of the UAF - background reclaim and inodegc
should not be running while the AIL is being pushed during unmount.
This patch eliminates the conditions that make the general race
particularly likely to trigger during unmount.

[1] https://lore.kernel.org/all/aai66aCvGC66P8cN@dread/

> xfs_inodegc_inactivate (aka the inodegc worker) can call
> xfs_inodegc_set_reclaimable, which in turn calls xfs_reclaim_work_queue.
> That will re-queue m_reclaim_work, which we just cancelled.  I think
> inodegc_stop has to come before cancelling m_reclaim_work.
> 
> --D

Thank you for your valuable feedback.
Fixed in v4 - xfs_inodegc_stop is now called before
cancel_delayed_work_sync, and the function comment is updated to
reflect the new ordering.

Yuto



Amazon Web Services EMEA SARL, 38 avenue John F. Kennedy, L-1855 Luxembourg, R.C.S. Luxembourg B186284

Amazon Web Services EMEA SARL, Irish Branch, One Burlington Plaza, Burlington Road, Dublin 4, Ireland, branch registration number 908705



