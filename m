Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-io1-f66.google.com ([209.85.166.66]:33579 "EHLO
        mail-io1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726155AbfE2UH2 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 29 May 2019 16:07:28 -0400
Received: by mail-io1-f66.google.com with SMTP id u13so3022092iop.0
        for <linux-xfs@vger.kernel.org>; Wed, 29 May 2019 13:07:28 -0700 (PDT)
MIME-Version: 1.0
References: <20190529174318.22424-1-amir73il@gmail.com> <20190529174318.22424-12-amir73il@gmail.com>
 <CAOQ4uxiAa5jCCqkRbq7cn8Mmnb0rX7piMOfy9W4qk7g=7ziJnA@mail.gmail.com>
In-Reply-To: <CAOQ4uxiAa5jCCqkRbq7cn8Mmnb0rX7piMOfy9W4qk7g=7ziJnA@mail.gmail.com>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Wed, 29 May 2019 22:07:17 +0200
Message-ID: <CAJfpegsft_1TZ-OjaAdmGE--a8+deCQwFjbcAYJsEdbp2YWQSw@mail.gmail.com>
Subject: Re: [PATCH v3 11/13] fuse: copy_file_range needs to strip setuid bits
 and update timestamps
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Amir Goldstein <amir73il@gmail.com>
Cc: Dave Chinner <david@fromorbit.com>, Christoph Hellwig <hch@lst.de>, linux-xfs <linux-xfs@vger.kernel.org>, Olga Kornievskaia <olga.kornievskaia@gmail.com>, Luis Henriques <lhenriques@suse.com>, Al Viro <viro@zeniv.linux.org.uk>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, ceph-devel@vger.kernel.org, Linux NFS Mailing List <linux-nfs@vger.kernel.org>, CIFS <linux-cifs@vger.kernel.org>, "Darrick J . Wong" <darrick.wong@oracle.com>

On Wed, May 29, 2019 at 9:38 PM Amir Goldstein <amir73il@gmail.com> wrote:
>
> Hi Miklos,
>
> Could we get an ACK on this patch.
> It is a prerequisite for merging the cross-device copy_file_range work.
>
> It depends on a new helper introduced here:
> https://lore.kernel.org/linux-fsdevel/CAOQ4uxjbcSWX1hUcuXbn8hFH3QYB+5bAC9Z1yCwJdR=T-GGtCg@mail.gmail.com/T/#m1569878c41f39fac3aadb3832a30659c323b582a

That likely is actually an unlikely.

Otherwise ACK.

Thanks,
Miklos
