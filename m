Received: from mailout1.samsung.com (mailout1.samsung.com [203.254.224.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A49E133939C
	for <linux-xfs@vger.kernel.org>; Fri, 16 Oct 2026 05:50:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.24
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792129856; cv=none; b=E0MQcsfAdPqYLKAdoi/kadn92yPQ5CGncEoKd2iksMByJdSPAJPcJc1V8rul+E0Fb0dI2JrjiGhhGJaJkYS2zyKfahIAlaJvxQhn1dEBjxGzo/D3IttBIyswBr9tI/9aAOjSuwzCgfv14Vqk3S5ym0XZkGI466QFZJeHW5LwnVM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792129856; c=relaxed/simple;
	bh=N9bLoMEXAyORyBUHfMJt0xAmZ0SQ39402416NzZ4rkI=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:In-Reply-To:
	 Content-Type:References; b=B6Vz+gXg8wD/M/37QrvdXOk+A/BzC/cnbgVmhdtBh33hM6uWVJhKiZjeGgg/6Qq8GpF+0cNZzINISbVaxSRAs2uzRP/TYtSto25eRtWP1FBR6rV3hBRqJiA01sNDa/zIyBg9EOt/x9WGXNLvwNj4ZGcRPnneW35m/LV4WTMi82Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=WSb29tyU; arc=none smtp.client-ip=203.254.224.24
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="WSb29tyU"
Received: from epcas5p2.samsung.com (unknown [182.195.41.40])
	by mailout1.samsung.com (KnoxPortal) with ESMTP id 20261016055047epoutp013001157abcf9035ebfe25b11491fc76b~e7Jnh3zm80855608556epoutp01a
	for <linux-xfs@vger.kernel.org>; Fri, 16 Oct 2026 05:50:47 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20261016055047epoutp013001157abcf9035ebfe25b11491fc76b~e7Jnh3zm80855608556epoutp01a
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1792129847;
	bh=NulQMBKqeqJeaJ5bzEpS/2rXPGab5nZ6k1FAtHlmFZI=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=WSb29tyUiOrybm4RBMVq2odfViFVUBWLtQex9WBMbHkX3/9+BXJMnhHOiP/Cf3Jd+
	 CG1bGLeoPBoGAJ7a/qosvRTxs48LfAzgSaroTw4Sl9DGLXXycVL84SPBabxiH393b6
	 xe5axRS5mXdC/VMBp+lTRDbztl2lyczx/T0dc5Js=
Received: from epsnrtp03.localdomain (unknown [182.195.42.155]) by
	epcas5p3.samsung.com (KnoxPortal) with ESMTPS id
	20261016055046epcas5p321392c6c10344c2d32caa1d2c6f71f7f~e7Jm9cY_v1134711347epcas5p3B;
	Fri, 16 Oct 2026 05:50:46 +0000 (GMT)
Received: from epcas5p2.samsung.com (unknown [182.195.38.88]) by
	epsnrtp03.localdomain (Postfix) with ESMTP id 4j5YvS5nzHz3hhTD; Fri, 16 Oct
	2026 05:50:44 +0000 (GMT)
Received: from epsmtip2.samsung.com (unknown [182.195.34.31]) by
	epcas5p4.samsung.com (KnoxPortal) with ESMTPA id
	20261016055044epcas5p480499de45c50b44005f4380b273f2fe4~e7Jkouif02663226632epcas5p4b;
	Fri, 16 Oct 2026 05:50:44 +0000 (GMT)
Received: from [107.122.11.51] (unknown [107.122.11.51]) by
	epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20261016055042epsmtip268e04fc79c853a2ff921c0e4ed67b167~e7JjEzT0j1484014840epsmtip2f;
	Fri, 16 Oct 2026 05:50:42 +0000 (GMT)
Message-ID: <bf0505d2-115d-43e9-95e8-2ed6a3404799@samsung.com>
Date: Fri, 16 Oct 2026 11:20:41 +0530
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 0/8] xfs write streams
From: Kanchan Joshi <joshi.k@samsung.com>
To: brauner@kernel.org, hch@lst.de, djwong@kernel.org, dgc@kernel.org,
	cem@kernel.org, jack@suse.cz, axboe@kernel.dk, kbusch@kernel.org
Cc: linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	gost.dev@samsung.com, Anuj Gupta <anuj20.g@samsung.com>
Content-Language: en-US
In-Reply-To: <20261015063246.103433-1-joshi.k@samsung.com>
Content-Transfer-Encoding: 7bit
X-CMS-MailID: 20261016055044epcas5p480499de45c50b44005f4380b273f2fe4
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
cpgsPolicy: CPGSC10-542,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20261015063425epcas5p23fd76d70af639f4bb138332ca3a575b0
References: <CGME20261015063425epcas5p23fd76d70af639f4bb138332ca3a575b0@epcas5p2.samsung.com>
	<20261015063246.103433-1-joshi.k@samsung.com>

Christoph, Darrick

The shape of the series is aligned with your feedback on v4 [1]. 
Possible to take a look and tell if anything should be changed?

I can fold that with the fix for the only real issue (partition related) 
that Sashiko reported in this round.

On 10/15/2026 12:02 PM, Kanchan Joshi wrote:
> since v5:
> https://lore.kernel.org/linux-xfs/20260921093147.59935-1- 
> joshi.k@samsung.com/
> 
> Fixes for issues found by Sashiko review; no changes in UAPI
> - fix 32-bit build: use do_div() for the inode-number hash in AG and
>    rtgroup selection
> - bound the stream pool to U16_MAX, the range of the stream id
> - cap the hardware stream count at U8_MAX, the most streams the block
>    layer can tag
> - tag the iomap_dio_zero() bio with the write stream, so sub-block
>    direct writes are not split across streams
> - document that the stream pool must outlive the mount a stream pins;
>    kernel-doc fixes
> - rebase on 7.3-rc7

[1] > since v4:
> https://lore.kernel.org/linux-xfs/20260717125538.508925-1- 
> joshi.k@samsung.com/
> 
> - stream reservation and fd handling moved to generic code, and the
>    stream id moved to struct inode from xfs inode (Darrick, Christoph)
> - stream id no longer shows in uapi: OPEN becomes ALLOC and returns
>    fd for any (unreserved) stream; OPEN_EXACT and GET are gone (Christoph)
> - ALLOC requires CAP_SYS_ADMIN (Christoph)
> - write stream and write life time hint are mutually exclusive at both
>    setters
> - stream pool lives on the buftarg (Christoph), which gives the realtime
>    device streams of its own: new patch to enable RT support (Christoph, Darrick)
> - software streams come first and work on any device; hardware streams
>    are enabled in the last (Christoph)

