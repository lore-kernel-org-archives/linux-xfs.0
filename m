Return-Path: <SRS0=kaVg=2T=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E0F6EC2D0C0
	for <linux-xfs@archiver.kernel.org>; Sun, 29 Dec 2019 05:59:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B2768206A4
	for <linux-xfs@archiver.kernel.org>; Sun, 29 Dec 2019 05:59:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=iith.ac.in header.i=@iith.ac.in header.b="ewRwhkFR"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725973AbfL2F7g (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 29 Dec 2019 00:59:36 -0500
Received: from mail-ed1-f42.google.com ([209.85.208.42]:36853 "EHLO
        mail-ed1-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725800AbfL2F7f (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 29 Dec 2019 00:59:35 -0500
Received: by mail-ed1-f42.google.com with SMTP id j17so29196591edp.3
        for <linux-xfs@vger.kernel.org>; Sat, 28 Dec 2019 21:59:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=iith.ac.in; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=OHj4lxg/O1/Iwn7XT8jc+rmPVetKntmgkgpQYlZlhLo=;
        b=ewRwhkFRh46P7EUZZ2Ynn0hVAJOD49o01uyJBZHtYVcbP4K2z/aESrfmAdbCUF7RiI
         ODR/fyZcQR2ilOcV288PHjxt9yGH7KMEd/8eNYoT2G9xPvoOMM+SOqmxpJMCfHEW+r2i
         hHQ03gLr+LNB4pqJB+EGrTiNlZBkfLW7WElqc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=OHj4lxg/O1/Iwn7XT8jc+rmPVetKntmgkgpQYlZlhLo=;
        b=ms+a/pBTtp5RydchmpZQmA16W60g59nFMzdx27GF1DNU5LUTfC2kBCdp1YKmFzxbgT
         MF1dUMIEQVcQYF+2LKltKyUisyTua6Lq5BhXbYrKgLVwg+MUqf0jJaSj6Qm2gdGay4tv
         cy5Y6JMNbey0bruobVeECWdfVKvZPl9bhmgx1qYiZQ4dyPrpMYiQSQRjoBTW3N06pr2a
         QtTpi7r5oW3CNy4cYZ846dX3cdu/3D6KTyP41XY2uPHvORSRcHj4SPXkRD6PPC3AVXT6
         g41N7TWkdFa2qRSp7Uwb3poOeFX6yJPjEiCBGEnb0VA77513acQBn0/NbipR751oGpdd
         D3aQ==
X-Gm-Message-State: APjAAAULLHC2kIjhBgz46GkO/abSuFQvXbuM7x47MEo9skxVVnk7MN1n
        OL1atayF74dQJfVLat1P82JsTH06cIJWB7x9C2KBQ83w
X-Google-Smtp-Source: APXvYqyUmZYMkC8oOGaVb4nK4e79WbPa87QYycM16srBVO8C3oxNsu3MyN8dOYe8LXHqCWcmJpg29x4oIee1nB6h62E=
X-Received: by 2002:a17:906:3519:: with SMTP id r25mr65083496eja.47.1577599174221;
 Sat, 28 Dec 2019 21:59:34 -0800 (PST)
MIME-Version: 1.0
References: <CAH3av2k4c63LKQ0eG9twweXEgC7QD7G_w3=c23tSO5rLP_cAfQ@mail.gmail.com>
 <CAJCQCtT5aMOX1RtFgbhzKsfq2BY00fwsF-UJMnt+0V8wBAJ93Q@mail.gmail.com>
In-Reply-To: <CAJCQCtT5aMOX1RtFgbhzKsfq2BY00fwsF-UJMnt+0V8wBAJ93Q@mail.gmail.com>
From:   Utpal Bora <cs14mtech11017@iith.ac.in>
Date:   Sun, 29 Dec 2019 11:28:57 +0530
Message-ID: <CAH3av2nFYMW-a4jkJk3TVuL9gaKDiOXLF-jfYoZz=s-KwwyO1g@mail.gmail.com>
Subject: Re: How to fix bad superblock or xfs_repair: error - read only 0 of
 512 bytes
To:     Chris Murphy <lists@colorremedies.com>
Cc:     xfs list <linux-xfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hello Chris,

Thank you for your response. I could solve the problem by extending
the lv as Eric suggested.

Regards,

Utpal Bora
Ph.D. Scholar
Computer Science & Engineering
IIT Hyderabad
http://utpalbora.com
PGP key fingerprint: 2F12 635E 409F 11AC 1502  BB41 7705 9980 A062 FA70


On Sun, Dec 29, 2019 at 8:45 AM Chris Murphy <lists@colorremedies.com> wrote:
>
> On Sat, Dec 28, 2019 at 4:12 AM Utpal Bora <cs14mtech11017@iith.ac.in> wrote:
> >
> > Hi,
> >
> > My XFS home drive is corrupt after trying to extend it with lvm.
> > This is what I did to extend the partition.
> > 1. Extend Volume group to use a new physical volume of around 1.2TB.
> > This was successful without any error.
> >     vgextend vg-1 /dev/sdc1
> >
> > 2. Extend logical volume (home-lv) to use the free space.
> >     lvextend -l 100%FREE /dev/mapper/vg--1-home--lv -r
>
> What approximate byte value is 100%FREE ?
>
> > 3. Resized home-lv and reduce 55 GB
> >    lvreduce -L 55G  /dev/mapper/vg--1-home--lv -r
>
> If this is really a volume reduction, along with -r I would expect
> this entire command to fail. XFS doesn't support shrink. Since a
> successful LV shrink requires shrinking the file system first, or else
> it results in truncation of the file system it contains and thus
> damages it, off hand I think this is a bug in lvreduce, or possibly in
> fsadm which is what -r calls to do the resize.
>
> My suggestion is to make no further changes at all, no further
> recovery attempts. And head over to the LVM list and make the same
> post as above. It's very possible there's backup LVM metadata that
> will reference the PE/LE's used in the LV prior to the lvreduce. By
> restoring the LV using that exact same mapping, it should be possible
> to recover the file system it contains. But only if you don't make
> other attempts. The more additional attempts the greater the chance of
> irreparable changes.
>
> https://www.redhat.com/mailman/listinfo/linux-lvm
>
> > I assumed that -r will invoke xfs_grow internally.
>
> Right, but xfs_grow only grows. It doesn't shrink. So my expectation
> is that the lvreduce command should fail without having made any
> changes. And yet...
>
> --
> Chris Murphy
