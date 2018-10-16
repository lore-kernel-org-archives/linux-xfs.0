Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-lf1-f68.google.com ([209.85.167.68]:45387 "EHLO
        mail-lf1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726760AbeJPVoW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 16 Oct 2018 17:44:22 -0400
Received: by mail-lf1-f68.google.com with SMTP id v22-v6so5206729lfe.12
        for <linux-xfs@vger.kernel.org>; Tue, 16 Oct 2018 06:53:47 -0700 (PDT)
MIME-Version: 1.0
References: <6A65F394-C1BA-4339-AC9B-051885D12F65@corp.ovh.com> <20181016125712.5k5xt4lzhi76qaj6@odin.usersys.redhat.com>
In-Reply-To: <20181016125712.5k5xt4lzhi76qaj6@odin.usersys.redhat.com>
From: Stefan Ring <stefanrin@gmail.com>
Date: Tue, 16 Oct 2018 15:53:33 +0200
Message-ID: <CAAxjCEyUL4nJ_Ds+ATragxGtUCyHjkZ9howsMHjc5H7VEe3xUg@mail.gmail.com>
Subject: Re: [QUESTION] multiple fsync() vs single sync()
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: romain.le-disez@corp.ovh.com
Cc: linux-xfs@vger.kernel.org

On Tue, Oct 16, 2018 at 2:57 PM Carlos Maiolino <cmaiolino@redhat.com> wrot=
e:
LY);
> >     write(fd, ...);
> >     fsetxattr(fd, ...);
> >     linkat(AT_FDCWD, =C2=AB /proc/self/fd/" + fd, AT_FDCWD, "/data/foob=
ar", AT_SYMLINK_FOLLOW);
> >     sync();
>
> IIRC, sync() on Linux is supposed to have the same guarantees of syncfs()=
, once
> we wait for IO completion on sync (POSIX doesn't guarantee sync() will re=
turn
> until everything is written to backing storage, but Linux does wait for I=
O
> completion).
>
> Short answer is, sync() does work the same way as if you run fsync() on e=
very
> file on your filesystem. The question would be. Do you want to fsync() al=
l files
> in your filesystem? This may take way longer than a pair of fsync() on th=
e file
> and its directory. But it's your call, as I said sync() will behave as if=
 you
> have ran a fsyn() on every file/directory on your filesystem.

But in what order? If I understood correctly, with the single sync()
call, he might end up with a directory entry referencing an incomplete
file. Which should not be possible in the case with the two fsyncs.
