Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B2487C88CB2
	for <linux-xfs@archiver.kernel.org>; Mon, 12 Jun 2023 16:45:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230408AbjFLQpJ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 12 Jun 2023 12:45:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229576AbjFLQpI (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 12 Jun 2023 12:45:08 -0400
Received: from mail-io1-xd33.google.com (mail-io1-xd33.google.com [IPv6:2607:f8b0:4864:20::d33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F425E63
        for <linux-xfs@vger.kernel.org>; Mon, 12 Jun 2023 09:45:07 -0700 (PDT)
Received: by mail-io1-xd33.google.com with SMTP id ca18e2360f4ac-7748ca56133so38517739f.0
        for <linux-xfs@vger.kernel.org>; Mon, 12 Jun 2023 09:45:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20221208.gappssmtp.com; s=20221208; t=1686588306; x=1689180306;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=1dwr8T1zkMzPdbUd2/C0KhHZJoiNvIRLyDbwZLM1weg=;
        b=ixfU/+ld6JbLaxzASoLYN+vemV1T75PcyCMZA9mtOdzOlRIXtUk9iXaqOkXeYsiTEP
         pJIW3QncVsHzGK3Gwq35rm8KCiQEQ3cbwV+EFhXZTH346ISnVWYyxUjDfZUD5G7dA3ne
         /VIsQYPYvwcO9InKvG/zmZS65GHL7nIajl7sCEhqWecYXTdNDRcz1ulub+UvX9bqqz88
         8mWNZvC1Za/lvUqqeL7WNr5fWX9rlcN7N8TwmYAOqoy5u9RxiR42FHjN8GTWijpV+VOY
         OVGhnwkTzJvyOZuPgjAVQouNCYhQgbDL+tT47Rzuxg7fwi7gEuoRdZu8kbB57zpCFv0D
         QzjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686588306; x=1689180306;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=1dwr8T1zkMzPdbUd2/C0KhHZJoiNvIRLyDbwZLM1weg=;
        b=l00yOJ4saAR1I4EMAremGiQR4d6J3RGc9NhvOUgF82fYGVpMaNdnjBxTok/2tCY1Ab
         OJzJmOoi4jKbY3yi0gWVY6ywG0YDi0azuI3fOB5ihpKkhGHBpkVy/ObTWhpAam9RQMPi
         Au594Ord4D8sNK1C2ae/goQ0whM9SymAFB4kmk45KwT5iQV1UO/xeDR/pzHi0gLWQxBG
         N5fCT3wVwfPAV3NpBAgortIWq//+u9ccC8H+fWMCCH29hPlzzIClfYVGRy990R/Co7jV
         NKsMabsYSPJsf+FVdiXtCEpiNOM9F15kJon+ViJlGkWlEhTso/WL6OSno3iy8REdJqd2
         05SA==
X-Gm-Message-State: AC+VfDx3bhkY+1N9CqzzpT7y9IeCdfvsfelf9WU+xP4A2mNPUVQNMFcq
        85VmsYcP/igemP9CH7lUXtQZWA==
X-Google-Smtp-Source: ACHHUZ4MFEV97yKO9ZXG1inL46usfPlNG2FWIs0Wnbs4QZrmsGOvLnhRlzx7JrGRs82qQSyNrB6pMw==
X-Received: by 2002:a6b:690a:0:b0:77a:ee79:652 with SMTP id e10-20020a6b690a000000b0077aee790652mr4620075ioc.1.1686588306591;
        Mon, 12 Jun 2023 09:45:06 -0700 (PDT)
Received: from [192.168.1.94] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id e10-20020a02a78a000000b0041a8df29ad7sm2783897jaj.38.2023.06.12.09.45.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 12 Jun 2023 09:45:06 -0700 (PDT)
Message-ID: <212a190c-f81e-2876-cf14-6d1e37d47192@kernel.dk>
Date:   Mon, 12 Jun 2023 10:45:05 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [6.5-rc5 regression] core dump hangs (was Re: [Bug report]
 fstests generic/051 (on xfs) hang on latest linux v6.5-rc5+)
Content-Language: en-US
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     "Darrick J. Wong" <djwong@kernel.org>,
        Dave Chinner <david@fromorbit.com>,
        Zorro Lang <zlang@redhat.com>, linux-xfs@vger.kernel.org,
        "Eric W. Biederman" <ebiederm@xmission.com>,
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
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <CAHk-=wgdBfqyNHk0iNyYpEuBUdVgq1KMzHMuEqn=ADtfyK_pkQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 6/12/23 10:42?AM, Linus Torvalds wrote:
> On Mon, Jun 12, 2023 at 9:38?AM Jens Axboe <axboe@kernel.dk> wrote:
>>
>> Quick peek would suggest that it's because io-wq clears PF_IO_WORKER on
>> exit, and now we fail the check in coredump_task_exit() that was added.
> 
> Oh, that makes sense.
> 
> Well, it makes sense for the bug, but that whole
> 
>         preempt_disable();
>         current->flags &= ~PF_IO_WORKER;
>         preempt_enable();
> 
> thin in io_worker_exit() does *not* make sense to me.
> 
> Does removing those three lines make things "JustWork(tm)"?

You snipped the suspicion in my reply on why that exists, to avoid
io_wq_worker_sleeping() triggering. But arguably this should be covered
by the RUNNING flag. I'll poke at it shortly, and yeah then we should
just remove the PF_IO_WORKER clearing.

Or maybe I'm just smoking crack and it's no longer needed at all. Will
test and send a patch.

-- 
Jens Axboe

