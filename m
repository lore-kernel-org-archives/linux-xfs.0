Return-Path: <SRS0=IJtx=XO=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AC42BC3A5A6
	for <linux-xfs@archiver.kernel.org>; Thu, 19 Sep 2019 17:05:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7D879214AF
	for <linux-xfs@archiver.kernel.org>; Thu, 19 Sep 2019 17:05:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1568912704;
	bh=l7pePM/NQUavY6rzQA3tJA6iXW69IP+oxvh/NwcCrmE=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:List-ID:From;
	b=kWySmFfgscJB6lX2ehnZjhhuRhCyLrX0AiZTNeWofgZwz331WTNzp7M6u3V0c3QRC
	 cZQ6V6IR16nqncF8copuJ7qqrBFURaGklKjs7NozPTefsls0LfIjsS1MUIsGVKmEV6
	 oI8xMYCgl5LT7cRXzckSkIgMpvFYxcqV4PxaWC/w=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732571AbfISRFE (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 19 Sep 2019 13:05:04 -0400
Received: from mail-lf1-f67.google.com ([209.85.167.67]:44242 "EHLO
        mail-lf1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731729AbfISRFD (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 19 Sep 2019 13:05:03 -0400
Received: by mail-lf1-f67.google.com with SMTP id q11so2895151lfc.11
        for <linux-xfs@vger.kernel.org>; Thu, 19 Sep 2019 10:05:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=cG/q3cFRYsyXfs7WGIDIqxPhNH59Y8kVxp4a4QrtYec=;
        b=E2cDdbP2/fhgtUxeWn9F/GPtmg03tInrSSBmBjgzSx2QzM61s/GaEXUloJz81ijobL
         PDNb7lDrr/uWOWaQGMcZ/bzgSkg2A+IktHmv0xZxrybAdkgVOGCSAErBYug47C0mIo+0
         3rMkP4xNaakXDWOWhasJcY2phrxijQ6+lzNPc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=cG/q3cFRYsyXfs7WGIDIqxPhNH59Y8kVxp4a4QrtYec=;
        b=nT//PKlNzy9D3rvB55zJ+gNBoMw6GPn1SRr+JgdVQlaw5A0ibgQuEy9wlfIjFi92EF
         ooRbrqF1++sONYgGbi94uQUtzazIfBYmFqO6Ld3sC7/IdRBhHyHHXlx/4/oU6j4gRpa7
         f/VvoaafdmMHoVLyAL/WaeEB9+EqU+lsf8lE1ol6c3bEOEcY2QJgc/mfIDAhFbDJ+p/r
         nxAaZYzBsrl02tkEYe27q8kzDUJATbVav0+ckXxnHqRwrGp9YoLC1AacnmDG2VAb5AXq
         /fTka6mZoR8qLtJwc3wvJjwKdxEdvxjpH9ZsVMADivCDXMSj/Zg73DrCjIn5yJ906M66
         kCpg==
X-Gm-Message-State: APjAAAUfNNfyJyMLvtrBowzK+rVOGI7Ru5mOBlggK5M8K0mr4oS0QtQn
        WOuavIQ8j5W2cCI3gBfWP5eDwb2NtFg=
X-Google-Smtp-Source: APXvYqxM+11rx2PsAbwJ/FgNR2RYjy77CCppQQmCkdht2iLfImMJETHRsqJAs2wDup6N7HlNv/ZL0w==
X-Received: by 2002:a05:6512:202:: with SMTP id a2mr5455862lfo.175.1568912701348;
        Thu, 19 Sep 2019 10:05:01 -0700 (PDT)
Received: from mail-lf1-f41.google.com (mail-lf1-f41.google.com. [209.85.167.41])
        by smtp.gmail.com with ESMTPSA id z19sm1786052ljj.50.2019.09.19.10.05.00
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 19 Sep 2019 10:05:00 -0700 (PDT)
Received: by mail-lf1-f41.google.com with SMTP id r2so2909177lfn.8
        for <linux-xfs@vger.kernel.org>; Thu, 19 Sep 2019 10:05:00 -0700 (PDT)
X-Received: by 2002:ac2:47f8:: with SMTP id b24mr5615990lfp.134.1568912700141;
 Thu, 19 Sep 2019 10:05:00 -0700 (PDT)
MIME-Version: 1.0
References: <20190917152140.GU2229799@magnolia> <CAHk-=wj9Zjb=NENJ6SViNiYiYi4LFX9WYqskZh4E_OzjijK1VA@mail.gmail.com>
 <20190919034502.GJ2229799@magnolia> <CAHk-=wgFRM=z6WS-QLThxL2T1AaoCQeZSoHzj8ak35uSePQVbA@mail.gmail.com>
In-Reply-To: <CAHk-=wgFRM=z6WS-QLThxL2T1AaoCQeZSoHzj8ak35uSePQVbA@mail.gmail.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Thu, 19 Sep 2019 10:04:44 -0700
X-Gmail-Original-Message-ID: <CAHk-=wjS25dNe=zj8s8w0ppGoL33JQczQWdF406ubnkJHQ9izg@mail.gmail.com>
Message-ID: <CAHk-=wjS25dNe=zj8s8w0ppGoL33JQczQWdF406ubnkJHQ9izg@mail.gmail.com>
Subject: Re: [GIT PULL] iomap: new code for 5.4
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     "Darrick J. Wong" <djwong@kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-xfs <linux-xfs@vger.kernel.org>,
        Dave Chinner <david@fromorbit.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Eric Sandeen <sandeen@sandeen.net>,
        Christoph Hellwig <hch@lst.de>,
        Andreas Gruenbacher <agruenba@redhat.com>,
        Bob Peterson <rpeterso@redhat.com>,
        cluster-devel <cluster-devel@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Sep 19, 2019 at 10:03 AM Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> So inside of xfs, that "pop ioend from the list" model really may make
> perfect sense, and you could just do
>
>     static inline struct xfs_ioend *xfs_pop_ioend(struct list_head *head)

Note that as usual, my code in emails is written in the MUA, entirely
untested, and may be completely broken.

So take it just as a "maybe something like this works for you".

             Linus
