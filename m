Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=203.254.224.34
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794451185;
	b=y+8s/EmiJ+Xj8/eQSdKnu3/WRFCaNOSO6GmLkWZN0a14AOT4i/AU1nRGLNuzQNFb4Q8b
	 m0zQruawCpeEqs1SAAWrIBN8ZgYGd7LTYUa5WVzwC6ROCi7yq/0EBUxgo9TRqlqoMpp30
	 6oDMTvCBv/u3yvF9guZelWzVp37KlbfT2HR1dUU15yqBZioNw0XCX08u6GBJpbuH/2imz
	 oCHKYvOugl7dfwgnBKNcNun6DB7EfNOVES5KrMx225u4icfcDJaGzN1QLcqw69NdFA1MV
	 hDYKDiOKu7HJwcWtrA5dkHQFwMbBk492Z8C5UGpbIyoNfVDdUlEAy8C1LBjQhA5LghA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794451185;
	h=DMARC-Filter:Received:DKIM-Filter:DKIM-Signature:Received:Received:
	 Mime-Version:Subject:Reply-To:Sender:From:To:CC:X-Priority:
	 X-Content-Kind-Code:In-Reply-To:X-CPGS-Detection:X-Drm-Type:
	 X-Msg-Generator:X-Msg-Type:X-Reply-Demand:Message-ID:Date:
	 X-CMS-MailID:Content-Transfer-Encoding:Content-Type:X-Sendblock-Type:
	 CMS-TYPE:X-CPGSPASS:X-CPGSPASS:cpgsPolicy:X-CFilter-Loop:
	 X-CMS-RootMailID:References;
	bh=wsYANF54daBhggjQ4RY4e0s/Afqnu86Njwm4rLR8ebM=;
	b=j/9FskGPx1W9ebA8uTzbXrBGRrDffzdb7YV8gSJYcENln4jeFGn7TbnpJ9Auwuyj03cT
	 yUu7/dLTAYKOP7BgZVny+/PQv4ApGiKmryCi7Tt1NitzW/Jp5XgK63mwl4krjwK0MQXme
	 UU+g0YuKeaG28Y7twNfTemFLr0ARUh24zPjWwV5YWRoa7jqX6ypZTbt3xI/AuTcL+U6Ff
	 XsflXzjbkljhl29MgjpEvAoGU0oXKKSy67eJnnkwf8/eVZvw4jgz4VrzXykrTH1Ha6uMv
	 iRxwyOKM2AtqDsPOrs7HMlBJH8ZI7+XOjqJq0U5XIVC4uqyesHtRlQBpSZvKO3/4Mmg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=samsung.com;
	spf=pass smtp.mailfrom=samsung.com;
	dkim=pass header.d=samsung.com header.i=@samsung.com header.a=rsa-sha256 header.s=mail20170921 header.b=larGOYB6;
	arc=none smtp.remote-ip=203.254.224.34
Received: from mailout4.samsung.com (mailout4.samsung.com [203.254.224.34])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F70B606A323
	for <linux-xfs@vger.kernel.org>; Thu, 12 Nov 2026 02:39:44 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 9F70B606A323
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=samsung.com header.i=@samsung.com header.a=rsa-sha256 header.s=mail20170921 header.b=larGOYB6
Received: from epcas2p4.samsung.com (unknown [182.195.41.56])
	by mailout4.samsung.com (KnoxPortal) with ESMTP id 20261112023942epoutp04b2761b3079149f7ba6a34372bb2dc6d2~nK9e_z1ci2131421314epoutp04U
	for <linux-xfs@vger.kernel.org>; Thu, 12 Nov 2026 02:39:42 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20261112023942epoutp04b2761b3079149f7ba6a34372bb2dc6d2~nK9e_z1ci2131421314epoutp04U
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1794451182;
	bh=wsYANF54daBhggjQ4RY4e0s/Afqnu86Njwm4rLR8ebM=;
	h=Subject:Reply-To:From:To:CC:In-Reply-To:Date:References:From;
	b=larGOYB68zTGF/VPNg5UcZBHaphn3WBqzwW0rBTTQweED3P78SUZdSej9Y3L88H18
	 R2Gqz3LTBeGxjTtQ3GC8I+kO3BVC/TiaBitRtzkxVw13aRSQ9LIYd4zS5iRfRERxj/
	 d4a1iRwuKUc1P5C/D+olvcl+Rha4KiZGj1GPWkBI=
Received: from epsnrtp04.localdomain (unknown [182.195.42.156]) by
	epcas2p3.samsung.com (KnoxPortal) with ESMTPS id
	20261112023941epcas2p3c181fe46ed8eef70fc662c6dcef368f6~nK9enBBLN2364523645epcas2p3E;
	Thu, 12 Nov 2026 02:39:41 +0000 (GMT)
Received: from epcas2p4.samsung.com (unknown [182.195.38.209]) by
	epsnrtp04.localdomain (Postfix) with ESMTP id 4jQ4NY2tYcz6B9m5; Thu, 12 Nov
	2026 02:39:41 +0000 (GMT)
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
Mime-Version: 1.0
Subject: RE:(2) [PATCH v2 2/2] xfs: skip the fsync flush when a later flush
 has completed
Reply-To: daejun7.park@samsung.com
Sender: Daejun Park <daejun7.park@samsung.com>
From: Daejun Park <daejun7.park@samsung.com>
To: Brian Foster <bfoster@redhat.com>
CC: Carlos Maiolino <cem@kernel.org>, "linux-xfs@vger.kernel.org"
	<linux-xfs@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, Dave Chinner
	<david@fromorbit.com>, "Darrick J. Wong" <djwong@kernel.org>, Amir Goldstein
	<amir73il@gmail.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, Daejun Park <daejun7.park@samsung.com>
X-Priority: 3
X-Content-Kind-Code: NORMAL
In-Reply-To: <avR6G6TQehW08BD0@bfoster>
X-CPGS-Detection: blocking_info_exchange
X-Drm-Type: N,general
X-Msg-Generator: Mail
X-Msg-Type: PERSONAL
X-Reply-Demand: N
Message-ID: <20261112023940epcms2p691f2ef101b0e3988d15c4250877dfea3@epcms2p6>
Date: Thu, 12 Nov 2026 11:39:40 +0900
X-CMS-MailID: 20261112023940epcms2p691f2ef101b0e3988d15c4250877dfea3
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
X-CPGSPASS: Y
X-CPGSPASS: Y
cpgsPolicy: CPGSC10-223,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20261111142234epcas2p48d80bde0c65d09a2fd8bdfdc9bdd2b1f
References: <avR6G6TQehW08BD0@bfoster>
	<20261111-xfs-fsync-flush-seq-v2-0-b5c00c25d276@samsung.com>
	<20261111-xfs-fsync-flush-seq-v2-2-b5c00c25d276@samsung.com>
	<CGME20261111142234epcas2p48d80bde0c65d09a2fd8bdfdc9bdd2b1f@epcms2p6>

On Wed, Nov 11, 2026 at 09:22:19AM -0500, Brian Foster wrote:
> Hmm.. that's kind of interesting. So IIUC unless dm can pass through a
> preflush+data bio, it will split out the flushes and ignore any error
> status in favor of the packaged data I/O..?

Yes. dm sends the empty flush first and then reissues the data without
REQ_PREFLUSH. __dm_io_complete() drops the flush error when it reissues
the data.

I sent a fix to dm-devel. With the fix, a failed preflush fails the
iclog write, and XFS shuts down:

https://lore.kernel.org/r/20261112-dm-flush-data-error-v1-1-c83d3f8f3ac4@samsung.com

[...]
> But if you have to post this again I think it would be useful to
> describe this caveat in the commit log description as well. If there
> happens to be some currently unknown flush failiure scenario that
> materializes in the future and we don't currently hit due to spamming
> enough flushes, that would be a useful clue about a subtle behavior
> change.

Thanks, agreed. If I post a v3, the dm paragraph below the --- will move
into the commit log of patch 2.

Best regards,
Daejun
