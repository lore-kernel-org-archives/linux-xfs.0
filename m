Received: from mail-dl1-f54.google.com (mail-dl1-f54.google.com [74.125.82.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BD2A314A84
	for <linux-xfs@vger.kernel.org>; Fri, 10 Apr 2026 00:47:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775782025; cv=none; b=qO6O+gCb939EDb2wHJYwRYWcopKKyBfayd82ViGDcu+JnFvIbBUa7/ZtAYYMlxlCDqzldSQ1aoh7UtrSWyA07ZKryZrWrn8OjsHu2Cqqca9oncO8q9rEUIXd6G6fbbdDgjWekTMzDNtcPI6DVMfxWaEFZb9omgXaxwjxzvQPveA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775782025; c=relaxed/simple;
	bh=5RSqm0i7TAMALBXs719N1oHBv8HwMRI4TbjdGJov0So=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=i2UJxL+0T1GsGExumLJQWvOBt1zOALiglaRsIOPLhgztz9joxu2zd0qHRe2O/ihvXDtWI88Dq65zQwNpHrzPyrkbvSH8pVhtlLZ8Y19Rtos/lOXhN7929cQOG1xeQGk962AQyj3+bTZGNpMvDKR/hnYSIfzUJKopgO6tvozRs/o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b=WL05AItd; arc=none smtp.client-ip=74.125.82.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b="WL05AItd"
Received: by mail-dl1-f54.google.com with SMTP id a92af1059eb24-12732165d1eso10752886c88.1
        for <linux-xfs@vger.kernel.org>; Thu, 09 Apr 2026 17:47:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20251104.gappssmtp.com; s=20251104; t=1775782022; x=1776386822; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=8dLqEnr+wCE0zIFZUjHqtBjKoRS3kf2QNeojFry0cDY=;
        b=WL05AItdw5GBbK/6YpQRx2xq0tzJP8x47J0Zbl8l/X8losGNzCSaDoSyBHSLagUmKC
         mzb0oB0nm33ulQ9luFZR3p1Yr36j8L0RJqDZRK2ZZxkZsukD3UvntYa0outb/ptdl6N3
         VCav4Er0OTMZEdPtu77kKoTx4pNp1AtV8/mRCuIh7VrE5zLNmXYxU5eGpMOCBicwh7zA
         CnX5rlRaIXjywKFCfMd0niM4t0j8Ic7lfKwpLdqJoRE67IM+GLHz24BqQZGC7RurZsYS
         PLK9sOE/w8z8TwnJV2uE/fnpNYIxLGHADXziHF6Nub7ozUqrGfjIayp1KpM/YfWMgMhO
         aOfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775782022; x=1776386822;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=8dLqEnr+wCE0zIFZUjHqtBjKoRS3kf2QNeojFry0cDY=;
        b=pagaIqkNfOMRDF8PJHJZXSnn/+1gooUvNaB1ndUo58dR3Zy8OPSblk3Qv8vyVqo6I+
         6cDLT50hM4syPfx58kb4lOo1QOTKj8L05IDpzNKB36N2HXvifxmLXzXTr0M+cR7Ci2qr
         GsXK5yJDAChUYaRcwhBxINCteomdTDmLzCdonLJmUe6/gCESfipX8J3RDPxwrSKR/meq
         NJplbK4SSbUV2GMhNkaByHokMGh3fr9Euu4iTe0yJOdvoFfEDnjtptXRKcw/min1xK1H
         2p7kkJyv2yb5vT9OV9yBFjunPCW8FWHrsEJHsS2PyQDbsNGFTThGYfhY7NPUwJWzan3S
         c/sA==
X-Forwarded-Encrypted: i=1; AJvYcCUo3WXlAwSy6G5xKC5K+2ygQm/GMpkSeW2zayHInIplIlRIwGsN8y18iYPsYZrqLaoyEYclHW9AHW8=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx9TZ2gAznvTCRM+if/rw4rnFBirnzsD5+LCQ2IJrJJpYbmyxmR
	p+ZhdbQ1YGMCBh/+0q5WZOFdkHH5RB+rr49D1onGE9+FbBTzgf6bLmoAxN/aJtV9Btg=
X-Gm-Gg: AeBDievdv7LLeoJdF/ETnsHTDCAYkryDnP9KuMqt5oEIkSP2kzp5d8NGJ+FVH4RFV04
	/y9lIMttZWnvLM4WKeT3/DPOaJeHMZ9T+nRBQghuogrBNiybRrGKvSL9m2ZdO8X5cxG5SJYxUIJ
	YbW2lsLKRt5chPVeaX+OHxMcP7XCOVlO94BF92C43obd91Gc0q//UV+S6HwAn4M2ls0HTkOYOJp
	0omYxERTxugvHnde4ILmIAHjkLubrNI0p1PhDv72GjYTN2NZ/gNRYGVvyp2cxi9HbtVCrlIJydF
	hKbfn36RdcPh3jTda9Sc636VrDyljwLWZZe3HSUlCIYQmUH85sNURMrQdi+RVhRDvmrQk91z5vj
	7rSOKU3qSjw73A12ccrK+T2CNgIMIz269Q215PTBfOClcA6M7IIIlVg4JRDezXUZLdavyRVhYfQ
	zu+l70ABH16PKaagD7iyXEbxBNcejjw1ZmfLbbcPGDOF/KJskbIfZW9OeF1krEyC0PWB8IhwxtE
	6Zh7VgHMHIw77XxFqWCL0IJf+eVlc0SywzsQDC5hwqTFUt8R5RjBhk=
X-Received: by 2002:a05:7022:e986:b0:127:15cd:9f52 with SMTP id a92af1059eb24-12c34e37b1fmr652018c88.5.1775782021786;
        Thu, 09 Apr 2026 17:47:01 -0700 (PDT)
Received: from ?IPV6:2600:380:873e:380f:e9e5:ea98:a905:9cbb? ([2600:380:873e:380f:e9e5:ea98:a905:9cbb])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-12c34352490sm1530405c88.0.2026.04.09.17.46.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 09 Apr 2026 17:47:01 -0700 (PDT)
Message-ID: <fb64ba71-7284-4768-979b-84919f2aa5f0@kernel.dk>
Date: Thu, 9 Apr 2026 18:46:54 -0600
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC v4 1/3] block: add BIO_COMPLETE_IN_TASK for
 task-context completion
To: Tal Zussman <tz2294@columbia.edu>
Cc: Matthew Wilcox <willy@infradead.org>,
 Christian Brauner <brauner@kernel.org>, "Darrick J. Wong"
 <djwong@kernel.org>, Carlos Maiolino <cem@kernel.org>,
 Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>,
 Christoph Hellwig <hch@infradead.org>, linux-block@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, linux-mm@kvack.org
References: <97b81868-6410-4c79-a242-679a9f04f073@columbia.edu>
 <95F28FA1-5CEF-4E80-BBB7-A429B4437D12@kernel.dk>
 <7e468bd2-e52b-4165-95c6-3f04e1dca21e@columbia.edu>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <7e468bd2-e52b-4165-95c6-3f04e1dca21e@columbia.edu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 4/9/26 12:54 PM, Tal Zussman wrote:
> 
> 
> On 4/8/26 7:36 PM, Jens Axboe wrote:
>> On Apr 8, 2026, at 4:51?PM, Tal Zussman <tz2294@columbia.edu> wrote:
>>>> On 4/8/26 3:51 PM, Jens Axboe wrote:
>>>>> On 4/8/26 12:?48 PM, Tal Zussman wrote: > On 3/25/26 4:?14 PM, Jens Axboe wrote:
>>>>>
>>>>> Thanks! I'm going to give Dave's llist suggestion a shot on top of
>>>>> this as it seems like it'll simplify this nicely. Looks like that'll
>>>>> involve turning bio::bi_next into a union with a struct llist_node.
>>>>
>>>> Since these lists can get long, I'd keep an eye on llist reversal
>>>> overhead there...
>>>>
>>>
>>> Going to send v5 shortly -- tested with and without the llist reversal and
>>> it didn't seem to make much of a difference. This was on a single-disk VM
>>> though, so any stress testing you could do would be very helpful.
>>>
>>
>> With all due respect, a single test like that isn?t going to be that useful. I?d be wary of making that change willy nilly and just thinking ?it?s fine, worked fine on the one case I tested?.
> 
> Understood -- unfortunately that's what I have access to at the moment. I
> can requisition a machine with 2, maybe 3 disks, and test more thoroughly on
> that before sending the next version, but that'll take a few days. You had
> previously offered to test on your big box, so was hoping that was still on
> the table :)

I can do that, but I'm OOO for the next week, so won't be until I'm
back.

> (Although Christoph seems to have proposed moving away from llist again)

I think that's a good idea, not a fan of using llist for this, in case
that wasn't clear. These are per-cpu lists anyway, and having a constant
overhead is better than needing to reverse an llist. IMHO.

-- 
Jens Axboe
