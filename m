Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=203.254.224.25
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794359090;
	b=NvLYJFKlNPH+qYLLCeZJ6hXshNRbNWkqbzpk7RUmHs5snm2OqDxw2QwoQWF96t6tfYnH
	 BWKu6DtNLl+iul13UhYApnw/zTn6cqO4dOeRWtpW31MX7F7E5JWsdawr2QvtQXO2f2GIe
	 qvfClOR+U2PvH0erVsM/sBWiSBSSrGXD+ACtV8nANNZAZay4qYH59B3kHVmihecoW7O7S
	 GUk8lus4d30nkCdKOUFj8ASB2GbMaMI3w3Y+unUd0VJm/IK7zXaJj6Nm601fIlWv3fmPv
	 Ttf8T2PWsh7NLaRA0SNJv8kHb22SdN+SgbvYXPo9x6zE6jZcZFrSkRTKEgJQpVFBKTw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794359090;
	h=DMARC-Filter:Received:DKIM-Filter:DKIM-Signature:Received:Received:
	 Mime-Version:Subject:Reply-To:Sender:From:To:CC:X-Priority:
	 X-Content-Kind-Code:In-Reply-To:X-CPGS-Detection:X-Drm-Type:
	 X-Msg-Generator:X-Msg-Type:X-Reply-Demand:Message-ID:Date:
	 X-CMS-MailID:Content-Transfer-Encoding:Content-Type:X-Sendblock-Type:
	 CMS-TYPE:X-CPGSPASS:X-CPGSPASS:cpgsPolicy:X-CFilter-Loop:
	 X-CMS-RootMailID:References;
	bh=GiKvb46pmPIsIzjT9+8NqIO6uycJTt0qqmhwF5WaVL0=;
	b=OdLsdAGO+e6jNxv8XY6AnMRzhmRpVjbm7bGprind4XfMcwW/y9noeTWva3AWbkiXOwCW
	 StB56m7qfJX4l9/Cn3OGyzMPUKJDiJDJEqZKYPXswMvndqvklZ/hm5+po0+RED6FvW2ly
	 p/IbtOrCLtTJV7lbkY9cc0tjfpwGQy9lfkLd2nfnLVia10DiZTFIYd6wD/xg0H3/bRA9k
	 xEscY5QJBOYvYZGp79VHrI+oFaC84SIMJ5Qu4/tauJTAQJionsoUxqVnjebcQE+N6GlRf
	 cMDImzMp8mYXwQrEDych1VmV+PKSU3S+sLcU7C3t+INRJvs6syTEUbOnCBHul34kARg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=samsung.com;
	spf=pass smtp.mailfrom=samsung.com;
	dkim=pass header.d=samsung.com header.i=@samsung.com header.a=rsa-sha256 header.s=mail20170921 header.b=BKktBoTX;
	arc=none smtp.remote-ip=203.254.224.25
Received: from mailout2.samsung.com (mailout2.samsung.com [203.254.224.25])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 223C6606A320
	for <linux-xfs@vger.kernel.org>; Wed, 11 Nov 2026 01:04:48 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 223C6606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=samsung.com header.i=@samsung.com header.a=rsa-sha256 header.s=mail20170921 header.b=BKktBoTX
Received: from epcas2p2.samsung.com (unknown [182.195.41.54])
	by mailout2.samsung.com (KnoxPortal) with ESMTP id 20261111010446epoutp02fd0cf37c51bfa3bb6350fe7392129fdf~m2BUasuR90998209982epoutp02S
	for <linux-xfs@vger.kernel.org>; Wed, 11 Nov 2026 01:04:46 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20261111010446epoutp02fd0cf37c51bfa3bb6350fe7392129fdf~m2BUasuR90998209982epoutp02S
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1794359086;
	bh=GiKvb46pmPIsIzjT9+8NqIO6uycJTt0qqmhwF5WaVL0=;
	h=Subject:Reply-To:From:To:CC:In-Reply-To:Date:References:From;
	b=BKktBoTX8zlzZefXM6WrPLscwhV9AVJTACR4ESI5kvenc2CWe6YpLQ+Zes/x8OgZn
	 faKXMyYINlI88I8I3yrUUBqEEjJMpCmZ7vKKPTJVQQoWzM1slDeB4NusseM9MX9GTq
	 w0l6B7HcO5FMRzDqHRv55cMjRW+dTjzsyaG5ty90=
Received: from epsnrtp04.localdomain (unknown [182.195.42.156]) by
	epcas2p3.samsung.com (KnoxPortal) with ESMTPS id
	20261111010446epcas2p39e5b6a345df9915383a215e287457105~m2BUMojI72708527085epcas2p3n;
	Wed, 11 Nov 2026 01:04:46 +0000 (GMT)
Received: from epcas2p2.samsung.com (unknown [182.195.38.207]) by
	epsnrtp04.localdomain (Postfix) with ESMTP id 4jPQKV0fNYz6B9mB; Wed, 11 Nov
	2026 01:04:46 +0000 (GMT)
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
Mime-Version: 1.0
Subject: RE:(2) [PATCH 1/2] xfs: number the cache flushes submitted to each
 buftarg
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
In-Reply-To: <avIGZ9ABd_pXSy1L@bfoster>
X-CPGS-Detection: blocking_info_exchange
X-Drm-Type: N,general
X-Msg-Generator: Mail
X-Msg-Type: PERSONAL
X-Reply-Demand: N
Message-ID: <20261111010445epcms2p7972ac621507b96f995e477b203e952dc@epcms2p7>
Date: Wed, 11 Nov 2026 10:04:45 +0900
X-CMS-MailID: 20261111010445epcms2p7972ac621507b96f995e477b203e952dc
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
X-CPGSPASS: Y
X-CPGSPASS: Y
cpgsPolicy: CPGSC10-223,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20261109174425epcas2p37306753cba345ce4909a28d2a77fb208
References: <avIGZ9ABd_pXSy1L@bfoster>
	<20261105-xfs-fsync-flush-seq-v1-0-299bdf5e28c3@samsung.com>
	<20261105-xfs-fsync-flush-seq-v1-1-299bdf5e28c3@samsung.com>
	<CGME20261109174425epcas2p37306753cba345ce4909a28d2a77fb208@epcms2p7>

On Mon, Nov 09, 2026 at 12:44:07PM -0500, Brian Foster wrote:
> > +	iclog->ic_flush_seq = 0;
> > +	if (iclog->ic_bio.bi_opf & REQ_PREFLUSH)
> > +		iclog->ic_flush_seq = xfs_buftarg_flush_start(log->l_targ);
>
> Bit of a nit, but it looks like this would be cleaner if we moved both
> of these a bit further up. I.e., zero ->ic_flush_seq right after where
> we init the iclog->ic_bio fields, and then move the assignment under the
> same block where we set the PREFLUSH flag. Hm?

Thanks, agreed. In v2 xlog_write_iclog() will zero ic_flush_seq right
after the ic_bio setup and take the number in the branch that sets
REQ_PREFLUSH.
