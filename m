Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:37177 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751581AbdGACfd (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Jun 2017 22:35:33 -0400
Date: Fri, 30 Jun 2017 19:35:29 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: Any tips for moving to reflink?
Message-ID: <20170701023529.GP5874@birch.djwong.org>
References: <CAHJqNbyngon0T1wnYpM6f+cWYzCrZjM9a6mp54QHgayeS9Bq5A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHJqNbyngon0T1wnYpM6f+cWYzCrZjM9a6mp54QHgayeS9Bq5A@mail.gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Alphazo <alphazo@gmail.com>
Cc: linux-xfs@vger.kernel.org

On Fri, Jun 30, 2017 at 10:33:03AM +0200, Alphazo wrote:
> Hello,
> 
> xfs never stops impressing me. Most if not all of my storage has been
> converted to it, including a 30TB+ unRaid server. I have been
> contemplating snapshot and dedup enabled filesystems like btrfs and
> ZFS but couldn't justify the jump. The new xfs reflink feature seems a
> good addition and compromise to a stable and proven filesystem.
> I'm strongly considering using the experimental reflink feature for my
> new photo drive.

FWIW, reflink is still an experimental feature and not production ready,
so beware that it could eat your backups...

> This will be done in a controlled environment with multiple backups.

...so good to hear this.  Note that the copy-on-write side of reflink
can fragment files and filesystems more heavily than 

> Are there any general rules of conduct when working with a dedup
> filesystem, like never go above 80% disk usage

That's a pretty good rule of thumb for a filesystem regardless of
whether it supports reflink. :)

That said, we do try to reserve space for future metadata expansion
to avoid running out of space and crashing the fs.

> or never trust df/dh results?

The free counts should be accurate, space reservations notwithstanding.

> Also is there any risk of trying to mount a reflink enabled xfs
> filesystem on an older kernel that doesn't know about it?

No, we set a feature flag bit for reflink (and rmap) so that old
kernels will not try to write to an fs they don't understand.

> I don't think I need it for the moment but would enabling rmapbt as
> well add any risk to the data integrity

It shouldn't.

> or impact performance?

It will, on account of having to update the rmap metadata.

> Can rmapbt be enabled later on an existing filesystem if required?

No.

> Will rmpabt be only used to enhance filesystem recovery?

It may some day be used to implement online shrink, but for now the only
things that /could/ use it are xfs_repair and online fsck.

> I'm planning to use this reflink feature for instant local snapshots
> and then use my backup software of choice, borg, to keep a long time
> history of my work on a remote server. Since borg stores data in a
> dedup fashion I can also backup the reflink snapshots and they won't
> take additional space. The only drawback is that today borg need to
> hash all the files found in a reflink directory in order to find out
> about dedup blocks. I asked a question on the borg mailing list
> https://github.com/borgbackup/borg/issues/2743 and apparently it won't
> be an issue to add a feature to support XFS in order to identify the
> physical extents. Is rmapbt required for that?

borgbackup will probably need to call the GETFSMAP ioctl, which won't
land until 4.12.  On xfs, rmapbt is needed to supply data block
ownership info, which is what borgbackup (and bees, and...) say they
want to be smarter about dedup.

Good luck!

--D

> Alphazo
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
