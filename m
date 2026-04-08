Received: from mx0b-00364e01.pphosted.com (mx0b-00364e01.pphosted.com [148.163.139.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 011362727F3
	for <linux-xfs@vger.kernel.org>; Wed,  8 Apr 2026 18:48:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.139.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775674121; cv=none; b=eX+D7a5Ky9VJLL8JT5JCmO7Qwq3zo+Pc3Z/+p9MgFrKxXB7Av1kqityPal529PLSv3kcKMtiXg6JBa01oZBz6se6qSiDdOHknYSm9fJ+MZxCe21QkfCHKtit2Lbj5iHezwUB4NyH4yJeh2k7SqXBKmG3nlbuSgXphS2MtpOgWTY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775674121; c=relaxed/simple;
	bh=1Ge5gfoGyv0TLiDmdg7VFxgHEnOfWaCDzgyu38mSmrI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=A3YzQdC+5xHJ/2iAKi89MpW/2nbVsQQp9YuSHJylYXfz5lUPBDRJqA3bofvXddYHd2VSCNnQzytv082cfVqHbMITlDcSHNniuzeP7aFDRolxQJuBH3lUNUkZKVlj5evAWZNqR4gRLidiYuM6jv1NTVORQ28sWSjXK79lXbiS1dY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=columbia.edu; spf=pass smtp.mailfrom=columbia.edu; dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b=sR4smn5j; arc=none smtp.client-ip=148.163.139.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=columbia.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=columbia.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b="sR4smn5j"
Received: from pps.filterd (m0167076.ppops.net [127.0.0.1])
	by mx0b-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 638IgSGn3449410
	for <linux-xfs@vger.kernel.org>; Wed, 8 Apr 2026 14:48:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps01; bh=Dque
	R3VMcaZMrGBpK+9TubzW0DI74xoKUrfLcydSJjc=; b=sR4smn5j86SJPqwuEiyD
	tiO3LrwmcnhTzYNq/puVbFVkdQ23hxVuhAkUQf+XO03Laic8F0LMMB0w65VG4DOi
	MjEHK9uj7aeFv/l1TdDJ7gbuo31iIbP5xUFzSH0CJ0T9ITcDfIVwPZDh10am+5b7
	ehPmyJTYiEI9yXGyzY5/G53LdBLNQNKv2p0tRQwtE/byTMVhqGihaAEgsZNWdGjO
	tyt+uX+NZg+/F+Q+Biwz3IinlnvjWz7wEkUB7z/BDtWx7ZoKXZ5ckuDdC944zQRS
	FkzIre59ahDNjblioAHT4fKYGPnEl1A9nuKVn1p4YOzRdPlEyPskoRX4KJ4JK+zd
	rA==
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com [209.85.160.199])
	by mx0b-00364e01.pphosted.com (PPS) with ESMTPS id 4dda3r6rjg-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-xfs@vger.kernel.org>; Wed, 08 Apr 2026 14:48:32 -0400 (EDT)
Received: by mail-qt1-f199.google.com with SMTP id d75a77b69052e-50d68dbb77bso2112071cf.2
        for <linux-xfs@vger.kernel.org>; Wed, 08 Apr 2026 11:48:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775674112; x=1776278912;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=DqueR3VMcaZMrGBpK+9TubzW0DI74xoKUrfLcydSJjc=;
        b=e28lc1LMafB0OJSQFyJfq2taPbwC6kXzuCkwAKmQxpjbtwc1bcF+mD8dO4lpVPtsIF
         ysbTx9yM+ho+iQXIpNuFuaIIlj1Nm88GyURxLHFerzKKvt2gMBt1G/4gPEgL3yKgeB7q
         1vsNISijWWL1xxucpRr+cZnwKqWuNLVSRzVWy5KuwxfPoEee9UbdgrgHRvYMpghHK1Jg
         dnTm+kSrUiKfGW+ia09IDIbItXFaMH13g6eZ7F17M88BPmrBlG+NzSZxvjLvi+YGjOH1
         x533wtQ78mz3bR6oqTmVB4AEQSqL41MOKvCZBzxb8LS2NFJSwq0yQOVEU6dYq+TOL905
         o6pQ==
X-Forwarded-Encrypted: i=1; AJvYcCU+1GKmoyKpLeyGAeViB8pR/RtjZhKsBWM7Yhp3mz1FZSbyLOIKZwk53mgqPtV+mMHh6+wv1Qi5QjA=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw4o8inLlGnIEc2FXaI+8czB41BJzkFsUyZwcOwD+45hvZbltvC
	NxUSQ6i02lkmm6HHf8xyOKOWFrNK2v3+y/ebQPyZdv+8r3L/ObzQMUTZr74W6CXzd64xGJSxibx
	hH4L6ivuRCRT09+rs1ojKhJbGT7vTlSELLwQqoNSF1LU8dojmK8yp+DMd6Q==
X-Gm-Gg: AeBDietNykTzl0hiuBKbfZIMpZUgv1IBAmLFxCm9GmfWV1SUk2ICdXRmbipHMldY3bg
	W7ISJPiRfM+vEoP16kbGO8FYMKRMvWjGAgKE0GRtXpK+pEdBoOIQmnOPZDZkKKIM6bS0KR4Q2dM
	jYdpjcd+dkt+eqXvHW4r7SKWbPrnh0JoNMYbMjnpkvtukObUSUq8qNBHkICpoUb0SauNmLVl8PE
	2eu3ACZAILxeC7Si7t9+Zkqy7I2uT9ssPZrNoy8D9d5R2KUFK7AT/RfHJj0qwlF5f+N7SU5HhWv
	hPWGBsfw+EU593/T2Y3J1YJrfeDXoeinpU54JHnqKm9trzEnzUHnpZGmp2tsX+Kx+iS7XJC+cY2
	HyjLfCf0Bq8CcWZqA8WPyvhKhoPp9kQ+GQXXolMaL
X-Received: by 2002:ac8:5813:0:b0:50b:551d:ca7a with SMTP id d75a77b69052e-50d62d18253mr330224391cf.52.1775674111611;
        Wed, 08 Apr 2026 11:48:31 -0700 (PDT)
X-Received: by 2002:ac8:5813:0:b0:50b:551d:ca7a with SMTP id d75a77b69052e-50d62d18253mr330224011cf.52.1775674111155;
        Wed, 08 Apr 2026 11:48:31 -0700 (PDT)
Received: from [192.168.129.206] ([216.158.158.246])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-50d5ea136a1sm148904291cf.25.2026.04.08.11.48.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 08 Apr 2026 11:48:30 -0700 (PDT)
Message-ID: <01e6c582-fbab-40ec-97ac-02675e6a08ed@columbia.edu>
Date: Wed, 8 Apr 2026 14:48:30 -0400
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC v4 1/3] block: add BIO_COMPLETE_IN_TASK for
 task-context completion
To: Jens Axboe <axboe@kernel.dk>,
        "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        Christian Brauner <brauner@kernel.org>,
        "Darrick J. Wong"
 <djwong@kernel.org>,
        Carlos Maiolino <cem@kernel.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>
Cc: Christoph Hellwig <hch@infradead.org>, linux-block@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-mm@kvack.org
References: <20260325-blk-dontcache-v4-0-c4b56db43f64@columbia.edu>
 <20260325-blk-dontcache-v4-1-c4b56db43f64@columbia.edu>
 <c4453f4e-c1a2-4f5a-b278-76b63d5dc4a3@kernel.dk>
Content-Language: en-US
From: Tal Zussman <tz2294@columbia.edu>
In-Reply-To: <c4453f4e-c1a2-4f5a-b278-76b63d5dc4a3@kernel.dk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-ORIG-GUID: aTxCuybE6NUgm-iFuebNpnXgbkyj3JOW
X-Authority-Analysis: v=2.4 cv=UplT8ewB c=1 sm=1 tr=0 ts=69d6a300 cx=c_pps
 a=WeENfcodrlLV9YRTxbY/uA==:117 a=mD05b5UW6KhLIDvowZ5dSQ==:17
 a=IkcTkHD0fZMA:10 a=A5OVakUREuEA:10 a=x7bEGLp0ZPQA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=Qm0qsxP7aFY2tkT6R2MF:22
 a=Da_CJWPV6nPH503sPTwA:9 a=QEXdDO2ut3YA:10 a=kacYvNCVWA4VmyqE58fU:22
X-Proofpoint-GUID: aTxCuybE6NUgm-iFuebNpnXgbkyj3JOW
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDA4MDE3NCBTYWx0ZWRfX7nKoDTNILiVn
 7/NUD9ZB8lWmVjqVfj9lK21vuhx8BioF0NGp/K9+a5T8IBqa6Gr8463f0B7ygcA9anlPctJMfh0
 orLpAmTUOS3vNS9JO3nmPSiLWh+tMbkFeSVbMzU2rfrZQY/rc0pZWSmNYZJA0XYV+3p2deJrsnP
 RT5SNsHfd9KlfOedJL/d4e3SxZgXVPa/fqES/Bc/csU+i+kqYtsXgafcHPrdGMT/Dav8O70hm59
 OPJgDQ/PwEDz7MO52uCRK/Or6rBZ3zLVrtQwNQq4DHUoI88LN1i+y89KyFItHyZuHGlHx4nPPL8
 3GGwDrgWoHC8YO7Ilc/QJedZ922SCkZOKn7jRX2MYyv6salyoKOU6qOZLeXBDgnCmfqgkujtxDc
 StrD1MnFux/LN+LVeLq6Qf4F9h+mMFXyvdxH6CPhMCnBpR61C3IllAB7E/fOWDpidtuNhABPYFv
 Yj2mJp/X6baQRBTqOUQ==
X-Proofpoint-Virus-Version: vendor=nai engine=6800 definitions=11753
 signatures=596818
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 bulkscore=10 spamscore=0 phishscore=0 lowpriorityscore=10
 impostorscore=10 malwarescore=0 clxscore=1015 suspectscore=0 adultscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2604010000 definitions=main-2604080174

On 3/25/26 4:14 PM, Jens Axboe wrote:
> On 3/25/26 12:43 PM, Tal Zussman wrote:
>> +static void bio_complete_work_fn(struct work_struct *w)
>> +{
>> +	struct bio_complete_batch *batch;
>> +	struct bio_list list;
>> +
>> +again:
>> +	local_lock_irq(&bio_complete_batch.lock);
>> +	batch = this_cpu_ptr(&bio_complete_batch);
>> +	list = batch->list;
>> +	bio_list_init(&batch->list);
>> +	local_unlock_irq(&bio_complete_batch.lock);
>> +
>> +	while (!bio_list_empty(&list)) {
>> +		struct bio *bio = bio_list_pop(&list);
>> +		bio->bi_end_io(bio);
>> +	}
>> +
>> +	local_lock_irq(&bio_complete_batch.lock);
>> +	batch = this_cpu_ptr(&bio_complete_batch);
>> +	if (!bio_list_empty(&batch->list)) {
>> +		local_unlock_irq(&bio_complete_batch.lock);
>> +
>> +		if (!need_resched())
>> +			goto again;
>> +
>> +		schedule_work_on(smp_processor_id(), &batch->work);
>> +		return;
>> +	}
>> +	local_unlock_irq(&bio_complete_batch.lock);
>> +}
> 
> bool looped = false;
> 
> do {
> 	if (looped && need_resched()) {
>      		schedule_work_on(smp_processor_id(), &batch->work);
> 		break;
> 	}
> 
> 	local_lock_irq(&bio_complete_batch.lock);
> 	batch = this_cpu_ptr(&bio_complete_batch);
> 	list = batch->list;
> 	bio_list_init(&batch->list);
> 	local_unlock_irq(&bio_complete_batch.lock);
> 
> 	if (bio_list_empty(&list))
> 		break;
> 
> 	do {
> 		struct bio *bio = bio_list_pop(&list);
> 		bio->bi_end_io(bio);
> 	} while (!bio_list_empty(&list));
> 	looped = true;
> } while (1);
> 
> would be a lot easier to read, and avoid needing the list manipulation
> included twice.

Yep, that looks cleaner. Although do we really need the looped variable?
Can't we just move the need_resched() check right before the while (1)?

>> +static void bio_queue_completion(struct bio *bio)
>> +{
>> +	struct bio_complete_batch *batch;
>> +	unsigned long flags;
>> +
>> +	local_lock_irqsave(&bio_complete_batch.lock, flags);
>> +	batch = this_cpu_ptr(&bio_complete_batch);
>> +	bio_list_add(&batch->list, bio);
>> +	local_unlock_irqrestore(&bio_complete_batch.lock, flags);
>> +
>> +	schedule_work_on(smp_processor_id(), &batch->work);
>> +}
> 
> Maybe do something ala:
> 
> static void bio_queue_completion(struct bio *bio)
> {
> 	struct bio_complete_batch *batch;
> 	unsigned long flags;
> 	bool was_empty;
> 
> 	local_lock_irqsave(&bio_complete_batch.lock, flags);
> 	batch = this_cpu_ptr(&bio_complete_batch);
> 	was_empty = bio_list_empty(&batch->list);
> 	bio_list_add(&batch->list, bio);
> 	local_unlock_irqrestore(&bio_complete_batch.lock, flags);
> 
> 	if (was_empty)
> 		schedule_work_on(smp_processor_id(), &batch->work);
> }

Makes sense, will do!

> Outside of these mostly nits, I like this approach. It avoids my main
> worry with this, which was contention on the list locks. And on the
> io_uring side, we'll never hit the !in_task() path anyway, as the
> completions are run from the task always. The bio flag makes sense for
> this.

Thanks! I'm going to give Dave's llist suggestion a shot on top of this as
it seems like it'll simplify this nicely. Looks like that'll involve turning
bio::bi_next into a union with a struct llist_node.

- Tal

