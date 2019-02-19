Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail01.adl2.internode.on.net ([150.101.137.133]:64413 "EHLO
        ipmail01.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725497AbfBSE2X (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 18 Feb 2019 23:28:23 -0500
Date: Tue, 19 Feb 2019 15:28:19 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [RFC PATCH 0/6] Allow setting file birth time with utimensat()
Message-ID: <20190219042818.GH14116@dastard>
References: <cover.1550136164.git.osandov@fb.com>
 <20190214220626.GV14116@dastard>
 <6a9dc05a-0445-d0ab-0140-1de4fee7ba9b@gmail.com>
 <20190217175450.psaesabv3vlzvjv4@angband.pl>
 <CALCETrWsCUTSbvwemKHB=8=pO4fwK2qD0boFEd4puBDkpb3F9g@mail.gmail.com>
 <20190219040447.GX12668@bombadil.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190219040447.GX12668@bombadil.infradead.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Matthew Wilcox <willy@infradead.org>
Cc: Andy Lutomirski <luto@kernel.org>, Adam Borowski <kilobyte@angband.pl>, Boaz Harrosh <openosd@gmail.com>, Omar Sandoval <osandov@osandov.com>, Linux FS Devel <linux-fsdevel@vger.kernel.org>, Al Viro <viro@zeniv.linux.org.uk>, kernel-team <kernel-team@fb.com>, Linux API <linux-api@vger.kernel.org>, Linux btrfs Developers List <linux-btrfs@vger.kernel.org>, Ext4 Developers List <linux-ext4@vger.kernel.org>, linux-f2fs-devel@lists.sourceforge.net, linux-xfs@vger.kernel.org

On Mon, Feb 18, 2019 at 08:04:47PM -0800, Matthew Wilcox wrote:
> On Sun, Feb 17, 2019 at 12:40:09PM -0800, Andy Lutomirski wrote:
> > So I'm highly in favor of this patch.  If XFS wants to disallow
> > writing the birth time, fine, but I think that behavior should be
> > overridable.
> 
> Please, no.  We need to have consistent behaviour between at least
> Linux local filesystems.  Not "Chris thinks this is a good idea,
> while Dave and Ted think its a bad idea, so btrfs supports it and
> XFS and ext4 disallow it".

And, quite frankly, this is the entire reason xattrs exist. i.e.
so that generic file attributes can be stored persitently without
each individual having to support them in their on-disk format.

I wish people would stop trying to implement stuff like this in
filesystem code and instead added it to the VFS and stored it in VFS
defined system xattrs so that it is common across all filesystems.
It also means that backup applications can preserve them during file
copies without really even being aware of their meaning, simply by
copying all the xattrs on the file...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
