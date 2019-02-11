Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-lj1-f177.google.com ([209.85.208.177]:43641 "EHLO
        mail-lj1-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727141AbfBKVxb (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 11 Feb 2019 16:53:31 -0500
Received: by mail-lj1-f177.google.com with SMTP id o1-v6so368319ljc.10
        for <linux-xfs@vger.kernel.org>; Mon, 11 Feb 2019 13:53:30 -0800 (PST)
MIME-Version: 1.0
References: <20190211172359.71aff9d6@harpe.intellique.com> <20190211174053.7eec6a59@harpe.intellique.com>
In-Reply-To: <20190211174053.7eec6a59@harpe.intellique.com>
From: Chris Murphy <lists@colorremedies.com>
Date: Mon, 11 Feb 2019 14:53:16 -0700
Message-ID: <CAJCQCtQtzsTRq_mP3kGLNsAOH7huATUtJaOYA7ujKdLqn8AnsA@mail.gmail.com>
Subject: Re: RAID hiccup, LVM information wiped, XFS FS gone, how to proceed?
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Emmanuel Florac <eflorac@intellique.com>
Cc: Linux-XFS list <linux-xfs@vger.kernel.org>

On Mon, Feb 11, 2019 at 9:42 AM Emmanuel Florac <eflorac@intellique.com> wr=
ote:
>
> Le Mon, 11 Feb 2019 17:23:59 +0100
> Emmanuel Florac <eflorac@intellique.com> =C3=A9crivait:
>
> > (I know, I could simply restore the vgcfgbackup if it existed...
> > please let's suppose this command doesn't exist).
> >
>
> Hum, actually I have a backup of the vg configuration but... it looks
> like actually 7 or 8 kB were erased  from the disk. So  no dice, I must
> recreate the PV first but wouldn't it wipe everything?

You're right to be concerned. First you need to make sure the raid is
assembled correctly, and functioning correctly. Is there a battery
backed cache? There should be raid logs that can be extract to show at
least what the hardware raid thinks happened; and if it did a cache
flush upon power being restored, the log should indicate that as well.
If it's possible the cache was full and the contents lost, that's also
useful information.

Anyway, get the raid sorted out first. Only then can you move on to
LVM checking and recovery options, from the LVM list:

linux-lvm@redhat.com

And only once LVM is healthy and working correctly can you move on to
XFS checks and if advised, repair. Just be really deliberate, don't go
stomping around with repairs and writes to disk that aren't
deliberate, or you risk user induced data loss. Basically, I advise
doing only checks and posting the results, and only doing repairs
recommended on the applicable list by developers or expert users.

All the lists will want information not provided in your first post, exampl=
e:
http://xfs.org/index.php/XFS_FAQ#Q:_What_information_should_I_include_when_=
reporting_a_problem.3F




--
Chris Murphy
