Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7F51486E58
	for <linux-xfs@vger.kernel.org>; Fri, 21 Aug 2026 12:33:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.33
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787315621; cv=none; b=jxcqVU3hXHTsWVHNsqXfmP+/J0HPxHMyWXElZcl2bSlFEOQxrn6KM1uR/Gb7nhCzUnYUnQodUeH2NSGZwiVdyWKWr40SjCJ3XR36yoU9gj6yPrLvJff4cCx5K+wkKuoCzKoYXlVnOyWX80Z5P5FYNPzApZPBviohuHGcSXUXRNA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787315621; c=relaxed/simple;
	bh=ExMBDFobXnMpp6RdVhm0dYjGLANPAQ4yQMEKSXVnyY0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:From:In-Reply-To:
	 Content-Type:References; b=oJd5Qf7+cC6RSi74FXsr6KP+g+kO/dIJBbj8rAL22kSdAcMW3lzYaSj5I02AXV65mXd/yWsMUXma9pxFjCTxMOH8XLm8eYffqwrn9ZMML5AgVRXjhEkY8Ui5ViB1PHLYdvmmS+ABPqfL4RnRDn1g4+WwmqvHXQAoBTOWlfRvggE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=o9kbQum0; arc=none smtp.client-ip=203.254.224.33
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="o9kbQum0"
Received: from epcas5p2.samsung.com (unknown [182.195.41.40])
	by mailout3.samsung.com (KnoxPortal) with ESMTP id 20260821123334epoutp0394a75916e877f67e50a2283c226af628~N0hT4lRIY1755317553epoutp03b
	for <linux-xfs@vger.kernel.org>; Fri, 21 Aug 2026 12:33:34 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20260821123334epoutp0394a75916e877f67e50a2283c226af628~N0hT4lRIY1755317553epoutp03b
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1787315614;
	bh=ODaDgCCYCUHp5n0OTjvR5sPE2vW6JgnD3H3aVJw7xl0=;
	h=Date:Subject:To:Cc:From:In-Reply-To:References:From;
	b=o9kbQum0UOIciTe1w+FMjdMqRXvY8anflXXhHzMGg27Ab2YuKiFWtBWaLGnuWBBU8
	 wCQYIhkf8/QT9F0Pg3KB4vl6jTMd+YRGySws7ri5ruxI1S1RXXe8LA4VzGgFKthsOV
	 w32bX2trw5kmp7UorekJiSDQXPEek084L4a3dPW0=
Received: from epsnrtp04.localdomain (unknown [182.195.42.156]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTPS id
	20260821123334epcas5p2010e9c4ae5f4bac56498d380910a878b~N0hTTU-Da0398603986epcas5p27;
	Fri, 21 Aug 2026 12:33:34 +0000 (GMT)
Received: from epcas5p1.samsung.com (unknown [182.195.38.88]) by
	epsnrtp04.localdomain (Postfix) with ESMTP id 4hRKV508qSz6B9m5; Fri, 21 Aug
	2026 12:33:33 +0000 (GMT)
Received: from epsmtip2.samsung.com (unknown [182.195.34.31]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTPA id
	20260821123332epcas5p2b0a3d8c25ea3f8f148f16031818b9bdc~N0hRs26Kr1514515145epcas5p2P;
	Fri, 21 Aug 2026 12:33:32 +0000 (GMT)
Received: from [107.122.11.51] (unknown [107.122.11.51]) by
	epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20260821123330epsmtip22fa01d534d6b61e2ad320efe56cf7b2e~N0hQBUPp32063620636epsmtip27;
	Fri, 21 Aug 2026 12:33:30 +0000 (GMT)
Message-ID: <aac9db64-691c-4632-879e-bbf88784249d@samsung.com>
Date: Fri, 21 Aug 2026 18:03:29 +0530
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 5/6] xfs: write stream based AG placement
To: Christoph Hellwig <hch@lst.de>
Cc: brauner@kernel.org, djwong@kernel.org, dgc@kernel.org, jack@suse.cz,
	cem@kernel.org, axboe@kernel.dk, kbusch@kernel.org, ritesh.list@gmail.com,
	linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-block@vger.kernel.org, gost.dev@samsung.com
Content-Language: en-US
From: Kanchan Joshi <joshi.k@samsung.com>
In-Reply-To: <20260819072902.GA2332@lst.de>
Content-Transfer-Encoding: 7bit
X-CMS-MailID: 20260821123332epcas5p2b0a3d8c25ea3f8f148f16031818b9bdc
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
cpgsPolicy: CPGSC10-542,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20260717125638epcas5p2fb7128170d2443be3cfe1a7687d0c5fd
References: <20260717125538.508925-1-joshi.k@samsung.com>
	<CGME20260717125638epcas5p2fb7128170d2443be3cfe1a7687d0c5fd@epcas5p2.samsung.com>
	<20260717125538.508925-6-joshi.k@samsung.com> <20260819072902.GA2332@lst.de>

On 8/19/2026 12:59 PM, Christoph Hellwig wrote:
> On Fri, Jul 17, 2026 at 06:25:37PM +0530, Kanchan Joshi wrote:
>> If AGs are fewer than write streams, write streams are distributed into
>> available AGs in round robin fashion.
> 
> I think we should just limit the number of available write streams
> to the number of AG, as otherwise we'll get into a bit of a mess.

To confirm: given above quoting, for the other two cases (i.e., Streams 
<= AGs), are you open to stream-based AG-sets modulo inode hashing (that 
you suggested to skip in previous patch)?
And is this point only for the case when Streams > AGs?

This case can happen for hw streams, but for pure software streams, we 
will not hit this case because the filesystem determines the stream 
count based on the AG count.

> And for the case of the hardware write streams query them in mkfs
> to align the AG geometry to that.

If this is only for the streams > AGs case, the filesystem can just 
clamp down to match, turning it into a 'streams = AGs' case.
And that means no changes in mkfs. Is that fine?
Related benefit is to skip tricky mkfs AG calculations right for future 
device sizes and varying stream counts.
