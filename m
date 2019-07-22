Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-oi1-f196.google.com ([209.85.167.196]:35256 "EHLO
        mail-oi1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732448AbfGVUMe (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 22 Jul 2019 16:12:34 -0400
Received: by mail-oi1-f196.google.com with SMTP id a127so30539189oii.2
        for <linux-xfs@vger.kernel.org>; Mon, 22 Jul 2019 13:12:33 -0700 (PDT)
MIME-Version: 1.0
References: <20190722095024.19075-1-hch@lst.de>
In-Reply-To: <20190722095024.19075-1-hch@lst.de>
From: Andreas Gruenbacher <agruenba@redhat.com>
Date: Mon, 22 Jul 2019 22:12:21 +0200
Message-ID: <CAHc6FU6oAsVGDA_7zMRiU=gR6EDh-P2x8sbjxr7XcKn4epS3UQ@mail.gmail.com>
Subject: Re: lift the xfs writepage code into iomap v3
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: "Darrick J . Wong" <darrick.wong@oracle.com>, Damien Le Moal <Damien.LeMoal@wdc.com>, linux-xfs@vger.kernel.org, linux-fsdevel <linux-fsdevel@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>

Hi Christoph,

On Mon, 22 Jul 2019 at 11:50, Christoph Hellwig <hch@lst.de> wrote:
> this series cleans up the xfs writepage code and then lifts it to
> fs/iomap.c so that it could be use by other file system.  I've been
> wanting to this for a while so that I could eventually convert gfs2
> over to it, but I never got to it.  Now Damien has a new zonefs
> file system for semi-raw access to zoned block devices that would
> like to use the iomap code instead of reinventing it, so I finally
> had to do the work.
>
>
> Changes since v2:
>  - rebased to v5.3-rc1
>  - folded in a few changes from the gfs2 enablement series

thanks for the much appreciated update.

I've added that and the remaining gfs2 iomap patches to this branch:

  git://git.kernel.org/pub/scm/linux/kernel/git/gfs2/linux-gfs2.git iomap

Your final patch on this branch, "gfs2: use iomap for buffered I/O in
ordered and writeback mode", still causes the following four xfstest
failures:

  generic/311 generic/322 generic/393 generic/418

The bug in generic/393 is that in the nobh case, when unstuffing an
inode, we fail to dirty the unstuffed page and so the page is never
written. This should be easy to fix. The other failures have other
causes (still investigating).

> Changes since v1:
>  - rebased to the latest xfs for-next tree
>  - keep the preallocated transactions for size updates
>  - rename list_pop to list_pop_entry and related cleanups
>  - better document the nofs context handling
>  - document that the iomap tracepoints are not a stable API

Thanks,
Andreas
