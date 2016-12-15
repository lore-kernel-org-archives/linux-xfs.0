Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-pf0-f193.google.com ([209.85.192.193]:33096 "EHLO
        mail-pf0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752959AbcLOAHc (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 14 Dec 2016 19:07:32 -0500
Date: Wed, 14 Dec 2016 16:07:29 -0800
From: Eric Biggers <ebiggers3@gmail.com>
Subject: Re: [PATCH] xfs_io: implement 'set_encpolicy' and 'get_encpolicy'
 commands
Message-ID: <20161215000729.GA18462@gmail.com>
References: <1480371512-12493-1-git-send-email-ebiggers@google.com>
 <9f56ed00-177e-392f-0afd-f87b41777533@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9f56ed00-177e-392f-0afd-f87b41777533@sandeen.net>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Eric Biggers <ebiggers@google.com>, linux-xfs@vger.kernel.org, fstests@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>, Jaegeuk Kim <jaegeuk@kernel.org>, Richard Weinberger <richard@nod.at>, David Gstir <david@sigma-star.at>, Michael Halcrow <mhalcrow@google.com>

Hi Eric,

On Wed, Dec 14, 2016 at 05:45:49PM -0600, Eric Sandeen wrote:
> On 11/28/16 4:18 PM, Eric Biggers wrote:
> > Add set_encpolicy and get_encpolicy commands to xfs_io so that xfstests
> > will be able to test filesystem encryption using the actual user API,
> > not just hacked in with a mount option.  These commands use the common
> > "fscrypt" API currently implemented by ext4 and f2fs, but it's also
> > under development for ubifs and planned for xfs.
> > 
> > Note that to get encrypted files to actually work, it's also necessary
> > to add a key to the kernel keyring.  This patch does not add a command
> > for this to xfs_io because it's possible to do it using keyctl.  keyctl
> > can also be used to remove keys, revoke keys, invalidate keys, etc.
> 
> What is the standard utility for doing this?  I ask because while
> xfs_io does operate on non-xfs filesystems, this may be the first dedicated
> command proposed for xfs_io which isn't actually useful on xfs itself.
> And that seems a little out of place to me at this point.
> 
> If it's just for the purpose of facilitating fstests, we do have some
> single-purpose helpers in src/ in the xfstests repo, as well.
> 

The new xfs_io commands are indeed only intended for xfstests.  My original
proposal was to add a fscrypt_util program to xfstests, but Dave Chinner said
the commands should be added to xfs_io instead and that it's planned to
eventually make XFS support the encryption API too.

set_policy and get_policy commands are also available in 'e4crypt', which is
part of e2fsprogs.  There is also a common userspace utility called 'fscrypt'
being designed to replace e4crypt.  However, neither of these programs are
intended to simply expose the raw ioctls.  Therefore, not everything I am
testing in the new xfstests could be tested with them.

Eric
