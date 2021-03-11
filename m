Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C888AC433E0
	for <linux-xfs@archiver.kernel.org>; Thu, 11 Mar 2021 08:27:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 85CCC64F9E
	for <linux-xfs@archiver.kernel.org>; Thu, 11 Mar 2021 08:27:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231452AbhCKI0u (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 11 Mar 2021 03:26:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231278AbhCKI0s (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 11 Mar 2021 03:26:48 -0500
Received: from mail-yb1-xb33.google.com (mail-yb1-xb33.google.com [IPv6:2607:f8b0:4864:20::b33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90978C061574;
        Thu, 11 Mar 2021 00:26:48 -0800 (PST)
Received: by mail-yb1-xb33.google.com with SMTP id 133so20868367ybd.5;
        Thu, 11 Mar 2021 00:26:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=dcZpA35LpDkKjUY2Q5hXt+oRBTl1Po2J4cSvuFIykJg=;
        b=DjYTcGueHAZYsfVWcXtNSV5/l9b9KrnYrqF65jNsk2ArqmZWXRS3axR3334xSPnksJ
         KpInpw14LRvoI0+d1KhzvcgE1CFYNdwTtPm+IPG9P2ikH4U8Y2HwEyqtWWTY4ER9D/Im
         tKABJcbZPj/+aA08uogzlTecDmN9WzdnpKOTEHUNNs2ygRLg0SrzAX7flrL7Zs5WTL95
         kw2WWz8GXrociRGMY0y1D/4yVsKqKXYgxPoPv+sNtc5Xm8dDTSFxycSJnXP20MK63TZ6
         TgvHhcQztSCshrA1MwAHkYghauzH0gTLgczXbJccIkQGqcS726u4gIP0X3z9vKk7vBSX
         mPvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=dcZpA35LpDkKjUY2Q5hXt+oRBTl1Po2J4cSvuFIykJg=;
        b=sapBmaj7/tBsdMjIyKMAUKKsbALcZQ39kv5A3ZH9xu0vVN/BN2OfTYuQLCk/ytZ9x6
         PXfMDXt/CZoCriOqF1SZadk/L9PE+mqAizWxvSfiGVqg+Agw1v+b2YdhwRmsYZAQVlJ4
         8shOBfVM7P4lI7Ly1DPQWSLHCtTQ+OHG29hnB53zDbrwWR0JOIz1gAoJiqOb7AqxRNtU
         nEKefj0fPQIPqrNGfFVUXqeWXiNPvX6OwDQTg9hymaj80BhwjJ/ppNaU6SIIlh9lDm1m
         lSwKWC307bn3UaJehXhAJKDTNAWxFkUD0QBgaTm4YxlWGILBnUtNhzZZsxEnXf9LAL6y
         veHA==
X-Gm-Message-State: AOAM530k0HMkV9pKnYcPdfh2jixFOgOUe2F2+rNF3t6iAMBW5UAWknIu
        rz53D0E2G+gUytpTSkWE1SrKy/C1wRzNX5bbswcNdAPOyi85VA==
X-Google-Smtp-Source: ABdhPJxDi0GRK2/QkVfeTJCzVq2zudoeSp/hgMaL164lMJ0uHqYkS0fpHT+H5oc1+Mf9DUZcBDo/d2853Fvi8jdJEdg=
X-Received: by 2002:a25:cc13:: with SMTP id l19mr9850423ybf.260.1615451207278;
 Thu, 11 Mar 2021 00:26:47 -0800 (PST)
MIME-Version: 1.0
References: <20210226002030.653855-1-ruansy.fnst@fujitsu.com>
 <CAEg-Je-OLidbfzHCJvY55x+-cOfiUxX8CJ1AeN8VxXAVuVyxKQ@mail.gmail.com>
 <20210310130227.GN3479805@casper.infradead.org> <20210310142159.kudk7q2ogp4yqn36@fiona>
 <20210310142643.GQ3479805@casper.infradead.org> <CAPcyv4i80GXjjoAD9G0AaRDWPbcTSLogJE9NokO4Eqpzt6UMkA@mail.gmail.com>
In-Reply-To: <CAPcyv4i80GXjjoAD9G0AaRDWPbcTSLogJE9NokO4Eqpzt6UMkA@mail.gmail.com>
From:   Neal Gompa <ngompa13@gmail.com>
Date:   Thu, 11 Mar 2021 03:26:11 -0500
Message-ID: <CAEg-Je9e1R2NAqtZfryM99+Z98SGjxTSQjt-CMyKRMxvDwtsyg@mail.gmail.com>
Subject: Re: [PATCH v2 00/10] fsdax,xfs: Add reflink&dedupe support for fsdax
To:     Dan Williams <dan.j.williams@intel.com>
Cc:     Matthew Wilcox <willy@infradead.org>,
        Goldwyn Rodrigues <rgoldwyn@suse.de>,
        Shiyang Ruan <ruansy.fnst@fujitsu.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-xfs <linux-xfs@vger.kernel.org>,
        linux-nvdimm <linux-nvdimm@lists.01.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Jan Kara <jack@suse.cz>, Al Viro <viro@zeniv.linux.org.uk>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>,
        ocfs2-devel@oss.oracle.com, david <david@fromorbit.com>,
        Christoph Hellwig <hch@lst.de>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Mar 10, 2021 at 7:53 PM Dan Williams <dan.j.williams@intel.com> wro=
te:
>
> On Wed, Mar 10, 2021 at 6:27 AM Matthew Wilcox <willy@infradead.org> wrot=
e:
> >
> > On Wed, Mar 10, 2021 at 08:21:59AM -0600, Goldwyn Rodrigues wrote:
> > > On 13:02 10/03, Matthew Wilcox wrote:
> > > > On Wed, Mar 10, 2021 at 07:30:41AM -0500, Neal Gompa wrote:
> > > > > Forgive my ignorance, but is there a reason why this isn't wired =
up to
> > > > > Btrfs at the same time? It seems weird to me that adding a featur=
e
> > > >
> > > > btrfs doesn't support DAX.  only ext2, ext4, XFS and FUSE have DAX =
support.
> > > >
> > > > If you think about it, btrfs and DAX are diametrically opposite thi=
ngs.
> > > > DAX is about giving raw access to the hardware.  btrfs is about off=
ering
> > > > extra value (RAID, checksums, ...), none of which can be done if th=
e
> > > > filesystem isn't in the read/write path.
> > > >
> > > > That's why there's no DAX support in btrfs.  If you want DAX, you h=
ave
> > > > to give up all the features you like in btrfs.  So you may as well =
use
> > > > a different filesystem.
> > >
> > > DAX on btrfs has been attempted[1]. Of course, we could not
> >
> > But why?  A completeness fetish?  I don't understand why you decided
> > to do this work.
>
> Isn't DAX useful for pagecache minimization on read even if it is
> awkward for a copy-on-write fs?
>
> Seems it would be a useful case to have COW'd VM images on BTRFS that
> don't need superfluous page cache allocations.

I could also see this being useful for databases (and maybe even swap
files!) on Btrfs, if I'm understanding this feature correctly.


--=20
=E7=9C=9F=E5=AE=9F=E3=81=AF=E3=81=84=E3=81=A4=E3=82=82=E4=B8=80=E3=81=A4=EF=
=BC=81/ Always, there's only one truth!
