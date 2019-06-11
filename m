Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-yb1-f193.google.com ([209.85.219.193]:40619 "EHLO
        mail-yb1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391474AbfFKQHU (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 11 Jun 2019 12:07:20 -0400
MIME-Version: 1.0
References: <20190611153916.13360-1-amir73il@gmail.com> <20190611153916.13360-2-amir73il@gmail.com>
 <20190611155925.GA5081@mit.edu>
In-Reply-To: <20190611155925.GA5081@mit.edu>
From: Amir Goldstein <amir73il@gmail.com>
Date: Tue, 11 Jun 2019 19:07:08 +0300
Message-ID: <CAOQ4uxiZxJk1qwuKCJQvYggx_km4yzvjaAWn8ow5pLjmPnceHA@mail.gmail.com>
Subject: Re: [PATCH v2 2/2] generic/554: test only copy to active swap file
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Theodore Ts'o <tytso@mit.edu>
Cc: Eryu Guan <guaneryu@gmail.com>, "Darrick J . Wong" <darrick.wong@oracle.com>, Dave Chinner <david@fromorbit.com>, fstests <fstests@vger.kernel.org>, linux-xfs <linux-xfs@vger.kernel.org>

On Tue, Jun 11, 2019 at 6:59 PM Theodore Ts'o <tytso@mit.edu> wrote:
>
> On Tue, Jun 11, 2019 at 06:39:16PM +0300, Amir Goldstein wrote:
> > Depending on filesystem, copying from active swapfile may be allowed,
> > just as read from swapfile may be allowed.
> >
> > Note the kernel fix commit in test description.
> >
> > Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> >
> > Per your and Ted's request, I've documented the kernel fix commit
> > in the new copy_range tests. Those commits are now on Darrick's
> > copy-file-range-fixes branch, which is on its way to linux-next
> > and to kernel 5.3.
>
> Thanks!  Are we sure at this point that the commit won't need to be
> modified / rebased in Darrick's tree?
>

Yes. The intention is that fs maintainers can now rebase their
v5.3 development branch on this non-rewindable branch.

Note that you do still need to merge the fixes from Darrick's branch
for ext4 to pass this test despite relaxing the "copy from swapfile" test case.

Thanks,
Amir.
