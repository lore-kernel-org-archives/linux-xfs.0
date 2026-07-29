Received: from mx0b-00364e01.pphosted.com (mx0b-00364e01.pphosted.com [148.163.139.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95ED3242D65
	for <linux-xfs@vger.kernel.org>; Wed, 29 Jul 2026 06:11:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.139.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785305490; cv=none; b=rNTw5AbsaRtUOtHP6SIJFy+W17heFh4dl41aVDqw8XKjmOyRCK144GB0TgUtgp/RCJ12eDl4i+pebUXKn1AmdltnJY/MILSlnHKJWjCbhodI+KoydAeQdsCsY1aTxEJixOPpHBMtEANsyqPNhpd93IgPmfG6nWfBhPFIXwuPUJM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785305490; c=relaxed/simple;
	bh=jL1L+M9UzP23TeE1WbPlqF1oRuPeCxkLBdJWLaUGyyE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=QuU6ijFupq4+A57YGH0jPPx2kku3O4leS8uWW1aSrKpH3ldTTqEAR0RzZRnxlHpCIQalho7rA5C5foPos/U7/wJUdkGmOMfNE6XYDjfOJ+zfgvDPHorp/UbEia/P3Vr9RMGEm9NagaHHpZVQvLC3ux7Z4UHtjfdGYUih25T3rt8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=columbia.edu; spf=pass smtp.mailfrom=columbia.edu; dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b=TMkaVCOG; arc=none smtp.client-ip=148.163.139.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=columbia.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=columbia.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b="TMkaVCOG"
Received: from pps.filterd (m0167074.ppops.net [127.0.0.1])
	by mx0b-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66T5fXUG3009286
	for <linux-xfs@vger.kernel.org>; Wed, 29 Jul 2026 02:11:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps01; bh=u855
	+fk6kISuaKSmfaV9vv5egbGgNKlzL+lMI+HDIuo=; b=TMkaVCOG/I7k1Flsl7WB
	1/4xg5/HFiDiQFPLjuJWN3AiqnVbPUdSlUhzkO0+2PbFTKoc64/HJazFYL+Bk3Ie
	jaUR+PrDYJUmpaynWYN1UqypZxTHko8jlnCRnD63ReiW5R5FDJClh9hHCMtPpeBG
	phTjvZzEeW6qzRJLgxv/5tEdvt3c72MZ6jHL2gt2bQgrN0oM3IDRW/dHrnJrqLlo
	c8YBlycb5MPJRxcbKbsQA08Td001HRFEPibV1SHwiFwuTm+J7ag+AuU4n5FlojHT
	Dn5z1gRJORA9FjapXBYzS6r0QaYg3xNo2fai5itZVSXsVnyOOGbBXhM8I1wAC6WQ
	9A==
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com [209.85.160.199])
	by mx0b-00364e01.pphosted.com (PPS) with ESMTPS id 4fpy7dm21q-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-xfs@vger.kernel.org>; Wed, 29 Jul 2026 02:11:19 -0400 (EDT)
Received: by mail-qt1-f199.google.com with SMTP id d75a77b69052e-51c1d7886cdso11755151cf.1
        for <linux-xfs@vger.kernel.org>; Tue, 28 Jul 2026 23:11:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785305479; x=1785910279;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=u855+fk6kISuaKSmfaV9vv5egbGgNKlzL+lMI+HDIuo=;
        b=hynckvcZCq8PWCFkQWn43SRqkqDsC371qRQEjhje4GF3efZEj1nRhhcvSdydutc/NH
         R/E9ZOOOcqZwMcJ+CJ30l3AD1oFURGATfMtBnWHX2FzRWTxtWqh3leGRJyA0qRfIsYih
         HFLanmm6AE7Pb3LlDyiRgLGBMJ4/cjU9GnQvgSQAE8rnKPWSZkUEuUwZgQ7PkuDXtCpw
         w3shRve7wMmPd3m7rdpvZsjVPkskQsj1SelLjtmXC9KH0m2GTsk0KqekLft0gcZaFnR4
         OxbDLMkip032gUI/1VZBOKd5hyfViD14ElaKokfCRAlTSg9bv72nS7VVTG7xoarG2sln
         eoWg==
X-Forwarded-Encrypted: i=1; AHgh+RqtY3k7MtVXOs5m4i2H+hhB4bLdF4QBNElgthm7q2Upq86ilWbuKQUAbb1NvyR5d+0Y43k78mvZLUE=@vger.kernel.org
X-Gm-Message-State: AOJu0YyL/5ucKozcVSi4qYNRdGCnWIFp6XMXmHNywjXA3jm679EYPSdP
	CW1uNDZN0SyGTWDIMgkS6YVjtxacxRscQWNqJIe5U5VehxxgP57u0QxVWf0yNU7Kp1eUkAOuU69
	nBUvS8EF2IjSDhgXlSJ9mRKD1TEahR1XNp2z7l6VjYt22FrW9vyna6n2uqw==
X-Gm-Gg: AR+sD13prARiEobT1MQJfpSSGjIq/YNGQdeOXZdHA+86SWj/mPaD/C+OJbWjb5rLCZj
	RmCk3b4l/WTUuoidcFDywykypsFNt+9Uz7hs0cANaRq4nFf9O/KDbQNU3wSQ7f6R3LqDQrUHvcz
	06U6lxoDxM7JpNtpXEII1NQHEFnWFF0farIEDhD+69cIewe5V++8QndWffaVD+WackxdRdX+sPW
	HRiYVYIO0h5n7Bbh2YD32apHzSfDwYp2em0crQVmaEnkb/WANdsDwpER3wWvWYGooBz9bsOQk+p
	SRuLEsworQyQKvWW7WhM1jUuwiiP9UT3FVapx1ksrIpxRhJGhJFB4fRiUqYGtFlYXrk7YUej8bf
	o7rM1hC+unzgaqAbKSp5AjCuphXGrt5yPFtdKd5BxQKCnIFqZwg==
X-Received: by 2002:a05:622a:111:b0:51c:1811:6eae with SMTP id d75a77b69052e-529d70eb754mr49138371cf.47.1785305479107;
        Tue, 28 Jul 2026 23:11:19 -0700 (PDT)
X-Received: by 2002:a05:622a:111:b0:51c:1811:6eae with SMTP id d75a77b69052e-529d70eb754mr49138181cf.47.1785305478580;
        Tue, 28 Jul 2026 23:11:18 -0700 (PDT)
Received: from [192.168.1.62] (dyn-160-39-33-242.dyn.columbia.edu. [160.39.33.242])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-9081dc890c7sm16972566d6.19.2026.07.28.23.11.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 28 Jul 2026 23:11:17 -0700 (PDT)
Message-ID: <8124341f-3af2-4a16-897d-38db5ab5a9d4@columbia.edu>
Date: Wed, 29 Jul 2026 02:11:17 -0400
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 1/4] block: add task-context bio completion
 infrastructure
To: Christoph Hellwig <hch@infradead.org>, Jan Kara <jack@suse.cz>
Cc: Jens Axboe <axboe@kernel.dk>,
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
References: <agq2KRd8RkP1TAf5@infradead.org>
 <ea1fa305-3ba2-4cfd-b7cb-86875032a300@columbia.edu>
 <ahPbaSEoNA755Nt3@infradead.org>
 <f1b8eeb6-2397-4f48-a21a-a023eb0c80ab@columbia.edu>
 <rkb5oei6cx2erbyininczz6ukbnquqheexhu7tznn5rslkkdn7@b4kpdyhdwdb6>
 <ahbq0RdUyLIPiItB@infradead.org>
 <80cb53f3-e7e5-4f96-bacc-f9fb7661d976@columbia.edu>
 <cuyklvhnt37xwk3jlr2iyyxxkzvt4bsf5iqv2gag4ixdicnbk2@rfqgjlclwesz>
 <4jtsjd2sbsn2w7fzfwb7wwowz72r4kc6345ckkkcjoxjbbwjwn@rkl44x3o3sgy>
 <cc58a101-6d09-4e42-b99d-673271934c29@columbia.edu>
 <amgrwn0yQoFvJP4u@infradead.org>
Content-Language: en-US
From: Tal Zussman <tz2294@columbia.edu>
In-Reply-To: <amgrwn0yQoFvJP4u@infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Authority-Analysis: v=2.4 cv=M+N97Sws c=1 sm=1 tr=0 ts=6a699987 cx=c_pps
 a=WeENfcodrlLV9YRTxbY/uA==:117 a=GaPK54s0Se3oFqK5NkZy0g==:17
 a=IkcTkHD0fZMA:10 a=RAioF0-LDSMA:10 a=x7bEGLp0ZPQA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=azVShVRs0zEubeQ0wG0L:22
 a=4b9XAn8bT_W39vTbWQgA:9 a=QEXdDO2ut3YA:10 a=kacYvNCVWA4VmyqE58fU:22
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzI5MDA0OCBTYWx0ZWRfX3Rhlsx42ju1A
 TL1IWYWUnEuOQnwkmmlc8EQu/8gF8QDYQqIK+267hIUXbf7t7eRA6huzHNsEnUkEgh/A/aRb+5G
 equEqoFLWPgHUUZZkpOiZbWdRffZ4BIYykutw61gxFiva2HKk1xF
X-Proofpoint-GUID: nyDlHXxZBdaGCsHzVXaQK1OS5Zpoad5R
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzI5MDA0OCBTYWx0ZWRfX5YLKw0AkxWLJ
 6+9F7lLu1cjXWu0Iz2aUe5BOeb1DFL/LM3KeDIJ+pipGAnKvlCepVOq1VOYuy0aWsx/BQPS94w5
 IfI/SIRikjC7t7r909mHM4wUvRZE4HidTsJdioVc6a4JPicASifyaZKJa/5I//J5iTd3AcihjCQ
 XdXEnn9lAyZAfjVTtvkooJgqccRAapdn88SgbraRVfXyIVaqKf+DmH9/4U7TbeZrf1bY8sa5VdX
 TJ6c6j4uY6TcOqGAoP0iOmz4V5Xow0m3/XOvjArusRfE3+R1wmkwR2Yhcwzr3neNMLrZHtrKluO
 F5iRSjJJ9gII5WxhVoIelR0erMUzcpSf/ym1FgLn8D0KyWe+buBA/bZR/+0IqJMabwagtS/Sk/5
 ZuWv+qQUGBGdF5fKr7JwIhrse93RvOz3ZIR7Y9VUD597tzEIU6CbEcsrGooxdUm5lt2RKTMOwPb
 28DZ4CKvJgYGwVncEKw==
X-Proofpoint-ORIG-GUID: nyDlHXxZBdaGCsHzVXaQK1OS5Zpoad5R
X-Proofpoint-Virus-Version: vendor=nai engine=6900 definitions=11859
 signatures=596817
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=10 malwarescore=0 adultscore=0 spamscore=0 priorityscore=1501
 phishscore=0 suspectscore=0 clxscore=1011 impostorscore=10
 lowpriorityscore=10 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2607290048

On 7/28/26 12:10 AM, Christoph Hellwig wrote:
> On Mon, Jun 22, 2026 at 12:45:25PM -0400, Tal Zussman wrote:
>> > 
>> > Any progress here? The patchset looks really promising so I'd love to have
>> > it completed :)
>> > 
>> Sorry for the delay - got caught up with some other work and had to set this
>> aside for a couple weeks, but haven't forgotten about this. Planning to pick
>> it back up some time this week.
> 
> Sorry for another ping, but we have a lot of code waiting on this
> kind of infrastructure now, it would be great to get a version in.
> 

No worries, and apologies again for the delay. I had some deadlines and
travel that kept me busy, but I have some additional results below:

First, I investigated the workload C behavior further. The underlying
problem is that ioends routed to the XFS completion workqueue were also
carrying BIO_COMPLETE_IN_TASK, so unwritten completions bounced through the
block-layer worker (plus its delay) only to be queued on
m_unwritten_workqueue afterwards. The ioend workqueue already provides the
task context the flag asks for, so something like this avoids the bounce:

diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
--- a/fs/xfs/xfs_aops.c
+++ b/fs/xfs/xfs_aops.c
@@ -552,8 +552,10 @@ xfs_writeback_submit(
        /*
         * Send ioends that might require a transaction to the completion wq.
         */
-       if (xfs_ioend_needs_wq_completion(ioend))
+       if (xfs_ioend_needs_wq_completion(ioend)) {
                ioend->io_bio.bi_end_io = xfs_end_bio;
+               bio_clear_flag(&ioend->io_bio, BIO_COMPLETE_IN_TASK);
+       }

        return iomap_ioend_writeback_submit(wpc, error);
 }
@@ -664,6 +666,7 @@ xfs_zoned_writeback_submit(
        struct iomap_ioend              *ioend = wpc->wb_ctx;

        ioend->io_bio.bi_end_io = xfs_end_bio;
+       bio_clear_flag(&ioend->io_bio, BIO_COMPLETE_IN_TASK);
        if (error) {
                ioend->io_bio.bi_status = errno_to_blk_status(error);
                bio_endio(&ioend->io_bio);

(Diffs may be whitespace-damaged, for illustrative purpose only)

On a fresh-file run of workload C (every completion doing an unwritten
conversion) this stops conversion-heavy writeback from entering the
block-layer deferral entirely and cuts write p50/p99 by 7-8% (3381 -> 3151us
/ 6761 -> 6193us) at equal bandwidth. I tested a sync waiter workload on a
fresh file too, and it also hit this even harder: a 4k write+fdatasync loop
goes from 2.0 to 17.0 MB/s with this change on top of v6.

I don't love this patch, as it feels a little hacky as currently
constructed, but the perf impact on this worst case is substantial.

I also implemented (a version) of Jan's suggestion of only delaying the
completion work when the offload rate hits a threshold, and tested it
against both delay=1 and delay=0.

We keep a per-CPU count of completions offloaded during the current jiffie
and dispatch the worker immediately unless that count crosses
BIO_COMPLETE_BATCH_RATE (16000/s per CPU, i.e. 16 per jiffie at HZ=1000):

diff --git a/block/bio.c b/block/bio.c
--- a/block/bio.c
+++ b/block/bio.c
@@ -1749,10 +1749,15 @@ void bio_check_pages_dirty(struct bio *bio)
  */
+#define BIO_COMPLETE_BATCH_RATE                16000   /* per second, per CPU */
+#define BIO_COMPLETE_BATCH_THRESH      (BIO_COMPLETE_BATCH_RATE / HZ)

 struct bio_complete_batch {
        struct bio_list list;
        struct delayed_work work;
        int cpu;
+       unsigned long window;   /* jiffie that count refers to */
+       unsigned int count;     /* completions offloaded during window */
 };

@@ -1784,16 +1789,27 @@ void __bio_complete_in_task(struct bio *bio)
 {
        struct bio_complete_batch *batch;
+       unsigned long now = jiffies;
+       unsigned long delay = 0;
        unsigned long flags;
        bool was_empty;

        local_irq_save(flags);
        batch = this_cpu_ptr(&bio_complete_batch);
+
+       if (batch->window != now) {
+               batch->count = 0;
+               batch->window = now;
+       }
+       batch->count++;
+       if (batch->count > BIO_COMPLETE_BATCH_THRESH)
+               delay = 1;
+
        was_empty = bio_list_empty(&batch->list);
        bio_list_add(&batch->list, bio);
        local_irq_restore(flags);

        if (was_empty)
                mod_delayed_work_on(batch->cpu, bio_complete_wq,
-                                   &batch->work, 1);
+                                   &batch->work, delay);
 }
 EXPORT_SYMBOL_GPL(__bio_complete_in_task);


I used 16000/s (at HZ=1000) as the threshold rather than the 1000/s
suggested. For async completions the 1-jiffie delay would at most double the
latency, but a sync waiter that can reach the threshold instead gets stuck
at it. Each deferral adds a jiffie, which drops its rate back below the
threshold, which re-arms a few ms later. This has a significant impact on
the qd1 fdatasync workload below (W1). My main concern is that this turns
out to be device-specific and 16000 is too low for faster drives.

Results are below.
fdatasync latencies are fio's sync percentiles. All three kernels
include the xfs patch above: delay=1 is the current unconditional
delay, delay=0 unconditional immediate dispatch, and gated is the diff above.
C and D are the same workloads as in the previous results.

                                 delay=1     delay=0       gated
W1) 4k write+fdatasync, qd1 (~14k completions/s)
  bandwidth (MB/s)                   2.0        52.6        52.5
  fdatasync p50 (us)              1990.7        69.8        70.1
  fdatasync p99.9 (us)            2965.5       118.3       119.6
  context switches                  212k       4.17M       4.18M
  cycles                          13.8e9     119.3e9     122.2e9

W2) 64k write+fdatasync, qd1 (~10k completions/s)
  bandwidth (MB/s)                  32.7       657.5       655.4
  fdatasync p50 (us)              1974.3        82.8        83.1
  fdatasync p99.9 (us)            2987.3       137.6       136.9
  context switches                  403k       3.30M       3.30M
  cycles                          22.8e9     144.9e9     144.5e9

C) 4k buffered randwrite, qd32 (~118k completions/s)
  bandwidth (MB/s)                 649.5       655.7       643.4
  write lat p50 (us)               215.4       214.7       216.1
  write lat p99.9 (us)             703.1       984.4       730.5
  context switches                20.69M      21.98M      21.44M
  cycles                         922.5e9     838.1e9     911.3e9

D) 64k buffered mixed r/w, qd32 (~11k completions/s)
  bandwidth (MB/s)                 761.2       753.2       757.2
  write lat p50 (us)              2605.1      2637.8      2605.1
  write lat p99.9 (us)            4358.1      4358.1      4358.1
  context switches                 5.99M       6.92M       6.92M
  cycles                         399.0e9     414.3e9     414.4e9

On W1/W2 the delay=1 caps a sync waiter at ~500 syncs/s, since every
fdatasync takes a full jiffie. The gated version never fires on either
workload, so it matches delay=0.

For C, delay=0 regresses write p99.9 by 40%, while the gated version stays
within 4% of delay=1's tail.

D is similar across configurations, but adds +3.9% cycles and +15% context
switches vs. delay=1.

Again, my main concern with this approach is that 16000 (or 1000) is a
somewhat arbitrary value that depends on disk performance. If the C p99.9
perf is an acceptable trade-off, I think we can get rid of the delay, but
I'd appreciate more thoughts on that and the XFS diff above.

I'll send v7 with the rest of the changes (Sashiko review, etc.) in a day or
two, pending any additional feedback.

Thanks,
Tal
