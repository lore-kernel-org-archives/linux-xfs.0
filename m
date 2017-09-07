Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from scorn.kernelslacker.org ([45.56.101.199]:34606 "EHLO
        scorn.kernelslacker.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751538AbdIGDsj (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 6 Sep 2017 23:48:39 -0400
Date: Wed, 6 Sep 2017 23:48:35 -0400
From: Dave Jones <davej@codemonkey.org.uk>
Subject: Re: iov_iter_pipe warning.
Message-ID: <20170907034835.arjbdpmujs6hs5n4@codemonkey.org.uk>
References: <20170421175430.GT29622@ZenIV.linux.org.uk>
 <20170428152955.mafs3f22srmm34aw@codemonkey.org.uk>
 <20170428164313.GK29622@ZenIV.linux.org.uk>
 <20170428165024.ofyl2atpjwohekqa@codemonkey.org.uk>
 <20170428172024.GL29622@ZenIV.linux.org.uk>
 <20170807201818.kykqzexce6ap6aik@codemonkey.org.uk>
 <20170828203130.y6dq5fqovev6wmrv@codemonkey.org.uk>
 <20170829042542.GO4757@magnolia>
 <20170906200337.b5wj3gpfebliindw@codemonkey.org.uk>
 <20170906234617.GW17782@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170906234617.GW17782@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>, Al Viro <viro@ZenIV.linux.org.uk>, Linux Kernel <linux-kernel@vger.kernel.org>, linux-xfs@vger.kernel.org

On Thu, Sep 07, 2017 at 09:46:17AM +1000, Dave Chinner wrote:
 > On Wed, Sep 06, 2017 at 04:03:37PM -0400, Dave Jones wrote:
 > > On Mon, Aug 28, 2017 at 09:25:42PM -0700, Darrick J. Wong wrote:
 > >  > On Mon, Aug 28, 2017 at 04:31:30PM -0400, Dave Jones wrote:
 > >  > > I'm still trying to narrow down an exact reproducer, but it seems having
 > >  > > trinity do a combination of sendfile & writev, with pipes and regular
 > >  > > files as fd's is the best repro.
 > >  > > 
 > >  > > Is this a real problem, or am I chasing ghosts ?  That it doesn't happen
 > >  > > on ext4 or btrfs is making me wonder...
 > >  > 
 > >  > <shrug> I haven't heard of any problems w/ directio xfs lately, but OTOH
 > >  > I think it's the only filesystem that uses iomap_dio_rw, which would
 > >  > explain why ext4/btrfs don't have this problem.
 > > 
 > > Another warning, from likely the same root cause.
 > > 
 > > WARNING: CPU: 3 PID: 572 at lib/iov_iter.c:962 iov_iter_pipe+0xe2/0xf0
 > 
 > 	WARN_ON(pipe->nrbufs == pipe->buffers);
 > 
 >  *      @nrbufs: the number of non-empty pipe buffers in this pipe
 >  *      @buffers: total number of buffers (should be a power of 2)
 > 
 > So that's warning that the pipe buffer is already full before we
 > try to read from the filesystem?
 > 
 > That doesn't seem like an XFS problem - it indicates the pipe we are
 > filling in generic_file_splice_read() is not being emptied by
 > whatever we are splicing the file data to....

The puzzling part is this runs for a day on ext4 or btrfs, whereas I can
make xfs fall over pretty quickly.  As Darrick pointed out though, this
could be due to xfs being the only user of iomap_dio_rw.

I'm juggling a few other things right now, so probably not going to
have much time to dig further on this until after plumbers + 1 wk.

	Dave

