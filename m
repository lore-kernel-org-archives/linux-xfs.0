Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A04C0C88CB2
	for <linux-xfs@archiver.kernel.org>; Mon, 12 Jun 2023 17:11:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230302AbjFLRLb convert rfc822-to-8bit (ORCPT
        <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 12 Jun 2023 13:11:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231252AbjFLRLb (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 12 Jun 2023 13:11:31 -0400
Received: from out02.mta.xmission.com (out02.mta.xmission.com [166.70.13.232])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99B06113;
        Mon, 12 Jun 2023 10:11:30 -0700 (PDT)
Received: from in02.mta.xmission.com ([166.70.13.52]:56964)
        by out02.mta.xmission.com with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <ebiederm@xmission.com>)
        id 1q8l4i-008G1Y-7Y; Mon, 12 Jun 2023 11:11:28 -0600
Received: from ip68-110-29-46.om.om.cox.net ([68.110.29.46]:35692 helo=email.froward.int.ebiederm.org.xmission.com)
        by in02.mta.xmission.com with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <ebiederm@xmission.com>)
        id 1q8l4h-00GGD8-4b; Mon, 12 Jun 2023 11:11:27 -0600
From:   "Eric W. Biederman" <ebiederm@xmission.com>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Jens Axboe <axboe@kernel.dk>,
        "Darrick J. Wong" <djwong@kernel.org>,
        Dave Chinner <david@fromorbit.com>,
        Zorro Lang <zlang@redhat.com>, linux-xfs@vger.kernel.org,
        Mike Christie <michael.christie@oracle.com>,
        "Michael S. Tsirkin" <mst@redhat.com>, linux-kernel@vger.kernel.org
References: <20230611124836.whfktwaumnefm5z5@zlang-mailbox>
        <ZIZSPyzReZkGBEFy@dread.disaster.area>
        <20230612015145.GA11441@frogsfrogsfrogs>
        <ZIaBQnCKJ6NsqGhd@dread.disaster.area>
        <CAHk-=whJqZLKPR-cpX-V4wJTXVX-_tG5Vjuj2q9knvKGCPdfkg@mail.gmail.com>
        <20230612153629.GA11427@frogsfrogsfrogs>
        <CAHk-=wiN-JcUh4uhDNmA4hp26Mg+c2DTuzgWY2fZ6hytDtOMCg@mail.gmail.com>
        <af31cadf-8c15-8d88-79fb-066dc87f0324@kernel.dk>
        <13d9e4f2-17c5-0709-0cc0-6f92bfe9f30d@kernel.dk>
        <CAHk-=wgdBfqyNHk0iNyYpEuBUdVgq1KMzHMuEqn=ADtfyK_pkQ@mail.gmail.com>
        <212a190c-f81e-2876-cf14-6d1e37d47192@kernel.dk>
        <CAHk-=wh0hrFjcU5C8uHvLBThrT5vQsFHb7Jk6HRP3LAJqdNx1A@mail.gmail.com>
Date:   Mon, 12 Jun 2023 12:11:19 -0500
In-Reply-To: <CAHk-=wh0hrFjcU5C8uHvLBThrT5vQsFHb7Jk6HRP3LAJqdNx1A@mail.gmail.com>
        (Linus Torvalds's message of "Mon, 12 Jun 2023 09:57:51 -0700")
Message-ID: <87wn08ppvs.fsf@email.froward.int.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/27.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-XM-SPF: eid=1q8l4h-00GGD8-4b;;;mid=<87wn08ppvs.fsf@email.froward.int.ebiederm.org>;;;hst=in02.mta.xmission.com;;;ip=68.110.29.46;;;frm=ebiederm@xmission.com;;;spf=pass
X-XM-AID: U2FsdGVkX19EY7Ho9kfWEUAJ7nVOKAACcXVbaQOg1IQ=
X-SA-Exim-Connect-IP: 68.110.29.46
X-SA-Exim-Mail-From: ebiederm@xmission.com
Subject: Re: [6.5-rc5 regression] core dump hangs (was Re: [Bug report]
 fstests generic/051 (on xfs) hang on latest linux v6.5-rc5+)
X-SA-Exim-Version: 4.2.1 (built Sat, 08 Feb 2020 21:53:50 +0000)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Linus Torvalds <torvalds@linux-foundation.org> writes:

> On Mon, Jun 12, 2023 at 9:45 AM Jens Axboe <axboe@kernel.dk> wrote:
>>
>> You snipped the suspicion in my reply on why that exists, to avoid
>> io_wq_worker_sleeping() triggering.
>
> I'm not seeing why triggering io_wq_worker_sleeping() should even be a
> problem in the first place.
>
> I suspect that is entirely historical too, and has to do with how it
> used to do that
>
>         struct io_worker *worker = kthread_data(tsk);
>         struct io_wqe *wqe = worker->wqe;
>
> back in the bad old days of kthreads.
>
> But yeah, I don't know that code.

If it is a problem it looks like the thread shutdown can clear
"worker->flags & IO_WORKER_F_UP" rather than
"current->flags & PF_IO_WORKER".

I don't see how it makes sense for the load balancing logic for
a per-process thread pool to be running at that point.

Eric
