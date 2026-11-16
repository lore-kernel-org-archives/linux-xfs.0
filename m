Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=203.254.224.25
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794809055;
	b=SIh6UpZLcXjltr9A1T4QbaRNILp2T8/73UeISXYpzpsL0w+by3HFuGXZwUptIblNBRGM
	 9Oktk64D2VTj7CkQtE0qHo7GPbE2NENyJhc0y3eKgfOo43fNyyc1jOQTY28XcnMTFblWj
	 rvsSs2l9FjVvd/UsDNwVshA3lYkelvMGB4dYBPLh515lr7DUJx6MNebnkpwsd2AQz780u
	 9i1za1oK76BlNIjmvV1TRzbmqtoU2MDijHI9vIBCbTIzh/+mNGPJmEtBI9XSV5X5PAQx0
	 Ecilcl60SJvUeA70QFWY3UflfGTwMWSCofhITEsXEEJ0S5WBZEY3FBqxnBzo2adjOKg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794809055;
	h=DMARC-Filter:Received:DKIM-Filter:DKIM-Signature:Received:Received:
	 Received:Received:Message-ID:Date:MIME-Version:User-Agent:Subject:To:
	 Cc:Content-Language:From:In-Reply-To:Content-Transfer-Encoding:
	 X-CMS-MailID:X-Msg-Generator:Content-Type:X-Sendblock-Type:CMS-TYPE:
	 cpgsPolicy:X-CFilter-Loop:X-CMS-RootMailID:References;
	bh=H7xrcC5hwu+0yEElMphAO/Ot/SJCVLBsU/hVZPg1pME=;
	b=SuZxVosP5SNoqBaO8c48QDC+OBu3uCzgkhQAv9joDlTSG+KWIVoIzkBHN9kK6v5FAJIj
	 qv7rahQci6rPppps7ICrM9VdK50hNhnHOpqm8C/F+Z5SkI5sW5y7YDL8wBUcYGf/0YrzE
	 AHW3g3gv0Fs2acQLgfQlPMrCiIX0n9xuWlGJ6oHTuLnjC9dtr7oVngWbYzqZ6ksMNWTTN
	 OV7KGXKHLL7iGj7qz0/699lNXxcHHtqKZCz9TR/SBXUDjsI5G74yu34XSOtLViZcnwL7Q
	 nxnT1rH2/nGYq93/AmSn9oC1fgQJgdVONS/nimIqI2kRdzNI0B6OYk/shsy7jNh2UiQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=samsung.com;
	spf=pass smtp.mailfrom=samsung.com;
	dkim=pass header.d=samsung.com header.i=@samsung.com header.a=rsa-sha256 header.s=mail20170921 header.b=G9fJsEJF;
	arc=none smtp.remote-ip=203.254.224.25
Received: from mailout2.samsung.com (mailout2.samsung.com [203.254.224.25])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AC01606A337
	for <linux-xfs@vger.kernel.org>; Mon, 16 Nov 2026 06:04:14 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3AC01606A337
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=samsung.com header.i=@samsung.com header.a=rsa-sha256 header.s=mail20170921 header.b=G9fJsEJF
Received: from epcas5p4.samsung.com (unknown [182.195.41.42])
	by mailout2.samsung.com (KnoxPortal) with ESMTP id 20261116060412epoutp02580145be14eb1728408f7f64e287ce99~ocVLZxfOW0671406714epoutp02o
	for <linux-xfs@vger.kernel.org>; Mon, 16 Nov 2026 06:04:12 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20261116060412epoutp02580145be14eb1728408f7f64e287ce99~ocVLZxfOW0671406714epoutp02o
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1794809052;
	bh=H7xrcC5hwu+0yEElMphAO/Ot/SJCVLBsU/hVZPg1pME=;
	h=Date:Subject:To:Cc:From:In-Reply-To:References:From;
	b=G9fJsEJFVYkdthaI9CLk3cwfU6ERMSkI5fa5+IOEuks5sLCrHkkhSLmXV9Q7CGaUr
	 v/EouUU+9fVEzFQAld9V9hKmp+TMcQHzP1f49idBUogaGtKzs9ulAtZ+YxtXSwM4Zt
	 Pe3SFb+VDyVseNywLC/lRdf9GYBcWgdGZsp1zqKE=
Received: from epsnrtp02.localdomain (unknown [182.195.42.154]) by
	epcas5p4.samsung.com (KnoxPortal) with ESMTPS id
	20261116060411epcas5p4f0931d035187129266222d789488caad~ocVK4bShX0467004670epcas5p4p;
	Mon, 16 Nov 2026 06:04:11 +0000 (GMT)
Received: from epcas5p4.samsung.com (unknown [182.195.38.87]) by
	epsnrtp02.localdomain (Postfix) with ESMTP id 4jSckf5WCzz2SSKs; Mon, 16 Nov
	2026 06:04:10 +0000 (GMT)
Received: from epsmtip2.samsung.com (unknown [182.195.34.31]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTPA id
	20261116055714epcas5p2320c9165ed0817d0785bf8b1de6bbdda~ocPGc5QD60734207342epcas5p2t;
	Mon, 16 Nov 2026 05:57:14 +0000 (GMT)
Received: from [107.122.10.194] (unknown [107.122.10.194]) by
	epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20261116055711epsmtip274752e558afe0bba931f5cc6431889e2~ocPD6NEY31263312633epsmtip2A;
	Mon, 16 Nov 2026 05:57:11 +0000 (GMT)
Message-ID: <96c91d01-98b5-4b00-a20c-c3cbc4c1ebca@samsung.com>
Date: Mon, 16 Nov 2026 11:27:01 +0530
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 0/8] xfs write streams
To: Hans Holmberg <hans.holmberg@wdc.com>, brauner@kernel.org, hch@lst.de,
	djwong@kernel.org, dgc@kernel.org, cem@kernel.org, jack@suse.cz,
	axboe@kernel.dk, kbusch@kernel.org
Cc: linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	gost.dev@samsung.com
Content-Language: en-US
From: Anuj Gupta/Anuj Gupta <anuj20.g@samsung.com>
In-Reply-To: <896f049c-ca48-4c2e-9c2a-934f106b465c@wdc.com>
Content-Transfer-Encoding: 7bit
X-CMS-MailID: 20261116055714epcas5p2320c9165ed0817d0785bf8b1de6bbdda
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
cpgsPolicy: CPGSC10-542,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20261103111022epcas5p4df6a10b70dd9a92992c117669c7227fc
References: <CGME20261103111022epcas5p4df6a10b70dd9a92992c117669c7227fc@epcas5p4.samsung.com>
	<20261103110640.1000095-1-anuj20.g@samsung.com>
	<896f049c-ca48-4c2e-9c2a-934f106b465c@wdc.com>

On 11/12/2026 4:18 PM, Hans Holmberg wrote:
> Is the base using write life time hints?
> 
> I had to cherry-pick this upstream patch on top of your stream branch
> to be able compare against life time hints (as it was broken before)
> 
>   b8400c9fa Make linux file write life time hinting work (#12595)
> 


No, the base did not use hints. But for this setup (i.e., non-zoned 
xfs), it would change nothing.
All other xfs allocators ignore write-hints.
And NVMe driver ignores bio->bi_write_hint.

> I think it's worth highlighting that CAP_SYS_ADMIN is required for
> allocating streams. CAP_SYS_ADMIN is very limiting, so are you
> planning follow-up work to relax this? Christoph suggested a per-user
> rlimit on the number of streams as the nicer long-term option back in
> v4:https://lore.kernel.org/all/20260819071137.GD1541@lst.de/

Yes, agree that it is limiting.
Per-user limit is scheduled as a follow-up.
Relaxing the check later does not break existing users, and with the 
checks moved to
common code (as you suggested) it will be done in one place for all 
filesystems.
