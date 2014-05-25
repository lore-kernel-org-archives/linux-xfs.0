Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id BCBD57F47
	for <xfs@oss.sgi.com>; Sun, 25 May 2014 16:11:40 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 959688F8037
	for <xfs@oss.sgi.com>; Sun, 25 May 2014 14:11:37 -0700 (PDT)
Received: from imap.thunk.org (imap.thunk.org [74.207.234.97]) by cuda.sgi.com
	with ESMTP id 2EGXDrEQzefBstyT (version=TLSv1 cipher=AES128-SHA
	bits=128 verify=NO) for <xfs@oss.sgi.com>;
	Sun, 25 May 2014 14:11:34 -0700 (PDT)
Date: Sun, 25 May 2014 17:11:30 -0400
From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] do_mounts: try all available filesystems before panicking
Message-ID: <20140525211129.GA5243@thunk.org>
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
Cc: Plamen Petrov <plamen.sisi@gmail.com>, sandeen@redhat.com, LKML <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com

On Sun, May 25, 2014 at 01:04:09PM -0700, Linus Torvalds wrote:
> 
> The fact is, I think xfs is just buggy. Returning 38 (ENOSYS) is
> totally insane. "No such system call"? Somebody is on some bad bad
> drugs. Not that the mount_block_root() loop and error handling might
> not be a good thing to perhaps tweak _too_, but at the very least your
> patch means that now it no longer prints out the error number at all.

There's only a single instance of ENOSYS in fs/xfs/xfs_mount.c:

	/*
	 * We must be able to do sector-sized and sector-aligned IO.
	 */
	if (sector_size > sbp->sb_sectsize) {
		if (loud)
			xfs_warn(mp, "device supports %u byte sectors (not %u)",
				sector_size, sbp->sb_sectsize);
		error = ENOSYS;
		goto release_buf;
	}

Plamen, does changing the ENOSYS to EINVAL above fix things for you?

> Anyway, I'm also not seeing why that xfs error would be new to 3.14,
> though.. Adding the XFS people to the cc.

If I had to guess, commit daba5427d is new to 3.14, and it might
explain the change in behavior.

Cheers,

						- Ted

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
