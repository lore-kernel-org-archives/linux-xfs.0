Return-Path: <SRS0=J5MO=ZF=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 21149C43331
	for <linux-xfs@archiver.kernel.org>; Wed, 13 Nov 2019 05:17:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DECE3222D0
	for <linux-xfs@archiver.kernel.org>; Wed, 13 Nov 2019 05:17:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="kVWHzDKV"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726107AbfKMFRT (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 13 Nov 2019 00:17:19 -0500
Received: from mail-yw1-f52.google.com ([209.85.161.52]:34615 "EHLO
        mail-yw1-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726087AbfKMFRT (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 13 Nov 2019 00:17:19 -0500
Received: by mail-yw1-f52.google.com with SMTP id y18so322062ywk.1
        for <linux-xfs@vger.kernel.org>; Tue, 12 Nov 2019 21:17:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Gb4ewfjgPCGRx8bhjFPb2zRwepox5PVbxqmHMUQvW/U=;
        b=kVWHzDKVspeHHAJdK68q6fWlwyQsUZI9/bN9Q7J1TD0xovjLBfGceCyDeGjnCn3ysq
         TY6Bi2FY5omiNhENYfoK38k+FvdIQeEyKNzj6sHrv98RaRmDOj4oxXYdanTu6wahYM2a
         v5LTXJDg8bkU2Parva55Qe3ShTMtBb+gESH6xVeuWsxBHFOR+P9J8vQwr4wPk62sZTfJ
         lRuPNneRLBsgHfIHWikL81wYiuvO9uyrfTLEbduU0o3m0boGPbCAHf174hbWhBY3PIPR
         Aj79vxDS+FRaRAWozAlXEUJjXsPcPACbirjnvKFW69yFYvcAaDTUGs8L3HNxFy4ILgLp
         CDOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Gb4ewfjgPCGRx8bhjFPb2zRwepox5PVbxqmHMUQvW/U=;
        b=Aucj9c8ZwU+hIFl29RW6x8JgoBkjY/wBxgzQgigMr8/Qi+qtJ5pklkEsQLqbX8CKyy
         ss42BgT43u4cS6gkLR0GnIghn0rBKyNLyo8lxpjBFodJi1TFD7I5YmIs0KsIrDdB0oZc
         Ok44BoZuWl5wDB8aUPP/OLttbDZi4Z5JU3oEGnX6+c4iXiAwIQrUq5VRK7fd/KS2II73
         prwt+lC4UiXW3gC8Pcfasi+MtKlCn8gnbzJGGD5h2T8aBDvHfu5914iCR24+NhqSP3h3
         DhL9lOg1IhEmJ5SyUZASFUDCtXEOa3GCF4pD86zS9Bk8G+lAYIZZXNJ8PIfcXr2jYcVi
         P6/w==
X-Gm-Message-State: APjAAAXwHDBpXxT2k+CplvlXl397g1h6AqYksFDsiwOMnyBrnZih5uvR
        RHjob+nZgrh351ERjwpimUGzW8fIti5JSzmR1TI=
X-Google-Smtp-Source: APXvYqzgva4c3/eCX2CBLxT8N00M9/l5IZG7bHXcEE8Xr9jbRLcr4XkpE+DWyOiKbDwNwpWGJNTmXFZ9OtgFVcs0VrY=
X-Received: by 2002:a81:58c6:: with SMTP id m189mr960311ywb.25.1573622237981;
 Tue, 12 Nov 2019 21:17:17 -0800 (PST)
MIME-Version: 1.0
References: <20191111213630.14680-1-amir73il@gmail.com> <20191111223508.GS6219@magnolia>
 <CAOQ4uxgC8Gz+uyCaV_Prw=uUVNtwv0j7US8sbkfoTphC4Z6b6A@mail.gmail.com>
 <20191112211153.GO4614@dread.disaster.area> <20191113035611.GE6219@magnolia>
 <CAOQ4uxi9vzR4c3T0B4N=bM6DxCwj_TbqiOxyOQLrurknnyw+oA@mail.gmail.com> <20191113045840.GR6219@magnolia>
In-Reply-To: <20191113045840.GR6219@magnolia>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Wed, 13 Nov 2019 07:17:06 +0200
Message-ID: <CAOQ4uxh0T-cddZ9gwPcY6O=Eg=2g855jYbjic=VwihYPz2ZeBw@mail.gmail.com>
Subject: Re: [RFC][PATCH] xfs: extended timestamp range
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     Dave Chinner <david@fromorbit.com>,
        linux-xfs <linux-xfs@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Deepa Dinamani <deepa.kernel@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

>
> Practically speaking I'd almost rather drop the precision in order to
> extend the seconds range, since timestamp updates are only precise to
> HZ anyway.
>

FWIW, NTFS and CIFS standard is unsigned 64bit of 100 nanoseconds
counting from Jan 1, 1601.

>
> Heh, ok.  I'll add an inode flag and kernel auto-upgrade of timestamps
> to the feature list.  It's not like we're trying to add an rmap btree to
> the filesystem. :)
>

Exactly.

> >
> > All right, so how do we proceed?
> > Arnd, do you want to re-work your series according to this scheme?
>
> Lemme read them over again. :)
>
> > Is there any core xfs developer that was going to tackle this?
> >
> > I'm here, so if you need my help moving things forward let me know.
>
> I wrote a trivial garbage version this afternoon, will have something
> more polished tomorrow.  None of this is 5.6 material, we have time.
>

I wonder if your version has struct xfs_dinode_v3 or it could avoid it.
There is a benefit in terms of code complexity and test coverage
to keep the only difference between inode versions in the on-disk
parsers, while reading into the same struct, the same way as
old inode versions are read into struct xfs_dinode.

Oh well, I can wait for tomorrow to see the polished version :-)

Thanks,
Amir.
