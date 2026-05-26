Received: from mx0a-00364e01.pphosted.com (mx0a-00364e01.pphosted.com [148.163.135.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C72933AF665
	for <linux-xfs@vger.kernel.org>; Tue, 26 May 2026 19:29:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.135.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779823779; cv=none; b=lwcT3jQerLbdzMwmY66vqyfGw57uQSfUR9NM99LhmJJIMstjkRjaJ9OCyKDg+APunvxNyZOOlfs8Qe7y2ePn3zxmpGp7LJ3sunOwHBib4a1/nxaSdh2/vpjG7Y92nzw1jNiq3rh8FK/T+dmOj1fVkny39MFdV9On7VOdUs1qnWA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779823779; c=relaxed/simple;
	bh=vYzNwQN175luagePY1ab0B36C2IxYvgHIz06JirVXm4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=qhY5npVZODgVx96q56czJMbMEngOXGenhn0mBhIfbw4hO+PdcrVkaMWiMuXFLa4QMqaUnNjdDAWV4xMrxwGexzMTJjb80vLQBdHnMd1S673i6EOAbo1+WhXsqEXqgJC21cx01EHSy9sQfqL1muvr2hA/Hl9kPcqbe/VppmXcfmE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=columbia.edu; spf=pass smtp.mailfrom=columbia.edu; dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b=CJmfJgDF; arc=none smtp.client-ip=148.163.135.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=columbia.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=columbia.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b="CJmfJgDF"
Received: from pps.filterd (m0167069.ppops.net [127.0.0.1])
	by mx0a-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 64QJNqGI3222086
	for <linux-xfs@vger.kernel.org>; Tue, 26 May 2026 15:29:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps01; bh=eF+K
	4idBW/n0FbUPDI/65dz93xILVqw4x2CBPyoeCog=; b=CJmfJgDF9wkJxW8aXSyQ
	0B+hZoErmDeQkinFJzySRXNs6xQEtaVCnU/03iz2lLkrvD+TPU+eGuO6BuRKPSB0
	5UFPLgMcbTTx2GZBbnnAPvW9kCmbr9JyGfOAucCDObHMEgI+fKZzCeyXAeODJZhw
	B261pEN5ksJXXIYupmyxejPqEeo6LKxF2BBGHyCrm4K3duQa7cl6dIAP+2JoxWv3
	Ny1czsoCe7fBznDDMfPUpF5rF6tqDB6QUgPlStwfcWZ6bgtyonMJtDFrguqjrFQW
	UD0HtYAGaejf9lFFUAoUShDSeOJJXoMPJnzFHmLlgZzcjYO0BvyxwecxPqdXRO5X
	DA==
Received: from mail-qv1-f69.google.com (mail-qv1-f69.google.com [209.85.219.69])
	by mx0a-00364e01.pphosted.com (PPS) with ESMTPS id 4edepqhudw-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-xfs@vger.kernel.org>; Tue, 26 May 2026 15:29:31 -0400 (EDT)
Received: by mail-qv1-f69.google.com with SMTP id 6a1803df08f44-8b1f4478ca7so54013156d6.3
        for <linux-xfs@vger.kernel.org>; Tue, 26 May 2026 12:29:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779823770; x=1780428570;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=eF+K4idBW/n0FbUPDI/65dz93xILVqw4x2CBPyoeCog=;
        b=J6IQS60xY0fRxT0eepbKbCKdifpZYAS/rh/rTsHntMW1RnZNUeeS+X7VWp6YYhfq0t
         05ZOKdNTGX9ZlVaZHWx05nrzsLAUvoOhPeUXN42NTVmvik0JpL7HHHJG9/JEJqmN4EeO
         FLggmF4V15ouVS7qr0xtpNC08cZCDSaNh0c0n9OAjvSYKmANezsM8oOFQ1B3XkP0yiKs
         CafdNzXrBnRLsx/O4XaG+caCfWUQ/EbJ2Q/Cs6wGsga9UHx/dJbvEZ0+Bmb4m4+kalSp
         h2qQnwQ+hlKbFR8GfiGbdmM9XIlLzueRJf28yUI4SPuZSCdLDS3G/8GMGT7m2yGcaejy
         JP+A==
X-Forwarded-Encrypted: i=1; AFNElJ8i3NlWizs+qLbLifFgnluVQ6CvPAZiNN4RticstPlShHzCevSbbOirkQm94JZhNCDYD6irqfIWU9o=@vger.kernel.org
X-Gm-Message-State: AOJu0YwXCodKS7mogzYEi3szEkrc7BhV77px+0PFcXDNQqDsL5dIfqs8
	I/xiZySqbA82Ftxrgv0ahkoGx/rPS6DzgqeOUNOZ7z9hkc2Z1r3BGSK32EQswM7qkOLxM9yk9Kt
	+LqjAHYxvbYWPYY0D6YoYVkGIi5UfLRIPFjDWeQEm10CXYx6v6CbmlKeNJQ==
X-Gm-Gg: Acq92OFR+USWfTxgKfoIv9ulyk04NTxldklCrHzVUrpW7XnmADFxjTmRlFawDxeuthz
	y9s9xSBgI3uXFd9cfAAUJB/RELfOvUuRpmeL5//mperJoZXHthAj+MEl4eh388z7MAj0s7tIqvP
	mKsJ1/nccuO4EIHAwBJw+YlyaoZG0DCelaAypwEO6Bzw27ngY8WQPHzLzP1/Mf2LzrhgMmDrARa
	gA4jzhDBIp0KxGOHt/neuJHQn4IHH34UsV7B+MalPKvpqkTl6c4KvxNIEO6sFr3Uxk1lC3fpWO4
	lZ3f3gFRvjnIVzF2tfcwtB234sSXYbRbJ0jaK2RadFY/tlD79EsuY51bC3KJ1VcFPEnfZVXIJy9
	uMa6QBpN95DubSuifKYSliNp+zjm17jSGe5Qwac1awzBYEX3DvijX2VkXa3K2H6T+Wf3itdQ=
X-Received: by 2002:a05:6214:2dc7:b0:8cc:6aa6:704e with SMTP id 6a1803df08f44-8cc7b51c1f6mr303884666d6.11.1779823770178;
        Tue, 26 May 2026 12:29:30 -0700 (PDT)
X-Received: by 2002:a05:6214:2dc7:b0:8cc:6aa6:704e with SMTP id 6a1803df08f44-8cc7b51c1f6mr303884056d6.11.1779823769667;
        Tue, 26 May 2026 12:29:29 -0700 (PDT)
Received: from [192.168.1.62] (dyn-160-39-33-242.dyn.columbia.edu. [160.39.33.242])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8cc80ded529sm149485386d6.16.2026.05.26.12.29.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 26 May 2026 12:29:29 -0700 (PDT)
Message-ID: <f1b8eeb6-2397-4f48-a21a-a023eb0c80ab@columbia.edu>
Date: Tue, 26 May 2026 15:29:28 -0400
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 1/4] block: add task-context bio completion
 infrastructure
To: Christoph Hellwig <hch@infradead.org>
Cc: Jens Axboe <axboe@kernel.dk>,
        "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        Christian Brauner <brauner@kernel.org>,
        "Darrick J. Wong"
 <djwong@kernel.org>,
        Carlos Maiolino <cem@kernel.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>,
        Dave Chinner <dgc@kernel.org>, Bart Van Assche <bvanassche@acm.org>,
        linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-mm@kvack.org, Gao Xiang <xiang@kernel.org>
References: <20260514-blk-dontcache-v6-0-782e2fa7477b@columbia.edu>
 <20260514-blk-dontcache-v6-1-782e2fa7477b@columbia.edu>
 <agq2KRd8RkP1TAf5@infradead.org>
 <ea1fa305-3ba2-4cfd-b7cb-86875032a300@columbia.edu>
 <ahPbaSEoNA755Nt3@infradead.org>
Content-Language: en-US
From: Tal Zussman <tz2294@columbia.edu>
In-Reply-To: <ahPbaSEoNA755Nt3@infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Authority-Analysis: v=2.4 cv=K+kS2SWI c=1 sm=1 tr=0 ts=6a15f49b cx=c_pps
 a=wEM5vcRIz55oU/E2lInRtA==:117 a=GaPK54s0Se3oFqK5NkZy0g==:17
 a=IkcTkHD0fZMA:10 a=NGcC8JguVDcA:10 a=x7bEGLp0ZPQA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=JR4YdQiviy7OQf72WyZ1:22
 a=xJqtjSYic485Zj8o0nAA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
 a=OIgjcC2v60KrkQgK7BGD:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTI2MDE3MiBTYWx0ZWRfX+WV4/DrllhPM
 gfEUWXRS3/qROYry/tdIFuudOsNW9VMWph1q8Hpb6bq4k4Nj9NjVq7wVTWghONxPoXDqIhB2NkW
 uVS89rkBzcAfXEYt+JvEAjobFjRvzCGI9NhgWv7v9ioRP2brgOaAaCD1IsSVJ9CSRE1CBas+13J
 kvnEMergCVTrE5UPKvcs0ASHkHirzBp4Y3qegx3Dsd2DwTzKCK5+bw8wPHQmkQN7hk+Jv7KuOM7
 1AaqlNlz7xwnnMvg9PSuhes09wswQRuRTz+6VqzHLkuvplzsVa1FfBbZz2/c++eBpSQF5q+JN6O
 3qAoldiLA2hiMdtHCWziTwBpwfMS/3qP1JsL/W2F4s8UzzHa1Ewk3pffOmQZGeo98vOdPeHxfw/
 4LFWv297rEx3e3cMEoHVpAoOLm1o1cUhv9s4gdvCV7j1vOyDhduwiiBtj8hQU2c24NFOi6oIo5X
 FFQIanU5UyYq5GQEuGA==
X-Proofpoint-ORIG-GUID: 8fHnBgA-xdbzxxDIk5XT58NCvZt23Jr1
X-Proofpoint-GUID: 8fHnBgA-xdbzxxDIk5XT58NCvZt23Jr1
X-Proofpoint-Virus-Version: vendor=nai engine=6900 definitions=11798
 signatures=596817
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=10 impostorscore=10 phishscore=0 clxscore=1015 priorityscore=1501
 lowpriorityscore=10 adultscore=0 spamscore=0 suspectscore=0 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2605130000 definitions=main-2605260172

On 5/25/26 1:17 AM, Christoph Hellwig wrote:
> On Fri, May 22, 2026 at 06:47:43PM -0400, Tal Zussman wrote:
>> > But this 1-jiffie delay also means we unconditionally increase
>> > completion latency, which feels like a bad idea.  Do you have any
>> > measurements that show where it does benefit?  Note that queing work
>> > already often has very measurable latency on it's own.  This also
>> > directly contradics the erofs experience that even went to a RT
>> > thread to reduce the latency.
>> 
>> I added this per Dave's feedback on v4, where he noted that XFS inodegc
>> uses a delayed work item to avoid context switch storms. There's only a
>> delay for the first bio in a batch to complete, as we only delay when the
>> list is empty. I'll run some experiments and measure context switches,
>> completion latency, etc. to see if this is necessary.
> 
> The difference is that XFS inodegc is not latency bound.  Most of the
> time no one cares if it is delayed a bit, in the cases where someone
> cares we explicitly flush the queues.  I/O completion on the other hand
> is something where users very much care about latency.
> 

I ran some experiments with fio on both XFS and a raw block device. Five
iterations each for 60s. Results below.

TLDR: Removing the delay doesn't significantly decrease user-visible
latency or otherwise improve performance, but does significantly reduce
throughput and increase context switches in some workloads (e.g. C).
I think it makes sense to leave the delay as-is. Thoughts?

Results:

Workloads (all `uncached=1`):
  A: rw=write     bs=128k iodepth=1   ioengine=pvsync2     # XFS
  B: rw=write     bs=128k iodepth=128 ioengine=io_uring    # XFS
  C: rw=randwrite bs=4k   iodepth=32  ioengine=io_uring    # XFS
  D: rw=rw 50/50  bs=64k  iodepth=32  ioengine=io_uring    # XFS
  E: rw=write     bs=128k iodepth=128 ioengine=io_uring    # raw /dev/nvmeXn1
  F: rw=write     bs=128k iodepth=128 numjobs=4
     + vm.dirty_bytes=64MB, vm.dirty_background_bytes=32MB # XFS

Mean ± stddev across 5 iterations:

    metric                     delay=1           delay=0     delta
    --------------------------------------------------------------

  A seq 128k qd1
    BW (MB/s)                4333 ± 27         4374 ± 34     +0.9%
    p99   (us)              36.2 ± 0.8        35.8 ± 0.4     -1.1%
    p999  (us)               3260 ± 75         3228 ± 29     -1.0%
    ctx-switches          184 k ± 59 k     3.68 M ± 65 k    +1903%
    cs / io                0.09 ± 0.03       1.86 ± 0.03    +1888%
    avg bios/run            80.4 ± 0.6         1.1 ± 0.0    -98.7%

  B seq 128k qd128
    BW (MB/s)               4393 ± 3.3        4311 ± 5.3     -1.9%
    p99   (us)               8461 ± 73        8638 ± 105     +2.1%
    p999  (us)             12465 ± 213       12386 ± 299     -0.6%
    ctx-switches        6.90 M ± 186 k    9.72 M ± 184 k    +40.7%
    cs / io                3.43 ± 0.10       4.92 ± 0.10    +43.4%
    avg bios/run            51.9 ± 2.2         1.3 ± 0.0    -97.4%

  C rand 4k qd32
    BW (MB/s)               66.2 ± 0.8        44.6 ± 7.4    -32.7%
    p99   (us)              8002 ± 174      17990 ± 6800   +124.8%
    p999  (us)             11390 ± 554     31890 ± 11076   +180.0%
    ctx-switches         3.67 M ± 45 k    3.59 M ± 106 k     -2.2%
    cs / io                3.78 ± 0.04       5.62 ± 0.83    +48.7%
    avg bios/run            32.3 ± 1.0         3.1 ± 0.3    -90.5%

  D mixed 50/50 r/w 64k qd32
    write BW (MB/s)       892.4 ± 20.9      925.3 ± 18.3     +3.7%
    write p99 (us)          3562 ± 107         3601 ± 82     +1.1%
    write p999 (us)         4673 ± 217        4647 ± 107     -0.6%
    read BW (MB/s)        893.6 ± 20.8      926.6 ± 18.4     +3.7%
    read p99 (us)            1003 ± 48         1035 ± 39     +3.2%
    read p999 (us)           1545 ± 63         1476 ± 50     -4.5%
    ctx-switches         5.15 M ± 75 k    5.79 M ± 230 k    +12.6%
    cs / io                6.32 ± 0.15       6.85 ± 0.20     +8.5%
    avg bios/run            23.9 ± 0.3         2.5 ± 0.0    -89.4%

  E raw 128k qd128
    BW (MB/s)               1043 ± 1.0        1045 ± 0.5     +0.1%
    p99   (us)             26922 ± 105       27027 ± 128     +0.4%
    p999  (us)            37906 ± 4527      37408 ± 2464     -1.3%
    ctx-switches          3.20 M ± 6 k     3.33 M ± 10 k     +3.8%
    cs / io                6.71 ± 0.01       6.95 ± 0.02     +3.7%
    avg bios/run            38.0 ± 0.1        32.0 ± 0.0    -15.6%

  F mem-pressure (dirty_bytes=64MB, 4 writers)
    BW (MB/s)                4361 ± 24         4444 ± 40     +1.9%
    p99   (us)             29439 ± 419       30173 ± 788     +2.5%
    p999  (us)            35704 ± 1773       36648 ± 535     +2.6%
    ctx-switches        20.8 M ± 1.6 M    27.1 M ± 1.4 M    +30.1%
    cs / io                6.94 ± 0.49       8.87 ± 0.46    +27.8%
    avg bios/run            23.6 ± 0.3         1.2 ± 0.0    -94.9%
