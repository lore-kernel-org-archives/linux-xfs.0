Return-Path: <SRS0=UH25=7B=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 51BBFC433E0
	for <linux-xfs@archiver.kernel.org>; Tue, 19 May 2020 23:39:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 20DE020809
	for <linux-xfs@archiver.kernel.org>; Tue, 19 May 2020 23:39:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="bU9Yv2CO"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726352AbgESXjA (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 19 May 2020 19:39:00 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:26404 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726178AbgESXjA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 19 May 2020 19:39:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1589931538;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=F9iKDzKWbnSe8Bi/P9mqSQ631n4EAZB5dcP/kjtd70I=;
        b=bU9Yv2COKURFMssqL5JUquWeZZRqduwasGGP8M4SLDFycbWXEdAfeqpPTKot5xJcZUqkga
        0wtt/0AKHSR/+q+5VGhS5Gtox+5VKHBqadqYMtWN0+UEQDTvIfzpvJ/905USHxvuUW6TlC
        35zhdbWMgHn7SX+iz5gEu491oiEP+yg=
Received: from mail-pl1-f198.google.com (mail-pl1-f198.google.com
 [209.85.214.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-216-TQtChKmZMrmliM4gxKVKww-1; Tue, 19 May 2020 19:38:56 -0400
X-MC-Unique: TQtChKmZMrmliM4gxKVKww-1
Received: by mail-pl1-f198.google.com with SMTP id f12so1176903plt.9
        for <linux-xfs@vger.kernel.org>; Tue, 19 May 2020 16:38:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=F9iKDzKWbnSe8Bi/P9mqSQ631n4EAZB5dcP/kjtd70I=;
        b=UClHEQU3FzgjUXPyvnTsDMx2H0qZv83gFzCYx/uBCmF+KTsqnfCZJ18xExzx21EMaE
         z5vb3uNlbUfnrWr5Midmvic2TGDzgfuRrWDR8adbLZkIlyGgF8JGzR3ZMaiO0CWOvBXI
         PHsR0OdoRMzRpK5GxjNSHB7n23z9vX+Wio67LsFzb2CooBPEa1kxBPLmpsLXo8X+Cr43
         CpQ4CtqBgQ3L2eDjVn0kuakoJD+Zq6YfGxP4Uh5VaCZ7RtYx15pi2IEgpme0MePvzXjp
         f9+AqzPslLR9ez7pjeDtQ+rJUS3GRVKxKHmBCbZVrfoHnWs/chvVa909/HxxZaaAmO6Z
         dR4Q==
X-Gm-Message-State: AOAM530iXosKdNqshK2j1mrOJxBTLLjk14fZNRZz+03bu3HwoaE3/weS
        cgoX9uk1EFqoyhljppSLufKpUnpL2CAauhRf/+jtEwG20pw9kQRPTU0E9nweFO5JHYaE/Xz1N8F
        bY4mpJhwjVB1cfEpXo3yi
X-Received: by 2002:a65:4bc6:: with SMTP id p6mr1486832pgr.20.1589931535598;
        Tue, 19 May 2020 16:38:55 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwASUt9gO3IIOhCX0jUQz+0RuCZKRzxwvNN3sl5VamoHkJitW/b2/dxgzB62R8hmNf1JoSRUA==
X-Received: by 2002:a65:4bc6:: with SMTP id p6mr1486811pgr.20.1589931535236;
        Tue, 19 May 2020 16:38:55 -0700 (PDT)
Received: from don.don ([60.224.129.195])
        by smtp.gmail.com with ESMTPSA id u188sm474939pfu.33.2020.05.19.16.38.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 19 May 2020 16:38:54 -0700 (PDT)
Subject: Re: [PATCH V2] xfs_repair: fix progress reporting
To:     Eric Sandeen <sandeen@sandeen.net>,
        Eric Sandeen <sandeen@redhat.com>,
        linux-xfs <linux-xfs@vger.kernel.org>
Cc:     Leonardo Vaz <lvaz@redhat.com>,
        "Darrick J. Wong" <darrick.wong@oracle.com>
References: <c4df68a7-706b-0216-b2a0-a177789f380f@redhat.com>
 <be31d007-5104-e534-eec6-931ff5df5444@redhat.com>
 <8d81d09c-9bc7-5cf7-4114-85b1e8905940@redhat.com>
 <9b2caada-4057-b73f-ca54-87208084f266@sandeen.net>
From:   Donald Douwsma <ddouwsma@redhat.com>
Message-ID: <caab376d-22b1-39cd-0b71-8ca2d1e4dc3d@redhat.com>
Date:   Wed, 20 May 2020 09:38:50 +1000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <9b2caada-4057-b73f-ca54-87208084f266@sandeen.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 19/05/2020 22:53, Eric Sandeen wrote:
> On 5/19/20 2:03 AM, Donald Douwsma wrote:
>>
>> On 19/05/2020 11:29, Eric Sandeen wrote:
>>> The Fixes: commit tried to avoid a segfault in case the progress timer
>>> went off before the first message type had been set up, but this
>>> had the net effect of short-circuiting the pthread start routine,
>>> and so the timer didn't get set up at all and we lost all fine-grained
>>> progress reporting.
>>>
>>> The initial problem occurred when log zeroing took more time than the
>>> timer interval.
>>>
>>> So, make a new log zeroing progress item and initialize it when we first
>>> set up the timer thread, to be sure that if the timer goes off while we
>>> are still zeroing the log, it will be initialized and correct.
>>>
>>> (We can't offer fine-grained status on log zeroing, so it'll go from
>>> zero to $LOGBLOCKS with nothing in between, but it's unlikely that log
>>> zeroing will take so long that this really matters.)
>>>
>>> Reported-by: Leonardo Vaz <lvaz@redhat.com>
>>> Fixes: 7f2d6b811755 ("xfs_repair: avoid segfault if reporting progre...")
>>> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
>>> ---
>> I've been looking at this myself, got stuck writing an xfstest, which this
>> passes, though the fix I was trying missed at least one of the formatters
>> that this fixes, and the log zeroing is a nice touch.
>>
>> Reviewed-by: Donald Douwsma <ddouwsma@redhat.com>
> 
> Hm, serves you right for writing a validation test.  ;)  sorry :(
> 

My fix ended up being a bit... primitive, so all good!

> But:  "the fix I was trying missed at least one of the formatters
> that this fixes" - which one is that?  I didn't think I fixed any existing
> thing.

Actually its probably my test that's a bit busted, I wanted to catch the
all of the formatting variations, but some are time sensitive, so its hit
second vs seconds and my filter didn't cope.


Ran: xfs/516
Failures: xfs/516
Failed 1 of 1 tests

[root@rhel7 xfstests-dev]# diff -u /root/Devel/upstream/xfstests-dev/tests/xfs/516.out /root/Devel/upstream/xfstests-dev/results//xfs/516.out.bad
--- /root/Devel/upstream/xfstests-dev/tests/xfs/516.out	2020-05-19 15:49:58.736465391 +1000
+++ /root/Devel/upstream/xfstests-dev/results//xfs/516.out.bad	2020-05-19 16:30:45.257220692 +1000
@@ -2,6 +2,7 @@
 Format and populate
 Introduce a dmdelay
 Run repair
+	- #:#:#: Phase #: #% done - estimated remaining time # minutes, # second
 	- #:#:#: Phase #: #% done - estimated remaining time # minutes, # seconds
 	- #:#:#: Phase #: elapsed time # second - processed # inodes per minute
 	- #:#:#: Phase #: elapsed time # seconds - processed # inodes per minute
@@ -13,3 +14,4 @@
         - #:#:#: scanning filesystem freespace - # of # allocation groups done
         - #:#:#: setting up duplicate extent list - # of # allocation groups done
         - #:#:#: verify and correct link counts - # of # allocation groups done
+        - #:#:#: zeroing log - # of # blocks done

