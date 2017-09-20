Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:43677 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751782AbdITOth (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 20 Sep 2017 10:49:37 -0400
Date: Wed, 20 Sep 2017 07:49:36 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: io_submit() blocks for writes for substantial amount of time
Message-ID: <20170920144936.GA12638@infradead.org>
References: <CAO2XSW6cctUGx18AdQQ29zHpjPiJ2vVJ-MHxrGcmoeMxzMvbbA@mail.gmail.com>
 <20170919122704.GA3487@bfoster.bfoster>
 <20170919145827.GA21523@infradead.org>
 <04cb3ee7-e7d5-6bba-6adb-8ac1c28e68dc@scylladb.com>
 <20170919173955.GB8139@dhcp-41-131.bos.redhat.com>
 <ba7a108e-733e-419d-9839-545bc04e0caf@scylladb.com>
 <20170920105021.GA16036@bfoster.bfoster>
 <8b7b0822-9d57-4fc9-d55f-b0f94d8a5cbd@scylladb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <8b7b0822-9d57-4fc9-d55f-b0f94d8a5cbd@scylladb.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Avi Kivity <avi@scylladb.com>
Cc: Brian Foster <bfoster@redhat.com>, Christoph Hellwig <hch@infradead.org>, Tomasz Grabiec <tgrabiec@scylladb.com>, linux-xfs@vger.kernel.org, Goldwyn Rodrigues <rgoldwyn@suse.com>, linux-aio@kvack.org

On Wed, Sep 20, 2017 at 02:11:49PM +0300, Avi Kivity wrote:
> I think it's still preferable to avoid a workqueue and its non-deterministic
> latencies and context switches if we can prove that a particular iocb will
> not require a synchronous operation. If that can be done then 4.13 nowait
> aio also works - the user provides the workqueue equivalent. The only
> problem is if we can't prove in advance that an iocb will require blocking.

The code is generally pessimistic and bails out rather too often.
The only issue not solved is memory allocation, at the moment we could
still block on them so this will need some more work.  For XFS direct
I/O the only memory allocations in that path should be the bios.

>  1. Short writes - just ignore the tail of a too-large iovec. May cause
> buggy applications to fail, so probably not a good idea.

We could still do it the same way we did RWF_NOWAIT - require an
explicit opt-in for what should be the defalt behavior because we
change the historic behavior.

>  3. Borrow the mm, and pin from the wq - I gather it was considered and
> rejected, but maybe it can be reconsidered.

It was done before in vendor kernels, and I think we also had code
for it in a driver implementing aio.  I'd need to look up the whole
history as I don't remember it.
