Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 3E2C97F47
	for <xfs@oss.sgi.com>; Sun, 25 May 2014 19:08:21 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 2CD558F8035
	for <xfs@oss.sgi.com>; Sun, 25 May 2014 17:08:18 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	CZJeC6UUdOSLYK9a for <xfs@oss.sgi.com>;
	Sun, 25 May 2014 17:08:16 -0700 (PDT)
Date: Mon, 26 May 2014 10:08:13 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] do_mounts: try all available filesystems before panicking
Message-ID: <20140526000813.GS8554@dastard>
References: <1399314889-9829-1-git-send-email-plamen.sisi@gmail.com>
	<CA+55aFwxF2xnYerLdJZ2gQdZizK3953L16X5KkUAqD-YePausQ@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CA+55aFwxF2xnYerLdJZ2gQdZizK3953L16X5KkUAqD-YePausQ@mail.gmail.com>
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
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Plamen Petrov <plamen.sisi@gmail.com>, LKML <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com

On Sun, May 25, 2014 at 01:04:09PM -0700, Linus Torvalds wrote:
> On Mon, May 5, 2014 at 11:34 AM, Plamen Petrov <plamen.sisi@gmail.com> wrote:
> >
> > The story short: on systems with btrfs root I have a kernel .config with ext4,
> > xfs and btrfs built-in which works fine with 3.13.x, but 3.14.x panics. After
> > inserting some debug printks, I got this info from mount_block_root:
> >
> > ---> EACCESS=13, EINVAL=22, Available filesystems: ext3 ext2 ext4 fuseblk xfs btrfs
> > -----> Tried ext3, error code is -22.
> > -----> Tried ext2, error code is -22.
> > -----> Tried ext4, error code is -22.
> > -----> Tried fuseblk, error code is -22.
> > -----> Tried xfs, error code is -38.
> > VFS: Cannot open root device "sda2" or unknown-block(8,2): error -38
> > Please append a correct "root=" boot option; here are the available partitions:

So, XFS returned ENOSYS to the mount attempt. That means it found
what appears to be a valid XFS superblock at block zero. That is,
the magic number matched, the version was valid, all of the sanity
checks of the values are within supported ranges, and the reason
the mount failed was either a block size larger than page size or an
unsupported inode size. There would have been an error in dmesg to
tell you which.

Can you please send the dmesg output of the failed mount attempt,
as well as the output of:

# dd if=/dev/sda2 bs=512 count=1 | hexdump -C

So we can determine exactly why XFS thought it should be mounting
that block device?

> > Last one tried is xfs, the needed btrfs in this case never gets a chance.
> > Looking at the code in init/do_mounts.c we can see that it "continue"s only if
> > the return code it got is EINVAL, yet xfs clearly does not fit - so the kernel
> > panics. Maybe there are other filesystems like xfs - I did not check. This
> > patch fixes mount_block_root to try all available filesystems first, and then
> > panic. The patched 3.14.x works for me.
> 
> Hmm. I don't really dislike your patch, but it makes all the code
> _after_ the switch-statement dead, since there is now no way to ever
> fall through the switch statement.

I don't think the patch addresses the cause of the problem. The code
is trying to "mount the first filesystem type it finds that
matches", but that match has resulted in a "filesystem cannot be
mounted" error. The cause of the problem is that there's a
difference between "don't understand what is on disk" and
"understand exactly what is on disk and we don't support it".

If we find a superblock match, then there is no other filesystem
type that should be checked regardless of the error that is returned
to upper loop. The loop should only continue if the filesystem
doesn't recognise what is on disk (i.e. EINVAL) is returned.

If it matches, then the filesystem must try to mount the filesystem.
What do you expect a filesystem to do if it has an error
during mount? It's going to return something other than
EINVAL. It could be ENOMEM, EIO, etc, and those cases should
terminate the "search until we find a match" loop.

So, from that persepective the change is simply wrong.

> The fact is, I think xfs is just buggy. Returning 38 (ENOSYS) is
> totally insane. "No such system call"? Somebody is on some bad bad
> drugs. Not that the mount_block_root() loop and error handling might
> not be a good thing to perhaps tweak _too_, but at the very least your
> patch means that now it no longer prints out the error number at all.

Sure, the error might be silly, but it's irrelevant to the patch
being discussed because it could have been one of several different
errors that a failed mount could return. And, besides, XFS has
returned that error for this condition for, well,
more than 10 years:

http://oss.sgi.com/cgi-bin/gitweb.cgi?p=archive/xfs-import.git;a=commitdiff;h=ba4331892d608b4e816b52a4de29693af0dd5c13

IOWs, ENOSYS in this case effectively means "system does not support
filesystem configuration". It's not an invalid superblock (EINVAL)
nor is it a corrupted superblock (EFSCORRUPTED), so it's something
else...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
