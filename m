Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:32199 "EHLO
        ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752501AbdIFXqU (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 6 Sep 2017 19:46:20 -0400
Date: Thu, 7 Sep 2017 09:46:17 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: iov_iter_pipe warning.
Message-ID: <20170906234617.GW17782@dastard>
References: <20170412190318.srkkdytf2ebrjzrg@codemonkey.org.uk>
 <20170421175430.GT29622@ZenIV.linux.org.uk>
 <20170428152955.mafs3f22srmm34aw@codemonkey.org.uk>
 <20170428164313.GK29622@ZenIV.linux.org.uk>
 <20170428165024.ofyl2atpjwohekqa@codemonkey.org.uk>
 <20170428172024.GL29622@ZenIV.linux.org.uk>
 <20170807201818.kykqzexce6ap6aik@codemonkey.org.uk>
 <20170828203130.y6dq5fqovev6wmrv@codemonkey.org.uk>
 <20170829042542.GO4757@magnolia>
 <20170906200337.b5wj3gpfebliindw@codemonkey.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170906200337.b5wj3gpfebliindw@codemonkey.org.uk>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Jones <davej@codemonkey.org.uk>, "Darrick J. Wong" <darrick.wong@oracle.com>, Al Viro <viro@ZenIV.linux.org.uk>, Linux Kernel <linux-kernel@vger.kernel.org>, linux-xfs@vger.kernel.org

On Wed, Sep 06, 2017 at 04:03:37PM -0400, Dave Jones wrote:
> On Mon, Aug 28, 2017 at 09:25:42PM -0700, Darrick J. Wong wrote:
>  > On Mon, Aug 28, 2017 at 04:31:30PM -0400, Dave Jones wrote:
>  > > I'm still trying to narrow down an exact reproducer, but it seems having
>  > > trinity do a combination of sendfile & writev, with pipes and regular
>  > > files as fd's is the best repro.
>  > > 
>  > > Is this a real problem, or am I chasing ghosts ?  That it doesn't happen
>  > > on ext4 or btrfs is making me wonder...
>  > 
>  > <shrug> I haven't heard of any problems w/ directio xfs lately, but OTOH
>  > I think it's the only filesystem that uses iomap_dio_rw, which would
>  > explain why ext4/btrfs don't have this problem.
> 
> Another warning, from likely the same root cause.
> 
> WARNING: CPU: 3 PID: 572 at lib/iov_iter.c:962 iov_iter_pipe+0xe2/0xf0

	WARN_ON(pipe->nrbufs == pipe->buffers);

 *      @nrbufs: the number of non-empty pipe buffers in this pipe
 *      @buffers: total number of buffers (should be a power of 2)

So that's warning that the pipe buffer is already full before we
try to read from the filesystem?

That doesn't seem like an XFS problem - it indicates the pipe we are
filling in generic_file_splice_read() is not being emptied by
whatever we are splicing the file data to....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
