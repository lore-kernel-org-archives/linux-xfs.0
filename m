Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail05.adl6.internode.on.net ([150.101.137.143]:40403 "EHLO
        ipmail05.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751906AbdCHVvm (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 8 Mar 2017 16:51:42 -0500
Date: Thu, 9 Mar 2017 08:50:26 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Significantly longer fallocate times with Flag Unwritten Extents
 disabled
Message-ID: <20170308215026.GR17542@dastard>
References: <CAEOfVRnuTD0AWNSE+_-3KVL_xTcgrq5Q8+mm0mEQYua7gaGQiQ@mail.gmail.com>
 <20170308155602.GE4353@infradead.org>
 <CAEOfVRkdurzmw4UZeyj6sTO+dGCniFvwp9BOjXyqU+_Tr6z-fw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEOfVRkdurzmw4UZeyj6sTO+dGCniFvwp9BOjXyqU+_Tr6z-fw@mail.gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Bill <billmcdave@gmail.com>
Cc: linux-xfs@vger.kernel.org

On Wed, Mar 08, 2017 at 04:48:09PM +0000, Bill wrote:
> Woops, I forgot to send this response to the mailing list:
> 
> Thanks for the information and the explanation. That all makes sense,
> as I cannot reproduce the non-zero data behaviour and suspect I called
> fallocate() on an existing file.  When I read back freshly fallocated
> files I only ever get zeros back.  Apologies for the confusion.
> 
> The reason I am trying to create large uninitialized files quickly is
> that I have a hardware (FPGA) based system which is capable of writing
> to an SSD at a very fast rate. With software in the loop (managing the
> OS, file system and IO etc) I am limited to quite low rates (about 1/5
> of the hardware performance) as my processor is not very capable.  As
> I typically only write large sequential files, I was pondering whether
> I could create a large uninitialized file, figure out where it was
> physically located on the disk, unmount the drive and then let my
> hardware fill the relevant blocks with data, before handing control
> back to the software and remounting the drive. This would give me the
> advantages of a filesystem, without having to implement one in
> hardware, which would be challenging!

And, realistically, quite naive.

Go look at how the PNFS file layout code works - file leases for
ensuring outstanding client side IO operations are completed
correctly before the filesystem does something that will conflict
with the client side IO (e.g. truncate), struct
export_operations.map_blocks to allocate blocks and layouts that are
handed to the client, client does the IO directly to/from the
device, and then calls export_operations.commit_blocks for the
client to signal the write IO is done.

i.e. you FPGA is the client, write a kernel module that takes a fd
and uses the low level exportfs interfaces into the filesystem to do
block allocation, pass the mapped blocks to the FPGA and then signal
IO completion to the filesystem when each FPGA write completes.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
