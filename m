Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=203.254.224.25
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794538619;
	b=PTenYxVc675M+fuZ32YU6QGodEIhk8XQsRmuWtHvyWnKadUUSx0sZ+Vn6O54hh/vkOnR
	 uWapVu9yzntlidgEa3/sVkODJKDW5K+FjCAhBFqE5q4vE8BnWxY9gEj7mY1lYhsC4l8Ke
	 +FBqEgfvb46THmUuORpdzDK+vT8ycGuyivhEV89TNjJo4wVpcrlICKrgAd5VxXM8w/w7A
	 JENEs5VKrVI7gceO2NdL1Fwcz6GZmI7T7v15Qy4UV3Pljdjtpnbx1pBCJocBBsAzRlQ5K
	 2YejH66bZl7VjNAV8fQcOTeD8U0DWBefk0L8Hcxezmo1FmWnLHM3Nw6V0Y3iqcYa2KA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794538619;
	h=DMARC-Filter:Received:DKIM-Filter:DKIM-Signature:Received:Received:
	 Mime-Version:Subject:Reply-To:Sender:From:To:CC:X-Priority:
	 X-Content-Kind-Code:In-Reply-To:X-CPGS-Detection:X-Drm-Type:
	 X-Msg-Generator:X-Msg-Type:X-Reply-Demand:Message-ID:Date:
	 X-CMS-MailID:Content-Transfer-Encoding:Content-Type:X-Sendblock-Type:
	 CMS-TYPE:X-CPGSPASS:X-CPGSPASS:cpgsPolicy:X-CFilter-Loop:
	 X-CMS-RootMailID:References;
	bh=ycCYr2y1perWAyUcIfRv6NhffRDJqH/MBKX0SCT8qfU=;
	b=K4Qw3/Fgs/gCDLFIyILHJNGtLF5uaw3alCAYfWEGzNdry0eDzoZzYZMg3QOUVVvBdxnn
	 flad2iEbGggXWtDvWrSx3s0+vm1UO/If7M95aKI5UzJjJDVQizskrr7Sor8hh1lHuMF68
	 LFOv5dunWBsziXM5NOctNsXBVXVt9S/9V3syRgNP2o+tSCH89UHPyvVs8XLuTdQdghm6e
	 R8Aw0JxYTWxfdw9uJ8vaNDzAZast3h6tHUcpr5vmvYSUK/NMrZCOTcCc0q0wDf6KgriPk
	 dkpCG9prjmoXGbpVIFCdIh234LQAMzmMlT0sBgs3GTM835u6qxNwvgJZQMBYQffd/HQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=samsung.com;
	spf=pass smtp.mailfrom=samsung.com;
	dkim=pass header.d=samsung.com header.i=@samsung.com header.a=rsa-sha256 header.s=mail20170921 header.b=bULfZHXt;
	arc=none smtp.remote-ip=203.254.224.25
Received: from mailout2.samsung.com (mailout2.samsung.com [203.254.224.25])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65DBF606A31C
	for <linux-xfs@vger.kernel.org>; Fri, 13 Nov 2026 02:56:59 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 65DBF606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.a=rsa-sha256 header.s=mail20170921 header.b=bULfZHXt
Received: from epcas2p2.samsung.com (unknown [182.195.41.54])
	by mailout2.samsung.com (KnoxPortal) with ESMTP id 20261113025643epoutp02ce03f0cf4b0966177db981029237cea8~ne1okayoA2786827868epoutp028
	for <linux-xfs@vger.kernel.org>; Fri, 13 Nov 2026 02:56:43 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20261113025643epoutp02ce03f0cf4b0966177db981029237cea8~ne1okayoA2786827868epoutp028
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1794538603;
	bh=ycCYr2y1perWAyUcIfRv6NhffRDJqH/MBKX0SCT8qfU=;
	h=Subject:Reply-To:From:To:CC:In-Reply-To:Date:References:From;
	b=bULfZHXtpJHTKM4a6E18RMwDwrv0iWWnB5aE+KDycrf/WCFOHlVjRxNe5ZIfoAIHY
	 AisXQZl7NmijCTdIP1H8ALl1br0TKyNhO2Qeo4HKyWDWpyB5uo/GHdomrXxOn/jZHR
	 wXQwntt2lfCyh5cFw07KFn1mN9zUaKaTyWTOOcJs=
Received: from epsnrtp02.localdomain (unknown [182.195.42.154]) by
	epcas2p1.samsung.com (KnoxPortal) with ESMTPS id
	20261113025643epcas2p10e509a643c1d10f27687c7512aeed4e0~ne1oC-YuB3159431594epcas2p1k;
	Fri, 13 Nov 2026 02:56:43 +0000 (GMT)
Received: from epcas2p3.samsung.com (unknown [182.195.38.210]) by
	epsnrtp02.localdomain (Postfix) with ESMTP id 4jQhjk59TCz2SSKZ; Fri, 13 Nov
	2026 02:56:42 +0000 (GMT)
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
Mime-Version: 1.0
Subject: RE:(2) [PATCH 1/2] xfs/438: retry failed metadata writes again
Reply-To: daejun7.park@samsung.com
Sender: Daejun Park <daejun7.park@samsung.com>
From: Daejun Park <daejun7.park@samsung.com>
To: Brian Foster <bfoster@redhat.com>
CC: Zorro Lang <zlang@kernel.org>, "fstests@vger.kernel.org"
	<fstests@vger.kernel.org>, "Darrick J. Wong" <djwong@kernel.org>, Christoph
	Hellwig <hch@lst.de>, Dave Chinner <dgc@kernel.org>,
	"linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>, Daejun Park
	<daejun7.park@samsung.com>
X-Priority: 3
X-Content-Kind-Code: NORMAL
In-Reply-To: <avXIstx55STwYao7@bfoster>
X-CPGS-Detection: blocking_info_exchange
X-Drm-Type: N,general
X-Msg-Generator: Mail
X-Msg-Type: PERSONAL
X-Reply-Demand: N
Message-ID: <20261113025637epcms2p7293f70d38c194bcc0484811c63137f94@epcms2p7>
Date: Fri, 13 Nov 2026 11:56:37 +0900
X-CMS-MailID: 20261113025637epcms2p7293f70d38c194bcc0484811c63137f94
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
X-CPGSPASS: Y
X-CPGSPASS: Y
cpgsPolicy: CPGSC10-223,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20261112141007epcas2p462246c1d6a82b4540937ad955dbfd8ec
References: <avXIstx55STwYao7@bfoster>
	<20261112-xfs-438-dquot-retry-v1-0-73149b823246@samsung.com>
	<20261112-xfs-438-dquot-retry-v1-1-73149b823246@samsung.com>
	<CGME20261112141007epcas2p462246c1d6a82b4540937ad955dbfd8ec@epcms2p7>

On Thu, Nov 12, 2026 at 09:09:54AM -0500, Brian Foster wrote:
> On Thu, Nov 12, 2026 at 10:37:17AM +0900, Daejun Park via B4 Relay wrote:
[...]
> > +# The dquot buffer write must still be failing and retried here. A shut
> > +# down filesystem means that the test missed the hang it checks.
>
> Nit on the comment.. something like this is a little more clear to me:
>
> # Run a stat to confirm we haven't shutdown prematurely. We expect the
> # fs to be running metadata write retries. A shutdown fs at this point
> # means that we haven't properly tested for the hang.
>
> But this LGTM regardless. Maybe Zorro can fix that up if you agree:

Thanks, agreed. Your wording is clearer.

Zorro, could you replace the comment with Brian's when you apply this?
Patch 2 does not touch these lines.

Best regards,
Daejun
