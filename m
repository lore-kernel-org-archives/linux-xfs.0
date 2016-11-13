Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:51536 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932513AbcKMMIt (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 13 Nov 2016 07:08:49 -0500
Date: Sun, 13 Nov 2016 04:08:48 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: EFI SLAB use after free in generic/388 run
Message-ID: <20161113120848.GA32761@infradead.org>
References: <20161112174049.GB27521@infradead.org>
 <20161113002634.GI16813@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20161113002634.GI16813@birch.djwong.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-xfs@vger.kernel.org

On Sat, Nov 12, 2016 at 04:26:34PM -0800, Darrick J. Wong wrote:
> On Sat, Nov 12, 2016 at 09:40:49AM -0800, Christoph Hellwig wrote:
> > Just saw this during a xfstests auto run on virtio with default
> > XFS parameters.  I don't think I saw this before when running the
> > same config, so it might not be 100% reproducible.  I'd be surpised
> > if my laptop has bad ram, but who knows..
> 
> Does your kernel have commit b77428b12b5 ("xfs: defer should abort
> intent items if the trans roll fails") in it?  I saw similar symptoms
> and fixed them with that patch.
> 
> (Patch should appear in -rc5 tomorrow.)

Let me try to reproduce it - I though I was just testing latest
for-next with my direct I/O changes, which would have it included,
but I just noticed I made a mess off my tree due to an unfinished
rebase, so maybe I actually was using an older base.
