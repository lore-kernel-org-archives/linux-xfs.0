Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=148.163.135.74
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794249300;
	b=awP7zSpfMSUi4Lg2VmDIR2jgaBUPDMbohHj22BNgfFRANXLZ9ajhT/uQjtb/Obhn5GXJ
	 gz6NI1qb4rrivggvs6cNRM8Po/B37iDAr2t76Nv5cRurDUjShPk1KvxJDsu+tcG/9iJ6i
	 OtmZx/WFnl9EPUajyrKORGPErZXOvTYgAsgFzENir+HnC9+AkhqTERDpABWdI8nhephw8
	 TdV3DRpFeqO5mpGkACHwP/tOkJ0eGxj7oXLIppvPQy3uFZIMMBpbk1NFAw91kU5jTURfm
	 k6GxP9whklYWZ9E3YfAuG6nQliFiXns19us0VF2Z9sS8UQOGkE3uyJUBzZLjsit9f0w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794249300;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 DKIM-Signature:X-Google-DKIM-Signature:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:X-Received:Received:Message-ID:
	 Date:MIME-Version:User-Agent:Subject:To:Cc:References:
	 Content-Language:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:X-Authority-Analysis:X-Proofpoint-ORIG-GUID:
	 X-Proofpoint-Spam-Info:X-Proofpoint-GUID:
	 X-Proofpoint-Spam-Details-Enc:X-Proofpoint-Virus-Version:
	 X-Proofpoint-Spam-Details;
	bh=rUkAN0D/BhV4eeepN5BkaPXtCpvrs73RQYqXxUHa58Y=;
	b=KdnD8HO+KpGZSyv2eVip08fZg2JKrH1qDvyqx4dkzQrUsILTxxnP+CMWeCHE1X0cEm5e
	 dVAy7Ri7IiZxcrqjl4crVWq2ytCddZsPcDKP1DZC7XiXyFmhhqfXiNtXRA0/5gZDXiNOX
	 lmEWfFhexGFU+FRHPd+pKFp8jhUuxEaixGYvwXsnfgOelNeOqnQIgpTXeN1YfvsjkYcPY
	 BrUKiYzulvkc4D3zvL6mfkTfeKduJEpHkfZPsz/jnz8THmHQESoWLvmkWonZrpRCNGFEH
	 zyd412HloHgVBJgnvTrpJmEbnrxu3tKOXMMa0HKGy6XRmdgn/mHT8XHg1d7DqZOw1SQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=columbia.edu;
	spf=pass smtp.mailfrom=columbia.edu;
	dkim=pass header.d=columbia.edu header.i=@columbia.edu header.a=rsa-sha256 header.s=pps01 header.b="l1c5/v8l";
	dkim=pass header.d=columbia.edu header.i=@columbia.edu header.a=rsa-sha256 header.s=lionmail header.b=TzTQAQZf;
	arc=none smtp.remote-ip=148.163.135.74
Received: from mx0a-00364e01.pphosted.com (mx0a-00364e01.pphosted.com [148.163.135.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C6E4606A325
	for <linux-xfs@vger.kernel.org>; Mon,  9 Nov 2026 18:34:59 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 1C6E4606A325
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=columbia.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=columbia.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.a=rsa-sha256 header.s=pps01 header.b=l1c5/v8l;
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.a=rsa-sha256 header.s=lionmail header.b=TzTQAQZf
Received: from pps.filterd (m0167070.ppops.net [127.0.0.1])
	by mx0a-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6A9HYh442298251
	for <linux-xfs@vger.kernel.org>; Mon, 9 Nov 2026 13:34:59 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps01; bh=rUkA
	N0D/BhV4eeepN5BkaPXtCpvrs73RQYqXxUHa58Y=; b=l1c5/v8l49hmG858fai+
	UKKiQ9cU4c/8V70uMPbqdB6EqIOXK5UkRD67zYVJ7g9z5KskWJNjpCpK/5GCbEwZ
	OtFQRwfcBaaWbQeICmqIuzEsFQM3maFplPKYmMt4RnF0f/P41Skphkwcf+w2PsHV
	inDXihKZrJ2ip+R144IbTbMX/M+KgfSnB2XX/itGgslUqPKd8uYcdDwLrnmjoS9j
	USZhhvtSjUkCwxCP56zcLZrys8cs29eG8hL8Y0xgUvxqVJ3jTLBK1DFRHzRvrD5i
	BJONdkj1fWuvBAPtJTYtw1lJFf3jDBILj4iPygz4co7c0OqZMrIjUU4SuQGohGZQ
	lQ==
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com [209.85.222.200])
	by mx0a-00364e01.pphosted.com (PPS) with ESMTPS id 4huhda1br7-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-xfs@vger.kernel.org>; Mon, 09 Nov 2026 13:34:59 -0500 (EST)
Received: by mail-qk1-f200.google.com with SMTP id af79cd13be357-93cb93c874bso254621585a.0
        for <linux-xfs@vger.kernel.org>; Mon, 09 Nov 2026 10:34:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=columbia.edu; s=lionmail; t=1794249298; x=1794854098; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=rUkAN0D/BhV4eeepN5BkaPXtCpvrs73RQYqXxUHa58Y=;
        b=TzTQAQZfq0XjUPsPaOslkTzmhx3irVPF938FT70tcVsvI6v3NI1XZz5NvlPd7o6cFk
         eaFKyGOz23E/d76UJyJ9nIBP3L5j8WDAS4cSHn9Q1rNFL6IDBIwWgCfJgrOZohU4/UF3
         jrEeHTU1waD4fHO68HtTIQ26sq0lfxUXULaUBJYPklefoFBJdReKvD8lc6ez/pbU1jSB
         ZwDQTLet7vMUTm7N7ozc+3gmgp/STNO4l9j9Vm8QhHXA5AImB9UiQE9dshyTBmlpJkZj
         X6NZV/22syct225nemTs5+lkfpJpWkMLubsFMQO3//vFGNoFgkt3zo8aDANNondVPAp9
         lUTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794249298; x=1794854098;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=rUkAN0D/BhV4eeepN5BkaPXtCpvrs73RQYqXxUHa58Y=;
        b=JVep5vLNTmTR/b58q6XlZHevUqAS+VroPgDlttN3M/8sU3zCQPSLxyQO7+GMdCPD2G
         xdNXTMP8je5JIQY1It70e4UX2dvqZf5dqtnr+jJO93zwjjX1u7NqZ22T8A1vaxjt/aZe
         c7nhCJ8p7y3urNBBhjxnZubvQQaGw4BFB02OFIsaofKOZfHRuB4idUXqrrOPiIwvto3Q
         GP9MVQHn5ly9F9YW+6x7LMm8Ww5ipst9kOFmB/fHhCLLTILsalAdDn0jRQPeG2pj7GFP
         9N0GywYrC1PHxNVyqbUo4qSzY/FiWfwurTAs7elaUk7w6DKWemSoo2scKzCeI6/hj0q4
         5mNQ==
X-Forwarded-Encrypted: i=1; AL+hErEjV9EiOwe1FeEpUoK1xyBC0r3FJCDkVIqG5tDtDtvUt8jRhtjV+2PmVpkSUYjDXAhIsrs1XsmgrB4=@vger.kernel.org
X-Gm-Message-State: APuU4Z+v9azAxCFL+3PDrQqB9h7ElZr75TwN3vv4g7yWg5TFLmG8ymqn
	rBFOcHPjaGlU68i1pppCJxHhO/j+H/S0RCXB0Jfr7w+1Dw9e07X6EBCo3gS1uOEyfkrr9l7cH9L
	t1F3A3WUgUIpytkddQhpon8fyc1bSJzZKIGnbdUypWuuBwHfZmxQ25pkXMQ==
X-Gm-Gg: AYBFou0KgNOEHXleOt8vmrlzWmfEP/PZB1wOR6nMGVEFmR7aKtPUudnFBicPEkTMEvF
	mPGS4gKaNtVXQDTMYMmfzOnm1P8isfdlR393XJ3ggIqhBfpLnYtVv2DqxPKQyR9we9Fj/lhWHfx
	nphJljwQIGLeD42KXdRsW29WTCX3MOV7OW4LjELvvujfKhMgN0Ks7uQn/5emvE/LmK6ggEEmBbc
	hziU0xwpar6cG7yp/a1eACFEr0Omilzm78UXNS/k8LWpWaWqKwXOnVOYJ0esA4WvLs5kHQYb7Vl
	EyY3Q2ElFJs/5g4zuKF0JEuNd2BubtHmPLaQkVEPVbCeyNLmrys1IjXxlmkxiFnlMMPXn0DjL+u
	bRt0Kj9uvr4CFUMdzBGi2L/68vrD0ck2F3BrcskOV2pDmN5MOPt3hM0JnYvWi8JDoZnFMpJH0Ys
	O0EAis2uG1uoUSyfpCT4U74Dg=
X-Received: by 2002:a05:620a:4050:b0:93c:3863:ff7f with SMTP id af79cd13be357-9479ee3c1b2mr70606285a.0.1794249298127;
        Mon, 09 Nov 2026 10:34:58 -0800 (PST)
X-Received: by 2002:a05:620a:4050:b0:93c:3863:ff7f with SMTP id af79cd13be357-9479ee3c1b2mr70601985a.0.1794249297669;
        Mon, 09 Nov 2026 10:34:57 -0800 (PST)
Received: from [10.207.116.169] (nat-128-59-178-16.net.columbia.edu. [128.59.178.16])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-9479e7e7f3bsm34634485a.37.2026.11.09.10.34.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 09 Nov 2026 10:34:57 -0800 (PST)
Message-ID: <c27b9521-7c4f-41ff-88f8-55313b5f395c@columbia.edu>
Date: Mon, 9 Nov 2026 13:34:56 -0500
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
Subject: Re: [PATCH 2/2] iomap: remove the atomic write length check in
 iomap_dio_bio_iter_one()
To: John Garry <john.garry@linux.dev>, Jens Axboe <axboe@kernel.dk>,
        Christian Brauner <brauner@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, linux-block@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
References: <20261107-blkdev-atomic-bounce-v1-0-f66344262096@columbia.edu>
 <20261107-blkdev-atomic-bounce-v1-2-f66344262096@columbia.edu>
 <3fc46788-d86d-44c5-8606-385d96fede4d@linux.dev>
Content-Language: en-US
From: Tal Zussman <tz2294@columbia.edu>
In-Reply-To: <3fc46788-d86d-44c5-8606-385d96fede4d@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Authority-Analysis: v=2.4 cv=NMVAaE6g c=1 sm=1 tr=0 ts=6af21253 cx=c_pps
 a=hnmNkyzTK/kJ09Xio7VxxA==:117 a=Gl6UJ28otdLh1ydVN8wMBg==:17
 a=IkcTkHD0fZMA:10 a=zJRp6_cAMcgA:10 a=x7bEGLp0ZPQA:10 a=A0y_DWxS2BwA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=svvvyxlR1OQQkelhaPoB:22
 a=VwQbUJbxAAAA:8 a=ADIp8eLfD24IfaEPE4MA:9 a=QEXdDO2ut3YA:10
 a=PEH46H7Ffwr30OY-TuGO:22
X-Proofpoint-ORIG-GUID: vhhXwWZvpGqnjTUD4ZML21Wnuc3Zouyx
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTA5MDA3NCBTYWx0ZWRfXzIGUBP38Gl0x
 5gHNZMtK1yenPJHMQqsNVIWZQRpaBUaleli4i8xGJ+Gx1SDhU9/FjL72+pg7iK0B6k6MNbfUX1Z
 pBx9aHSf6gNQNbR3Bo6jqquR6BZbg2Qwjq9DttllP8TwBo3A4vOD
X-Proofpoint-GUID: vhhXwWZvpGqnjTUD4ZML21Wnuc3Zouyx
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTA5MDA3NCBTYWx0ZWRfXxfjQ8dZ7yV05
 /rB3UbhbC6lMAaI8kAmtphxHAn0UKw8w7Ed/HAtmmcQMxY6IFJUh2+RAQezop2mPr+51iAotjIQ
 15+bqn80kMvpFS2Ixd4lDaN1YcEWhMAK5kA8HYG2sWgO5B1j/C+0VPAsTWDEuIuHoCKJL4G1c7w
 aNCXSs7WrYdFlxSKbm4cKOnrcXTJPw3C36dGQDS6VRUBtUNnsKKpzAVIbnMX3a6aJeXRYS/pw3f
 dUYBv0kr0jWcmOHl4ZCv88h66z+scJIYrwLkgKerAibd+9JYrYZCB3Ak8YKhsAcpiZjgATAA2zI
 MHrxRluhGi41/S7OFZaOHjfrPx16YtO1RSAKJ3DLmy00itcp/jcD4aoUTtaZ6icJG7fqT+qIC3w
 6QO5auJXiajNLytf7CXknUIXxmF/JqR29XQqZTIsaFjafz7etNRutdYniT9X7504oZBOIIfyHiy
 UX6B7uiwTcOzp/HXaCA==
X-Proofpoint-Virus-Version: vendor=nai engine=6900 definitions=11961
 signatures=596817
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 spamscore=0 suspectscore=0 clxscore=1015
 lowpriorityscore=10 bulkscore=10 impostorscore=10 malwarescore=0 adultscore=0
 phishscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2611040001
 definitions=main-2611090074



On 11/8/26 12:06 PM, John Garry wrote:
> On 11/8/26 04:24, Tal Zussman wrote:
>> bio_iov_iter_get_pages() and bio_iov_iter_bounce_write() now fail a
>> REQ_ATOMIC bio that doesn't cover the whole iterator, so the bio here
>> always covers iomap_length() and the check can't trigger. Remove the
>> check.
>> 
>> Suggested-by: John Garry <john.garry@linux.dev>
>> Link: https://lore.kernel.org/all/82978d5c-3e08-48e9-bf0a-7913e1cd0507@linux.dev/
>> Signed-off-by: Tal Zussman <tz2294@columbia.edu>
> 
> Reviewed-by: John Garry <john.garry@linux.dev>
> 

Thanks!

> This looks ok. But I am just thinking that a CoW-based atomic write does
> not have the single bio restriction, so we don't need to fail the atomic
> in this case. However, we should have consistent rules for iovec's
> whether it's a block device or regular file for ext4 or xfs, so this
> makes sense.
> 
> thanks
> 
> BTW, you could be a real hero and add an xfstests case for this also.
> 

What specifically would you want to see tested? I can do an atomic write with
a partially unmapped buffer, with and without stable writes, and check that it
fails and that nothing is written.

>> ---
>>   fs/iomap/direct-io.c | 14 --------------
>>   1 file changed, 14 deletions(-)
>> 
>> diff --git a/fs/iomap/direct-io.c b/fs/iomap/direct-io.c
>> index ad041ac3252a..aca7cbaea4af 100644
>> --- a/fs/iomap/direct-io.c
>> +++ b/fs/iomap/direct-io.c
>> @@ -370,15 +370,6 @@ static ssize_t iomap_dio_bio_iter_one(struct iomap_iter *iter,
>>   		goto out_put_bio;
>>   	ret = bio->bi_iter.bi_size;
>>   
>> -	/*
>> -	 * An atomic write bio must cover the complete length.  If it doesn't,
>> -	 * error out.
>> -	 */
>> -	if ((op & REQ_ATOMIC) && WARN_ON_ONCE(ret != iomap_length(iter))) {
>> -		ret = -EINVAL;
>> -		goto out_bio_release_pages;
>> -	}
>> -
>>   	if (dio->flags & IOMAP_DIO_WRITE)
>>   		task_io_account_write(ret);
>>   	else if ((dio->flags & IOMAP_DIO_USER_BACKED) &&
>> @@ -393,11 +384,6 @@ static ssize_t iomap_dio_bio_iter_one(struct iomap_iter *iter,
>>   	iomap_dio_submit_bio(iter, dio, bio, pos);
>>   	return ret;
>>   
>> -out_bio_release_pages:
>> -	if (dio->flags & IOMAP_DIO_BOUNCE)
>> -		bio_free_folios(bio);
>> -	else
>> -		bio_release_pages(bio, false);
>>   out_put_bio:
>>   	bio_put(bio);
>>   	return ret;
>> 
> 

