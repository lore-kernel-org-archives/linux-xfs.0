Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:34754 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755632AbdJRHbG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 18 Oct 2017 03:31:06 -0400
Date: Wed, 18 Oct 2017 00:31:04 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: agcount for 2TB, 4TB and 8TB drives
Message-ID: <20171018073104.GA6274@infradead.org>
References: <1b5b6410-b1d9-8519-7032-8ea0ca46f5b5@scylladb.com>
 <20171009112306.GM3666@dastard>
 <89a7ae9a-9960-ae37-f6ca-0c1f2e33f65f@scylladb.com>
 <20171009220332.GP3666@dastard>
 <38bd7785-174d-fd09-fc1f-50a2d4e1dd69@scylladb.com>
 <20171010225524.GV3666@dastard>
 <86635b89-5016-5cd1-53a2-bf21b842ae04@scylladb.com>
 <20171014224224.GD15067@dastard>
 <db0ca95f-ce16-4b2e-7d69-52f3552a6004@scylladb.com>
 <20171015220018.GG3666@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171015220018.GG3666@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: Avi Kivity <avi@scylladb.com>, Eric Sandeen <sandeen@sandeen.net>, "Darrick J. Wong" <darrick.wong@oracle.com>, Gandalf Corvotempesta <gandalf.corvotempesta@gmail.com>, linux-xfs@vger.kernel.org

On Mon, Oct 16, 2017 at 09:00:19AM +1100, Dave Chinner wrote:
> fallocate will block *all* IO and mmap faults on that file, not just
> the ones that require allocation. fallocate creates a complete IO
> submission pipeline stall, punting all new IO submissions to the
> background worker where they will block until fallocate completes.

Not sure if it helps Avis case, but I think we could relax the
fallocate exclusive i_rwsem requirement a bit, similar to direct I/O
writes.  Basically as long as your fallocate is block aligned we
should be fine with a shared iolock for the "normal" allocating
fallocate (discounting things like hole punches and extent shifts
of course).
