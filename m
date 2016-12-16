Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:42268 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751710AbcLPDDk (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 15 Dec 2016 22:03:40 -0500
Subject: Re: [PATCH v2] xfs_io: implement 'set_encpolicy' and 'get_encpolicy'
 commands
References: <1481848815-104231-1-git-send-email-ebiggers3@gmail.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <9f588a76-beb9-6f9c-ece3-d2940815a565@sandeen.net>
Date: Thu, 15 Dec 2016 21:03:39 -0600
MIME-Version: 1.0
In-Reply-To: <1481848815-104231-1-git-send-email-ebiggers3@gmail.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Biggers <ebiggers3@gmail.com>, linux-xfs@vger.kernel.org
Cc: fstests@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>, Jaegeuk Kim <jaegeuk@kernel.org>, Richard Weinberger <richard@nod.at>, David Gstir <david@sigma-star.at>, Michael Halcrow <mhalcrow@google.com>, Eric Biggers <ebiggers@google.com>

On 12/15/16 6:40 PM, Eric Biggers wrote:
> From: Eric Biggers <ebiggers@google.com>
> 
> Add set_encpolicy and get_encpolicy commands to xfs_io so that xfstests
> will be able to test filesystem encryption using the actual user API,
> not just hacked in with a mount option.  These commands use the common
> "fscrypt" API currently implemented by ext4 and f2fs, but it's also
> under development for ubifs and planned for xfs.
> 
> Note that to get encrypted files to actually work, it's also necessary
> to add a key to the kernel keyring.  This patch does not add a command
> for this to xfs_io because it's possible to do it using keyctl.  keyctl
> can also be used to remove keys, revoke keys, invalidate keys, etc.
> 
> Signed-off-by: Eric Biggers <ebiggers@google.com>

Thanks for the update -

Reviewed-by: Eric Sandeen <sandeen@sandeen.net>

