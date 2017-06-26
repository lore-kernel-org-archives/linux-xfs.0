Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-ua0-f171.google.com ([209.85.217.171]:35609 "EHLO
        mail-ua0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750752AbdFZOV2 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 26 Jun 2017 10:21:28 -0400
Received: by mail-ua0-f171.google.com with SMTP id j53so1723466uaa.2
        for <linux-xfs@vger.kernel.org>; Mon, 26 Jun 2017 07:21:27 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20170626095010.GA14057@infradead.org>
References: <1498224884-346-1-git-send-email-agruenba@redhat.com> <20170626095010.GA14057@infradead.org>
From: Andreas Gruenbacher <agruenba@redhat.com>
Date: Mon, 26 Jun 2017 16:21:26 +0200
Message-ID: <CAHc6FU7-5LddvvPfEpDRSYRx918hLBjyhhzK8fSQWakOjFH6XA@mail.gmail.com>
Subject: Re: [PATCH v2 0/6] SEEK_HOLE / SEEK_DATA via iomap
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-xfs@vger.kernel.org, cluster-devel <cluster-devel@redhat.com>, Jan Kara <jack@suse.cz>

On Mon, Jun 26, 2017 at 11:50 AM, Christoph Hellwig <hch@infradead.org> wrote:
> On Fri, Jun 23, 2017 at 03:34:38PM +0200, Andreas Gruenbacher wrote:
>> These patches, on top of the page_cache_seek_hole_data patches posted earlier
>> today, convert xfs to implement SEEK_HOLE / SEEK_DATA via iomap, and implement
>> SEEK_HOLE / SEEK_DATA via iomap in gfs2.
>
> Please send those as one series - in fact to me the previous
> series doesn't even make sense - just introduce page_cache_seek_hole_data
> for the iomap code only as everyone should be using that.
>
>> ext4 doesn't implement IOMAP_REPORT, so it can't be switched to use the iomap
>> based SEEK_HOLE / SEEK_DATA or fiemap code so far.
>
> Just treat it as a no-op, it only really matters for the reflink case.

I'm actually not sure what you're talking about. The
page_cache_seek_hole_data patches fix a bug in the lseek
implementations of xfs and ext4. We want those bugs to be fixed on
both filesystems. On ext4, we cannot switch to iomap_seek_hole_data
because ext4 doesn't implement IOMAP_REPORT. We also cannot fall back
to a dummy IOMAP_REPORT function that reports the whole file as data
because that would be a regression -- after all, ext4 supports lseek
SEEK_HOLE / SEEK_DATA already.

We could squash the two xfs patches together, but __xfs_seek_hole_data
can only be removed once your patch for cleaning up the quota code is
merged, so the combined patch would convert __xfs_seek_hole_data to
use page_cache_seek_hole_data and xfs_seek_hole_data to use
iomap_seek_hole_data at the same time, which is a bit messy.

Thanks,
Andreas
