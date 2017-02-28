Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:34399 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751756AbdB1XWU (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 28 Feb 2017 18:22:20 -0500
Date: Tue, 28 Feb 2017 15:22:04 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [RFC] failure atomic writes for file systems and block devices
Message-ID: <20170228232204.GB5269@birch.djwong.org>
References: <20170228145737.19016-1-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170228145737.19016-1-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org, linux-block@vger.kernel.org

On Tue, Feb 28, 2017 at 06:57:25AM -0800, Christoph Hellwig wrote:
> Hi all,
> 
> this series implements a new O_ATOMIC flag for failure atomic writes
> to files.   It is based on and tries to unify to earlier proposals,
> the first one for block devices by Chris Mason:
> 
> 	https://lwn.net/Articles/573092/
> 
> and the second one for regular files, published by HP Research at
> Usenix FAST 2015:
> 
> 	https://www.usenix.org/conference/fast15/technical-sessions/presentation/verma
> 
> It adds a new O_ATOMIC flag for open, which requests writes to be
> failure-atomic, that is either the whole write makes it to persistent
> storage, or none of it, even in case of power of other failures.
> 
> There are two implementation various of this:  on block devices O_ATOMIC
> must be combined with O_(D)SYNC so that storage devices that can handle
> large writes atomically can simply do that without any additional work.
> This case is supported by NVMe.
> 
> The second case is for file systems, where we simply write new blocks
> out of places and then remap them into the file atomically on either
> completion of an O_(D)SYNC write or when fsync is called explicitly.
> 
> The semantics of the latter case are explained in detail at the Usenix
> paper above.

(Assuming there's no syncv involved here...?)

> Last but not least a new fcntl is implemented to provide information
> about I/O restrictions such as alignment requirements and the maximum
> atomic write size.
> 
> The implementation is simple and clean, but I'm rather unhappy about
> the interface as it has too many failure modes to bullet proof.  For
> one old kernels ignore unknown open flags silently, so applications

Ok, heh, disregard my review comment (for the xfs part) about the
seemingly insufficient O_ATOMIC validation.

> have to check the F_IOINFO fcntl before, which is a bit of a killer.
> Because of that I've also not implemented any other validity checks
> yet, as they might make thing even worse when an open on a not supported
> file system or device fails, but not on an old kernel.  Maybe we need
> a new open version that checks arguments properly first?

Does fcntl(F_SETFL...) suffer from this?

> Also I'm really worried about the NVMe failure modes - devices simply
> advertise an atomic write size, with no way for the device to know
> that the host requested a given write to be atomic, and thus no
> error reporting.

Yikes!

> This is made worse by NVMe 1.2 adding per-namespace
> atomic I/O parameters that devices can use to introduce additional
> odd alignment quirks - while there is some language in the spec
> requiring them not to weaken the per-controller guarantees it all
> looks rather weak and I'm not too confident in all implementations
> getting everything right.
> 
> Last but not least this depends on a few XFS patches, so to actually
> apply / run the patches please use this git tree:

Well, the XFS parts don't look too bad....

--D

> 
>     git://git.infradead.org/users/hch/vfs.git O_ATOMIC
> 
> Gitweb:
> 
>     http://git.infradead.org/users/hch/vfs.git/shortlog/refs/heads/O_ATOMIC
