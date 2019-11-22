Return-Path: <SRS0=QtPe=ZO=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A5538C432C0
	for <linux-xfs@archiver.kernel.org>; Fri, 22 Nov 2019 15:59:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7BF382071F
	for <linux-xfs@archiver.kernel.org>; Fri, 22 Nov 2019 15:59:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="aF2xnekH"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726568AbfKVP7j (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 22 Nov 2019 10:59:39 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:53531 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726546AbfKVP7j (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 22 Nov 2019 10:59:39 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1574438377;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=6cUATCgjNTWy1j7e+6YZBa6wvUrnAr97KTnCKueSilI=;
        b=aF2xnekH8zMtnwiVNbYS6ZZiOUREZLUyyV7RSkDL4gF40mTkc/19kOBLgpybaTE/uY05ct
        JrUrWRq8Nl46Y4db1X/yMiRXRRLCFqxACmEDK2qdAjbV65OKBYefUTzwOMvcwkVcVr7dqB
        ddJjw2uT/iSkUvn1MDM2goKHzMg7EPY=
Received: from mail-vs1-f70.google.com (mail-vs1-f70.google.com
 [209.85.217.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-46-Oq1P3gUcNtKdUc-DW7lLBA-1; Fri, 22 Nov 2019 10:59:33 -0500
Received: by mail-vs1-f70.google.com with SMTP id b3so1318650vse.18
        for <linux-xfs@vger.kernel.org>; Fri, 22 Nov 2019 07:59:33 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=/doIP1hCYUWfxP+YrWmD205G4WoDMxLizUbI1o+JIUQ=;
        b=on5/TxV7jL5kUPbmqlqeUm7ggVKQA+TSUkUonBVR6tX7HrGHqILJ+etfacBQUiXsES
         +8l0b8Bhw37OPszFEcmEBhXYZZrOFRZ2zyDo9Qvrah4JBqIwSWEG0qifn36V1LPxmOoi
         HqGrt+YNNxT+w7n1hJGiy9HjV23NggeOk2Ih9eNnn4QCSWzBce+nvotHn7FmTCyutsqO
         k+KVDaIFP6OFoXID/KV78YP/hHy4TKo6HWDwqduXiWZXZsk4W5+SyOF3rVV34MOgEj8Z
         JOP+Z+kvUXPJ1+7nPzAaGsLVM+RwJ1sSnqvzQl9AB6jI3Dxw5kH5mR8VeSkebYNMKSvI
         DJSg==
X-Gm-Message-State: APjAAAXdyvc0VryWmYTCLaxbC+o/XMz4QsGk2x85DwjG2FtVuK/vg8et
        sET9otdKg2LY8w0jZOVZSz1S4ykgyAqfcGh5QY5BJfJc9TrCIVFkAxbFNpLIJGbuxAyHfBd2E38
        PITWNtuzPsH0UtVoh0xdBViopu7q3wF/dtmUn
X-Received: by 2002:a67:ce12:: with SMTP id s18mr10139947vsl.77.1574438372860;
        Fri, 22 Nov 2019 07:59:32 -0800 (PST)
X-Google-Smtp-Source: APXvYqyHo6asaDD4WjzaFs6ogFj882BbtTDr64mK9n8Si3S53UzyrUQmoiTh7oZMNOdQ2HAtDl+5y/VkuYpzE4wOgqk=
X-Received: by 2002:a67:ce12:: with SMTP id s18mr10139926vsl.77.1574438372432;
 Fri, 22 Nov 2019 07:59:32 -0800 (PST)
MIME-Version: 1.0
References: <20191121214445.282160-1-preichl@redhat.com> <20191121214445.282160-2-preichl@redhat.com>
 <20191121231838.GH4614@dread.disaster.area> <20191122153807.GD6219@magnolia>
In-Reply-To: <20191122153807.GD6219@magnolia>
From:   Pavel Reichl <preichl@redhat.com>
Date:   Fri, 22 Nov 2019 16:59:21 +0100
Message-ID: <CAJc7PzX0sra12ikpVAY4LE-zRxamJK+JiNxj69MS+MOTmP730g@mail.gmail.com>
Subject: Re: [PATCH 1/2] mkfs: Break block discard into chunks of 2 GB
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org
X-MC-Unique: Oq1P3gUcNtKdUc-DW7lLBA-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Nov 22, 2019 at 4:38 PM Darrick J. Wong <darrick.wong@oracle.com> w=
rote:
>
> On Fri, Nov 22, 2019 at 10:18:38AM +1100, Dave Chinner wrote:
> > On Thu, Nov 21, 2019 at 10:44:44PM +0100, Pavel Reichl wrote:
> > > Signed-off-by: Pavel Reichl <preichl@redhat.com>
> > > ---
> >
> > This is mixing an explanation about why the change is being made
> > and what was considered when making decisions about the change.
> >
> > e.g. my first questions on looking at the patch were:
> >
> >       - why do we need to break up the discards into 2GB chunks?
> >       - why 2GB?
>
> Yeah, I'm wondering that too.

OK, thank you both for the question - simple answer is that I took
what is used in e2fsprogs as default and I expected a discussion about
proper value during review process :-)
>
> >       - why not use libblkid to query the maximum discard size
> >         and use that as the step size instead?
>
> FWIW my SATA SSDs the discard-max is 2G whereas on the NVME it's 2T.  I
> guess firmwares have gotten 1000x better in the past few years, possibly
> because of the hundred or so 10x programmers that they've all been hiring=
.
>
> >       - is there any performance impact from breaking up large
> >         discards that might be optimised by the kernel into many
> >         overlapping async operations into small, synchronous
> >         discards?
>
> Also:
> What is the end goal that you have in mind?  Is the progress reporting
> the ultimate goal?  Or is it to break up the BLKDISCARD calls so that
> someone can ^C a mkfs operation and not have it just sit there
> continuing to run?

The goal is mainly the progress reporting but the possibility to do ^C
is also convenient. It seems that some users are not happy about the
BLKDISCARD taking too long and at the same time not being informed
about that - so they think that the command actually hung.

>
> --D
>
> > i.e. the reviewer can read what the patch does, but that deosn't
> > explain why the patch does this. Hence it's a good idea to explain
> > the problem being solved or the feature requirements that have lead
> > to the changes in the patch....
> >
> > Cheers,
> >
> > Dave.
> > --
> > Dave Chinner
> > david@fromorbit.com
>

