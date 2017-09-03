Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-qk0-f182.google.com ([209.85.220.182]:33866 "EHLO
        mail-qk0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752847AbdICOJK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 3 Sep 2017 10:09:10 -0400
Received: by mail-qk0-f182.google.com with SMTP id z143so2092636qkb.1
        for <linux-xfs@vger.kernel.org>; Sun, 03 Sep 2017 07:09:10 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20170903074306.GA8351@infradead.org>
References: <CABXGCsOL+_OgC0dpO1+Zeg=iu7ryZRZT4S7k-io8EGB0ZRgZGw@mail.gmail.com>
 <20170903074306.GA8351@infradead.org>
From: =?UTF-8?B?0JzQuNGF0LDQuNC7INCT0LDQstGA0LjQu9C+0LI=?=
        <mikhail.v.gavrilov@gmail.com>
Date: Sun, 3 Sep 2017 19:08:54 +0500
Message-ID: <CABXGCsMmEvEh__R2L47jqVnxv9XDaT_KP67jzsUeDLhF2OuOyA@mail.gmail.com>
Subject: Re: kernel BUG at fs/xfs/xfs_aops.c:853! in kernel 4.13 rc6
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-xfs@vger.kernel.org, linux-mm@kvack.org

On 3 September 2017 at 12:43, Christoph Hellwig <hch@infradead.org> wrote:
>
> This is:
>
>         bh = head = page_buffers(page);
>
> Which looks odd and like some sort of VM/writeback change might
> have triggered that we get a page without buffers, despite always
> creating buffers in iomap_begin/end and page_mkwrite.
>
> Ccing linux-mm if anything odd happen in that area recently.
>
> Can you tell anything about the workload you are running?
>

On XFS partition stored launched KVM VM images, + home partition with
Google Chrome profiles.
Seems the bug triggering by high memory consumption and using swap
which two times larger than system memory.
I saw that it happens when swap has reached size of system memory.

--
Best Regards,
Mike Gavrilov.
