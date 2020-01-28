Return-Path: <SRS0=UJS8=3R=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B96E8C33CB1
	for <linux-xfs@archiver.kernel.org>; Tue, 28 Jan 2020 01:28:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8DB092467C
	for <linux-xfs@archiver.kernel.org>; Tue, 28 Jan 2020 01:28:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1580174926;
	bh=Zds4NOwLTCDcIdvIHPsXpWqNcvbYqSU61DLA9ocvOpA=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:List-ID:From;
	b=XAlZTfKPYef9Ff2AtNGq0VzaaqiqRT6CJ3zinl2mTbeOUxfVZjVUUFjqtoVh/+/FR
	 0OWVluja+oKdMvET3ItwjlwGWLMlKWMC6DSBAdUQSkNzhN0tDd0bCxh1TmhW4CyKlo
	 kwSE9W3T09TFVGVV1IWg400xlMTTjGGzuHdIFYm4=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726173AbgA1B2q (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 27 Jan 2020 20:28:46 -0500
Received: from mail-lj1-f194.google.com ([209.85.208.194]:43778 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726703AbgA1B2p (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 27 Jan 2020 20:28:45 -0500
Received: by mail-lj1-f194.google.com with SMTP id a13so12936683ljm.10
        for <linux-xfs@vger.kernel.org>; Mon, 27 Jan 2020 17:28:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=vyg3NKEp2bxr484Sg68cndy6raZFMZTA4yF4ZhQs6xQ=;
        b=ZwZCZIO0IYyYHGyUd4fQxgAHJdpemFwJyBRh1bLDPf/Bg4kuctvr+23k1ufcDXh+rO
         YhacjuLMqf6owAn9magtEfwyFneJosD23UCjAsMEY8OCj2mNNtkv03tLOEY6YV9uAz0P
         Mof+NMLsFwiPZXulWXN6n9oGlUwtjLuKeL85U=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=vyg3NKEp2bxr484Sg68cndy6raZFMZTA4yF4ZhQs6xQ=;
        b=g3Yg5W4Dc3hIXvmOkT8itwR1i8ALecJIGeS4LR20RhnW3vJlYgkvg1ciTcf8dwrDqu
         L9GhLIqyjFvHVPmpgpcYjOk1Sysqm+6cS8XL9EkmSiyVxhajzIej2iwE4Taz1VzIk4ji
         0N+bQep+FMqRlecNVG0rvzbGVBY9mQa3LE9wvr4Pw86J09vsKBJfLoF1KgQ6YywaoFz4
         W0H76Yf/6RdUSMjdBBlBpjwvbxX23kkp81WrB/gdunicfKDEH3UaFPJll0W4ajIasXji
         J0Uc2uSmlOw2Pg/oZsenulmclBT4VHO+bEc+PcKlTWt8Xr3Z+geTZT03B6ITnBs/WSEq
         YwCw==
X-Gm-Message-State: APjAAAW3kCqo92qgN7PbGnZsSPDgaDtUY1Bv1lN+7M774BGhSMsocFit
        f4xQ2VdbVnnXjY27hEIRxhn+O5+HYXs=
X-Google-Smtp-Source: APXvYqzi6OwZz/2gsEfuPjOWHFS7a1np+N72mJpkhc3s8zBqaOY2Wb+QpjnRsu0vKYT1t2IOUVM7qA==
X-Received: by 2002:a2e:99ca:: with SMTP id l10mr12119613ljj.276.1580174921384;
        Mon, 27 Jan 2020 17:28:41 -0800 (PST)
Received: from mail-lf1-f41.google.com (mail-lf1-f41.google.com. [209.85.167.41])
        by smtp.gmail.com with ESMTPSA id w16sm8976570lfc.1.2020.01.27.17.28.40
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 27 Jan 2020 17:28:40 -0800 (PST)
Received: by mail-lf1-f41.google.com with SMTP id r14so7799929lfm.5
        for <linux-xfs@vger.kernel.org>; Mon, 27 Jan 2020 17:28:40 -0800 (PST)
X-Received: by 2002:a19:f514:: with SMTP id j20mr825368lfb.31.1580174919818;
 Mon, 27 Jan 2020 17:28:39 -0800 (PST)
MIME-Version: 1.0
References: <3021e46f-d30b-f6c5-b1fc-81206a7d034b@web.de> <BYAPR04MB5816FB9844937D8A86B52F8DE70A0@BYAPR04MB5816.namprd04.prod.outlook.com>
In-Reply-To: <BYAPR04MB5816FB9844937D8A86B52F8DE70A0@BYAPR04MB5816.namprd04.prod.outlook.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Mon, 27 Jan 2020 17:28:23 -0800
X-Gmail-Original-Message-ID: <CAHk-=whHZzyaRKu5WXTE7_mPaQPf-E-r=cZ+8YGVK5RPbzjt1g@mail.gmail.com>
Message-ID: <CAHk-=whHZzyaRKu5WXTE7_mPaQPf-E-r=cZ+8YGVK5RPbzjt1g@mail.gmail.com>
Subject: Re: [PATCH v9 1/2] fs: New zonefs file system
To:     Damien Le Moal <Damien.LeMoal@wdc.com>
Cc:     Markus Elfring <Markus.Elfring@web.de>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Darrick J . Wong" <darrick.wong@oracle.com>,
        Hannes Reinecke <hare@suse.de>,
        Johannes Thumshirn <jth@kernel.org>,
        Naohiro Aota <Naohiro.Aota@wdc.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Jan 27, 2020 at 5:26 PM Damien Le Moal <Damien.LeMoal@wdc.com> wrote:
>
> Yes, good catch. Furthermore, since this array is used only in
> zonefs_create_zgroup(), I moved its declaration on-stack in that function.

What?

Making it _local_ to that function makes sense, but not on stack.
Please keep it "static const char *[]" so that it isn't copied onto
the stack.

               Linus
