Return-Path: <SRS0=cWrc=DB=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2D5DEC4363D
	for <linux-xfs@archiver.kernel.org>; Thu, 24 Sep 2020 19:54:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CE6A32220D
	for <linux-xfs@archiver.kernel.org>; Thu, 24 Sep 2020 19:54:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Ag7cmlDi"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726187AbgIXTyt (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 24 Sep 2020 15:54:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726135AbgIXTyt (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 24 Sep 2020 15:54:49 -0400
Received: from mail-oi1-x242.google.com (mail-oi1-x242.google.com [IPv6:2607:f8b0:4864:20::242])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DFD8C0613CE;
        Thu, 24 Sep 2020 12:54:49 -0700 (PDT)
Received: by mail-oi1-x242.google.com with SMTP id t76so276001oif.7;
        Thu, 24 Sep 2020 12:54:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:reply-to:from:date:message-id
         :subject:to:cc;
        bh=jldMj2b4W/i201Qch4vQ/qr+pxXhjLlwoSvPBbRwv+w=;
        b=Ag7cmlDip6MLztwNHzkjXP/MQtMVjcCMKP9L3Yr26nhJlEPCTgd7hGZl4RXvU/vboh
         KA+ogWNW8L6/7lcXC+5kj4Vp42bTIkJpKor/nRA6fRJxswS+/pOLAjvd0b5sA3DtohxM
         0MhRfTJO6ER+F+FRyCRHNapWrf+N8bmaM2yqQATru3baBBZgmMywmMI0eOtVtExtByJs
         f17pHYtYm+u2QpT2tXMm6+J9/jaPUMvHivaF1lM6gFN3+fkOorDDKXNUfzZ6dW0iy7uZ
         hw0djMDlmfuChm1TkEUGJS8ORDezBCfF6aAU9EDvhvoq7pxWQkdaL4hRRsk9Bp6hpjyv
         YL1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:reply-to
         :from:date:message-id:subject:to:cc;
        bh=jldMj2b4W/i201Qch4vQ/qr+pxXhjLlwoSvPBbRwv+w=;
        b=JXARMTr0UQhPSnKrah3QJZ5DBXlb/dGIQbL1V/2S/OLoHM9JkK0uZWJwjL/XZWtph0
         pOvGHjS4kUNmTxExZYKerr6kWPVACS9TlP4OtDRe8fGFI914szv6xqo1FzXv/4vvjqw/
         NRpiC7ndr7+VxW0vB92iHh/AElkRudkCZPdfvVtii9YFU/0AhvY4N/7w0xO8YQOtmTQR
         lDXlXztX2gxWFsS8IoDnjksZXXwCnw20LfyWW9h07rIlxdg9U+/jQxJq8SaKLlhfVGpJ
         +E8/0S0tt3qNpCYSbci9RZFG66Nc2Ppt0x4st2tA0/njGSrITS3sTezpkDFT4pXn5GJg
         jrug==
X-Gm-Message-State: AOAM533LbznLPtrMZw53bZ8WtWhOd+IBd9iDI4wwppZrgJJ9qP6Wa+AM
        dREw+HVDqKG9GWnEE0r+GAmfy2WTUNJNu82xF1c=
X-Google-Smtp-Source: ABdhPJyzB7jvMmkSgAOmdTjvZlsmOKuH5+ZJjESfv8QED1qgQLMae2leuVu0j/Dfj7LUDklmmK9Cup61HCCOCQOqht0=
X-Received: by 2002:aca:ec50:: with SMTP id k77mr270352oih.35.1600977287872;
 Thu, 24 Sep 2020 12:54:47 -0700 (PDT)
MIME-Version: 1.0
References: <20200924125608.31231-1-willy@infradead.org> <CA+icZUUQGmd3juNPv1sHTWdhzXwZzRv=p1i+Q=20z_WGcZOzbg@mail.gmail.com>
 <20200924151538.GW32101@casper.infradead.org> <CA+icZUX4bQf+pYsnOR0gHZLsX3NriL=617=RU0usDfx=idgZmA@mail.gmail.com>
 <20200924152755.GY32101@casper.infradead.org> <CA+icZUURRcCh1TYtLs=U_353bhv5_JhVFaGxVPL5Rydee0P1=Q@mail.gmail.com>
 <20200924163635.GZ32101@casper.infradead.org> <CA+icZUUgwcLP8O9oDdUMT0SzEQHjn+LkFFkPL3NsLCBhDRSyGw@mail.gmail.com>
 <f623da731d7c2e96e3a37b091d0ec99095a6386b.camel@redhat.com>
In-Reply-To: <f623da731d7c2e96e3a37b091d0ec99095a6386b.camel@redhat.com>
Reply-To: sedat.dilek@gmail.com
From:   Sedat Dilek <sedat.dilek@gmail.com>
Date:   Thu, 24 Sep 2020 21:54:36 +0200
Message-ID: <CA+icZUVO65ADxk5SZkZwV70ax5JCzPn8PPfZqScTTuvDRD1smQ@mail.gmail.com>
Subject: Re: [PATCH] iomap: Set all uptodate bits for an Uptodate page
To:     Qian Cai <cai@redhat.com>
Cc:     Matthew Wilcox <willy@infradead.org>, linux-xfs@vger.kernel.org,
        linux-fsdevel@vger.kernel.org,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Christoph Hellwig <hch@infradead.org>,
        Brian Foster <bfoster@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Sep 24, 2020 at 8:47 PM Qian Cai <cai@redhat.com> wrote:
>
> On Thu, 2020-09-24 at 20:27 +0200, Sedat Dilek wrote:
> > I run both linux-kernel on my Debian/unstable AMD64 host (means not in
> > a VM) with and without your patch.
> >
> > Instructions:
> > cd /opt/ltp
> > ./runltp -f syscalls -s preadv203
> >
> > Unfortunately, the logs in the "results" directory have only the short
> > summary.
> >
> > Testcase                                           Result     Exit Value
> > --------                                           ------     ----------
> > preadv203                                          PASS       0
> > preadv203_64                                       PASS       0
> >
> > So, I guess I am not hitting the issue?
> > Or do I miss some important kernel-config?
>
> https://gitlab.com/cailca/linux-mm/-/blob/master/arm64.config
>
> That is .config I used to reproduce. Then, I ran the linux-mm testsuite (lots of
> hard-coded places because I only need to run this on RHEL8) first:
>
> # git clone https://gitlab.com/cailca/linux-mm
> # cd linux-mm; make
> # ./random -k
>
> Then, run the whole LTP syscalls:
> # ./runltp -f syscalls
>

Doing this right now.

> If that is still not triggered, it needs some syscall fuzzing:
> # ./random -x 0-100 -f
>

Out of curiosity:
You are named in "mm: fix misplaced unlock_page in do_wp_page()".
Is this here a different issue?

- Sedat -

[1] https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=be068f29034fb00530a053d18b8cf140c32b12b3
