Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mr012msb.fastweb.it ([85.18.95.109]:43626 "EHLO
        mr012msb.fastweb.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751738AbeBYV6T (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 25 Feb 2018 16:58:19 -0500
Subject: Re: Reflink (cow) copy of busy files
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date: Sun, 25 Feb 2018 22:58:16 +0100
From: Gionatan Danti <g.danti@assyoma.it>
In-Reply-To: <20180225211309.GF30854@dastard>
References: <9e69fcd01e1c02ea53e0e1ac66d60d24@assyoma.it>
 <20180224220757.GC30854@dastard>
 <711dd96e3c4b3e92d3fb38a01e77dc64@assyoma.it>
 <20180225024727.GD30854@dastard>
 <25ebcdb42650430d83d283435053efed@assyoma.it>
 <20180225211309.GF30854@dastard>
Message-ID: <d105d0000652be75774cc1f5f23eae68@assyoma.it>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org, g.danti@assyoma.it

Il 25-02-2018 22:13 Dave Chinner ha scritto:
> This isn't a copy on write issue. This is an issue of the state of
> the file and the I/O stack above it at the time the data extents are
> shared. There is I/O inflight, and so there's no guarantee that what
> is in the extents being shared is consistent. Freezing the
> filesystem stops IO in flight, so the extents can be shared while
> the filesystem knows it has consistent state on stable storage.

Uhm, it seems the very same definition/catches of "crash-consistent" 
snapshot...

Suppose an XFS filesystem used for VM disk images hosting, with running 
VMs. I naively execute a cp --reflink=always copy, stop the original VM 
and start the copied one.

For an atomic snapshot I would expect that dataloss is comparable to a 
"power pull" case:
- async writes are lost. After all, they were on the pagecache and never 
hit the backing file;
- unacknowledged sync writes are lost. Again, they never successfully 
hit the disk;
- acknowledged sync writes (ie: the one which returned) are properly 
written to the backing file.

If the above is correct, when starting the new (copied) VM, the guest 
filesystem will behave as power was lost: its journal will be replied 
and broght to a consistent state. Application can/will be affected based 
on what they were doing at the time of the reflinked copy, but important 
ones (ie: the ones correctly using fsync), as databases, will gracefully 
recover replying their logs.

This should be similar to how LVM snapshot works when no filesystem is 
(directly) layered on top of the volume (ie: volume assigned to a VM).

Still, you warned be that a CoW copy on a running VM will produce 
garbage; so I am surely misunderstanding something.
I would greatly appreciate any clarification.

Thanks.

-- 
Danti Gionatan
Supporto Tecnico
Assyoma S.r.l. - www.assyoma.it
email: g.danti@assyoma.it - info@assyoma.it
GPG public key ID: FF5F32A8
