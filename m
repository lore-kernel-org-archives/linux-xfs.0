Return-Path: <SRS0=7MVS=IG=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7D503C433E0
	for <linux-xfs@archiver.kernel.org>; Mon,  8 Mar 2021 10:50:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2B7A5651FC
	for <linux-xfs@archiver.kernel.org>; Mon,  8 Mar 2021 10:50:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230039AbhCHKuW (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 8 Mar 2021 05:50:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230125AbhCHKtt (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 8 Mar 2021 05:49:49 -0500
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B7F5C06174A
        for <linux-xfs@vger.kernel.org>; Mon,  8 Mar 2021 02:49:48 -0800 (PST)
Received: by mail-pl1-x62e.google.com with SMTP id n17so1121699plc.7
        for <linux-xfs@vger.kernel.org>; Mon, 08 Mar 2021 02:49:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=references:user-agent:from:to:cc:subject:in-reply-to:date
         :message-id:mime-version;
        bh=/5QP9rPfQqlXhD0IF6cUc8tn4UetbeGFHAGwYdKf9BY=;
        b=aHYxC5raLJlknMbscRBbtZ4CPbXwxjFu2mNcRJXsi+Y77xz1KblKsc0dcQrIl78tNF
         jkUl0Sro0+3rVvwrJvGb/Tjcgih9MdMMXZ+DYQfvKHpRVNYG0FuayzI55e4xSOtl3w9z
         tNbbvxxg6sVIlzPPlkeVBDke+jbtYyk9fRWP5EkXpvWp14WAgf3IbzI43i/wqcv87nHD
         ZQQ6unFgsA4lR9iz2qe02UPQog1iY/PznA+Op2IC4jSfFKKIoUJ7eCIifc2/ZrMlDbq7
         LdC+OH3xGxqQKAmC/FZ438fNbEB2ClQ6BSoiT5+XrFkB4XscY5hi6LSpLjTMJenUryGD
         g7Hw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject
         :in-reply-to:date:message-id:mime-version;
        bh=/5QP9rPfQqlXhD0IF6cUc8tn4UetbeGFHAGwYdKf9BY=;
        b=hKOzAkC84modXgvElcwEWcs3ovQbwVmmNUFqtxwzuEKk51NuHwovX8/DJMVPBLYum+
         NxIAWVufN589su0asdqg3Hy/MoEUwzAnSLc5LylP6YcPfo9ozGc2xC6xNHBWhkc+f9lD
         JV2UXgs9vGPstkQvyhaFacdkMOdzNgRSfSNcZZkus7G3UpXlQi/Eez40YEfFYkt1eB5a
         0jhSDJgJUE7P7RrnZIQX6OblRQORLBDMXXgIVWV52bMKxo+ZSiuN8u9WmhzEPahKRubR
         FWkfD+sTn1STOwGPFQsPw8EZVzrsBCBWfZaw6I8pAG1nkDyJq1xgiK3ODJULI6910NSe
         bD0A==
X-Gm-Message-State: AOAM533/OG9E30q6dAtpPTFf9SjVob3ZFyDH3dsmNwZ0D4cbQh7fkd72
        KIIXWoV1o8sP6Qx+KEAwCJcAn+y8/yiVdg==
X-Google-Smtp-Source: ABdhPJyYStU/hj7bau4G8BaTGKstXuSP2Qifp0fbkNkPk05QyUCXMbucIiZsHfzoSOxLSAkawPTayA==
X-Received: by 2002:a17:902:cb0b:b029:e5:b670:d905 with SMTP id c11-20020a170902cb0bb02900e5b670d905mr21030315ply.18.1615200587580;
        Mon, 08 Mar 2021 02:49:47 -0800 (PST)
Received: from garuda ([122.167.231.243])
        by smtp.gmail.com with ESMTPSA id d6sm10045700pjs.38.2021.03.08.02.49.46
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 08 Mar 2021 02:49:47 -0800 (PST)
References: <20210305051143.182133-1-david@fromorbit.com> <20210305051143.182133-9-david@fromorbit.com>
User-agent: mu4e 1.0; emacs 26.1
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 08/45] xfs: journal IO cache flush reductions
In-reply-to: <20210305051143.182133-9-david@fromorbit.com>
Date:   Mon, 08 Mar 2021 16:19:44 +0530
Message-ID: <87czw95393.fsf@garuda>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 05 Mar 2021 at 10:41, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
>
> Currently every journal IO is issued as REQ_PREFLUSH | REQ_FUA to
> guarantee the ordering requirements the journal has w.r.t. metadata
> writeback. THe two ordering constraints are:
>
> 1. we cannot overwrite metadata in the journal until we guarantee
> that the dirty metadata has been written back in place and is
> stable.
>
> 2. we cannot write back dirty metadata until it has been written to
> the journal and guaranteed to be stable (and hence recoverable) in
> the journal.
>
> The ordering guarantees of #1 are provided by REQ_PREFLUSH. This
> causes the journal IO to issue a cache flush and wait for it to
> complete before issuing the write IO to the journal. Hence all
> completed metadata IO is guaranteed to be stable before the journal
> overwrites the old metadata.
>
> The ordering guarantees of #2 are provided by the REQ_FUA, which
> ensures the journal writes do not complete until they are on stable
> storage. Hence by the time the last journal IO in a checkpoint
> completes, we know that the entire checkpoint is on stable storage
> and we can unpin the dirty metadata and allow it to be written back.
>
> This is the mechanism by which ordering was first implemented in XFS
> way back in 2002 by commit 95d97c36e5155075ba2eb22b17562cfcc53fcf96
> ("Add support for drive write cache flushing") in the xfs-archive
> tree.
>
> A lot has changed since then, most notably we now use delayed
> logging to checkpoint the filesystem to the journal rather than
> write each individual transaction to the journal. Cache flushes on
> journal IO are necessary when individual transactions are wholly
> contained within a single iclog. However, CIL checkpoints are single
> transactions that typically span hundreds to thousands of individual
> journal writes, and so the requirements for device cache flushing
> have changed.
>
> That is, the ordering rules I state above apply to ordering of
> atomic transactions recorded in the journal, not to the journal IO
> itself. Hence we need to ensure metadata is stable before we start
> writing a new transaction to the journal (guarantee #1), and we need
> to ensure the entire transaction is stable in the journal before we
> start metadata writeback (guarantee #2).
>
> Hence we only need a REQ_PREFLUSH on the journal IO that starts a
> new journal transaction to provide #1, and it is not on any other
> journal IO done within the context of that journal transaction.
>
> The CIL checkpoint already issues a cache flush before it starts
> writing to the log, so we no longer need the iclog IO to issue a
> REQ_REFLUSH for us. Hence if XLOG_START_TRANS is passed
> to xlog_write(), we no longer need to mark the first iclog in
> the log write with REQ_PREFLUSH for this case. As an added bonus,
> this ordering mechanism works for both internal and external logs,
> meaning we can remove the explicit data device cache flushes from
> the iclog write code when using external logs.
>
> Given the new ordering semantics of commit records for the CIL, we
> need iclogs containing commit records to issue a REQ_PREFLUSH. We
> also require unmount records to do this. Hence for both
> XLOG_COMMIT_TRANS and XLOG_UNMOUNT_TRANS xlog_write() calls we need
> to mark the first iclog being written with REQ_PREFLUSH.
>
> For both commit records and unmount records, we also want them
> immediately on stable storage, so we want to also mark the iclogs
> that contain these records to be marked REQ_FUA. That means if a
> record is split across multiple iclogs, they are all marked REQ_FUA
> and not just the last one so that when the transaction is completed
> all the parts of the record are on stable storage.
>
> And for external logs, unmount records need a pre-write data device
> cache flush similar to the CIL checkpoint cache pre-flush as the
> internal iclog write code does not do this implicitly anymore.
>
> As an optimisation, when the commit record lands in the same iclog
> as the journal transaction starts, we don't need to wait for
> anything and can simply use REQ_FUA to provide guarantee #2.  This
> means that for fsync() heavy workloads, the cache flush behaviour is
> completely unchanged and there is no degradation in performance as a
> result of optimise the multi-IO transaction case.
>
> The most notable sign that there is less IO latency on my test
> machine (nvme SSDs) is that the "noiclogs" rate has dropped
> substantially. This metric indicates that the CIL push is blocking
> in xlog_get_iclog_space() waiting for iclog IO completion to occur.
> With 8 iclogs of 256kB, the rate is appoximately 1 noiclog event to
> every 4 iclog writes. IOWs, every 4th call to xlog_get_iclog_space()
> is blocking waiting for log IO. With the changes in this patch, this
> drops to 1 noiclog event for every 100 iclog writes. Hence it is
> clear that log IO is completing much faster than it was previously,
> but it is also clear that for large iclog sizes, this isn't the
> performance limiting factor on this hardware.
>
> With smaller iclogs (32kB), however, there is a sustantial
> difference. With the cache flush modifications, the journal is now
> running at over 4000 write IOPS, and the journal throughput is
> largely identical to the 256kB iclogs and the noiclog event rate
> stays low at about 1:50 iclog writes. The existing code tops out at
> about 2500 IOPS as the number of cache flushes dominate performance
> and latency. The noiclog event rate is about 1:4, and the
> performance variance is quite large as the journal throughput can
> fall to less than half the peak sustained rate when the cache flush
> rate prevents metadata writeback from keeping up and the log runs
> out of space and throttles reservations.
>
> As a result:
>
> 	logbsize	fsmark create rate	rm -rf
> before	32kb		152851+/-5.3e+04	5m28s
> patched	32kb		221533+/-1.1e+04	5m24s
>
> before	256kb		220239+/-6.2e+03	4m58s
> patched	256kb		228286+/-9.2e+03	5m06s
>
> The rm -rf times are included because I ran them, but the
> differences are largely noise. This workload is largely metadata
> read IO latency bound and the changes to the journal cache flushing
> doesn't really make any noticable difference to behaviour apart from
> a reduction in noiclog events from background CIL pushing.
>

I see that the missing preflush w.r.t previous iclogs of a multi-iclog
checkpoint transaction has been handled in this version. Hence,

Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>

-- 
chandan
