Return-Path: <SRS0=6Z+e=CI=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 233ADC433E2
	for <linux-xfs@archiver.kernel.org>; Sun, 30 Aug 2020 13:31:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DFCB82078D
	for <linux-xfs@archiver.kernel.org>; Sun, 30 Aug 2020 13:31:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="OC+Nc2ub"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728609AbgH3NbT (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 30 Aug 2020 09:31:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728780AbgH3Nag (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 30 Aug 2020 09:30:36 -0400
Received: from mail-io1-xd44.google.com (mail-io1-xd44.google.com [IPv6:2607:f8b0:4864:20::d44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9FFFDC061573;
        Sun, 30 Aug 2020 06:30:35 -0700 (PDT)
Received: by mail-io1-xd44.google.com with SMTP id g128so3406535iof.11;
        Sun, 30 Aug 2020 06:30:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=EVyvtFVtqUEjubDTj46AnJ/udn3jbNd5SDkjfeFdLNo=;
        b=OC+Nc2ubfIoreWhOwa3idZwr/JeaqFyIFU7obd9UZax3+fDbd8NdqocASnWhQnT7ie
         OZpXIC8W+vvaylc9xdckpnmBoEl0+gWSTpgDOPCtts8UE8znFoAE5nqdNc3zM7DxrqF5
         jdDzZg9fgeRm03Feb6XlYZgg0dZJJuMlj6k1QO1IHBKY6nyEJlYQrRHdiyT2OYOE+my6
         YlT2GBl4jcZF8ejKdDL6Y/Q6VBh+HW3QBalc7YVMoNjbYkhE6azVR/wQi3Xe3/3inCLI
         sEZp1jF4yphCJenhnsO1c33Xu2ttsPtgqueRoySKLmOSxFc8SdXKHnRJ2bta9ZoTlL+g
         fcOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=EVyvtFVtqUEjubDTj46AnJ/udn3jbNd5SDkjfeFdLNo=;
        b=tDSqscuojE8tQtojXleFbZ0BUxYjx1PVSUG8IxNDSAwHRzzq9RhlJJhYlUAnuuKdxG
         N4BHn7n31BUK4E0EuJ56jq7JkHYbt0PcXkrITyEnox6vc1E5JIropQPjS0ob3VSKzBwu
         dasoP5xlwZKSOS/w2mi2lspYuCokJgRwTpDHyr0aeDVQeM+GCOfYYeb6agQIm7v2Qyw7
         PvCcwFvWhLmvDJyIodeHSM/jprRRLEnbs00VSbyQTXWGNTs+eyAdHjlV5Bs2GUMb5Vbk
         MLquMgYAFbI+DH8jBeWHQS+GuQ00pGMil+eP6pTJcQmXKoXBVnEEvKvNJjJmuZ6VL49O
         4Krg==
X-Gm-Message-State: AOAM531riYNcV+44Q78zLTIVV3gBtKFM1LkXxz/5klpBWxxc9MD03ZZ6
        mHV33xE5GuwZc0xZ9VlqpbQHa7nMy00HgxvIsaU=
X-Google-Smtp-Source: ABdhPJy+EuliOJKW4j8ef76Jn/hQWq/t2TiNEckAHkXCAFB2uLc0ew9cAEXThl+znZ6aSyr3dn1o8Q4YUrENpfebmI4=
X-Received: by 2002:a6b:ec17:: with SMTP id c23mr5486508ioh.186.1598794234831;
 Sun, 30 Aug 2020 06:30:34 -0700 (PDT)
MIME-Version: 1.0
References: <20200826143815.360002-1-bfoster@redhat.com> <20200826143815.360002-2-bfoster@redhat.com>
 <CAOQ4uxjYf2Hb4+Zid7KeWUcu3sOgqR30de_0KwwjVbwNw1HfJg@mail.gmail.com>
 <20200827070237.GA22194@infradead.org> <CAOQ4uxhhN6Gj9AZBvEHUDLjTRKWi7=rOhitmbDLWFA=dCZQxXw@mail.gmail.com>
 <20200827073700.GA30374@infradead.org> <c59a4ed6-2698-ab61-6a73-143e273d9e22@toxicpanda.com>
 <20200827170242.GA16905@infradead.org> <20200827183507.GB434083@bfoster> <20200829064659.GB29069@infradead.org>
In-Reply-To: <20200829064659.GB29069@infradead.org>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Sun, 30 Aug 2020 16:30:23 +0300
Message-ID: <CAOQ4uxiKsFKZkLaDLgfc7NEdHnMmuKW1zNLdzVaWP-1gw0kK+w@mail.gmail.com>
Subject: Re: [PATCH 1/4] generic: require discard zero behavior for
 dmlogwrites on XFS
To:     Christoph Hellwig <hch@infradead.org>
Cc:     Brian Foster <bfoster@redhat.com>,
        Josef Bacik <josef@toxicpanda.com>,
        fstests <fstests@vger.kernel.org>,
        linux-xfs <linux-xfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sat, Aug 29, 2020 at 9:47 AM Christoph Hellwig <hch@infradead.org> wrote:
>
> On Thu, Aug 27, 2020 at 02:35:07PM -0400, Brian Foster wrote:
> > OTOH, perhaps the thinp behavior could be internal, but conditional
> > based on XFS. It's not really clear to me if this problem is more of an
> > XFS phenomenon or just that XFS happens to have some unique recovery
> > checking logic that explicitly detects it. It seems more like the
> > latter, but I don't know enough about ext4 or btrfs to say..
>
> The way I understand the tests (and Josefs mail seems to confirm that)
> is that it uses discards to ensure data disappears.  Unfortunately
> that's only how discard sometimes work, but not all the time.
>

I think we are confusing two slightly different uses of discard in those tests.
One use case is that dm-logwrites records discards in test workloads and then
needs to replay them to simulate the sequence of IO event up to a crash point.

I think that use case is less interesting, because as Christoph points out,
discard is not reliable, so I think we should get rid of " -o discard"
in the tests -
it did not catch any issues that I know of.

But there is another discard in those tests issued by _log_writes_mkfs
(at least it does for xfs and ext4). This discard has the by product of
making sure that replay from the start to point in time, first wipes all
stale data from the replay block device.

Of course the problems we encounter is that it does not wipe all stale
data when not running on dm-thinp, which is why I suggested to always
use dm-thinp for replay device, but I can live perfectly well with Brian's
v1 patches where both workload and replay are done on dm-thinp.

Josef had two variants for those tests, one doing "replay from start"
for every checkpoint and utilizing this discard-as-wipe behavior
and one flavor that used dm-thinp to take snapshots and replay
from snapshot T to the next mark.

I remember someone tried converting some of the tests to the snapshot
flavor, but it turned out to be slower, so we left it as is (always replay from
the start).

In conclusion, I *think* the correct fix for the failing tests is:
1. Use dm-thinp for all those tests (as v1 does)
2. In _log_writes_replay_log{,_range}() start by explicitly
    wiping dm-thinp, either with with hole punch command or by
    re-creating the new thinp volume, whichever is faster.
    instead of relying on the replay of discard operation recorded
    from mkfs that sort of kind of worked by mistake.

Thanks,
Amir.
