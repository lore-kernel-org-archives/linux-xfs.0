Received: from toucan.tulip.relay.mailchannels.net (toucan.tulip.relay.mailchannels.net [23.83.218.254])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5958244C94
	for <linux-xfs@vger.kernel.org>; Thu, 15 Aug 2024 19:44:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=23.83.218.254
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723751080; cv=pass; b=GrDOUVujcDuFHnM865xGMnOhKmdOFBXnlMNy0nmEy26+8rPZIQAL5UmuKsM/HBJbpjqAG6UZFsM2AYU/9Xde1KDf+jLABq8psAMEBTZJvvAGE8kzX8cmoe+vTugnybEztHFp5c420guGkg/heViLPoEm8ynODo820Bii93OseRk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723751080; c=relaxed/simple;
	bh=sDi47lle6+ZnZ+Ow0opxwBtu9z0DRPQ3+RQv0j0AVpM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jPBfat+e7l+eRvs0LG3tSQSV+fZ5wRXwdbxAxx2Bvi32VZvtAVm3rl6rkzcT3e0HKsCq10M3op6YTTaNjDqvPFMY14Fow0mOHKHAeSOXVk9K5Y5rNEHambUstS/seotuBle+2l+XBnetuAZyJBos0zglZtjqr3XJYTaQOq3PvA0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=templeofstupid.com; spf=pass smtp.mailfrom=templeofstupid.com; dkim=pass (2048-bit key) header.d=templeofstupid.com header.i=@templeofstupid.com header.b=Jf5jRmzG; arc=pass smtp.client-ip=23.83.218.254
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=templeofstupid.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=templeofstupid.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=templeofstupid.com header.i=@templeofstupid.com header.b="Jf5jRmzG"
X-Sender-Id: dreamhost|x-authsender|kjlx@templeofstupid.com
Received: from relay.mailchannels.net (localhost [127.0.0.1])
	by relay.mailchannels.net (Postfix) with ESMTP id 11B7C842E5
	for <linux-xfs@vger.kernel.org>; Thu, 15 Aug 2024 19:36:52 +0000 (UTC)
Received: from pdx1-sub0-mail-a210.dreamhost.com (unknown [127.0.0.6])
	(Authenticated sender: dreamhost)
	by relay.mailchannels.net (Postfix) with ESMTPA id BC358843AA
	for <linux-xfs@vger.kernel.org>; Thu, 15 Aug 2024 19:36:51 +0000 (UTC)
ARC-Seal: i=1; s=arc-2022; d=mailchannels.net; t=1723750611; a=rsa-sha256;
	cv=none;
	b=BCqzV6bcrZYiQyLuytzAuu8dFpJUEstL4l0xp40GqyQ+ftGKLPR63+O+VncjZJ/jSDbrLO
	Ga9jlrXQ3qWnnSvSCxfVbI+npv1f1wp2JvWnYisB2scgS2HwcUXE08PtkGsjhqMaOFHV02
	Lwuwq11UPAA8NWrxjOj2fFn3bkbs6GMQua0OQ1nWT6j2qrWUSUzIixMSHKcSLONIM5Bqz9
	4p4kocM90Qn/d9JLc6zmHXmTsdnKbX4nbgXv1ld+jKMjesCPi41XphOpiKh0zOCUX0dHRy
	pndjbbaLq8sjCe+aKqg3SKjoJEmOUKDneofl/g0zJfcftBIDuwuZDf4ZVx4Z1A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mailchannels.net;
	s=arc-2022; t=1723750611;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=d6eEeYvoaLrlXlELqiuQrkY1BKA6OHscTlcfI7Dk5mE=;
	b=IZ5xjWnihP1UGR1/06SQAmuC/kjN8yZNxEeLjImOhkSx5BPy3WV7BlKdhcckNUW/EMpAS3
	HsQQeiZqPiuBiBc7n8GyBC8ENuhLfiJP1DWTGBMxPfiwgvkkBgb7XpwPEapVdDns+Fd1tj
	ZLJ+euhjb6c7NLO0PC+S13pOB1YHMjmCSmFF9gM/+HWh4QkDFPed5iKuU3Osp5oMwqHI5G
	Xrlro9Xc5xyWqMBu9iKRJa5J+kaO/wtNWMjzf0ofxMi+FFuahla/hg3J58s8wPYSk//lJ2
	8+DUnMUAQSZ0FyNtcIeAMdutoMQU/g0JvyS/SKZ3ugZ0vYTPa1oFE/jNtfk8Yw==
ARC-Authentication-Results: i=1;
	rspamd-587694846-mw6dw;
	auth=pass smtp.auth=dreamhost smtp.mailfrom=kjlx@templeofstupid.com
X-Sender-Id: dreamhost|x-authsender|kjlx@templeofstupid.com
X-MC-Relay: Neutral
X-MailChannels-SenderId: dreamhost|x-authsender|kjlx@templeofstupid.com
X-MailChannels-Auth-Id: dreamhost
X-Dime-Desert: 26e0e3cf010eb9bf_1723750611987_287577319
X-MC-Loop-Signature: 1723750611987:1180613728
X-MC-Ingress-Time: 1723750611987
Received: from pdx1-sub0-mail-a210.dreamhost.com (pop.dreamhost.com
 [64.90.62.162])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384)
	by 100.127.182.137 (trex/7.0.2);
	Thu, 15 Aug 2024 19:36:51 +0000
Received: from kmjvbox.templeofstupid.com (c-73-70-109-47.hsd1.ca.comcast.net [73.70.109.47])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: kjlx@templeofstupid.com)
	by pdx1-sub0-mail-a210.dreamhost.com (Postfix) with ESMTPSA id 4WlFkC3fNKzC6
	for <linux-xfs@vger.kernel.org>; Thu, 15 Aug 2024 12:36:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=templeofstupid.com;
	s=dreamhost; t=1723750611;
	bh=d6eEeYvoaLrlXlELqiuQrkY1BKA6OHscTlcfI7Dk5mE=;
	h=Date:From:To:Cc:Subject:Content-Type;
	b=Jf5jRmzGmDREJYzKId53hlRi4w8P730a//q692wIDq6S+0e462DeUuusyM6+YZ4YT
	 uSpT4XNi0R0MPzjZC+lO+t5VDGt2tO9U7bBW5et80JjRo9S8uLmjBKETgE9NAbAWXX
	 y+d93UQisBxDNGTcBPpK2zmKMF2duku+m0z1gxTCIfS/41PwLZmlaBqq86zIOQp7bB
	 N+p2heqqLXxx4O/YGvoitVLS+mGx9H/s0R3MCPbznSKlSq+YN0Ykzkza7R88zwspq1
	 Or7fBJZXSgJDD0udX06Oln8QMO9IGxee+2YLV2Lm+dtPs3tOrUSCKQQQv6xZJNBBOX
	 /XCeHkP5mWunw==
Received: from johansen (uid 1000)
	(envelope-from kjlx@templeofstupid.com)
	id e0064
	by kmjvbox.templeofstupid.com (DragonFly Mail Agent v0.12);
	Thu, 15 Aug 2024 12:36:50 -0700
Date: Thu, 15 Aug 2024 12:36:50 -0700
From: Krister Johansen <kjlx@templeofstupid.com>
To: Chandan Babu R <chandan.babu@oracle.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Dave Chinner <david@fromorbit.com>
Cc: Dave Chinner <dchinner@redhat.com>, Zorro Lang <zlang@kernel.org>,
	linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: [RFC PATCH 0/2] xfstests: fstests for agfl reservation
Message-ID: <cover.1723690703.git.kjlx@templeofstupid.com>
References: <cover.1723687224.git.kjlx@templeofstupid.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1723687224.git.kjlx@templeofstupid.com>

Hi,
This set includes a test to trigger the xfs_bmap_extents_to_btree WARN
that tends to the the most observed symptom of the dependent allocation
failures that this author encounters.  The patches to fix the problem
also introduced a failure in xfs/306.  I'm including a fix for that as
well, though if this is an inappropriate resolution of the underlying
problem, I'm happy to take another approach.

This is sent as an RFC since it's my first foray into submitting
xfstests.  The 608 test should be deterministic on kernels that precede
the AG-aware allocator re-write.  On my machines on recent kernels I'm
getting about a 40-50% success rate with triggering the bug with this
test now.

-K

Krister Johansen (2):
  xfs/608: a test case for xfs_bmap_extents_to_btree allocation failure
  xfs/306: update resblks to account for increased per-ag reservation
    size

 tests/xfs/306     |   2 +-
 tests/xfs/608     | 372 ++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/608.out |   2 +
 3 files changed, 375 insertions(+), 1 deletion(-)
 create mode 100755 tests/xfs/608
 create mode 100644 tests/xfs/608.out


base-commit: f5ada754d5838d29fd270257003d0d123a9d1cd2
-- 
2.25.1

