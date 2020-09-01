Return-Path: <SRS0=ZxTw=CK=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1E034C433E2
	for <linux-xfs@archiver.kernel.org>; Tue,  1 Sep 2020 14:18:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E1E3E206EF
	for <linux-xfs@archiver.kernel.org>; Tue,  1 Sep 2020 14:18:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="s763gG5r"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726928AbgIAOSR (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 1 Sep 2020 10:18:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728245AbgIAOQo (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 1 Sep 2020 10:16:44 -0400
Received: from mail-il1-x143.google.com (mail-il1-x143.google.com [IPv6:2607:f8b0:4864:20::143])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1635C061245;
        Tue,  1 Sep 2020 07:05:05 -0700 (PDT)
Received: by mail-il1-x143.google.com with SMTP id w3so1261971ilh.5;
        Tue, 01 Sep 2020 07:05:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=QfanSJsnDHXMBJydOhcBySoqPAhHQDknT274Z3FU9oY=;
        b=s763gG5rUSl5/Ne7hAD9UlsMJFSpVWC70EtUTsVOJY+lWd9DcdZQGbSSOLALXL61VJ
         N2cBtp2Jpt7egCQG42hRzvZZV4e6EX/GDErjMRXfMXhGvT0AM3Pwq2T6b6+msY7JYUn6
         3jHqcAGjgE++6Dcm+Dj3Ne4UGWF6lIO7nDZbEaohtAGBzRIBGnNkkj8JFuafjCe51TBC
         +uV7yxFAMf1xuGpi+udidYHVd7/Yrsrp881T/sg6WV/Qw0HBrxi31LqN2GoME3ea+tMU
         em0vXU5ReipxFi0IbMl/DJJ0T7caFiQER92Bs/z4TPFft/BTBPXtLgdPK9YeGwIu80a1
         XnyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=QfanSJsnDHXMBJydOhcBySoqPAhHQDknT274Z3FU9oY=;
        b=R/oqau17hM/EInvbdneuFO3T38TXdvV3OMnXyPN2go1VfbUt05QzOn2SYle55wmola
         LY4EmOhZz/QvHPonJaKSu/e0OMP6Rf2h/RQ2Fng5bQRkawCGqv/e8ZiFVgrK82eBlUzW
         fUzg3zyYsVWksyeXVWF732SZOviUKpXblGRGa61Tv/mmyDFP3SfHBoIFOPskTy2WSiED
         pBw1zIk228qd8aJK0TUdQO1F2opghZ3LZYXswLpD5x8JVHdGL3LgyjQCjx69MQbAt3/1
         sAfakMbHbAu8ExAIlt6hzhS1p5uwsUUJ80+43aSeHPLrDgTaiGCLqPeTB7rlfjK8b8OZ
         6YHA==
X-Gm-Message-State: AOAM53007urUBccPynj5SjbpETeDlBOiyfgW8Em/cVYZIxUPVpBgR+wz
        cZ8PxYETdO35sJhhUdlRSUJx79/IWrYDXWjOWIM=
X-Google-Smtp-Source: ABdhPJxdPa8glBoHPUvSTojjOn7Xx4AKgY6EUMb+cwPV9k9BSCGsB1FpeCWWnH51mobvJEpdbe78enkZ4mh74VOQBw4=
X-Received: by 2002:a05:6e02:685:: with SMTP id o5mr1434383ils.72.1598969104493;
 Tue, 01 Sep 2020 07:05:04 -0700 (PDT)
MIME-Version: 1.0
References: <20200827145329.435398-1-bfoster@redhat.com> <20200829064850.GC29069@infradead.org>
 <20200831133732.GB2667@bfoster> <CAOQ4uxiqtoDTfkDvwL2Vs28reRmgLqg1ZVGoQEk=bkU1o-Mwrw@mail.gmail.com>
 <20200901123130.GA174813@bfoster>
In-Reply-To: <20200901123130.GA174813@bfoster>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Tue, 1 Sep 2020 17:04:53 +0300
Message-ID: <CAOQ4uxi=OD5Pk3c44AFhyH9fv=76U=ygj5+_rAuFgks_Eu2jtw@mail.gmail.com>
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

> I don't see much difference with zero/punch on dm-thinp. An
> fallocate(FL_PUNCH_HOLE|FL_KEEP_SIZE) doesn't work because it explicitly
> requests hardware zeroing, which I don't have.
> fallocate(FL_ZERO_RANGE|FL_KEEP_SIZE) works, but takes a minute or two
> on my 10G device because it falls back to manual zeroing. There is a
> NO_HIDE_STALE variant of PUNCH_HOLE, but I don't seem to have any
> userspace tools that define NO_HIDE_STALE and it looks like it just
> sends discards anyways. Of course, a 'blkdiscard -o 0 -l 10g <thindev>'
> unmaps nearly the entire device in ~1s, but then we're back to the
> argument of using discard for zeroing. :P
>

I don't think that is a problem if we build the test around thinp and its
well defined behavior on discard. This is what I was getting at:
1. Move dm-thinp setup inside the dm-logwrite helpers, so dm-logwrites
    tests cannot be written without dm-thinp by mistake.
2. Use explicit discard in start of replay helper to zap everything before
    replay

I'll add to my TODO list.

Thanks,
Amir.
