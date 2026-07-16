Received: from mailout1.samsung.com (mailout1.samsung.com [203.254.224.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 529163E2742
	for <linux-xfs@vger.kernel.org>; Thu, 16 Jul 2026 12:27:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.24
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784204856; cv=none; b=kCMgrrCRFLnkpYWpD8jtKF9WVqD3W8wuaGHxfSTvP5WLUVtJuMS/odTpqYEns6ASRNRM8mTLAj4lBkJwArDUUNz4SeQqUavvd7N2gseg8sEcptGf5QjmKjrdEslxUJTZqTYgW9vTM8w6yFNyVccm45Hy57UdZQGhWyG4BbS94EQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784204856; c=relaxed/simple;
	bh=6a3Myq+YEczHskqy6H5LktCSv/08gjKKFs8PPfwvXO4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:From:In-Reply-To:
	 Content-Type:References; b=qovkE1nA3rtbHSiRyk/qKjbwyJycOPYyEFCAzqtDCY1ozTnjPK/oMiPpdMW+ROPWdBiyEN1Ziry8WNmP5zck053DUPuRAcqZOZqcVFSogFtn0arcIOu2s1AKHctF8UcHhkxjAk1uJUWN/tBlS8fnm6nTt2HJ0f0+Ex8nd/dXbnw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=lrSMTPsv; arc=none smtp.client-ip=203.254.224.24
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="lrSMTPsv"
Received: from epcas5p1.samsung.com (unknown [182.195.41.39])
	by mailout1.samsung.com (KnoxPortal) with ESMTP id 20260716122732epoutp011d736c6bc455caf362ce741caf6ea146~CxNwcdnP13150731507epoutp01R
	for <linux-xfs@vger.kernel.org>; Thu, 16 Jul 2026 12:27:32 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20260716122732epoutp011d736c6bc455caf362ce741caf6ea146~CxNwcdnP13150731507epoutp01R
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1784204852;
	bh=goVpL7phv0f5v85AoAM/QZBOHt0lBeS9xOxdnmRJRho=;
	h=Date:Subject:To:Cc:From:In-Reply-To:References:From;
	b=lrSMTPsvhirFZvmuKPdVvZe4wEm9pkIf2FYnRWaB0QlnYRwyxKwqAirvZEPcngvfH
	 0q+sCKiZArUftASUedHW+jEHhZC3AjeYESMt++ALvLajZXrjAdrRrvtE3TMtNoT78d
	 jvJV9XKbCbgYDc11CPrd/I7FYgese4lvAZWWBCFQ=
Received: from epsnrtp02.localdomain (unknown [182.195.42.154]) by
	epcas5p4.samsung.com (KnoxPortal) with ESMTPS id
	20260716122731epcas5p4b72a6b2d54f87de136569cb57bf22e21~CxNvuHdeA0311403114epcas5p4o;
	Thu, 16 Jul 2026 12:27:31 +0000 (GMT)
Received: from epcas5p3.samsung.com (unknown [182.195.38.95]) by
	epsnrtp02.localdomain (Postfix) with ESMTP id 4h1C3k27Ybz2SSKX; Thu, 16 Jul
	2026 12:27:30 +0000 (GMT)
Received: from epsmtip2.samsung.com (unknown [182.195.34.31]) by
	epcas5p1.samsung.com (KnoxPortal) with ESMTPA id
	20260716122729epcas5p1c1d760a6356d1234e8098d8a4436e541~CxNuCviDN1127111271epcas5p1B;
	Thu, 16 Jul 2026 12:27:29 +0000 (GMT)
Received: from [107.122.11.51] (unknown [107.122.11.51]) by
	epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20260716122727epsmtip277c923c3033f4e6c4f6432f6195bce6b~CxNsOdiBE0195101951epsmtip2R;
	Thu, 16 Jul 2026 12:27:27 +0000 (GMT)
Message-ID: <9cb5024f-7e39-4b02-8720-fb4a76affa60@samsung.com>
Date: Thu, 16 Jul 2026 17:57:26 +0530
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 2/6] iomap: introduce and propagate write_stream
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: brauner@kernel.org, hch@lst.de, dgc@kernel.org, jack@suse.cz,
	cem@kernel.org, axboe@kernel.dk, kbusch@kernel.org, ritesh.list@gmail.com,
	linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-block@vger.kernel.org, gost.dev@samsung.com
Content-Language: en-US
From: Kanchan Joshi <joshi.k@samsung.com>
In-Reply-To: <20260624181044.GW6078@frogsfrogsfrogs>
Content-Transfer-Encoding: 7bit
X-CMS-MailID: 20260716122729epcas5p1c1d760a6356d1234e8098d8a4436e541
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
cpgsPolicy: CPGSC10-542,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20260616181244epcas5p318804096b125c240c2155e54f76e2e07
References: <20260616180555.33338-1-joshi.k@samsung.com>
	<CGME20260616181244epcas5p318804096b125c240c2155e54f76e2e07@epcas5p3.samsung.com>
	<20260616180555.33338-3-joshi.k@samsung.com>
	<20260624181044.GW6078@frogsfrogsfrogs>

On 6/24/2026 11:40 PM, Darrick J. Wong wrote:
>> diff --git a/fs/iomap/direct-io.c b/fs/iomap/direct-io.c
>> index b36ee619cdcd..455fd5d97d25 100644
>> --- a/fs/iomap/direct-io.c
>> +++ b/fs/iomap/direct-io.c
>> @@ -348,6 +348,7 @@ static ssize_t iomap_dio_bio_iter_one(struct iomap_iter *iter,
>>   	fscrypt_set_bio_crypt_ctx(bio, iter->inode, pos, GFP_KERNEL);
>>   	bio->bi_iter.bi_sector = iomap_sector(&iter->iomap, pos);
>>   	bio->bi_write_hint = iter->inode->i_write_hint;
>> +	bio->bi_write_stream = iter->iomap.write_stream;
>>   	bio->bi_ioprio = dio->iocb->ki_ioprio;
>>   	bio->bi_private = dio;
>>   	bio->bi_end_io = iomap_dio_bio_end_io;
>> diff --git a/fs/iomap/ioend.c b/fs/iomap/ioend.c
>> index acf3cf98b23a..56ed5ba6a421 100644
>> --- a/fs/iomap/ioend.c
>> +++ b/fs/iomap/ioend.c
>> @@ -164,6 +164,7 @@ static struct iomap_ioend *iomap_alloc_ioend(struct iomap_writepage_ctx *wpc,
>>   			       GFP_NOFS, &iomap_ioend_bioset);
>>   	bio->bi_iter.bi_sector = iomap_sector(&wpc->iomap, pos);
>>   	bio->bi_write_hint = wpc->inode->i_write_hint;
>> +	bio->bi_write_stream = wpc->iomap.write_stream;
>>   	wbc_init_bio(wpc->wbc, bio);
>>   	wpc->nr_folios = 0;
>>   	return iomap_init_ioend(wpc->inode, bio, pos, ioend_flags);
>> @@ -187,6 +188,8 @@ static bool iomap_can_add_to_ioend(struct iomap_writepage_ctx *wpc, loff_t pos,
>>   	if (!(wpc->iomap.flags & IOMAP_F_ANON_WRITE) &&
>>   	    iomap_sector(&wpc->iomap, pos) != bio_end_sector(&ioend->io_bio))
>>   		return false;
>> +	if (wpc->iomap.write_stream != ioend->io_bio.bi_write_stream)
>> +		return false;
>>   	/*
>>   	 * Limit ioend bio chain lengths to minimise IO completion latency. This
>>   	 * also prevents long tight loops ending page writeback on all the
>> diff --git a/include/linux/iomap.h b/include/linux/iomap.h
>> index 2c5685adf3a9..44583429ffa4 100644
>> --- a/include/linux/iomap.h
>> +++ b/include/linux/iomap.h
>> @@ -120,6 +120,8 @@ struct iomap {
>>   	u64			length;	/* length of mapping, bytes */
>>   	u16			type;	/* type of mapping */
>>   	u16			flags;	/* flags for mapping */
>> +	u8			write_stream; /* write stream for I/O */
> I'm mildly confused by the types here -- the ioctl exposes a u32, iomap
> has a u8, and xfs seems to use u16.  I gather you want maximum
> flexibility in the uapi and that's the reason for the u32, but can the
> internal interfaces be made consistent?

Yes, using u16 within iomap will make it better.

> I also wonder what happens if the write stream ever becomes persistent,
> but this patchset doesn't go there, and maybe the programming model is
> simply that you have to set it every time you open the file?

Right, not trying to make things persistent.
