Received: from mx0a-00364e01.pphosted.com (mx0a-00364e01.pphosted.com [148.163.135.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A507028373
	for <linux-xfs@vger.kernel.org>; Mon, 22 Jun 2026 17:08:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.135.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782148120; cv=none; b=jOelvKGkXLogcNZEV5TUe65rrThjl+xU7eBRaH39uvC9iH4RARL5DlNQ3xxXBIsCKliYW2rsvW1qpWm1iwMWu2wTDkdEcwh9EiIJzDtMRy6Kp0JcDbvjQiImsbmjHiTBWxIX98nQr89S5DUXYW5ZatmRLkiZp92M8IVWWWb+X6s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782148120; c=relaxed/simple;
	bh=YPns9BMqruoPxxfbzv9I+MeJ+qdUDzUn5e+bYYe7QOs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=uAQ2RubGW0MkY6xygREQZY8mPwxN2rAG1HOXPKCiSuJsGR8lP8IMZUXJXqFZcom8BE4ew/JUW+iXrPNuOI4KvKDfQPRA22jA0zj/vt+0R/8KfoFOVP9u8oZ4BR72B0pzdQh9VQ79yb8l9uI3cNHCmNXmym/zy/T/rp71sGIgUlg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=columbia.edu; spf=pass smtp.mailfrom=columbia.edu; dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b=OgqViIyl; arc=none smtp.client-ip=148.163.135.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=columbia.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=columbia.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b="OgqViIyl"
Received: from pps.filterd (m0167072.ppops.net [127.0.0.1])
	by mx0a-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 65MGjISV3586157
	for <linux-xfs@vger.kernel.org>; Mon, 22 Jun 2026 12:45:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps01; bh=xdMm
	a0yFZmweYohmNWNZydRh/c/N/8MYIz6Kz390Uw8=; b=OgqViIylG77wjYnZddWf
	88YfH8KC/P+mTnqfevI0Too4wjycZ3p6FDhKIuH4gSeU6WIqYUin9SIwCTR6PaKZ
	045ca89rm3XjdDbD88fhES2ssfW6qKxDwQin7jbln+eDXhZkvt3rzuDRgmWjHMRt
	bXYHTOkWmIAFxgnpV4zpM7IRvRFLSqvlRe9rO0LhHgRiw57Lo6kU9bc2l1P547kk
	e9qbhjV/IUmE4cBLJp0ph0MjvifIWO9Cbl1cu3blssXdXcGOmioJG41eIAP7Lg8m
	yUF+mqa00i0REXrcqjro2yGFuw1WO8p8bDvLjCkeQhbdW59jQV35RatkKdld/Er1
	Cw==
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com [209.85.160.199])
	by mx0a-00364e01.pphosted.com (PPS) with ESMTPS id 4exn0dnu6u-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-xfs@vger.kernel.org>; Mon, 22 Jun 2026 12:45:29 -0400 (EDT)
Received: by mail-qt1-f199.google.com with SMTP id d75a77b69052e-517d766e05aso1911431cf.0
        for <linux-xfs@vger.kernel.org>; Mon, 22 Jun 2026 09:45:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782146728; x=1782751528;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=xdMma0yFZmweYohmNWNZydRh/c/N/8MYIz6Kz390Uw8=;
        b=OBAVCzvsArl68Wi3XTtX1t0NydaxhLAF8JlNJA352i66oz9Cn6sKqRw1nbyJKKrxuW
         HXeqR/DuZzx3wzDtxnVbWVp5f1gvp2p0l1lbk2QsDPhvt10tB44fXBln/jjVxgwTv+Yt
         a4bOmAD1Y6GOUUqE+bvJEyyj/admbHrtkQxzMFSpRBSBLdqMfxFE98O0c1LnueDoM/E7
         teJIUfzVycWREGfs11pyXcP7JwE6sCrYG2hjsauphliqr8Ne70kwyGDbTzVAtWht6WyB
         ZGU+PYxLjA4gDKRK0DgoTuwb4TG8gLpwxGlG/gEAQxATNI0pmtnrS/fxisjxCoPM72p7
         +kPA==
X-Forwarded-Encrypted: i=1; AFNElJ8t+XqwQs1RSI4y+yGnCLxEL3/Gs+CV06vwEIGG9WEw1qy8HSp9sCPWwOZi6suavWVTmMWnMFy3S2o=@vger.kernel.org
X-Gm-Message-State: AOJu0YzM/fNSvAPizX85+n1P5BYRonpX805UawjTG7hhnqjlMd2pYVaK
	NSvMgjlXlIRhvhauClFN5ZurVu5xTGGPzjvSbNGQmxGIF8h/8uQBc7UezptIBoKpMEZNUDnce0O
	RcJ+s92j2j03kiRgr3L+dvXm++wPE4/ulyJWSDEw+VQ7PX78fIs1L0npxvQ==
X-Gm-Gg: AfdE7ckebJlFkq8yvMtU+gnC1FJEYVKC1lEDEbpQZLNgZefsZFqVUoc0ySyxLSQVjVJ
	4xQaVzCTvgfEJvTPgR0BZBlNBlB5QqMP2Xg7NenOGpOd2VIEime79RMOpEqh+Pw3fI/h07jE42M
	cu8xq9li46wIgSCFhP3/YvIJrGTpq8trzLzMbFgIg/jwmlfcCH+d97e2uC3UGOh+7jvvVKxIAMU
	9OqKQqhgQ4ngLAsOugYC9Kaa6Fk3aAaYyxj+fRGjBP2lgh4jERSbK4VW+9pJJMRuzFc4Y9IsHtd
	ApKiDBDCgCktXYlzFia2tYKEP3ih/+s/8dKIgIty7kv+3KDdyXiMo2VkkyurZXqNUucsbPFRmXB
	GJw4V1Kvi9Dsf47+TZJSpn+2Xyfz1
X-Received: by 2002:ac8:5703:0:b0:516:ed2c:9c75 with SMTP id d75a77b69052e-51a51a9be7bmr4274301cf.16.1782146727921;
        Mon, 22 Jun 2026 09:45:27 -0700 (PDT)
X-Received: by 2002:ac8:5703:0:b0:516:ed2c:9c75 with SMTP id d75a77b69052e-51a51a9be7bmr4273601cf.16.1782146727437;
        Mon, 22 Jun 2026 09:45:27 -0700 (PDT)
Received: from [10.206.129.146] ([129.236.229.236])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-51a515ccdbbsm2022461cf.11.2026.06.22.09.45.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 22 Jun 2026 09:45:26 -0700 (PDT)
Message-ID: <cc58a101-6d09-4e42-b99d-673271934c29@columbia.edu>
Date: Mon, 22 Jun 2026 12:45:25 -0400
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 1/4] block: add task-context bio completion
 infrastructure
To: Jan Kara <jack@suse.cz>
Cc: Christoph Hellwig <hch@infradead.org>, Jens Axboe <axboe@kernel.dk>,
        "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        Christian Brauner <brauner@kernel.org>,
        "Darrick J. Wong"
 <djwong@kernel.org>,
        Carlos Maiolino <cem@kernel.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Dave Chinner <dgc@kernel.org>, Bart Van Assche <bvanassche@acm.org>,
        linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-mm@kvack.org, Gao Xiang <xiang@kernel.org>
References: <20260514-blk-dontcache-v6-0-782e2fa7477b@columbia.edu>
 <20260514-blk-dontcache-v6-1-782e2fa7477b@columbia.edu>
 <agq2KRd8RkP1TAf5@infradead.org>
 <ea1fa305-3ba2-4cfd-b7cb-86875032a300@columbia.edu>
 <ahPbaSEoNA755Nt3@infradead.org>
 <f1b8eeb6-2397-4f48-a21a-a023eb0c80ab@columbia.edu>
 <rkb5oei6cx2erbyininczz6ukbnquqheexhu7tznn5rslkkdn7@b4kpdyhdwdb6>
 <ahbq0RdUyLIPiItB@infradead.org>
 <80cb53f3-e7e5-4f96-bacc-f9fb7661d976@columbia.edu>
 <cuyklvhnt37xwk3jlr2iyyxxkzvt4bsf5iqv2gag4ixdicnbk2@rfqgjlclwesz>
 <4jtsjd2sbsn2w7fzfwb7wwowz72r4kc6345ckkkcjoxjbbwjwn@rkl44x3o3sgy>
Content-Language: en-US
From: Tal Zussman <tz2294@columbia.edu>
In-Reply-To: <4jtsjd2sbsn2w7fzfwb7wwowz72r4kc6345ckkkcjoxjbbwjwn@rkl44x3o3sgy>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Authority-Analysis: v=2.4 cv=D5h37PRj c=1 sm=1 tr=0 ts=6a3966a9 cx=c_pps
 a=WeENfcodrlLV9YRTxbY/uA==:117 a=Ne+/oOzQhjyqTAlfBCchDA==:17
 a=IkcTkHD0fZMA:10 a=FelO9ux0wxsA:10 a=x7bEGLp0ZPQA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=SsB-OO3BMngHh3ZO9fOt:22
 a=xMg8OGkpyC76Z8KfPXcA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
 a=kacYvNCVWA4VmyqE58fU:22
X-Proofpoint-Spam-Info: AW1haW4tMjYwNjIyMDE2NCBTYWx0ZWRfX4axjM1ZjP8Ln
 QkHeFlgguHZm2ckynYGp378eQN/B5KahLgOdRr/duOJABRmqvGg1b/SrFQ/n422Wks34XR3JSSH
 3ChQUVCmmc1O5yWq/AWdOB02cF4EcW8YvTPmVSrcbzWtt3oap7pu
X-Proofpoint-GUID: xzi5pGZgazr6X6UXr_HWof6G9uYXYqom
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjIyMDE2NCBTYWx0ZWRfX81W5e3ZacNZW
 r0SgWA6uoawiWmEWrRivbg1/g5Ng+Yo6WfZUo84hsxvcz5waAB957w6yGeYzpEMYfeRbjc/vcU3
 c2odyetNtfrFES6RnSbuePXqE60JuGxJ3xkjIeJWbZsgjtfgsubJWKzjXO4+zfdzEeOuFdlO9ba
 owK1E5P5lpBY+BPQlBVBkrfrKgF2hLTE16MGV28lLFLnQCaD4KJU9M7YRNlTZUP5WiRHoP/Schf
 df/aT+VolB4huNGU7RCQ6ybfKYe1JgkjWUT6CS6W6GyPbjOGoHFNvmA72oOG0qNZ+cuXQpbTqvF
 raIapIvtPbEuXwTsu3AwxfmkdvrnybptVBbh+JY5AXSp44jSI5EnfKW3mVpnBj+Ld67blzj3Hay
 efwa0CfxVRbWNRBYHtahhfPXjsvyZPkEiQ5nhKhBpb1hZV06h1hAFPJXYxPTM28FFDLagZLg5Xq
 kB+fTpE43P0DyFde3vQ==
X-Proofpoint-ORIG-GUID: xzi5pGZgazr6X6UXr_HWof6G9uYXYqom
X-Proofpoint-Virus-Version: vendor=nai engine=6900 definitions=11825
 signatures=596817
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 lowpriorityscore=10 adultscore=0 suspectscore=0 bulkscore=10 clxscore=1015
 phishscore=0 priorityscore=1501 malwarescore=0 spamscore=0 impostorscore=10
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2606220164

On 6/18/26 10:26 AM, Jan Kara wrote:
> On Mon 01-06-26 13:04:41, Jan Kara wrote:
>> On Fri 29-05-26 16:46:15, Tal Zussman wrote:
>> > On 5/27/26 9:00 AM, Christoph Hellwig wrote:
>> > > On Wed, May 27, 2026 at 11:42:28AM +0200, Jan Kara wrote:
>> > >> > I ran some experiments with fio on both XFS and a raw block device. Five
>> > >> > iterations each for 60s. Results below.
>> > >> > 
>> > >> > TLDR: Removing the delay doesn't significantly decrease user-visible
>> > >> > latency or otherwise improve performance, but does significantly reduce
>> > >> > throughput and increase context switches in some workloads (e.g. C).
>> > >> > I think it makes sense to leave the delay as-is. Thoughts?
>> > >> 
>> > >> Thanks for the test! One question below:
>> > > 
>> > > Thanks from me as well!
>> > > 
>> > >> 
>> > >> > Results:
>> > >> > 
>> > >> > Workloads (all `uncached=1`):
>> > >> >   A: rw=write     bs=128k iodepth=1   ioengine=pvsync2     # XFS
>> > >> >   B: rw=write     bs=128k iodepth=128 ioengine=io_uring    # XFS
>> > >> >   C: rw=randwrite bs=4k   iodepth=32  ioengine=io_uring    # XFS
>> > >> >   D: rw=rw 50/50  bs=64k  iodepth=32  ioengine=io_uring    # XFS
>> > >> >   E: rw=write     bs=128k iodepth=128 ioengine=io_uring    # raw /dev/nvmeXn1
>> > >> >   F: rw=write     bs=128k iodepth=128 numjobs=4
>> > >> >      + vm.dirty_bytes=64MB, vm.dirty_background_bytes=32MB # XFS
>> > >> > 
>> > >> > Mean ± stddev across 5 iterations:
>> > >> > 
>> > >> >     metric                     delay=1           delay=0     delta
>> > >> >     --------------------------------------------------------------
>> > >> > 
>> > >> >   A seq 128k qd1
>> > >> >     BW (MB/s)                4333 ± 27         4374 ± 34     +0.9%
>> > >> >     p99   (us)              36.2 ± 0.8        35.8 ± 0.4     -1.1%
>> > >> >     p999  (us)               3260 ± 75         3228 ± 29     -1.0%
>> > >> >     ctx-switches          184 k ± 59 k     3.68 M ± 65 k    +1903%
>> > >> >     cs / io                0.09 ± 0.03       1.86 ± 0.03    +1888%
>> > >> >     avg bios/run            80.4 ± 0.6         1.1 ± 0.0    -98.7%
>> > >> 
>> > >> So 1 jiffie delay is (with default HZ=1000) 1ms. That means for this load
>> > >> the completion latency should be at least 1000us but your results show p99
>> > >> latency of 36. What am I missing?
>> > > 
>> > > Yes, this looks a bit odd.  Unless there's multiple threads submitting
>> > > and somehow the completions get batched this should complete one
>> > > bio at a time and be the worst case for the delay scheme.
>> > 
>> > Sorry, I should've clarified - the latency here is the userspace-visible
>> > I/O completion latency (i.e. fio's clat value).
>> > 
>> > I ran again and traced to get the actual time from __bio_complete_in_task()
>> > to calling ->bi_end_io(). The results match the 1 jiffie delay now:
>> > 
>> >   metric                  delay=1  delay=0
>> > 
>> >   A seq 128k qd1
>> >     fio clat p99             38us     36us
>> >     bio cb p50             1.23ms    2.5us
>> >     bio cb p99             4.13ms   1.44ms
>> >     bio cb p999            5.01ms   2.63ms
>> 
>> So I'm clearly missing something fundamental as I don't see how can fio
>> reported IO completion time be lower than the end_io callback latency...
>> Ahh, it is the strange meaning of clat in fio in combination with sync
>> engine where clat means: "how long after the syscall has returned the data
>> is ready". Which for sync engine is immediately so the clat number is
>> meaningless. I think reporting 'lat' numbers from fio would make more
>> sense but whatever.
>> 
>> The bio cb latency indeed looks like what I'd roughly expect now. And
>> notice how the median latency of IO completion is 1.23ms in delay=1 case
>> and your throughput isn't abbysmal only because writes end up accumulating
>> in the page cache and writeback infrastructure ends up submitting a lot of
>> writeback IOs in parallel (you have ~80 bios to complete per run which
>> amortizes the latency to decent level).
>> 
>> However if you'd have IO that were to use BIO_COMPLETE_IN_TASK
>> infrastructure which doesn't have so many IOs in flight (like direct IO
>> with lower queue depth which has to do extent conversion on completion),
>> you would very much see the latency hit on your throughput as well. In the
>> extreme case of qd=1 direct IO you'd reduce the throughput to ~4MB/s.
>> 
>> Now I'm not saying the delay is bad - it is a tradeoff with clear wins in
>> CPU overhead your benchmarks are showing. I just wanted to point out
>> there's also the cost side which your benchmarks don't show very clearly.
>> So we might need to keep some stats showing how many IO completions we are
>> offloading per second on each CPU and switch to delaying the work only once
>> it crosses a threshold like 1000000/HZ per second or so (so we at most
>> double the IO latency by delaying the end_io callback).
> 
> Any progress here? The patchset looks really promising so I'd love to have
> it completed :)
> 
Sorry for the delay - got caught up with some other work and had to set this
aside for a couple weeks, but haven't forgotten about this. Planning to pick
it back up some time this week.

Thanks,
Tal

