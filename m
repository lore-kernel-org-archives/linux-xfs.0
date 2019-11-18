Return-Path: <SRS0=mMHn=ZK=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.7 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9BC3EC432C0
	for <linux-xfs@archiver.kernel.org>; Mon, 18 Nov 2019 09:31:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6B7FA2073A
	for <linux-xfs@archiver.kernel.org>; Mon, 18 Nov 2019 09:31:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="YIV3hUUW"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726472AbfKRJbK (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 18 Nov 2019 04:31:10 -0500
Received: from mail-yw1-f68.google.com ([209.85.161.68]:42341 "EHLO
        mail-yw1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726464AbfKRJbK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 18 Nov 2019 04:31:10 -0500
Received: by mail-yw1-f68.google.com with SMTP id z67so5623549ywb.9
        for <linux-xfs@vger.kernel.org>; Mon, 18 Nov 2019 01:31:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Nnn2NMQoclXxuw5BOgdR3Z7Ii8phbpZZ5SBihkJZmJs=;
        b=YIV3hUUWNI6sSvIH1rfU9zahvscuFYJSJxXScY07NXLYK9ydPkBLM9LJHFzHbCtxXU
         EnBY88iOFAIivRyY0BkK8MNvcfG1vpSFcwVYO6BKRHu1KMqugI5g7oxinGVjHUPpmWL1
         b2kaHZj8kv3hWYGMRT+5MBiOWTJHsp/fTMXvlwqTejQY/FNL94AC1ws1Qr1e8+3OZiqK
         wTQK1Sr6zESKYcYpz/dP4RzSsDmjUt8BeznpGd44ZdGR6y2hgdhqU6Hb+udgzVQYkJ+C
         BvPULimsgeNZYiovpZ6tfNdoYeR26zsEEaAqRBKQuZg6zUwGHD0FbxgJhS/LysdKEedX
         Oh8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Nnn2NMQoclXxuw5BOgdR3Z7Ii8phbpZZ5SBihkJZmJs=;
        b=nRXzTvaEkuxdvtk3U3WjeBMPvgwfUJ/aavFTALV1C34pmpqttHqC55IUD0I9wfaEOc
         fUULtsSp4YkojSsgwvhMjUpKplhX695ULmVqwVcs/O6eYaICUsWrY7D+MrgxsWqCiZv+
         ceoixje+X4FkGTkXKrYgnefcN2/VKWEkGEl+ZHniArqMWJdQJnPPYALvJ43Qg+TPeFjc
         LkXKNVnY2H5NcKFHeudft3sVVBTdr5vk7YvhwxZTggQDmkz8wcnQY/b0x1ucGZzxaNM+
         vuRodPMd761Vkfn8fFNG1xOMURs9cV1nwy7rkwYssf7Vr85vOtEucFfE2q4Fp41oyeZc
         Anvg==
X-Gm-Message-State: APjAAAWA0PVvK2+7o4Z/YnkyyrUKUc96C3y2pGlntm6WdWzFJFTj04JE
        5PTRr6GIXz/goT+KRxNZ4xmPgNW/xPn+HjwyNZ4=
X-Google-Smtp-Source: APXvYqwP3qZtGx0TdoZfdeMdbsn7WsKVzo0L1lHegtcDUPXz4lPEL/saNxrXl1UwSF5OWJ9dVsfifV00Pn8lonjrDvY=
X-Received: by 2002:a81:1cd5:: with SMTP id c204mr18678509ywc.379.1574069469427;
 Mon, 18 Nov 2019 01:31:09 -0800 (PST)
MIME-Version: 1.0
References: <20191111213630.14680-1-amir73il@gmail.com> <20191111223508.GS6219@magnolia>
 <CAOQ4uxgC8Gz+uyCaV_Prw=uUVNtwv0j7US8sbkfoTphC4Z6b6A@mail.gmail.com>
 <20191112211153.GO4614@dread.disaster.area> <20191113035611.GE6219@magnolia>
 <CAOQ4uxi9vzR4c3T0B4N=bM6DxCwj_TbqiOxyOQLrurknnyw+oA@mail.gmail.com>
 <20191113045840.GR6219@magnolia> <CAOQ4uxh0T-cddZ9gwPcY6O=Eg=2g855jYbjic=VwihYPz2ZeBw@mail.gmail.com>
 <20191113052032.GU6219@magnolia> <CAOQ4uxiTRWkeM6i6tyMe5dzSN8nsR=1XZEMEwwwVJAcJNVimGA@mail.gmail.com>
 <20191118082216.GU4614@dread.disaster.area>
In-Reply-To: <20191118082216.GU4614@dread.disaster.area>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Mon, 18 Nov 2019 11:30:58 +0200
Message-ID: <CAOQ4uxgyf7gWy0TpE8+i1cw37yH+NKsBa=ffP0rw5uLW55LwLw@mail.gmail.com>
Subject: Re: [RFC][PATCH] xfs: extended timestamp range
To:     Dave Chinner <david@fromorbit.com>
Cc:     "Darrick J. Wong" <darrick.wong@oracle.com>,
        linux-xfs <linux-xfs@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Deepa Dinamani <deepa.kernel@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Nov 18, 2019 at 10:22 AM Dave Chinner <david@fromorbit.com> wrote:
>
> On Mon, Nov 18, 2019 at 06:52:39AM +0200, Amir Goldstein wrote:
> > > >
> > > > I wonder if your version has struct xfs_dinode_v3 or it could avoid it.
> > > > There is a benefit in terms of code complexity and test coverage
> > > > to keep the only difference between inode versions in the on-disk
> > > > parsers, while reading into the same struct, the same way as
> > > > old inode versions are read into struct xfs_dinode.
> > > >
> > > > Oh well, I can wait for tomorrow to see the polished version :-)
> > >
> > > Well now we noticed that Arnd also changed the disk quota structure
> > > format too, so that'll slow things down as we try to figure out how to
> > > reconcile 34-bit inode seconds vs. 40-bit quota timer seconds.
> > >
> > > (Or whatever happens with that)
> > >
> >
> > Sigh. FWIW, I liked Arnd's 40-bit inode time patch because it
> > keeps the patch LoC for this conversion minimal.
>
> We can extend the quota warning range without changing the on-disk
> structures, and with much less code than changing the on-disk
> structures.
>
> We only need a ~500 year range for the warning expiry timestamp, and
> we don't really care about fine grained resolution of the timer
> expiry.
>
> We've already got a 70 year range with the signed second counter. So
> let's just redefine the timeout value on disk to use units of 10s
> instead of 1s when the bigtime superblock feature bit is set. ANd
> now we have our >500 year range requirement.
>
> That shouldn't need much more than 5-10 lines of new code
> translating the units when we read/write them from/to disk....
>

Sounds good.

What is your take on the issue of keeping struct xfs_dinode
and struct xfs_log_dinode common to v3..v4?

If we make struct xfs_timestamp_t/xfs_ictimestamp_t a union
of {{t_sec32;t_nsec32}, {t_nsec64}} then xfs_log_dinode_to_disk()
conversion code is conditional to di_version.
If we store v4 on-disk as {t_nsec32_hi;t_nsec32_lo} then the
conversion code from disk to log is unconditional to di_version.

Am I overthinking this?

Darrick,

I am assuming you are working on the patch.
If you would like me to re-post my patch with the decided
on-disk formats for inode and a quota patch let me know.

Thanks,
Amir.
