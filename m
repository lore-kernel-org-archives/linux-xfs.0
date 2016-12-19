Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:38590 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755440AbcLSLi2 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 19 Dec 2016 06:38:28 -0500
Date: Mon, 19 Dec 2016 12:38:26 +0100
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 1/4] xfs: fix bogus minleft manipulations
Message-ID: <20161219113826.GA26535@lst.de>
References: <1481644767-9098-1-git-send-email-hch@lst.de> <1481644767-9098-2-git-send-email-hch@lst.de> <20161214173507.GA24645@bfoster.bfoster> <20161214193626.GA12106@lst.de> <20161214215133.GA26688@bfoster.bfoster> <20161215143430.GB29477@bfoster.bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20161215143430.GB29477@bfoster.bfoster>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org, eguan@redhat.com, darrick.wong@oracle.com

On Thu, Dec 15, 2016 at 09:34:33AM -0500, Brian Foster wrote:
> FWIW, I was playing with this a bit more and managed to manufacture a
> filesystem layout that this series doesn't handle too well. Emphasis on
> "manufactured" because this might not be a likely real world scenario,
> but either way the current code handles it fine.

It does, although mostly by accident.  I suspect with an even better
manufcatured image you could also drive the current code to it's knees,
e.g. only have one single block free in the first few AGs, and then
a small number just higher than that in a higher AG.

> I've attached a metadump of the offending image. mdestore it, mount and
> attempt something like 'dd if=/dev/zero of=/mnt/file' on the root. The
> buffered write looks like it's in a livelock, waiting indefinitely for a
> writeback cycle that will never complete...

Yeah, that's the loop that keeps going even if it can't allocate any
blocks, which seems generally bogus.  But even without that we'd get
ENOSPC despite not having a reservations. Which is a little easier to
debug, but just as wrong.

The only good way out I can see is to not hand out any more reservations
after we only nave nr_ags * xfs_bmap_worst_indlen(1) available.  I'll
see if I can come up with a patch for that.
