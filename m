Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:43056 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751055AbdESP1i (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 19 May 2017 11:27:38 -0400
Date: Fri, 19 May 2017 11:27:34 -0400
From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] vfs: freeze filesystems just prior to reboot
Message-ID: <20170519152734.qd4lf32e7wst4jdh@thunk.org>
References: <20170519002032.GA21202@birch.djwong.org>
 <1495202431.1896310.982081664.066926F8@webmail.messagingengine.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1495202431.1896310.982081664.066926F8@webmail.messagingengine.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Colin Walters <walters@verbum.org>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>, xfs <linux-xfs@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-ext4 <linux-ext4@vger.kernel.org>

On Fri, May 19, 2017 at 10:00:31AM -0400, Colin Walters wrote:
> As a maintainer of one of those userspace tools (https://github.com/ostreedev/ostree),
> which I don't think is the one in question here, but likely has the same
> issue - I'd like to have some sort of API to fix this - maybe flush the journal *without*
> remounting r/o?
> 
> Unlike the case you're talking about with rebooting into a special
> update mode, libostree constructs a new root with hardlinks while
> the system is running.  Hence, system downtime is just reboot, like
> dual-partition update systems, except we're more flexible.
> 
> Although hm...I guess an API to flush the journal would only narrow
> the race.
> 
> Is the single partition case really just doomed?

One of the things that came up when Darrick and I discussed this on
the weekly ext4 developer's conference call was our mutual wonderment
that none of the userspace tools implemented a reboot by created a
tmpfs chroot, pivoting into the chroot, and then unmounting all of the
remaining file systems.

This would also allow update schemes who want to enable various new
file system features, or upgrade the root file system somehow, to be
able to do so while the root file system is completely and cleanly
unmounted.

The other thing that would be useful is if grub2 would actually be
able to replay the file system journal --- but given that grub2 is
GPLv3, and both ext4 and xfs are GPLv2-only, and given that past
attempts of teams attempting to do clean room reimplementations of
complex code bases for licensing reasons only (cough, make_ext4fs,
*cough*) have not necessarily turned out well, I'm at least not going
to hold my breath.

   	   			- Ted
