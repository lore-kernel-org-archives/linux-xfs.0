Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-yw1-f68.google.com ([209.85.161.68]:35366 "EHLO
        mail-yw1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387456AbfFJROU (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 10 Jun 2019 13:14:20 -0400
MIME-Version: 1.0
References: <20190610160624.GG1871505@magnolia>
In-Reply-To: <20190610160624.GG1871505@magnolia>
From: Amir Goldstein <amir73il@gmail.com>
Date: Mon, 10 Jun 2019 20:14:08 +0300
Message-ID: <CAOQ4uxhkE_TsN7XMBgzxVhEYDw+gZEOOCiZzn9otVwQtB-XHeA@mail.gmail.com>
Subject: Re: [ANNOUNCE] xfs-linux: copy-file-range-fixes updated to fe0da9c09b2d
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>, Miklos Szeredi <miklos@szeredi.hu>, Anna Schumaker <Anna.Schumaker@netapp.com>, Steve French <smfrench@gmail.com>, Ilya Dryomov <idryomov@gmail.com>
Cc: xfs <linux-xfs@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Olga Kornievskaia <olga.kornievskaia@gmail.com>, Theodore Ts'o <tytso@mit.edu>, Dave Chinner <david@fromorbit.com>, Linux NFS Mailing List <linux-nfs@vger.kernel.org>, CIFS <linux-cifs@vger.kernel.org>, ceph-devel@vger.kernel.org

+CC affected maintainers

On Mon, Jun 10, 2019 at 7:06 PM Darrick J. Wong <darrick.wong@oracle.com> wrote:
>
> Hi folks,
>
> The copy-file-range-fixes branch of the xfs-linux repository at:
>
>         git://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git
>
> has just been updated.  This is a common branch from which everyone else
> can create their own copy-file-range fix branches for 5.3.  When you
> send your pull request to Linus please let him know that the fixes
> stream out from here like some kind of hydra. :)

Thanks Darrick!
Should we also request to include this branch in linux-next?

Attention nfs/cifs/fuse/ceph maintainers!
This branch includes changes to your filesystems.
At lease nfs/cifs/ceph have been tested with these changes and the
new xfstests.

I think it would be preferred if you merge Darrick's branch into your
5.3 branch as soon as you have one ready to reduce chances of
conflicts down the road.

I will be sending out 2 more patches to cifs/ceph, which depend on
this branch directly to maintainers.

Thanks,
Amir.
