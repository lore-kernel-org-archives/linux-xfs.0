Received: from smtpbgjp3.qq.com (smtpbgjp3.qq.com [54.92.39.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 672FC3ACA43;
	Tue,  9 Jun 2026 11:17:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=54.92.39.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781003858; cv=none; b=ct7EzP1jYTLWSwxBCN9lZPI+k/Rp8H0CD5JlYHIYJ0b2ebhuEjcdkXCxTtEih+QoAzuCWinJitYbE7YBWW/ZiZIwh68KVZpm9xj+bshn0d/TYVWlTcvRjA75NMd4K+t7AQGzTVTAnB2y3xUfLnXjJaylQfJSMtWNpxgM8XPXLok=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781003858; c=relaxed/simple;
	bh=ScL84qa76Z292/f0XsEinRsYlVqQkRnRiiKwEY7h16U=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=rS4zQgVW66KXqAPI2aI1HGMijOxvaNpBvFG3CmCJA0rCASitoNbilx+RP7f1VHcV34zsvuOr7BiSbBTPom1GatgK42MLMu5dZHt7J9TyfefNO6sm0zjmm/G6pTzJKpZ/cpBuRhMh00ZzSJRsokYlAee9koGgAaW+NcDuGd/0250=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com; spf=pass smtp.mailfrom=uniontech.com; dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b=GekOWab0; arc=none smtp.client-ip=54.92.39.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=uniontech.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b="GekOWab0"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uniontech.com;
	s=onoh2408; t=1781003838;
	bh=UgtN+oB4FcagJkTFTS4P1GpJ1+B7pOqtyMC1DRlgFl0=;
	h=From:To:Subject:Date:Message-Id:MIME-Version;
	b=GekOWab0Ds7U52uZeoLs+SgEMMpMc7V0EBK5jaWyh1p+6X88jToFQckq7yrO+hRE5
	 0HeXqx4rNdfPwcJkd6QP7Y1S2Yd4PkV6re+WAgp2CqXgP69kuPNFHUOHxtfOCHokeH
	 6R43zMoGiGdGICCociGCySMYTAuyHyB0dMQQ+u70=
X-QQ-mid: zesmtpgz5t1781003833tabc8093b
X-QQ-Originating-IP: abG4cnEg0X5sVg3eFKFW4C2owj9uEdAHchTDyl6Ix1Q=
Received: from localhost.localdomain ( [123.114.60.34])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Tue, 09 Jun 2026 19:17:11 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 1
X-BIZMAIL-ID: 14170577481076518643
EX-QQ-RecipientCnt: 5
From: Yingjie Gao <gaoyingjie@uniontech.com>
To: linux-xfs@vger.kernel.org
Cc: cem@kernel.org,
	djwong@kernel.org,
	linux-kernel@vger.kernel.org,
	Yingjie Gao <gaoyingjie@uniontech.com>
Subject: [PATCH 0/2] xfs: fix inode leak and clean up attr intent recovery
Date: Tue,  9 Jun 2026 19:16:17 +0800
Message-Id: <20260609111619.1866748-1-gaoyingjie@uniontech.com>
X-Mailer: git-send-email 2.20.1
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: zesmtpgz:uniontech.com:qybglogicsvrgz:qybglogicsvrgz5b-1
X-QQ-XMAILINFO: NvGGTAUhB2iWNMfvTlXi7oCIgH7ypEo9ma5X1Cnm2iluJ9wo7HoXLmYx
	2WJmPUPX3SbaPUng9ZORFuFx6uLjpC8BjixIUwR+l/V/LgCyq+Ewxo34+qCHJkEd0caDl0x
	LcMZ1G9MBMQiebJlOWUjf0QiE0orOtbbNz0vywIiT0BRYAnNU0RvDJH6mGcEI86NI2NcilD
	1thQNtAPtvF+CL0eXUP0UaEIVruZcLA/2fFaOpF9cC0UBdDcaN4SQkQ0UM+w8BDayjL/xyh
	zvQfn6qux9Zh3RcF+kmlTmUL4cpfT1CohUlMyXQN2kZREifzQCFoe9fRZkG9xMoJIo5c8qH
	QQoHLV+N4StC1h/fcpfQBH8tMyKILshuttcpB0Q31fx8gs4lClFP70BPZ1sGYc767d2HBhp
	OraPyyH5r4KnvNTT/ptYpVn8itDgS1MJ8zQLPjniZ99QCHW3KQdsvJbwFdPYmZotL2gsy/x
	lahccwW0glaXV4tNhmvQHbuY/dsHs019+8mjLoCfbYhLYXk6AbTC0MJj0SHi+ioBzJ2UMJO
	dsqrSr4MZAGE2Jk93xMTQg964lqq/zw6xNqDd6pbpWAeHGp7IClnbjcjTkGojuc+rwNnH1e
	R08fduRxw6Nje5PDKz6ztjXosB6xbmx+E8X6sDPOcq6UvJ/B+MIOy4Iz/srmX7fmZQ8uAKz
	pP6heQ4uxN8Vii5/DcWv0UHLyJpjDlfLPNIGZBk/9jWgtTztx4iMk2BfJirHpU5diTb1a9G
	6d0t+hrm9IJgLi5iscQ8RjRcInEmICyGNcFx/XA2KB7EgUKzxuA5/Dkvcot7owmBmkaIvhk
	nxzIO21qokmQrM7+Y/+TlYnlmPIaQ7lP5YCKm3MQqs6t7/TUiwdvlwktge7ZJdZi+dOhw2v
	IvB19Hbmz7nPEsvqNHavzdVGIkWi1xIsPIvYeP/GK32yCFWagu5fgyrpu+NOqAqbTrlLMUV
	nwqmAZcLR4S1ayDEqQrEAL+Ab5Ri9dcEs7a74Mh5kfhMbRPgo/rILu0N79S/0iIXlOm8e24
	Xlx0sUZUN53sSBMqwK
X-QQ-XMRINFO: Nq+8W0+stu50tPAe92KXseR0ZZmBTk3gLg==
X-QQ-RECHKSPAM: 0

Hi all,

The first patch fixes a leaked inode reference in
xfs_attr_recover_work() when transaction allocation fails after the
recovered attr work item has been attached to the defer pending list.

The second patch cleans up the same function's exit paths so they follow
the same linear cleanup style as the neighboring bmap and exchmaps
recovery helpers, and initializes the local error variable in the same
style.

Thanks,
Yingjie

Yingjie Gao (2):
  xfs: fix inode ref leak in attr intent recovery
  xfs: clean up attr intent recovery error paths

 fs/xfs/xfs_attr_item.c | 17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)

-- 
2.20.1
