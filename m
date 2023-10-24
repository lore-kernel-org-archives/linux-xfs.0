Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8143CC25B48
	for <linux-xfs@archiver.kernel.org>; Tue, 24 Oct 2023 12:45:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234342AbjJXMpg (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 24 Oct 2023 08:45:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234339AbjJXMpe (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 24 Oct 2023 08:45:34 -0400
Received: from mail-oi1-x233.google.com (mail-oi1-x233.google.com [IPv6:2607:f8b0:4864:20::233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9AA72123;
        Tue, 24 Oct 2023 05:45:32 -0700 (PDT)
Received: by mail-oi1-x233.google.com with SMTP id 5614622812f47-3ae35773a04so2946609b6e.0;
        Tue, 24 Oct 2023 05:45:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1698151532; x=1698756332; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fDpE4b9lrbKshRFNBmBeWLt8OGBDwzY5y8TDfJJrCF0=;
        b=XeY1jSK2+9CFCW2jWIxj1hjkzT1mC6Jvo2wPCHYuzavdkU4sfQsXOPE7rBgNij01t1
         fDxe/nPhF/GnabodEyRhcKcksCc1RmygSClWixPgqOAz5CTD5jbj4QoKmHdNMjfzqrmT
         als3CAWMVgidDrr0FAVDY9YPeTQ7+mgBcbQoVTZsYnQNmrQ5sSbg3Kj26pbb//JD6dBU
         sOBk8LXVunajxaXBn1mIxZWeag8sPUD7vumyQ1hYA46RNP79ds5B1GrNGEwZWx4PlIv8
         4WzL9nxC3imVaYFoy4ZdA51ju25Rz2EmDHGBp40qoymMrRozrrFFnwBi26bnTHI0b9Pu
         EQvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698151532; x=1698756332;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=fDpE4b9lrbKshRFNBmBeWLt8OGBDwzY5y8TDfJJrCF0=;
        b=V9I3CVgk56kYPRHtnY947MifIAQenAEsKK/Ownbr296aeMAhkp6RP0YE5Sz85LswhK
         C0eZuQSZuLt/jtNpOjCxOfuhdA6hEovlV2zVpWbLtut3V53hAxc+sPno0EoatTPslEBn
         atqFYMNoJSDfBSIxL7hLfgHFO8Hmn5wkIajy3gvNJJKtYJPa27VaxhlrmzS4vB5oPr3v
         YDPkLMRqQ0KPsncXng36wkZmgZSw1UBtgywGvIXqFgqMNu2ODf00829T9ACUJrvavy2G
         jVwV4yseq46v0bFB51CMiQnauSk0eoh3Ji8Ogbbl2x8Uc1ixDtJ8TnSMVWvrPueZ7S2W
         zT9A==
X-Gm-Message-State: AOJu0YxR9qy9VliLHDh8hYhfiktOgr4O4BqTG87+6PeBu74gIDQ6eEj6
        tphQFKoylq6DUdsxY2OfWaKnMGX6bgv909475+U=
X-Google-Smtp-Source: AGHT+IFNzKTfnCI5djyaqlxvz74BRlz1XB4g2ZcwPxS9eSiil8asvvG9OW6yi7hQhiC6NOdpmJitdvs/BUm9N15FtvY=
X-Received: by 2002:a05:6808:5c5:b0:3ae:1358:fafc with SMTP id
 d5-20020a05680805c500b003ae1358fafcmr12142750oij.58.1698151531903; Tue, 24
 Oct 2023 05:45:31 -0700 (PDT)
MIME-Version: 1.0
References: <20231024064416.897956-1-hch@lst.de> <20231024064416.897956-2-hch@lst.de>
 <CAOi1vP_mF_A6OmNvYPvmBcS-CHQkwOHqsZ1oAZCJXQmow3QUMw@mail.gmail.com> <ZTe0C90lRfp7nnlz@casper.infradead.org>
In-Reply-To: <ZTe0C90lRfp7nnlz@casper.infradead.org>
From:   Ilya Dryomov <idryomov@gmail.com>
Date:   Tue, 24 Oct 2023 14:45:19 +0200
Message-ID: <CAOi1vP-Q9J=Kk7vnjYU7t7KPt_DXf6hAwDBWRj6WS3E45z21Vg@mail.gmail.com>
Subject: Re: [PATCH 1/3] filemap: add a per-mapping stable writes flag
To:     Matthew Wilcox <willy@infradead.org>
Cc:     Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-block@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-xfs@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Oct 24, 2023 at 2:09=E2=80=AFPM Matthew Wilcox <willy@infradead.org=
> wrote:
>
> On Tue, Oct 24, 2023 at 02:03:36PM +0200, Ilya Dryomov wrote:
> > > +static inline void mapping_clear_stable_writes(struct address_space =
*mapping)
> >
> > Hi Christoph,
> >
> > Nit: mapping_clear_stable_writes() is unused.
>
> It's used in patch 3

My apologies, I was too quick to archive it as specific to XFS.

Thanks,

                Ilya
