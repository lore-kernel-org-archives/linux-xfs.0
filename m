Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:36740 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933625AbcLOA1V (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 14 Dec 2016 19:27:21 -0500
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (1.0)
Subject: Re: [PATCH] xfs_io: implement 'set_encpolicy' and 'get_encpolicy' commands
From: Eric Sandeen <sandeen@sandeen.net>
In-Reply-To: <20161215000729.GA18462@gmail.com>
Date: Wed, 14 Dec 2016 18:13:27 -0600
Content-Transfer-Encoding: 8BIT
Message-Id: <4ED1D2FB-C3DE-4C1F-9DA3-DFBCE6F05C7F@sandeen.net>
References: <1480371512-12493-1-git-send-email-ebiggers@google.com> <9f56ed00-177e-392f-0afd-f87b41777533@sandeen.net> <20161215000729.GA18462@gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Biggers <ebiggers3@gmail.com>
Cc: Eric Biggers <ebiggers@google.com>, linux-xfs@vger.kernel.org, fstests@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>, Jaegeuk Kim <jaegeuk@kernel.org>, Richard Weinberger <richard@nod.at>, David Gstir <david@sigma-star.at>, Michael Halcrow <mhalcrow@google.com>


> On Dec 14, 2016, at 6:07 PM, Eric Biggers <ebiggers3@gmail.com> wrote:
> 
> Hi Eric,
> 
>> On Wed, Dec 14, 2016 at 05:45:49PM -0600, Eric Sandeen wrote:
>>> On 11/28/16 4:18 PM, Eric Biggers wrote:
>>> Add set_encpolicy and get_encpolicy commands to xfs_io so that xfstests
>>> will be able to test filesystem encryption using the actual user API,
>>> not just hacked in with a mount option.  These commands use the common
>>> "fscrypt" API currently implemented by ext4 and f2fs, but it's also
>>> under development for ubifs and planned for xfs.
>>> 
>>> Note that to get encrypted files to actually work, it's also necessary
>>> to add a key to the kernel keyring.  This patch does not add a command
>>> for this to xfs_io because it's possible to do it using keyctl.  keyctl
>>> can also be used to remove keys, revoke keys, invalidate keys, etc.
>> 
>> What is the standard utility for doing this?  I ask because while
>> xfs_io does operate on non-xfs filesystems, this may be the first dedicated
>> command proposed for xfs_io which isn't actually useful on xfs itself.
>> And that seems a little out of place to me at this point.
>> 
>> If it's just for the purpose of facilitating fstests, we do have some
>> single-purpose helpers in src/ in the xfstests repo, as well.
>> 
> 
> The new xfs_io commands are indeed only intended for xfstests.  My original
> proposal was to add a fscrypt_util program to xfstests, but Dave Chinner said
> the commands should be added to xfs_io instead and that it's planned to
> eventually make XFS support the encryption API too.

Oh - I'm sorry I missed that discussion.  I guess I won't argue with Dave on that point, then.  :)
> 
> set_policy and get_policy commands are also available in 'e4crypt', which is
> part of e2fsprogs.  There is also a common userspace utility called 'fscrypt'
> being designed to replace e4crypt.  However, neither of these programs are
> intended to simply expose the raw ioctls.  Therefore, not everything I am
> testing in the new xfstests could be tested with them.
> 
Ok, thanks for the info.  I'll get it reviewed.

Eric

> Eric
> --
> To unsubscribe from this list: send the line "unsubscribe fstests" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

