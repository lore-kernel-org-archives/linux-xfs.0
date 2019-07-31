Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-qk1-f196.google.com ([209.85.222.196]:45618 "EHLO
        mail-qk1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726300AbfGaRuw (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 31 Jul 2019 13:50:52 -0400
MIME-Version: 1.0
References: <20190731171734.21601-1-willy@infradead.org>
In-Reply-To: <20190731171734.21601-1-willy@infradead.org>
From: Song Liu <liu.song.a23@gmail.com>
Date: Wed, 31 Jul 2019 10:50:40 -0700
Message-ID: <CAPhsuW66e=7g+rPhi3NU8jQRGqQEz0oQ5XJerg6ds=oxMz8U1g@mail.gmail.com>
Subject: Re: [RFC 0/2] iomap & xfs support for large pages
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Matthew Wilcox <willy@infradead.org>, William Kucharski <william.kucharski@oracle.com>
Cc: Linux-Fsdevel <linux-fsdevel@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org, Linux-MM <linux-mm@kvack.org>

On Wed, Jul 31, 2019 at 10:17 AM Matthew Wilcox <willy@infradead.org> wrote:
>
> From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
>
> Christoph sent me a patch a few months ago called "XFS THP wip".
> I've redone it based on current linus tree, plus the page_size() /
> compound_nr() / page_shift() patches currently found in -mm.  I fixed
> the logic bugs that I noticed in his patch and may have introduced some
> of my own.  I have only compile tested this code.

Would Bill's set work on XFS with this set?

Thanks,
Song

>
> Matthew Wilcox (Oracle) (2):
>   iomap: Support large pages
>   xfs: Support large pages
>
>  fs/iomap/buffered-io.c | 82 ++++++++++++++++++++++++++----------------
>  fs/xfs/xfs_aops.c      | 37 +++++++++----------
>  include/linux/iomap.h  |  2 +-
>  3 files changed, 72 insertions(+), 49 deletions(-)
>
> --
> 2.20.1
>
