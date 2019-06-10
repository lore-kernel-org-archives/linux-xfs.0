Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-it1-f196.google.com ([209.85.166.196]:53833 "EHLO
        mail-it1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388841AbfFJTYA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 10 Jun 2019 15:24:00 -0400
MIME-Version: 1.0
References: <20190610174007.4818-1-amir73il@gmail.com>
In-Reply-To: <20190610174007.4818-1-amir73il@gmail.com>
From: Ilya Dryomov <idryomov@gmail.com>
Date: Mon, 10 Jun 2019 21:24:07 +0200
Message-ID: <CAOi1vP-ad+62U4hBkSetFq+8kxC2fhmCLzcHZ+=wYBqgTyyy7g@mail.gmail.com>
Subject: Re: [PATCH] ceph: copy_file_range needs to strip setuid bits and
 update timestamps
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Amir Goldstein <amir73il@gmail.com>
Cc: "Darrick J . Wong" <darrick.wong@oracle.com>, Dave Chinner <david@fromorbit.com>, Christoph Hellwig <hch@lst.de>, xfs <linux-xfs@vger.kernel.org>, Luis Henriques <lhenriques@suse.com>, Al Viro <viro@zeniv.linux.org.uk>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Ceph Development <ceph-devel@vger.kernel.org>, "Yan, Zheng" <zyan@redhat.com>, Jeff Layton <jlayton@redhat.com>

On Mon, Jun 10, 2019 at 7:40 PM Amir Goldstein <amir73il@gmail.com> wrote:
>
> Because ceph doesn't hold destination inode lock throughout the copy,
> strip setuid bits before and after copy.
>
> The destination inode mtime is updated before and after the copy and the
> source inode atime is updated after the copy, similar to the filesystem
> ->read_iter() implementation.
>
> Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> ---
>
> Hi Ilya,
>
> Please consider applying this patch to ceph branch after merging
> Darrick's copy-file-range-fixes branch from:
>         git://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git
>
> The series (including this patch) was tested on ceph by
> Luis Henriques using new copy_range xfstests.
>
> AFAIK, only fallback from ceph to generic_copy_file_range()
> implementation was tested and not the actual ceph clustered
> copy_file_range.

Zheng, Jeff, please take a look.

Thanks,

                Ilya
