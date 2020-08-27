Return-Path: <SRS0=R4OI=CF=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4396BC433DF
	for <linux-xfs@archiver.kernel.org>; Thu, 27 Aug 2020 08:17:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1D7DC22B47
	for <linux-xfs@archiver.kernel.org>; Thu, 27 Aug 2020 08:17:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="vCpXDGyd"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726266AbgH0IRs (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 27 Aug 2020 04:17:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726851AbgH0IRr (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 27 Aug 2020 04:17:47 -0400
Received: from mail-il1-x142.google.com (mail-il1-x142.google.com [IPv6:2607:f8b0:4864:20::142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD0F0C061264
        for <linux-xfs@vger.kernel.org>; Thu, 27 Aug 2020 01:17:46 -0700 (PDT)
Received: by mail-il1-x142.google.com with SMTP id f75so4161544ilh.3
        for <linux-xfs@vger.kernel.org>; Thu, 27 Aug 2020 01:17:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=bibxd2o41dYg40BtxvXnRbmJgKKhy9PyqC2iAFCW6r4=;
        b=vCpXDGydtr4/A6wZV5+gyYrFtj+Rq6yHR/5je7PhHHOI9yCVOWjr8GGWC7agZhIVGm
         cmi9GwAMA/3/JmxxN/eYGINKR+634qJqjCZh9kodmrM66ojtG9qU0kir1P+gXP/UerWO
         IbXHCnKMXAMUeXP1Y96l747yX7w31kU9qQ+AZG7DMYaHMOw4ilpyFsLZGoyx7lU8BkvU
         PyxZlm822zpsI6fTZ9kpPFUqNOZikxQ/QIbQ2qLxftDHCE/IehSxjqWzaAsUpg+b1jEx
         44NG9WuTpdQ3nD59U+KYmuw+Ec4Dnckr2KzElyuSf1Bgv8/8EXJDp8TNRvXJbFAbHlWI
         jSOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=bibxd2o41dYg40BtxvXnRbmJgKKhy9PyqC2iAFCW6r4=;
        b=ohH7kcB55i8UbGVIuA1ZFuPjkjaZ/r7A6YQl/1ehoijPw92nVAcLsMP0IIMGhqgzqy
         xfBbhTb6MOEMmO6+fVGNXHhXdctRBheWyItSdpLAF82/Js25LdDuVFEF9MC4ljqPvumb
         xUFFA3rHx0TjWU8IFT7Si3PQeglhcm6JOMxFo9SCoYoBviFJ8aciCqZZ13dmTRdfhn2O
         ypF6H/ZjeVCqmxOC4mSY3rWdlnSfZbmJtDOkpwT/AeNwRQh6NXGPjekVyOnLL6Tt3x47
         bG/P+rb+5mU7TtYboAf9URqv7HFjD4T1GpDD9co6OxfLMGt97tEjZaqxpSTXGJ06txzh
         OKoQ==
X-Gm-Message-State: AOAM533xI8xfP9jUqXTWh3wKVhWkUjT0LZWTEBzM7eh9tzJQUMZS1Dal
        EyhHZgZKKu9KEDeGx3yvwL/1gOkKyDNd88NgcVcNkJLL
X-Google-Smtp-Source: ABdhPJx+QNSYRrp1gc4jlAkW9mmpHZLl8AHagET3TxKlaPPDIITyn03VorWyBHdDeetrN6pMqMXsfOjK68SPvOve4Ks=
X-Received: by 2002:a05:6e02:dc3:: with SMTP id l3mr16739233ilj.137.1598516265849;
 Thu, 27 Aug 2020 01:17:45 -0700 (PDT)
MIME-Version: 1.0
References: <159847949739.2601708.16579235017313836378.stgit@magnolia>
 <159847954327.2601708.9783406435973854389.stgit@magnolia> <20200827065114.GA17534@infradead.org>
In-Reply-To: <20200827065114.GA17534@infradead.org>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Thu, 27 Aug 2020 11:17:34 +0300
Message-ID: <CAOQ4uxiXNaboUgCs6A5zjfnMpmb8+=m+TaZ6fKj0-5sknie3Ag@mail.gmail.com>
Subject: Re: [PATCH 07/11] xfs: kill struct xfs_ictimestamp
To:     Christoph Hellwig <hch@infradead.org>
Cc:     "Darrick J. Wong" <darrick.wong@oracle.com>,
        Dave Chinner <david@fromorbit.com>,
        linux-xfs <linux-xfs@vger.kernel.org>,
        Eric Sandeen <sandeen@sandeen.net>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Aug 27, 2020 at 9:51 AM Christoph Hellwig <hch@infradead.org> wrote:
>
> > + */
> > +static inline xfs_ictimestamp_t
> > +xfs_inode_to_log_dinode_ts(
> > +     const struct timespec64 tv)
> > +{
> > +     uint64_t                t;
> > +
> > +#ifdef __LITTLE_ENDIAN
> > +     t = ((uint64_t)tv.tv_nsec << 32) | ((uint64_t)tv.tv_sec & 0xffffffff);
> > +#elif __BIG_ENDIAN
> > +     t = ((int64_t)tv.tv_sec << 32) | ((uint64_t)tv.tv_nsec & 0xffffffff);
> > +#else
> > +# error System is neither little nor big endian?
> > +#endif
> > +     return t;
>
> Looking at this I wonder if we should just keep the struct and cast
> to it locally in the conversion functions, as that should take
> care of everything.  Or just keep the union from the previous version,
> sorry..

Looking at this my eyes pop out.
I realize that maintaining on-disk format of the log is challenging,
so if there is no other technical solution that will be easier for humans
to review and maintain going forward, I will step back and let others
review this code.

But it bears the question: do we have to support replaying on BE a
log that was recorded on LE? Especially with so little BE machines
around these days, this sounds like over design to me.
Wouldn't it be better just to keep a bit in the log if it is LE or BE and refuse
to replay it on the wrong architecture?

Sure, we need to support whatever we supported up to now, but "bigtime"
can require a new incompat log feature "host order" (or something).

Anyway, I am probably mumbling utter garbage, do feel free to ignore
or set me straight.

Thanks,
Amir.
