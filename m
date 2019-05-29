Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-yb1-f195.google.com ([209.85.219.195]:45716 "EHLO
        mail-yb1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725880AbfE2FjB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 29 May 2019 01:39:01 -0400
MIME-Version: 1.0
References: <20190527172655.9287-1-amir73il@gmail.com> <20190528202659.GA12412@mit.edu>
In-Reply-To: <20190528202659.GA12412@mit.edu>
From: Amir Goldstein <amir73il@gmail.com>
Date: Wed, 29 May 2019 08:38:49 +0300
Message-ID: <CAOQ4uxgo5jmwQbLAKQre9=7pLQw=CwMgDaWPaJxi-5NGnPEVPQ@mail.gmail.com>
Subject: Re: [RFC][PATCH] link.2: AT_ATOMIC_DATA and AT_ATOMIC_METADATA
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Theodore Ts'o <tytso@mit.edu>
Cc: Jan Kara <jack@suse.cz>, "Darrick J . Wong" <darrick.wong@oracle.com>, Dave Chinner <david@fromorbit.com>, Chris Mason <clm@fb.com>, Al Viro <viro@zeniv.linux.org.uk>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-xfs <linux-xfs@vger.kernel.org>, Ext4 <linux-ext4@vger.kernel.org>, Linux Btrfs <linux-btrfs@vger.kernel.org>, linux-api@vger.kernel.org

On Tue, May 28, 2019 at 11:27 PM Theodore Ts'o <tytso@mit.edu> wrote:
>
> On Mon, May 27, 2019 at 08:26:55PM +0300, Amir Goldstein wrote:
> >
> > Following our discussions on LSF/MM and beyond [1][2], here is
> > an RFC documentation patch.
> >
> > Ted, I know we discussed limiting the API for linking an O_TMPFILE
> > to avert the hardlinks issue, but I decided it would be better to
> > document the hardlinks non-guaranty instead. This will allow me to
> > replicate the same semantics and documentation to renameat(2).
> > Let me know how that works out for you.
> >
> > I also decided to try out two separate flags for data and metadata.
> > I do not find any of those flags very useful without the other, but
> > documenting them seprately was easier, because of the fsync/fdatasync
> > reference.  In the end, we are trying to solve a social engineering
> > problem, so this is the least confusing way I could think of to describe
> > the new API.
>
> The way you have stated thigs is very confusing, and prone to be
> misunderstood.  I think it would be helpful to state things in the
> positive, instead of the negative.
>
> Let's review what you had wanted:
>
>         *If* the filename is visible in the directory after the crash,
>         *then* all of the metadata/data that had been written to the file
>         before the linkat(2) would be visible.
>
>         HOWEVER, you did not want to necessarily force an fsync(2) in
>         order to provide that guarantee.  That is, the filename would
>         not necessarily be guaranteed to be visible after a crash when
>         linkat(2) returns, but if the existence of the filename is
>         persisted, then the data would be too.
>
>         Also, at least initially we talked about this only making
>         sense for O_TMPFILE file desacriptors.  I believe you were
>         trying to generalize things so it wouldn't necessarily have to
>         be a file created using O_TMPFILE.  Is that correct?

That is correct. I felt we were limiting ourselves only to avert the
hardlinks issue, so decided its better to explain that "nlink is not
part of the inode metadata" that this guarantee refers to.
I would be happy to get your feedback about the hardlink disclaimer
since you brought up the concern. It the disclaimer enough?
Not needed at all?

>
> So instead of saying "A filesystem that accepts this flag will
> guaranty, that old inode data will not be exposed in the new linked
> name."  It's much clearer to state this in the affirmative:
>
>         A filesystem which accepts this flag will guarantee that if
>         the new pathname exists after a crash, all of the data written
>         to the file at the time of the linkat(2) call will be visible.
>

Sounds good to me. I will take a swing at another patch.

Thanks for the review!
Amir.
