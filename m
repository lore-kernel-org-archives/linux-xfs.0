Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-yw1-f68.google.com ([209.85.161.68]:33810 "EHLO
        mail-yw1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726531AbfEaPV5 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 31 May 2019 11:21:57 -0400
MIME-Version: 1.0
References: <20190527172655.9287-1-amir73il@gmail.com> <20190528202659.GA12412@mit.edu>
 <CAOQ4uxgo5jmwQbLAKQre9=7pLQw=CwMgDaWPaJxi-5NGnPEVPQ@mail.gmail.com>
In-Reply-To: <CAOQ4uxgo5jmwQbLAKQre9=7pLQw=CwMgDaWPaJxi-5NGnPEVPQ@mail.gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Fri, 31 May 2019 18:21:45 +0300
Message-ID: <CAOQ4uxgj94WR82iHE4PDGSD0UDxG5sCtr+Sv+t1sOHHmnXFYzQ@mail.gmail.com>
Subject: Re: [RFC][PATCH] link.2: AT_ATOMIC_DATA and AT_ATOMIC_METADATA
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Theodore Ts'o <tytso@mit.edu>
Cc: Jan Kara <jack@suse.cz>, "Darrick J . Wong" <darrick.wong@oracle.com>, Dave Chinner <david@fromorbit.com>, Chris Mason <clm@fb.com>, Al Viro <viro@zeniv.linux.org.uk>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-xfs <linux-xfs@vger.kernel.org>, Ext4 <linux-ext4@vger.kernel.org>, Linux Btrfs <linux-btrfs@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>

> >
> > So instead of saying "A filesystem that accepts this flag will
> > guaranty, that old inode data will not be exposed in the new linked
> > name."  It's much clearer to state this in the affirmative:
> >
> >         A filesystem which accepts this flag will guarantee that if
> >         the new pathname exists after a crash, all of the data written
> >         to the file at the time of the linkat(2) call will be visible.
> >
>
> Sounds good to me. I will take a swing at another patch.
>

So I am down to single flag documented with 3 tweets ;-)

What do you think of:

"AT_ATOMIC_DATA (since Linux 5.x)
A filesystem which accepts this flag will guarantee that if the linked file
name exists after a system crash, then all of the data written to the file
and all of the file's metadata at the time of the linkat(2) call will be
visible.

The way to achieve this guarantee on old kernels is to call fsync (2)
before linking the file, but doing so will also results in flushing of
volatile disk caches.

A filesystem which accepts this flag does NOT
guarantee that any of the file hardlinks will exist after a system crash,
nor that the last observed value of st_nlink (see stat (2)) will persist."


Thanks,
Amir.
