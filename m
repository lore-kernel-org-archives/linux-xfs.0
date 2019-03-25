Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:56533 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729373AbfCYGwD (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 25 Mar 2019 02:52:03 -0400
Date: Mon, 25 Mar 2019 07:51:55 +0100
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [QUESTION] Long read latencies on mixed rw buffered IO
Message-ID: <20190325065155.GA21259@lst.de>
References: <CAOQ4uxi0pGczXBX7GRAFs88Uw0n1ERJZno3JSeZR71S1dXg+2w@mail.gmail.com> <20190325001044.GA23020@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190325001044.GA23020@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: Amir Goldstein <amir73il@gmail.com>, linux-xfs <linux-xfs@vger.kernel.org>, Christoph Hellwig <hch@lst.de>

On Mon, Mar 25, 2019 at 11:10:44AM +1100, Dave Chinner wrote:
> That's one part of it. The other is POSIX atomic write semantics.
> 
> https://pubs.opengroup.org/onlinepubs/009695399/functions/read.html
> 
> "I/O is intended to be atomic to ordinary files and pipes and FIFOs.
> Atomic means that all the bytes from a single operation that started
> out together end up together, without interleaving from other I/O
> operations."
> 
> i.e. that independent read()s should see a write() as a single
> atomic change. hence if you do a read() concurrently with a write(),
> the read should either run to completion before the write, or the
> write run to completion before the read().
> 
> XFS is the only linux filesystem that provides this behaviour.

I don't think that is entirely true.  ocfs2 and gfs2 also took
a cluster wide shared lock in read last time I looked, and of
course we do the right thing when using DAX for all supported
file systems.
