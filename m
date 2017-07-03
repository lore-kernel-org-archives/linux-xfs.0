Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-ua0-f182.google.com ([209.85.217.182]:34963 "EHLO
        mail-ua0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755513AbdGCPD4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 3 Jul 2017 11:03:56 -0400
Received: by mail-ua0-f182.google.com with SMTP id j53so111081317uaa.2
        for <linux-xfs@vger.kernel.org>; Mon, 03 Jul 2017 08:03:56 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20170630173740.GB11420@lst.de>
References: <20170629135420.21357-1-hch@lst.de> <20170629135420.21357-6-hch@lst.de>
 <CAHc6FU4u+G1gtZVr3CUbJi2i+GwWhfDUOZemQ4Nnde=uiOmjXA@mail.gmail.com> <20170630173740.GB11420@lst.de>
From: Andreas Gruenbacher <agruenba@redhat.com>
Date: Mon, 3 Jul 2017 17:03:54 +0200
Message-ID: <CAHc6FU4rK3cg+nYeOSSJirKoYiuApV9KauqE_iar+7Q7X6g20A@mail.gmail.com>
Subject: Re: [PATCH 5/5] ext4: Switch to iomap for SEEK_HOLE / SEEK_DATA
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: Jan Kara <jack@suse.cz>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-xfs@vger.kernel.org, linux-ext4 <linux-ext4@vger.kernel.org>

On Fri, Jun 30, 2017 at 7:37 PM, Christoph Hellwig <hch@lst.de> wrote:
> On Fri, Jun 30, 2017 at 01:51:10PM +0200, Andreas Gruenbacher wrote:
>> Also, ext4 no longer calls inode_lock or inode_lock_shared; that needs
>> to be added back for consistency between reading i_size and walking
>> the file extents.
>
> At least for XFS we never had such a consistency as we never took
> the iolock (aka i_rwsem).

What else does this piece of code from mainline xfs_seek_hole_data()
do instead then?

        lock = xfs_ilock_data_map_shared(ip);

        end = i_size_read(inode);
        offset = __xfs_seek_hole_data(inode, start, end, whence);

Thanks,
Andreas
