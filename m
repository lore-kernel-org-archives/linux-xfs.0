Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:44364 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754153AbdKNRR5 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 14 Nov 2017 12:17:57 -0500
Date: Tue, 14 Nov 2017 12:17:44 -0500
From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [btrfs] WARNING: CPU: 0 PID: 6379 at fs/direct-io.c:293
 dio_complete+0x1d4/0x220
Message-ID: <20171114171744.463cudlhypbevja3@thunk.org>
References: <20171030072021.gcgpaolo5m3myuln@wfg-t540p.sh.intel.com>
 <20171030074429.GC3283@eguan.usersys.redhat.com>
 <20171031001041.5qjzn5pjertpdc3e@wfg-t540p.sh.intel.com>
 <20171031065417.GD3283@eguan.usersys.redhat.com>
 <20171106011306.GB11631@zzz.localdomain>
 <20171113191322.GA123488@gmail.com>
 <ff823a95-3dff-0f2b-13ab-aab9bed7b0d3@kernel.dk>
 <CA+55aFxv4jVzoa_NpYOq=+TVpBvbSmJq++dPW5nmWNdxUEc-8Q@mail.gmail.com>
 <20171113215601.GD6246@magnolia>
 <CA+55aFzQM747SW959w3CDD=6UypUa7XTqEyHnPaTcFCX+vDLGA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFzQM747SW959w3CDD=6UypUa7XTqEyHnPaTcFCX+vDLGA@mail.gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>, Jens Axboe <axboe@kernel.dk>, Eric Biggers <ebiggers3@gmail.com>, Eryu Guan <guaneryu@gmail.com>, Fengguang Wu <fengguang.wu@intel.com>, Lukas Czerner <lczerner@redhat.com>, Jan Kara <jack@suse.cz>, Jeff Moyer <jmoyer@redhat.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, xfs <linux-xfs@vger.kernel.org>

On Mon, Nov 13, 2017 at 02:01:36PM -0800, Linus Torvalds wrote:
> 
> And in the end, maybe even the warning is pointless. You used
> direct-IO and cached IO at the same time, and you got coherency
> issues. What did you expect? directio is fundamentally broken.

A single warning per inode, "page cache coherency broken due to direct
I/O; userspace did a dumb thing; oh, well" is probably more than
sufficient.  The reason to have the warning is so that when the user
complains about the file system bug, we can point at the "userspace
did a dumb thing" warning message.

						- Ted
