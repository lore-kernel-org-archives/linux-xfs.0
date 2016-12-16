Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail04.adl6.internode.on.net ([150.101.137.141]:35608 "EHLO
        ipmail04.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1754042AbcLPA7d (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 15 Dec 2016 19:59:33 -0500
Date: Fri, 16 Dec 2016 11:53:26 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 5/6] xfs_io: make various commands one-shot only
Message-ID: <20161216005326.GK4326@dastard>
References: <20161207034724.1613-1-david@fromorbit.com>
 <20161207034724.1613-6-david@fromorbit.com>
 <fec1a6dd-cebd-1ff4-e916-f696139b876e@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fec1a6dd-cebd-1ff4-e916-f696139b876e@sandeen.net>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: linux-xfs@vger.kernel.org, fstests@vger.kernel.org, amir73il@gmail.com

On Thu, Dec 15, 2016 at 12:21:43PM -0600, Eric Sandeen wrote:
> On 12/6/16 9:47 PM, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > It makes no sense to iterate the file table for some xfs_io
> > commands. Some commands are already marked in this way, but lots of
> > them are not and this leads to bad behaviour. For example, the open
> > command will run until the process fd table is full and EMFILE is
> > returned rather than just opening the specified file once.
> 
> Ok, I'm not quite clear on when we should expect commands to be
> "oneshot"
> 
> With freeze, for example, this:
> 
> xfs_io -x -c freeze mnt/file mnt2/file
> 
> will freeze both filesystems today.  With this change,

xfs_freeze will ignore multiple filesystem options, so it only ever
passes a single file to xfs_io.  IOWs, it's behaviour will be
completely unchanged by making the xfs_io freeze command a one-shot
command.

And right now, I think that's the only case we have to care about.
unless someone is actually using xfs_io directly to freeze multiple
filesystems like this, then I think it's better to make it a
one-shot command.

> xfs_io -x -c freeze mnt/file mnt2/file
> 
> freezes the mnt2 filesystem but not mnt.  Is that desired?

It's exactly what the man page says the freeze command does.

> I guess the command /is/ documented as "freeze fs of /current/ file"
> but i wonder if that's just an accident of documentation.

If the man page documents it as operating on the current file,
but instead it freezes all the open files, then that's a bug that
needs fixing.

> ditto for i.e. the inode command, or resblks - why not
> iterate those?

Because they are aimed at single, specific filesystem operations
only. It just doesn't make sense to iterate them across all open
files inside xfs_io. If you have multiple filesystems youneed to
query/modify, then do an xfs_io call for each. 

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
