Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-qk1-f194.google.com ([209.85.222.194]:45849 "EHLO
        mail-qk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731238AbfHOLCh (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 15 Aug 2019 07:02:37 -0400
MIME-Version: 1.0
References: <20190814204259.120942-1-arnd@arndb.de> <20190814204259.120942-2-arnd@arndb.de>
 <20190814213753.GP6129@dread.disaster.area> <20190815071314.GA6960@infradead.org>
 <CAK8P3a2Hjfd49XY18cDr04ZpvC5ZBGudzxqpCesbSsDf1ydmSA@mail.gmail.com>
 <20190815080211.GA17055@infradead.org> <20190815102649.GA10821@infradead.org>
In-Reply-To: <20190815102649.GA10821@infradead.org>
From: Arnd Bergmann <arnd@arndb.de>
Date: Thu, 15 Aug 2019 13:02:19 +0200
Message-ID: <CAK8P3a0jEsJbpkgKrjWNOsDSvQv5AXq_P7A92zr4my+uMnZijw@mail.gmail.com>
Subject: Re: [PATCH v5 01/18] xfs: compat_ioctl: use compat_ptr()
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: Dave Chinner <david@fromorbit.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Al Viro <viro@zeniv.linux.org.uk>, Linux FS-devel Mailing List <linux-fsdevel@vger.kernel.org>, "Darrick J. Wong" <darrick.wong@oracle.com>, linux-xfs <linux-xfs@vger.kernel.org>, Brian Foster <bfoster@redhat.com>, Allison Collins <allison.henderson@oracle.com>, Nick Bowler <nbowler@draconx.ca>, Eric Sandeen <sandeen@sandeen.net>, Dave Chinner <dchinner@redhat.com>

On Thu, Aug 15, 2019 at 12:26 PM Christoph Hellwig <hch@infradead.org> wrote:
>
> On Thu, Aug 15, 2019 at 01:02:11AM -0700, Christoph Hellwig wrote:
> > In many ways I'd actually much rather have a table driven approach.
> > Let me try something..
>
> Ok, it seems like we don't even need a table containing native and
> compat as we can just fall back.  The tables still seem nicer to read,
> though.
>
> Let me know what you think of this:
>
> http://git.infradead.org/users/hch/xfs.git/shortlog/refs/heads/xfs-ioctl-table

These all look like useful cleanups, but I'm a little worried about introducing
merge conflicts with my own patches. I would want to have my series get
merged as a complete branch since each patch that removes a bit of
fs/compat_ioctl.c would clash with a patch removing the adjacent bits
otherwise.

I still haven't heard from Al regarding what he thinks of my v5 series.
If he wants me to send a pull request for it, I can of course add in
your patches  after they are fully reviewed.

> I also wonder if we should life the ioctl handler tables to the VFS.

The idea of these tables has come up a few times in the past,
and there are a couple of subsystems that have something like it,
e.g. drivers/media.

Usually you'd want to combine the table with a more generic way to
do the copy_from_user()/copy_to_user() on the argument, but that
in turn requires all commands to be defined correctly (a lot of drivers
have some commands that specify the wrong direction or the wrong
size, or one that predates the _IO() macro).

What I could imaging having in the long run is to have the ioctl table
attached to the file_operations structure, and then define it in a way
that handles at least the more common variations:

- copy_from_user to stack, pass a kernel pointer to handler
- a single entry for commands that are 32/64-bit compatible
- entries that are only used for native vs compat mode if they
  have incompatible arguments (this could also be handled
  by calling in_compat_syscall() in the handler itself).
- a flag to specify handlers that require the __user pointer instead
  of the implied copy.

Doing this right will certainly require several revisions of patch
series and lots of discussions, and is unrelated to the removal
of fs/compat_ioctl.c, so I'd much prefer to get this series merged
before we start working on that.

       Arnd
