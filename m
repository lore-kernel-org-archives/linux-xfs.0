Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-it0-f65.google.com ([209.85.214.65]:38459 "EHLO
        mail-it0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755252AbeFNNEj (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 14 Jun 2018 09:04:39 -0400
Received: by mail-it0-f65.google.com with SMTP id v83-v6so8549428itc.3
        for <linux-xfs@vger.kernel.org>; Thu, 14 Jun 2018 06:04:39 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20180614120457.28285-1-hch@lst.de>
References: <20180614120457.28285-1-hch@lst.de>
From: Andreas Gruenbacher <agruenba@redhat.com>
Date: Thu, 14 Jun 2018 15:04:38 +0200
Message-ID: <CAHc6FU4nQ562SxepV1=dqcuuuPBWOTXr4sAiY_5H-Z7uOaTNng@mail.gmail.com>
Subject: Re: iomap preparations for GFS2 v2
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org, Dan Williams <dan.j.williams@intel.com>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, cluster-devel <cluster-devel@redhat.com>, linux-ext4 <linux-ext4@vger.kernel.org>

On 14 June 2018 at 14:04, Christoph Hellwig <hch@lst.de> wrote:
> Hi all,
>
> this is a slight rework of the patches from Andreas to prepare for gfs2
> using the iomap code.
>
> Note: I'd like to start with an immutable branch for iomap patches in either
> the XFS tree or a tree of mine at the beginning of the merge window so that
> we have a common base for the GFS2 and XFS iomap work.
>
> Changes since v1:
>  - move code to a different spot in iomap.c to prefer for readpages
>    inline data support
>  - add a forward declaration for struct page to iomap.h
>  - fix a typo in the dax_dev/bdev unioning
>  - fix a comment typo

I saw that you've pushed this onto the gfs2-iomap branch in your xfs
repository. I've rebased the gfs2 iomap-write branch onto that;
there's a trivial patch for adding a private pointer to struct iomap
at the head of that branch that would sense to move to the shared
branch as well now.

The next step would probably be to start using iomap_readpage /
iomap_readpages in gfs2 for block size == page size. This requires
adding inline data support to iomap_readpage which is trivial, but
because of gfs2's reliance on buffer heads, that alone isn't enough.

Thanks,
Andreas
