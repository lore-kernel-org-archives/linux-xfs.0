Return-Path: <SRS0=AwRW=WL=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CC9BBC3A589
	for <linux-xfs@archiver.kernel.org>; Thu, 15 Aug 2019 19:38:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9292C2083B
	for <linux-xfs@archiver.kernel.org>; Thu, 15 Aug 2019 19:38:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1565897933;
	bh=4uF+kURMpdTjzfmoBftVlEOvN+YmflMyHPYEJTQuKv0=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:List-ID:From;
	b=l97woaXeR0opPVfD2NfiqJORdkxcyZpyRwv3dnSW0DxNNF8TITp1sAbVm8dc+8Mmv
	 BMU4KHAXE9jU/ARIfRQ6pWCrOeiqSB+HfGEj2qhShWjzrPGwt3j77o33IV3ks6+2Q7
	 v6jTrjN+gjB0EhJr2pk29pWzkYA+QVUrLlwS1qrw=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732716AbfHOTix (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 15 Aug 2019 15:38:53 -0400
Received: from mail-lf1-f66.google.com ([209.85.167.66]:39227 "EHLO
        mail-lf1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731916AbfHOTix (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 15 Aug 2019 15:38:53 -0400
Received: by mail-lf1-f66.google.com with SMTP id x3so2428731lfn.6
        for <linux-xfs@vger.kernel.org>; Thu, 15 Aug 2019 12:38:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=yMwOuV3nMz/hoRB1Cse/AbiFhP4WrksE1suSS0/V1zE=;
        b=YmGIhLIQHRX1aKG0aqinsyf8Q6Cz8DldpQwWcGk+3w0bstMiMpVU5jvU0qMkhk9iqJ
         i+43l3YXMdK3T4S3opKhlYw/6UZSza9gRXU3Bz9lQXs+DX3uDP32Tlqgca7j09ZmGM/+
         DdfOz+AukMq5QpjiXFdsZmJDBjz4N4+21ioXQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=yMwOuV3nMz/hoRB1Cse/AbiFhP4WrksE1suSS0/V1zE=;
        b=IRthgFhFTMi4nakioyXYCS2Z1U67uDuoU0HYZZZ+YO4Ynwt/1+RWYu47P2FLfE6N2l
         dEspUdEPxKqmC5pmJSbQu7iqHn83sIiY9vEnOPqbPBt5/OuPYFugTvSRaOSa30noTgle
         /HRC0v1d5wCgGGmx+AoZrExYZN1ttZTXwrdZXH3nqAoJd56y6ON2CCyWtBvc2u4MjduO
         r/R8aOTKlC+jzll+ad5t4/7T5YmY7YJ05VAx8oeL3elGF5wKUEn3P8EEb/h6bD5OU7Jq
         +CmaCTRHYXGbi6GJHTxzsUKscbZFI9CC5v7TL6R3SbAHQUypem2oy7ksXtqmB7UZa6GZ
         huVQ==
X-Gm-Message-State: APjAAAWCYVoxwURcb+zsyOHGyOnwwqAtEAXd0ACeSG4lc04P3G+A9+i9
        nnIiYKnJzOpJ9EmYnPuHGMv+3wMYfSM=
X-Google-Smtp-Source: APXvYqxh9WZScagyTTNfSL3aEfmg2ej8LtFYj6OQJSM8VvFjiUfZJ32lZMZGyK+Ob/ZM6miDTOes1g==
X-Received: by 2002:a19:f11a:: with SMTP id p26mr3171432lfh.160.1565897930723;
        Thu, 15 Aug 2019 12:38:50 -0700 (PDT)
Received: from mail-lf1-f53.google.com (mail-lf1-f53.google.com. [209.85.167.53])
        by smtp.gmail.com with ESMTPSA id w13sm592030lfe.8.2019.08.15.12.38.49
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 15 Aug 2019 12:38:49 -0700 (PDT)
Received: by mail-lf1-f53.google.com with SMTP id b17so2415207lff.7
        for <linux-xfs@vger.kernel.org>; Thu, 15 Aug 2019 12:38:49 -0700 (PDT)
X-Received: by 2002:a19:c20b:: with SMTP id l11mr3214120lfc.106.1565897929268;
 Thu, 15 Aug 2019 12:38:49 -0700 (PDT)
MIME-Version: 1.0
References: <20190815171347.GD15186@magnolia>
In-Reply-To: <20190815171347.GD15186@magnolia>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Thu, 15 Aug 2019 12:38:33 -0700
X-Gmail-Original-Message-ID: <CAHk-=wiHuHLK49LKQhtERXaq0OYUnug4DJZFLPq9RHEG2Cm+bQ@mail.gmail.com>
Message-ID: <CAHk-=wiHuHLK49LKQhtERXaq0OYUnug4DJZFLPq9RHEG2Cm+bQ@mail.gmail.com>
Subject: Re: [GIT PULL] xfs: fixes for 5.3-rc5
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-xfs <linux-xfs@vger.kernel.org>,
        Dave Chinner <david@fromorbit.com>,
        Linux List Kernel Mailing <linux-kernel@vger.kernel.org>,
        Eric Sandeen <sandeen@sandeen.net>,
        Christoph Hellwig <hch@lst.de>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Pulled. Just a quick note:

On Thu, Aug 15, 2019 at 10:13 AM Darrick J. Wong <djwong@kernel.org> wrote:
>
> - Convert more directory corruption debugging asserts to actual
>   EFSCORRUPTED returns instead of blowing up later on.

The proper error code looks like an obvious improvement, but I do
wonder if there should be some (ratelimited) system logging too?

I've seen a lot of programs that don't report errors very clearly and
might just silently stop running and as a sysadmin I'd think I'd
rather have something in the system logs than users saying "my app
crashes at startup"/

Maybe the logging ends up being there already - just done later. It
wasn't obvious from the patch, and I didn't check the whole callchain
(only direct callers).

                  Linus
