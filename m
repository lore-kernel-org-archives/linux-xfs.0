Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 22BE77F56
	for <xfs@oss.sgi.com>; Tue,  2 Dec 2014 13:23:46 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 114F48F8033
	for <xfs@oss.sgi.com>; Tue,  2 Dec 2014 11:23:42 -0800 (PST)
Received: from imap.thunk.org (imap.thunk.org [74.207.234.97]) by cuda.sgi.com
	with ESMTP id B52FsfVY5BSByqci (version=TLSv1 cipher=AES128-SHA
	bits=128 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 02 Dec 2014 11:23:41 -0800 (PST)
Date: Tue, 2 Dec 2014 14:23:37 -0500
From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH-v5 1/5] vfs: add support for a lazytime mount option
Message-ID: <20141202192337.GA13618@thunk.org>
References: <1417154411-5367-1-git-send-email-tytso@mit.edu>
	<1417154411-5367-2-git-send-email-tytso@mit.edu>
	<20141128172323.GD738@quack.suse.cz>
	<20141128181421.GA19461@google.com>
	<20141202125820.GE9092@quack.suse.cz>
	<547DFD24.9070805@plexistor.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <547DFD24.9070805@plexistor.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Boaz Harrosh <boaz@plexistor.com>
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, Jan Kara <jack@suse.cz>, linux-btrfs@vger.kernel.org, xfs@oss.sgi.com

On Tue, Dec 02, 2014 at 07:55:48PM +0200, Boaz Harrosh wrote:
> 
> This I do not understand. I thought that I_DIRTY_TIME, and the all
> lazytime mount option, is only for atime. So if there are dirty
> pages then there are also m/ctime that changed and surly we want to
> write these times to disk ASAP.

What are the situations where you are most concerned about mtime or
ctime being accurate after a crash?

I've been running with it on my laptop for a while now, and it's
certainly not a problem for build trees; remember, whenever you need
to update the inode to update i_blocks or i_size, the inode (with its
updated timestamps) will be flushed to disk anyway.

In actual practice, what happens in a build tree is that when make
decides that it needs to update a generated file, when the file is
created as a zero-length inode, m/ctime will be set to the time that
file is created, which is newer than its source files.  As the file is
written, the mtime is updated each time that we actually need to do an
allocating write.  In the case of the linker, it will seek to the
beginning of the file to update ELF header at the very end of its
operation, and *that* time will be left stale, such that the in-memory
mtime is perhaps a millisecond ahead of the on-disk mtime.  But in the
case of a crash, either time is such that make won't be confused.

I'm not aware of an application which is doing a large number of
non-allocating random writes (for example, such as a database), where
said database actually cares about mtime being correct.  In fact, most
databases use fdatasync() to prevent the mtimes from being sync'ed out
to disk on each transaction, so they don't have guaranteed timestamp
accuracy after a crash anyway.  The problem is even if the database is
using fdatasync(), every five seconds we end up updating the mtime
anyway --- and in the case of ext4, we end up needing to take various
journal locks which on a sufficiently parallel workload and a
sufficiently fast disk, can actually cause measurable contention.

Did you have such a use case or application in mind?

> if we are lazytime also with m/ctime then I think I would like an
> option for only atime lazy. because m/ctime is cardinal to some
> operations even though I might want atime lazy.

If there's a sufficiently compelling use case where we do actually
care about mtime/ctime being accurate, and the current semantics don't
provide enough of a guarantee, it's certainly something we could do.
I'd rather keep things simple unless it's really there.  (After all,
we did create the strictatime mount option, but I'm not sure anyone
every ends up using it.  It woud be a shame if we created a
strictcmtime, which had the same usage rate.)

I'll also note that if it's only about atime updates, with the default
relatime mount option, I'm not sure there's enough of a win to hae a
mode to justify a lazyatime only option.  If you really neeed strict
c/mtime after a crash, maybe the best thing to do is to just simply
not use the lazytime mount option and be done with it.

Cheeres,

					- Ted

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
