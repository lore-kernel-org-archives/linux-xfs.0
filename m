Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-lj1-f180.google.com ([209.85.208.180]:36147 "EHLO
        mail-lj1-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725723AbeJDFha (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 4 Oct 2018 01:37:30 -0400
Received: by mail-lj1-f180.google.com with SMTP id p89-v6so6636617ljb.3
        for <linux-xfs@vger.kernel.org>; Wed, 03 Oct 2018 15:47:06 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20181002183018.37343c26@harpe.intellique.com>
References: <20181002162530.42b30c11@harpe.intellique.com> <20181002163707.5452307c@harpe.intellique.com>
 <6eb79c7b-4f15-28af-44b5-03488008a897@sandeen.net> <20181002183018.37343c26@harpe.intellique.com>
From: Chris Murphy <lists@colorremedies.com>
Date: Wed, 3 Oct 2018 16:47:05 -0600
Message-ID: <CAJCQCtQyXjB1bzOWuj8f+cd-WgFkxDY8xpZ8YhVoTC72rPLThA@mail.gmail.com>
Subject: Re: [somewhat OT] I just discovered that Stratis uses XFS.
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Emmanuel Florac <eflorac@intellique.com>
Cc: Eric Sandeen <sandeen@sandeen.net>, xfs <linux-xfs@vger.kernel.org>

On Tue, Oct 2, 2018 at 10:30 AM, Emmanuel Florac <eflorac@intellique.com> w=
rote:
> Le Tue, 2 Oct 2018 10:05:42 -0500
> Eric Sandeen <sandeen@sandeen.net> =C3=A9crivait:
>
>> But if Stratis starts at 1TB it's not terrible; I'd need to look and
>> see how many AGs get created (probably 4?) and if so, 250G AGs are
>> not /too/ granular. If it's creating a lot more smaller AGs, that
>> could become an issue if it gets grown to a very large size.  IOWs
>> the growfs concern is mostly about the resulting AG size & AG count.
>>
>
> You're right, I've looked through the source code and no option ever
> gets passed to mkfs.xfs nor xfs_growfs related to FS size. That means
> that it creates the FS with the default 4 AGs for a start.

Stratis volumes are always built on dm-thin so I'd expect default
mkfs.xfs to create ~33 AG's, which is what I get when running mkfs.xfs
on LVM thin volumes.

--=20
Chris Murphy
