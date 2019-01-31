Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:43328 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725730AbfAaVNy (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 31 Jan 2019 16:13:54 -0500
Date: Thu, 31 Jan 2019 13:13:51 -0800
From: Matthew Wilcox <willy@infradead.org>
Subject: Re: [LSF/MM TOPIC] Lazy file reflink
Message-ID: <20190131211351.GB26359@bombadil.infradead.org>
References: <CAOQ4uxgqm-m1Zj073o_vSnwkTbGObJiQ-CdWV2ESd_P-29=jZw@mail.gmail.com>
 <20190128125044.GC27972@quack2.suse.cz>
 <20190128212642.GQ4205@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190128212642.GQ4205@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: Jan Kara <jack@suse.cz>, Amir Goldstein <amir73il@gmail.com>, lsf-pc@lists.linux-foundation.org, linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-xfs <linux-xfs@vger.kernel.org>, "Darrick J. Wong" <darrick.wong@oracle.com>, Christoph Hellwig <hch@lst.de>

On Tue, Jan 29, 2019 at 08:26:43AM +1100, Dave Chinner wrote:
> Really, though, for this use case it's make more sense to have "per
> file freeze" semantics. i.e. if you want a consistent backup image
> on snapshot capable storage, the process is usually "freeze
> filesystem, snapshot fs, unfreeze fs, do backup from snapshot,
> remove snapshot". We can already transparently block incoming
> writes/modifications on files via the freeze mechanism, so why not
> just extend that to per-file granularity so writes to the "very
> large read-mostly file" block while it's being backed up....
> 
> Indeed, this would probably only require a simple extension to
> FIFREEZE/FITHAW - the parameter is currently ignored, but as defined
> by XFS it was a "freeze level". Set this to 0xffffffff and then it
> freezes just the fd passed in, not the whole filesystem.
> Alternatively, FI_FREEZE_FILE/FI_THAW_FILE is simple to define...

This sounds like you want a lease (aka oplock), which we already have
implemented.
