Return-Path: <SRS0=ZxTw=CK=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 49221C433E6
	for <linux-xfs@archiver.kernel.org>; Tue,  1 Sep 2020 06:25:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 296B82151B
	for <linux-xfs@archiver.kernel.org>; Tue,  1 Sep 2020 06:25:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Nl6hQBPn"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726112AbgIAGZ4 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 1 Sep 2020 02:25:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726044AbgIAGZz (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 1 Sep 2020 02:25:55 -0400
Received: from mail-il1-x143.google.com (mail-il1-x143.google.com [IPv6:2607:f8b0:4864:20::143])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD001C0612AC;
        Mon, 31 Aug 2020 23:25:54 -0700 (PDT)
Received: by mail-il1-x143.google.com with SMTP id c6so205086ilo.13;
        Mon, 31 Aug 2020 23:25:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Klflu2bxGRpJUpFIoMBIbijhGz+J1OPdyIgpCb+K+zM=;
        b=Nl6hQBPnXCrrk/ISVnziczKSlsw+sVHVnh+1o/IQqfmFpAnwVL73/02Qv1cbK9vJkq
         gS/DjdhV69UcWUIfAOD4jmRmyI038O9b0Gh1MFOOgcA7ZdsGwM71nfXD1yEWx9DHIoH3
         PVR1U0a+DyeY8uyX08DuyI9hEzull0IVmQMTcgbGteMm8nsvvqVtnf96al5d+QNobInp
         PzhnbBdRarsu0TgLpWMvfzuCM9fEtzhtbVgDwdA6gztLUmol9/LovAIyg7ESzBsZwvNk
         RDogfPhM0n2CFwD0DPeYCLdT9EYQEwNzJYBZv3YKgpM8ph6NDSic6+kP7rBZtQ5jtONG
         CY2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Klflu2bxGRpJUpFIoMBIbijhGz+J1OPdyIgpCb+K+zM=;
        b=T74YiydMsbO4WtIDIF3Bfp1OEEyyacKIFmnXXI5JDQA5jIEoTS7/uy4pLw4yicIo2J
         k9Vh14Ys6ldmfUs3ldF+QEzIgM65+KN0HbvhXwWZxR68p5/QsQqzQOe47bnDzj4iSce0
         nTnVvuTsRjJVqjkBQyzWwKFu+Da6TU7OFtjummmEDXlmScFwdhbxgwwPJniwaEl5p000
         57j07SNkj7H0yuF0kxqsjnEoLkWOFvZGQz9SFE6216BPimMLhMviQFt0IVS7dqK26KZB
         fmo9gucy4EfTzSyeTMNgwpn/F0WjTXvnfTZD65HtPp1lEPBGBHrscxia9vko0HH/O7uI
         rqJQ==
X-Gm-Message-State: AOAM5335sB2FkYCfo6s//N0s1eXwOhrW7VpE82mgWgv3ZPzE83rYZS82
        yWzRcgsimX4rKHprYyG+ceDRcnOyNMa5loITxwJCbNZlR2A=
X-Google-Smtp-Source: ABdhPJwl/YvK1khmnGP42SW7xzcprBWFyba5uHV50S56yLQD63YYfOLLTxV8v1yMOrEvN6R73d4phkJcPbXpFkfSDrA=
X-Received: by 2002:a92:2810:: with SMTP id l16mr86727ilf.9.1598941553532;
 Mon, 31 Aug 2020 23:25:53 -0700 (PDT)
MIME-Version: 1.0
References: <20200827145329.435398-1-bfoster@redhat.com> <20200829064850.GC29069@infradead.org>
 <20200831133732.GB2667@bfoster>
In-Reply-To: <20200831133732.GB2667@bfoster>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Tue, 1 Sep 2020 09:25:42 +0300
Message-ID: <CAOQ4uxiqtoDTfkDvwL2Vs28reRmgLqg1ZVGoQEk=bkU1o-Mwrw@mail.gmail.com>
Subject: Re: [PATCH v2] generic: disable dmlogwrites tests on XFS
To:     Brian Foster <bfoster@redhat.com>
Cc:     Christoph Hellwig <hch@infradead.org>,
        fstests <fstests@vger.kernel.org>,
        linux-xfs <linux-xfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Aug 31, 2020 at 4:37 PM Brian Foster <bfoster@redhat.com> wrote:
>
> On Sat, Aug 29, 2020 at 07:48:50AM +0100, Christoph Hellwig wrote:
> > On Thu, Aug 27, 2020 at 10:53:29AM -0400, Brian Foster wrote:
> > > Several generic fstests use dm-log-writes to test the filesystem for
> > > consistency at various crash recovery points. dm-log-writes and the
> > > associated replay mechanism rely on discard to clear stale blocks
> > > when moving to various points in time of the fs. If the storage
> > > doesn't provide discard zeroing or the discard requests exceed the
> > > hardcoded maximum (128MB) of the fallback solution to physically
> > > write zeroes, stale blocks are left around in the target fs. This
> > > causes issues on XFS if recovery observes metadata from a future
> > > version of an fs that has been replayed to an older point in time.
> > > This corrupts the filesystem and leads to spurious test failures
> > > that are nontrivial to diagnose.
> > >
> > > Disable the generic dmlogwrites tests on XFS for the time being.
> > > This is intended to be a temporary change until a solution is found
> > > that allows these tests to predictably clear stale data while still
> > > allowing them to run in a reasonable amount of time.
> >
> > As said in the other discussion I don't think this is correct.  The
> > intent of the tests is to ensure the data can't be read.  You just
> > happen to trigger over that with XFS, but it also means that tests
> > don't work correctly on other file systems in that configuration.
> >
>
> Yes, but the goal of this patch is not to completely fix the dmlogwrites
> infrastructure and set of tests. The goal is to disable a subset of
> tests that are known to produce spurious corruptions on XFS until that
> issue can be addressed, so it doesn't result in continued bug reports in
> the meantime. I don't run these tests routinely on other fs', so it's
> not really my place to decide that the tradeoff between this problem and
> the ability of the test to reproduce legitimate bugs justifies disabling
> the test on those configs.
>

Brian,

Let's not take this course please.
Please post patches v1 2/4-4/4 without patch v1 1/4
The only objection was to patch 1/4 and it is not strictly needed
to solve the problem you care about.

I had a *concern* about pacthes 2-4, but I can live with that
concern and it is certainly preferred to disabling the tests.

I can follow up with fixing the dmlogwrites common helpers
later when I get the time, so they do not rely on discard for
correctness of replay.

As I wrote, all it takes is to issue an explicit zero/punch command
in the beginning of replay halpers. Just need to find the command
that works correctly and most efficiently with thinp.

If you have the time to do that (since I believe you already tested
some commands) that would be great. Otherwise, I'll do that later.

Thanks,
Amir.
