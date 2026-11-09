Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=148.163.135.74
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794248861;
	b=vzLS3XhK+Nm61CVw+paWLongV+g1yqLXaNys079z2l3pO6eR5uEE5UM6M5/PR4onEcko
	 Ig25ry4tr5euiKy3Zp68dkw6TO495LqMuWd8gJ57UOZFeCV53jBiqwpmCuLTk1usyL/UZ
	 jyrRmfstRMkB333ZFwl2HpzcXZMmkT8CwKkuwei+BSn87KHi1eO2Qo89hrDR41jepXNdb
	 GnBInL+BDuicz5gxh81KRHSQz6wpGpV+EbAzSrgCPXThg9WQCVncjVMfXSl6oUjd/3OJy
	 OBqvcW/sviy00+yxrBmUO8ZrSlmN/N3+Dqe6AGlVd029BYQcMk7y8JbKpHyTR/rDWcQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794248861;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 DKIM-Signature:X-Google-DKIM-Signature:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:X-Received:Received:Message-ID:
	 Date:MIME-Version:User-Agent:Subject:To:Cc:References:
	 Content-Language:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:X-Authority-Analysis:X-Proofpoint-ORIG-GUID:
	 X-Proofpoint-Spam-Info:X-Proofpoint-GUID:
	 X-Proofpoint-Spam-Details-Enc:X-Proofpoint-Virus-Version:
	 X-Proofpoint-Spam-Details;
	bh=3LmoJP6g3WtU8XQSQhoDtd6EbgMyoETHVY4mSGzEhSU=;
	b=Q/LnU0F3cpyyCIYH3SROlWiJY4zQdD5tAEafp6uSO4zH9/TMGZeGf0hRM74BF4fU+TdI
	 IM+FPmxqx2Vo9wHNYavKnF7r3LT4jU7+MufBI/8pL49RyQODZfaOgtoS3HGctlta5fyxx
	 vWcP72R1zlp+wTbNOQ8HeAK7kpaVpWPuo4qPZw8j77+0DGrepwA169pfcL3DN/rdJmKFv
	 nc3FxBb1B1dOtFSrvcHt3Oi4wBkfCpM8tV+XYRbQl52Q1e/Y2yHE6orR/TzMK/gKkwT1r
	 IgGaWEHqqdyv4C9uiL5LRVB9dEQu1CCg6CijcNlpPHw5xGTJqzdrDANzoiTyEE5k06A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=columbia.edu;
	spf=pass smtp.mailfrom=columbia.edu;
	dkim=pass header.d=columbia.edu header.i=@columbia.edu header.a=rsa-sha256 header.s=pps01 header.b=kCc8EzR+;
	dkim=pass header.d=columbia.edu header.i=@columbia.edu header.a=rsa-sha256 header.s=lionmail header.b="uF9wMu/4";
	arc=none smtp.remote-ip=148.163.135.74
Received: from mx0a-00364e01.pphosted.com (mx0a-00364e01.pphosted.com [148.163.135.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB5EF606B5A6
	for <linux-xfs@vger.kernel.org>; Mon,  9 Nov 2026 18:27:39 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org CB5EF606B5A6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=columbia.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=columbia.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.a=rsa-sha256 header.s=pps01 header.b=kCc8EzR+;
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.a=rsa-sha256 header.s=lionmail header.b=uF9wMu/4
Received: from pps.filterd (m0167072.ppops.net [127.0.0.1])
	by mx0a-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6A9HcWhq1361031
	for <linux-xfs@vger.kernel.org>; Mon, 9 Nov 2026 13:27:33 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps01; bh=3Lmo
	JP6g3WtU8XQSQhoDtd6EbgMyoETHVY4mSGzEhSU=; b=kCc8EzR+b4HrbTrsozWd
	wB3ICfreUm+eixPxqajsNMRIlnZon/Sy5lgy3EzkzghBxLoNs7vYP8QRVS5rLdLC
	kEVhJL0Ph48wv907s6NMXcnDWDU9YBxuYW3XDklW9eHfl3reIVYXlFL8w4j8XZ5S
	rpePeD7RDGFYYNe+aTEy/xR20NBr+fZ+WZKH93POyM4xwQ+vdsJsmIr+vUBE86gJ
	QtxJVaJmLLpxBpdT9BkUENMgRHdgQ2KPWWAzb8uyAyajGaEByZH3EnEtyGEvXqEc
	WzNgU7Uv19RY6DHPQkYJ/3Wr8kf8Jr0eb2FmHas8iniDLBLHep7M7Z9JCFaHSFP2
	gw==
Received: from mail-qt1-f198.google.com (mail-qt1-f198.google.com [209.85.160.198])
	by mx0a-00364e01.pphosted.com (PPS) with ESMTPS id 4hujrn8d3q-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-xfs@vger.kernel.org>; Mon, 09 Nov 2026 13:27:32 -0500 (EST)
Received: by mail-qt1-f198.google.com with SMTP id d75a77b69052e-544019b1831so23442231cf.0
        for <linux-xfs@vger.kernel.org>; Mon, 09 Nov 2026 10:27:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=columbia.edu; s=lionmail; t=1794248852; x=1794853652; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=3LmoJP6g3WtU8XQSQhoDtd6EbgMyoETHVY4mSGzEhSU=;
        b=uF9wMu/4H29cIsrk2claBd6GaJ/dUYrENKFpwSi28u+CaRmvimN68tPNtHmySxeLun
         jyKS2DHQVN4yQZaxky8bS+m8V0YULEcbTQX6OQ6aIm2ooqwu9D6GycZ9NCrwr8pkxhop
         K5BVAgDopGr3LXDX/jm+yhNEmR7oQGqooYsqrhPtq3PdzSO/34akVMHykDBMAm3Z8PXt
         ztZlwpy/hm1BKK8DfAwWwYP6Emzq+yIAiG5XqrmuvWQoLGxs3oqMvf+7MQ24nCdFFoeO
         UQLoOfFL47g1UrujfRiVj/fpeQdmsSD0f8+IwmhPbp/5JYloVmMKseRWrtZOZDE8oijx
         5V5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794248852; x=1794853652;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=3LmoJP6g3WtU8XQSQhoDtd6EbgMyoETHVY4mSGzEhSU=;
        b=RscR1Nj6zZpf+IdClu3hGjFwe5nWAYbSXI6+f5AiBH7PLCCtcY7Rwa62PebHCnYi6J
         qEjlE+pjjkK9j/lwfe7p88IL6ywMwNJgf2+feVxW0PRYQR1Hx2mo9UqtJ7NSn6wnFmfH
         Qx9P4PTH/j2v5M8zQXLBg+32nTEqVL0+G5O5MSfmVRdDqzaaA9tfyj6Zi66MuaE4+YTs
         T3tUhRrVhTx0IfB4Q9XQocgqBJ1qNdMyrgsGw1aOYsqj0hhBtxthrWO3j/ecDEdMVyCO
         vOPljfnXbcUiz6XLchcFduu461X8TVuK6kkQ3/MGrHRCeiXFuIpCW/eM+prsQDZuqHCf
         TQrg==
X-Forwarded-Encrypted: i=1; AL+hErEYrFolkMGDfBUweEuGyxUKg/NaP/NtDkfCJMl77hB0GnHMMGPLfNxHw1QBJOgGgqK2V0g0MuAUT6o=@vger.kernel.org
X-Gm-Message-State: APuU4Z/40w9gI//S2FhjvcbGH5oydGLrQIwfr9qOwh4cod74MJTbRG0F
	wq8XijqSyZunpPd4QqHbdNEuclDFo/YIRoFM9ItzaBdZpucBedhcNL12wwXXZtwq2GK5UtrFjjX
	tgBk6Hptvmo0ZlHGYQvTR0+C77TyGy8BwCx0osbNcz9y65bR6wuJLOriidvCvMtzVVg==
X-Gm-Gg: AYBFou12vmuycmC48RMwDqFJp+mCTcm/zI+9vuEt+S74HgNZHtjcW9l4mjVD/kv2AL3
	OJtXLDcBmtXn2tzKgDqkyYVPcqA4r1znmc+JQwF/IWoDmyb5ixK03d2BiAP+nvO0rgR1yJ+LQw1
	w5ZmFWVl5c2ya+R1HlDvrqxCUOCO7JPYDlRMuVuSTRH3a2bK0iNSqlwVtbPDkMSD2gQT6tYXOdf
	IQz6GJHnlMZD4eF0tdqlntJTzbgNHqhXuuggqmO3AErPf0u6zLVptXfQ5gJF5Ys26Mr3dLLC2sL
	uufP4IRoZyFvIPgkX7zoIPVVIAimAVB28XzC6szr6U5QNWealJtu3iajQf+25IyUpow6O186h3m
	r8plrdDMmeKZuUm5J+z4WlIsAx7RbJ/i4j4MApLUA69hDN/Z4B88ydA3cUIsSt1kD7d/xBCyHZU
	iVHXqmdiFZv3RcC+yDqk0aK9k=
X-Received: by 2002:a05:622a:5b8b:b0:536:6c87:ebd7 with SMTP id d75a77b69052e-5552b64e9f2mr1970901cf.69.1794248851898;
        Mon, 09 Nov 2026 10:27:31 -0800 (PST)
X-Received: by 2002:a05:622a:5b8b:b0:536:6c87:ebd7 with SMTP id d75a77b69052e-5552b64e9f2mr1970471cf.69.1794248851255;
        Mon, 09 Nov 2026 10:27:31 -0800 (PST)
Received: from [10.207.116.169] (nat-128-59-178-16.net.columbia.edu. [128.59.178.16])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-5550b4516c6sm3479241cf.12.2026.11.09.10.27.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 09 Nov 2026 10:27:30 -0800 (PST)
Message-ID: <74c7632e-52fa-4378-a15b-f90b492fe613@columbia.edu>
Date: Mon, 9 Nov 2026 13:27:30 -0500
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
Subject: Re: [PATCH 1/2] block: fail a short atomic bounce in
 bio_iov_iter_bounce_write()
To: John Garry <john.garry@linux.dev>, Jens Axboe <axboe@kernel.dk>,
        Christian Brauner <brauner@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, linux-block@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
References: <20261107-blkdev-atomic-bounce-v1-0-f66344262096@columbia.edu>
 <20261107-blkdev-atomic-bounce-v1-1-f66344262096@columbia.edu>
 <6bc16c54-a9f1-4c51-ab68-b227eeecaf66@linux.dev>
Content-Language: en-US
From: Tal Zussman <tz2294@columbia.edu>
In-Reply-To: <6bc16c54-a9f1-4c51-ab68-b227eeecaf66@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Authority-Analysis: v=2.4 cv=d8NgWhjE c=1 sm=1 tr=0 ts=6af21095 cx=c_pps
 a=mPf7EqFMSY9/WdsSgAYMbA==:117 a=Gl6UJ28otdLh1ydVN8wMBg==:17
 a=IkcTkHD0fZMA:10 a=zJRp6_cAMcgA:10 a=x7bEGLp0ZPQA:10 a=A0y_DWxS2BwA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=SsB-OO3BMngHh3ZO9fOt:22
 a=sFb2lJ8PKqpIU8oD2L0A:9 a=QEXdDO2ut3YA:10 a=dawVfQjAaf238kedN5IG:22
X-Proofpoint-ORIG-GUID: p0wqdPYeV8ZM9n0tBMB0kMRPxEj0GFph
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTA5MDA3MyBTYWx0ZWRfXx239N4GBGLpU
 +fqFAbgp8CYM0jZTTLPTnUpCePGt7NfFuoRXLoTnJOiark5lTbJ0qz3B9mVMvIsxl0NIKaa/iwY
 ZuheX6nMcOv2LBFDMj5Wkyczt9FszvyfSRd/QpHtWylMQwUdyzjK
X-Proofpoint-GUID: p0wqdPYeV8ZM9n0tBMB0kMRPxEj0GFph
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTA5MDA3MyBTYWx0ZWRfX/n4UWpH14PRB
 xzgZkbWq6FUedu/4JA095runV2crouMyCy7+OvUu6fY0If70sRVjzY5XNIMe+wIyyswg8N8PmvJ
 dkIm7K4iHelMmQ0YEuF18oM7+lAc1T+GaMoPr2UuPL9I58arRGl/mfvYlpPg0X13n+8w4+vJkUt
 UJaeasBx+ImhDt26xC3/iRirVipoZA+iZUkUA7OxrSSpfthQJ/nFcUdzj8BsES8LZaKZJc4Lzr+
 gu063C0lN7o9sMKQIxXe6kiyQKiapzDeo/0nH+T99mMWmYjHcO3uLp7QJ7TORxRD0yXG5AOhs6u
 inzCszLxyhD+JIUp9Q+5JPbz1zLjE7Jxwk7xpoNGI6DmGHRZquxp84aIaAJjyVlaZ3Vi1+ftFMo
 C6Yu0MR2XHxJulSqXcyf5HdGKXYYPtdrg+CZ5bzpjM7FdzWHrUpiZQz6PslWvymh3aJ5Z9HbkiD
 kO0o6AwHWiv96n1i+wg==
X-Proofpoint-Virus-Version: vendor=nai engine=6900 definitions=11961
 signatures=596817
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 suspectscore=0 lowpriorityscore=10 impostorscore=10
 bulkscore=10 phishscore=0 adultscore=0 clxscore=1015 priorityscore=1501
 spamscore=0 classifier=typeunknown authscore=0 authtc= authcc= route=outbound
 adjust=0 reason=mlx scancount=1 engine=8.22.0-2611040001
 definitions=main-2611090073

On 11/8/26 12:13 PM, John Garry wrote:
> On 11/8/26 04:24, Tal Zussman wrote:
>> bio_iov_iter_get_pages() fails a REQ_ATOMIC bio that doesn't cover the
>> whole iterator, since an atomic write is submitted as a single bio, and
>> submitting only part of it would tear the write. In contrast,
>> bio_iov_iter_bounce_write() doesn't. If a folio allocation fails partway
>> through, it returns a short bio, which for an atomic write triggers a
>> WARN_ON_ONCE() in iomap_dio_bio_iter_one().
>> 
>> Make bio_iov_iter_bounce_write() also check that a REQ_ATOMIC bio covers
>> the whole iterator, and clean up and return -EINVAL if it doesn't.
>> 
>> Signed-off-by: Tal Zussman <tz2294@columbia.edu>
> 
> This looks reasonable, as atomic stable writes are implied to be
> supported from 3373503df025a ("xfs: use bounce buffering direct I/O when
> the device requires stable pages"). I am wondering how to test and prove
> this (change is good and maintained)?
> 

I tested this with XFS on scsi_debug (dif=1 dix=1 atomic_wr=1), doing
1M RWF_ATOMIC direct writes and using fail_page_alloc to make the
folio allocations in bio_alloc_bounce_folios() fail partway through.
I had an LLM make it pretty precise and target bio_alloc_bounce_folios()
using the stack filtering mechanism, so I don't think this necessarily
makes sense as an xfstest if that's what you were thinking...

Without this patch, the write returns -EINVAL and hits the
WARN_ON_ONCE() in iomap_dio_bio_iter_one(). With it, the write returns
-EINVAL without the warning.

This also happened to turn up a scsi_debug bug: with dif=1 dix=1 it
doesn't store the protection information for WRITE ATOMIC(16), so
reading back an atomic write fails. I'll send a separate patch for that.

Does that answer your question/is that what you were getting at?

Thanks,
Tal

>> ---
>>   block/bio.c | 10 ++++++++++
>>   1 file changed, 10 insertions(+)
>> 
>> diff --git a/block/bio.c b/block/bio.c
>> index b0fcc69de653..61a3812520a2 100644
>> --- a/block/bio.c
>> +++ b/block/bio.c
>> @@ -1523,6 +1523,16 @@ int bio_iov_iter_bounce_write(struct bio *bio, struct iov_iter *iter,
>>   		}
>>   	}
>>   
>> +	/*
>> +	 * An atomic write is submitted as a single bio, so it has to cover
>> +	 * the whole iterator or it would be torn.
>> +	 */
>> +	if ((bio->bi_opf & REQ_ATOMIC) && iov_iter_count(iter)) {
>> +		iov_iter_revert(iter, total_copied);
>> +		bio_free_folios(bio);
>> +		return -EINVAL;
>> +	}
>> +
>>   	return 0;
>>   }
>>   EXPORT_SYMBOL_GPL(bio_iov_iter_bounce_write);
>> 
> 

