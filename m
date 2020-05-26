Return-Path: <SRS0=dAFJ=7I=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7ABE5C433E0
	for <linux-xfs@archiver.kernel.org>; Tue, 26 May 2020 09:21:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4DC38207ED
	for <linux-xfs@archiver.kernel.org>; Tue, 26 May 2020 09:21:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ggl6IbwM"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731643AbgEZJVM (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 26 May 2020 05:21:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728837AbgEZJVM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 26 May 2020 05:21:12 -0400
Received: from mail-io1-xd41.google.com (mail-io1-xd41.google.com [IPv6:2607:f8b0:4864:20::d41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BF30C03E97E
        for <linux-xfs@vger.kernel.org>; Tue, 26 May 2020 02:21:11 -0700 (PDT)
Received: by mail-io1-xd41.google.com with SMTP id o5so21153547iow.8
        for <linux-xfs@vger.kernel.org>; Tue, 26 May 2020 02:21:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=2sgSrXdI341CB1ZKkBLGOWJSDm+jrqpmxGPseKGI+iU=;
        b=ggl6IbwMVNtzqYLPr9Ack9YbMCB46cL2RxKUb1ONlVdGrXBgSlViQ+2LlHWzcM5dUQ
         9/nDH5+lwiMC2oy7cHhlCZdmHqXXtKS7xht8rGhw2oScrt7lMF1GYztAUq1W1SOYvCz+
         +Giy+8rzj1YgqY9dKAn1j9xWuSwoXpymqHgQlsTfkRf6GiZCISkaqmuGcbKRaKKtaQDI
         L1EL1CGooHfQjHSQbYnIhJI7xzDjpnZP7TKhdnShw8Q5VqUU/NheiynAfwBOnEx18ZVN
         /BdjwjCB07Ge9QE9GI0QcpPR16CrAVdCqSJZpSuGdizIEWrVMeQ+3vIVgyIR427qloOa
         3DdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=2sgSrXdI341CB1ZKkBLGOWJSDm+jrqpmxGPseKGI+iU=;
        b=swpizyrdCHdiEp6ptrIVIRe/oqeG4E7LEMJCQ4Yb01Izk3caSEF9q/Y1tS/OSd4Jvp
         AmZKmtyHDLK0MQzNcEnrGITXCWKGGf7kcq2C1RjTYX0PaawIyMdlOvEAkxYfjsuu9S4A
         1/WCUPpmI6fDVbpDUS9c1DuJ1n/Sqx3x/PdESPrppafwn9X1a9lMibNU1Lv6VtDZLOJz
         0ew9oHNujkuJ2yKXpFiglp3AMdscqMS3DyQPzG5JlsAbeuIL3AWRVwpJlUHBeToL0vg/
         RK51qHiYx3mkvtVX/k8wDnVZZ539nlhWas8opJWVPtyWQhghwnnBCQHmUscL5b16OP7p
         E5og==
X-Gm-Message-State: AOAM530eUHmcr1M86Tao1Mm4e255ePrzlzSg/0kviKkKUaT9XciYdSHc
        q7jt2V85I6fEq59VmdJrFMPpA7FZKQN4EWv9xDw=
X-Google-Smtp-Source: ABdhPJxYuSMsKdE1P1xQzZ0ujoO3b78LO1sDtWGIAuWiEkcmSHePxC3DlNs6XGHPjpShGq7CCg2DwJOAASI/6S1X+jo=
X-Received: by 2002:a5d:8c95:: with SMTP id g21mr16087777ion.72.1590484870548;
 Tue, 26 May 2020 02:21:10 -0700 (PDT)
MIME-Version: 1.0
References: <157784106066.1364230.569420432829402226.stgit@magnolia>
In-Reply-To: <157784106066.1364230.569420432829402226.stgit@magnolia>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Tue, 26 May 2020 12:20:59 +0300
Message-ID: <CAOQ4uxjhrW3EkzNm8y7TmCTWQS82VreAVy608X7naaLPfWSFeA@mail.gmail.com>
Subject: Re: [PATCH 00/14] xfs: widen timestamps to deal with y2038
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs <linux-xfs@vger.kernel.org>,
        Eric Sandeen <sandeen@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jan 1, 2020 at 3:11 AM Darrick J. Wong <darrick.wong@oracle.com> wrote:
>
> Hi all,
>
> This series performs some refactoring of our timestamp and inode
> encoding functions, then retrofits the timestamp union to handle
> timestamps as a 64-bit nanosecond counter.  Next, it refactors the quota
> grace period expiration timer code a bit before implementing bit
> shifting to widen the effective counter size to 34 bits.  This enables
> correct time handling on XFS through the year 2486.
>

I intend to start review of this series.
I intend to focus on correctness of conversions and on backward
forward compatibility.

I saw Eric's comments on quota patches and that you mentioned
you addressed some of them. I do not intend to review correctness
of existing quota code anyway ;-)

I see that you updated the branch 3 days ago and that patch 2/14
was dropped. I assume the rest of the series is mostly unchanged,
but I can verify that before reviewing each patch.

As far as you are concerned, should I wait for v2 or can I continue
to review this series?

Thanks,
Amir.



> If you're going to start using this mess, you probably ought to just
> pull from my git trees, which are linked below.
>
> This is an extraordinary way to destroy everything.  Enjoy!
> Comments and questions are, as always, welcome.
>
> --D
>
> kernel git tree:
> https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=bigtime
>
> xfsprogs git tree:
> https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=bigtime
>
> fstests git tree:
> https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=bigtime
