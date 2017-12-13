Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:45193 "EHLO
        ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753360AbdLMV3J (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 13 Dec 2017 16:29:09 -0500
Received: from dave by dastard with local (Exim 4.80)
        (envelope-from <david@fromorbit.com>)
        id 1ePEaQ-0004vy-G8
        for linux-xfs@vger.kernel.org; Thu, 14 Dec 2017 08:29:06 +1100
Date: Thu, 14 Dec 2017 08:29:06 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: fallocate behavior on -ENOSPC for blocks past EOF
Message-ID: <20171213212906.GA5858@dastard>
References: <20171213161611.53oavmzhnsum2fqc@odin.usersys.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171213161611.53oavmzhnsum2fqc@odin.usersys.redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

On Wed, Dec 13, 2017 at 05:16:11PM +0100, Carlos Maiolino wrote:
> We have talked a bit about it on irc before but iirc we didn't end on any
> conclusion about it.
> 
> Current fallocate behavior on XFS in case it hits -ENOSPC in the middle of the
> reservation is kind of weird now when these new blocks are allocated past EOF.
> 
> We end up not changing the i_size to match the partial blocks allocated even if
> fallocate is not called with KEEP_SIZE.
> 
> Such behavior is confusing some users of fallocate, and I've been talking to
> Eric if wouldn't be better to update the i_size to match the partially allocated
> blocks IF KEEP_SIZE has not been used.

What's the confusion? fallocate is supposed to provide the backing
for posix_fallocate(), which either succeeds completely or returns
an error. posix_fallocate() specifically states that:

	If the offset+ len is beyond the current file size, then
	posix_fallocate() shall adjust the file size to offset+ len.
	Otherwise, the file size shall not be changed.

(http://pubs.opengroup.org/onlinepubs/009695399/functions/posix_fallocate.html)

IOWs, setting the file size to anything other than offset+len
is not allowed (it's a "shall" definition which means we must follow
that exact behaviour), and hence on failure we have only two choices:

	a) lie to the user and extend the file even though we didn't
	preallocate all the space; or

	b) don't change the file size so there's no visible change
	to the file on failure.

We've chosen b) when fallocate fails for *any reason*. IOWs, the
file appears unchanged to the user on failure so they don't have to
handle undoing a failed partial operation.

> I know though that fallocate behavior is kind of undefined in this case, but I

Seems pretty clearly defined to me :/

> wonder if is there anything we could agree to improve to make it less confusing
> for fallocate users, or at least agree if this is the behavior we want in XFS.
> 
> Maybe is worth to mention though, that by now, we release any unwritten extent
> past EOF at certain points in the code (/me don't remember exactly where by
> now).

In general, that does not happen with preallocated files. Successful
preallocation sets the inode flag XFS_DIFLAG_PREALLOC, which turns
off the post-EOF extent removal code for that inode. Preallocation
is persistent, speculative allocation beyond EOF (such as done by
delayed allocation) is not.

However, if fallocate fails with ENOSPC, then we don't set that
flag, so if there hasn't been any other preallocation we will clean
up the blocks beyond EOF eventually without the user needing to do
anything. That's not a guarantee, though, because previous
preallocations could have set that flag....

I think, though, this is a side issue and really doesn't matter when
it comes to how fallocate should behave on failure.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
