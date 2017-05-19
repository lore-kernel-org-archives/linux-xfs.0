Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:38331 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1755157AbdESQsm (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 19 May 2017 12:48:42 -0400
Message-Id: <1495212521.1935005.982278280.1453433F@webmail.messagingengine.com>
From: Colin Walters <walters@verbum.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="utf-8"
References: <20170519002032.GA21202@birch.djwong.org>
 <1495202431.1896310.982081664.066926F8@webmail.messagingengine.com>
 <20170519152734.qd4lf32e7wst4jdh@thunk.org>
 <1495211669.1931975.982263184.0F641F32@webmail.messagingengine.com>
Subject: Re: [PATCH] vfs: freeze filesystems just prior to reboot
In-Reply-To: <1495211669.1931975.982263184.0F641F32@webmail.messagingengine.com>
Date: Fri, 19 May 2017 12:48:41 -0400
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Colin Walters <walters@verbum.org>, Theodore Ts'o <tytso@mit.edu>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>, xfs <linux-xfs@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-ext4 <linux-ext4@vger.kernel.org>

On Fri, May 19, 2017, at 12:34 PM, Colin Walters wrote:
>
> So as far as I can see, a userspace API to ensure the journal is
> flushed on a mounted filesystem is going to be necessary for
> the general case.  I don't have a strong opinion on whether or not
> that's `syncfs()` - if it's e.g. a `XFS_IOC_FREEZE` `_THAW` pair
> that seems OK to me too.

Or (thinking about this more) maybe we indeed could implement that today by pivoting back to
the initramfs, and using umount()+mount() as our "syncfs() + journal flush" implementation.

Basically when we have to update /boot, we unmount, then remount again and add
new kernel+initramfs, unmount, remount and mv(/boot/grub2.conf.new,/boot/grub2.conf),
then finally unmount again.

In current design this would require keeping the initramfs resident in memory
just for this purpose, or to re-synthesize it on shutdown.

Not impossible, but it'd sure be simpler if say syncfs() had a flags argument
and there were a special "flush the journal" argument for this.

