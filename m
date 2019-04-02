Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-io1-f66.google.com ([209.85.166.66]:42275 "EHLO
        mail-io1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731151AbfDBNdu (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 2 Apr 2019 09:33:50 -0400
Received: by mail-io1-f66.google.com with SMTP id c4so10871763ioh.9
        for <linux-xfs@vger.kernel.org>; Tue, 02 Apr 2019 06:33:50 -0700 (PDT)
MIME-Version: 1.0
References: <1554042273-3307-1-git-send-email-alex@zadara.com> <20190402114450.GB2899@bfoster>
In-Reply-To: <20190402114450.GB2899@bfoster>
From: Alex Lyakas <alex@zadara.com>
Date: Tue, 2 Apr 2019 16:33:38 +0300
Message-ID: <CAOcd+r0fc+ctiAX+RrhMdByCmf1yU=E=57wU_a0hm2becTTzKg@mail.gmail.com>
Subject: Re: [STABLE PATCH 0/2] Fix in-memory metadata corruption at xfs_attr3_leaf_write_verify()
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: linux-xfs@vger.kernel.org, stable@vger.kernel.org, "Darrick J. Wong" <darrick.wong@oracle.com>, hch@lst.de, Shyam Kaushik <shyam@zadara.com>

Hi Brian,

On Tue, Apr 2, 2019 at 2:44 PM Brian Foster <bfoster@redhat.com> wrote:
>
> On Sun, Mar 31, 2019 at 05:24:33PM +0300, Alex Lyakas wrote:
> > This is a partial backport of original Darrick's series "xfs: logging fixes" to kernel 4.14.
> > It fixes the in-memory metadata corruption error, which happens
> > when a partially initialized attribute buffer is attemped to be written to disk.
> > This issue is reproducible with kernel 4.14, when adding a 1-sec sleep in xfs_attr_set(),
> > between the call to  xfs_attr_shortform_to_leaf() and the call to xfs_attr_leaf_addname().
> >
>
> For future reference, you probably want to make sure the patch series is
> threaded when it's posted to the list.
I am not sure what you mean by this. I used "git-send-email" to send
all the patches one-by-one. Perhaps you mean that I should have sent
them in one "git-send-email" command?

> That aside, this looks like a
> reasonable and straightforward backport to me:
>
> Acked-by: Brian Foster <bfoster@redhat.com>
I assume that I can treat your "Acked-by" as "Reviewed-by" (Dave asked
for this to pass a review).

Thanks!
Alex.


>
> > Darrick J. Wong (2):
> >   xfs: add the ability to join a held buffer to a defer_ops
> >   xfs: hold xfs_buf locked between shortform->leaf conversion and the
> >     addition of an attribute
> >
> >  fs/xfs/libxfs/xfs_attr.c      | 20 +++++++++++++++-----
> >  fs/xfs/libxfs/xfs_attr_leaf.c |  9 ++++++---
> >  fs/xfs/libxfs/xfs_attr_leaf.h |  3 ++-
> >  fs/xfs/libxfs/xfs_defer.c     | 39 ++++++++++++++++++++++++++++++++++++---
> >  fs/xfs/libxfs/xfs_defer.h     |  5 ++++-
> >  5 files changed, 63 insertions(+), 13 deletions(-)
> >
> > --
> > 1.9.1
> >
