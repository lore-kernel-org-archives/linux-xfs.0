Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:43690 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754778AbdESSVD (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 19 May 2017 14:21:03 -0400
Date: Fri, 19 May 2017 14:20:57 -0400
From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] vfs: freeze filesystems just prior to reboot
Message-ID: <20170519182057.qyx3sevm4vatff6a@thunk.org>
References: <20170519002032.GA21202@birch.djwong.org>
 <1495202431.1896310.982081664.066926F8@webmail.messagingengine.com>
 <20170519152734.qd4lf32e7wst4jdh@thunk.org>
 <1495211669.1931975.982263184.0F641F32@webmail.messagingengine.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1495211669.1931975.982263184.0F641F32@webmail.messagingengine.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Colin Walters <walters@verbum.org>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>, xfs <linux-xfs@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-ext4 <linux-ext4@vger.kernel.org>

On Fri, May 19, 2017 at 12:34:29PM -0400, Colin Walters wrote:
> > One of the things that came up when Darrick and I discussed this on
> > the weekly ext4 developer's conference call was our mutual wonderment
> > that none of the userspace tools implemented a reboot by created a
> > tmpfs chroot, pivoting into the chroot, and then unmounting all of the
> > remaining file systems.
> 
> On general purpose systems we have a tmpfs chroot already: the initramfs.

Aren't we discarding the initramfs after we've pivoted away from it,
to save on memory?  Keeping the tmpfs chroot around forever would be a
waste of memory, and in some cases, especially if you are using a
distribution kernel, the initramfs chroot can be rather large.

Creating an tmpfs chroot that was only good enough to manage the
shutdown would be pretty easy, though; the number of files you would
need would be quite very few in number.

> That narrows the problem down to keeping `/boot` consistent at
> shutdown time.  AIUI, a problem here is that XFS doesn't flush the
> journal on `syncfs`, only on unmount?  And from what I can tell,
> even the `XFS_IOC_FREEZE` ioctl won't do that either.

I believe the log *is* checkpointed on an XFS_IOC_FREEZE.

  	      	       		       	  - Ted
