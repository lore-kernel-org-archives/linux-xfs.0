Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=148.163.135.74
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794264393;
	b=Pe8TnxVtCdBj6FSUhCGbSStJglSiFd/ZkZrzQVQ8WpSqgKDxIqsXDyA0VwhQzaBIGOet
	 F/AzL4KfNBPM2JHxs44oxKlcZjwuu5RcECgX11Lveos+cN0YqHy754EX0XEVKGg0WKJ+1
	 DCthpj92AbW7QlySLIMNz+rjJEwg9yozvol3Vqyx7EA6D7RNxnDxQi4l5R9hwf3QAv9Gj
	 4eoxWv4LBegd/Catux4bfPv+3sPl6MTbMGlDtwFnlLKtqnKQE18te6UV/5xfUZInXaPOK
	 AhXcySjBTXoFZfFT8V0Byr1lQOnki9gAwp0l5AgfRmTv9brXsp7e14L4hBWhM6tPQEA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794264393;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 DKIM-Signature:X-Google-DKIM-Signature:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:X-Received:Received:Message-ID:
	 Date:MIME-Version:User-Agent:Subject:To:Cc:References:
	 Content-Language:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:X-Authority-Analysis:X-Proofpoint-ORIG-GUID:
	 X-Proofpoint-Spam-Info:X-Proofpoint-GUID:
	 X-Proofpoint-Spam-Details-Enc:X-Proofpoint-Virus-Version:
	 X-Proofpoint-Spam-Details;
	bh=WIZBljhWyOjAV704JqzV8vhFcRwS8d3hm/gLxcJtn20=;
	b=057BOmfsCrBqruGvM2iMAPHqmivRfuBT1rOsmKHiucAQTnrBRULO++5gzq+AZiTzZoHA
	 CxnsrTGQeBlBz3hFunu2FeOYtWKTsQjALoTAxvTcobVKO8NoSH94OAcsZx8FlZBXqmAHp
	 1YoKHT4ZsjSH4aJxq4KRSJ/fFFh8+eXhuUf5sLrkI6p+DI+F52hkKduZwuEfv4NGMTYa+
	 HosueFfyUDKgr2gkTOr49NVT/cMA4CsHwBVGkGyAG2QhRLME8tPP6CQ/IYVlwD4kYsPtC
	 e+bo+LDcdwLfx1EMa9YMGVxIE82oNavWEWkAuR7d5l62ttMYacq1wPHU1PjdW9o8yCg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=columbia.edu;
	spf=pass smtp.mailfrom=columbia.edu;
	dkim=pass header.d=columbia.edu header.i=@columbia.edu header.a=rsa-sha256 header.s=pps01 header.b=rJPYJ+Pf;
	dkim=pass header.d=columbia.edu header.i=@columbia.edu header.a=rsa-sha256 header.s=lionmail header.b=xa+hwWfC;
	arc=none smtp.remote-ip=148.163.135.74
Received: from mx0a-00364e01.pphosted.com (mx0a-00364e01.pphosted.com [148.163.135.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C6C3606A321
	for <linux-xfs@vger.kernel.org>; Mon,  9 Nov 2026 22:46:32 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 7C6C3606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=columbia.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=columbia.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.a=rsa-sha256 header.s=pps01 header.b=rJPYJ+Pf;
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.a=rsa-sha256 header.s=lionmail header.b=xa+hwWfC
Received: from pps.filterd (m0167070.ppops.net [127.0.0.1])
	by mx0a-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6A9MRlAt3003224
	for <linux-xfs@vger.kernel.org>; Mon, 9 Nov 2026 17:46:32 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps01; bh=WIZB
	ljhWyOjAV704JqzV8vhFcRwS8d3hm/gLxcJtn20=; b=rJPYJ+PfHhoR2aC5ddre
	KeX0TdnGyNff0y44edc9qO8omnXiG0NrT5sfljaWfFAbsoL94MHrzXPazE3d+qFT
	/SKQftG+Rknkszqx3bWtOTlRrOoqsD/qf1W7Pani/bgd3TS8I22tMOP8VJ5rRj10
	l9M9Nu8XtoWOYmt5kHgVpCOWVmo9hHIiaGFMK8XsGzXv7eVyeq5gtDm9v8p8wJWJ
	bSzVKEkv/r88EFjHPXlneH6gL9V9wgG7s3ylcsavjTXCEIPoyRKkPBLPwA4foQe5
	VkG4/vTvUMZWQKljuE5sEeZynPzCtkcnfE372yfe2FTqyT24VAmBfWGBCf405lJL
	uA==
Received: from mail-qv1-f71.google.com (mail-qv1-f71.google.com [209.85.219.71])
	by mx0a-00364e01.pphosted.com (PPS) with ESMTPS id 4huhda3jcn-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-xfs@vger.kernel.org>; Mon, 09 Nov 2026 17:46:31 -0500 (EST)
Received: by mail-qv1-f71.google.com with SMTP id 6a1803df08f44-91c6c1e082bso25118326d6.0
        for <linux-xfs@vger.kernel.org>; Mon, 09 Nov 2026 14:46:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=columbia.edu; s=lionmail; t=1794264391; x=1794869191; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=WIZBljhWyOjAV704JqzV8vhFcRwS8d3hm/gLxcJtn20=;
        b=xa+hwWfChS6blPVU9xF5h3SgWEjNFtz4hHzVqyb3q8634jEL3ZHywuPqJwY623mEqz
         9RsZWr5K6SVaCxS8kVOh/0Nh0Ukkbd/wKFnZHSpjkp07Jajp52mC8VljZorLMdes1on2
         8f3Th0Wi3L1OeTfQZ0nXLJKXgpkOcu61ZxdsLL7tk+OYkcQFbR0Zj1WKOYUjiBFIjW0o
         ZqQKXSwkY6QvikNgrWkcsMHUFyaydz2y7c4DddLdYOAEmyQyBb5E2+VTIestR6kmupR7
         6eCps4Cz0Hdr7anA1rXii1eGVLzvceiFJVHiX45UVnZlGY71AzcBvjwk+v+7mVYmexza
         Sm3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794264391; x=1794869191;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=WIZBljhWyOjAV704JqzV8vhFcRwS8d3hm/gLxcJtn20=;
        b=iNKKsAptpxcPvCeyG4msv0v9kRDffOI0+42ZE6ViqLMPUU7IpU7lPLSLQhE4QUKOO6
         qDhgWc+A5G0y7gpWkiThzGS0+MS+RGVu4mE4hpRNUKrsUeiEDtzTugrpPyQGaDNwqVbv
         FKLiVFZltUhfoWfAk1TaKWt2wNeBtWoeXoWH+QGQwtlHH/JqOurXe5+q/MjZ8OTN3a7G
         k3KSNtgoJAG700tzYTkd3/UahlhVNdRSzc/MettbLJ1ucp3Y+h0zlE6nUhfjS8VSI1Rn
         N7oarg2dsfUmu7/ZdHPwCeG4i/mblHpj6idL7T+AU69viCSW+nU2Tx/ixeF3oYh9FaW4
         W4aQ==
X-Forwarded-Encrypted: i=1; AL+hErFIbAqYuxJF/tfKABl6hF+gSHqfkpUQu0vXVEi3muFpGcw6cHWW+8+ow9raNM/nvtxKJN9Gj6FEq00=@vger.kernel.org
X-Gm-Message-State: APuU4Z/vvTT+tmvTMnU+2Fm2KtCOoro3RNFwNfFuY7VL5i6QfIfE7QvW
	pW3+N632oCITMhSLvCrcm8FdQo4jW+nwpYAVoEVeM1WHw3skJ3vENLUciI+GrZjcWc2dNvcJovK
	bz0FVEH2Dzv6DBdl7z5A7avJMTS5kXnjmyvOdhnAtIvxi/exl8p90VwjB4A==
X-Gm-Gg: AYBFou0gtuG8ILUs9uP5qrOjUbKVuol1UOqMHjanm+ejyOE7bRvU41eupNbE4x+QpNn
	j9MhWJS4cBRV2oOyAtw3BbW29IUQ4fB7bO7oXTFrXfusj1zox18UxPCApewrPYaqv0CrmuGH1UV
	NoijMpSb1g6mZnLHP72gpa+o7zZWE7OQtybEhMGw4h8Ya95GvVNFkKaH0od5PzY0uLkG9kYgEbY
	5MPLZPtrjnCFB33XcoEhIsRDB4enflSOERvWXwjCjEToaRmLyounrZ/1mwx3tFWshGlcareweL8
	TDb6zoglz1/ppq81lavd+6PtmyqtXCs3xieZ1tLrnHPu35/oa5DLTfxz3koHfP1xN+yvzCwxDIy
	OJCe0T0fWAPz5700eAhR0LyCUwI7RK4D8kRNQPJI0dotEJlqRtou/btD0ZgdSm0upLpuHKCeqqj
	7Ae4i2D7oSt2/ujHe0R51XlrA=
X-Received: by 2002:a05:6214:cc8:b0:914:cdbf:b6e with SMTP id 6a1803df08f44-91ef049b91amr14954446d6.22.1794264390517;
        Mon, 09 Nov 2026 14:46:30 -0800 (PST)
X-Received: by 2002:a05:6214:cc8:b0:914:cdbf:b6e with SMTP id 6a1803df08f44-91ef049b91amr14954056d6.22.1794264390014;
        Mon, 09 Nov 2026 14:46:30 -0800 (PST)
Received: from [10.207.116.169] (nat-128-59-178-16.net.columbia.edu. [128.59.178.16])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-91ef031aaddsm7023636d6.3.2026.11.09.14.46.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 09 Nov 2026 14:46:29 -0800 (PST)
Message-ID: <21793564-61f4-4d57-b375-1271ad9bc70c@columbia.edu>
Date: Mon, 9 Nov 2026 17:46:28 -0500
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
 <c27b9521-7c4f-41ff-88f8-55313b5f395c@columbia.edu>
 <4022d4f9-5e2e-45d1-b9b8-208c80f82ecf@linux.dev>
Content-Language: en-US
From: Tal Zussman <tz2294@columbia.edu>
In-Reply-To: <4022d4f9-5e2e-45d1-b9b8-208c80f82ecf@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Authority-Analysis: v=2.4 cv=NMVAaE6g c=1 sm=1 tr=0 ts=6af24d47 cx=c_pps
 a=UgVkIMxJMSkC9lv97toC5g==:117 a=Gl6UJ28otdLh1ydVN8wMBg==:17
 a=IkcTkHD0fZMA:10 a=zJRp6_cAMcgA:10 a=x7bEGLp0ZPQA:10 a=A0y_DWxS2BwA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=svvvyxlR1OQQkelhaPoB:22
 a=-APkALjPeVA3zQJKllEA:9 a=QEXdDO2ut3YA:10 a=1HOtulTD9v-eNWfpl4qZ:22
X-Proofpoint-ORIG-GUID: LMfZ1aEqFEXVnlhHqx_BWgZNyMTxNgGo
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTA5MDA5MCBTYWx0ZWRfX/aFw1EE5eWcM
 Uslg6YNK9eFELkXS7sZ47pUuCsHklLRZ/pgfPKR7M1c8nrNS2GS5tvSmtLCnQqJ/QcGEErBgMnw
 +b1XKP59WtM3SN7z+bkb0des4cH2npWbRf8K8U3WLwPEazc+Ppvu
X-Proofpoint-GUID: LMfZ1aEqFEXVnlhHqx_BWgZNyMTxNgGo
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTA5MDA5MCBTYWx0ZWRfXwkR2YD1+Ux1D
 tsfRzrZ7G5Yj7/vsm95bZlG7pNiAHIjoEEXanVduaXf7a4sRFmRYBnjRDSF13jeWcnICMxGCwS5
 F+lrNWIkwGc08R8MPqgwD5aPtiyvMPXYp6XzBEMPIA9BlisKFgrL4/5JYef8sPjGslNHxapvfaW
 tJmESBsehAB8hc+rMGMtE6ybHCYjerMjde5VUSV/MquMJBFmz02z9nCdsVFExbL46B0OLH4FZEO
 Tjh1phPIr/CBVE05HVK2DWjZutzFqZSCrR9QQEddl93uN/wlsgvemKTZtbuR2OKwTY2KZGQMKC8
 jreDkOx48C9ZlKF0cbq3+NhKs2Ow8osq3CQt88T08DpG9tnGoNkfNwXxxL7v1PyZhG3SAdIuTyK
 K/J8glcS1OVXi2o4zjya8XLWPa5pQmQCVpfLSGMU5vtX3qaFkLm+YIBynZEszu2VJ+qXT2H+kul
 0OwyVgTMicJ/qozblUw==
X-Proofpoint-Virus-Version: vendor=nai engine=6900 definitions=11961
 signatures=596817
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 spamscore=0 suspectscore=0 clxscore=1015
 lowpriorityscore=10 bulkscore=10 impostorscore=10 malwarescore=0 adultscore=0
 phishscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2611040001
 definitions=main-2611090090

On 11/9/26 1:44 PM, John Garry wrote:
>> 
>>> This looks ok. But I am just thinking that a CoW-based atomic write does
>>> not have the single bio restriction, so we don't need to fail the atomic
>>> in this case. However, we should have consistent rules for iovec's
>>> whether it's a block device or regular file for ext4 or xfs, so this
>>> makes sense.
>>>
>>> thanks
>>>
>>> BTW, you could be a real hero and add an xfstests case for this also.
>>>
>> 
>> What specifically would you want to see tested? I can do an atomic write with
>> a partially unmapped buffer, with and without stable writes, and check that it
>> fails and that nothing is written.
> 
> Just something similar to the blktests case which you added.
> 

Sounds good, I'll add it to the queue.

> BTW, have you tested this partially-unmapped case for CoW-based atomics
> on xfs? You can just do that by setting atomic_wr=0
> 

Yeah, I just tested it. It behaves as expected: returns -EFAULT with the file
unchanged, both with and without bouncing.

The single-bio check depends on REQ_ATOMIC, which only the HW atomic path sets,
so it doesn't apply to CoW writes, both before and after this series.

In terms of consistency, the unmapped buffer returns -EINVAL on the non-bounce
HW path (from bio_iov_iter_get_pages()) but -EFAULT for all other paths. That
should probably be made consistent across HW and SW and bounce vs. non-bounce,
but that's a separate change.

Thanks,
Tal


> Thanks,
> John
> 
>> 
>>>> ---
>>>>    fs/iomap/direct-io.c | 14 --------------
>>>>    1 file changed, 14 deletions(-)
>>>>
>>>> diff --git a/fs/iomap/direct-io.c b/fs/iomap/direct-io.c
>>>> index ad041ac3252a..aca7cbaea4af 100644
>>>> --- a/fs/iomap/direct-io.c
>>>> +++ b/fs/iomap/direct-io.c
>>>> @@ -370,15 +370,6 @@ static ssize_t iomap_dio_bio_iter_one(struct iomap_iter *iter,
>>>>    		goto out_put_bio;
>>>>    	ret = bio->bi_iter.bi_size;
>>>>    
>>>> -	/*
>>>> -	 * An atomic write bio must cover the complete length.  If it doesn't,
>>>> -	 * error out.
>>>> -	 */
>>>> -	if ((op & REQ_ATOMIC) && WARN_ON_ONCE(ret != iomap_length(iter))) {
>>>> -		ret = -EINVAL;
>>>> -		goto out_bio_release_pages;
>>>> -	}
>>>> -
>>>>    	if (dio->flags & IOMAP_DIO_WRITE)
>>>>    		task_io_account_write(ret);
>>>>    	else if ((dio->flags & IOMAP_DIO_USER_BACKED) &&
>>>> @@ -393,11 +384,6 @@ static ssize_t iomap_dio_bio_iter_one(struct iomap_iter *iter,
>>>>    	iomap_dio_submit_bio(iter, dio, bio, pos);
>>>>    	return ret;
>>>>    
>>>> -out_bio_release_pages:
>>>> -	if (dio->flags & IOMAP_DIO_BOUNCE)
>>>> -		bio_free_folios(bio);
>>>> -	else
>>>> -		bio_release_pages(bio, false);
>>>>    out_put_bio:
>>>>    	bio_put(bio);
>>>>    	return ret;
>>>>
>>>
>> 
> 

