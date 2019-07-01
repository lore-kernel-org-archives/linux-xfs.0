Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:54070 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726442AbfGAItq (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 1 Jul 2019 04:49:46 -0400
Date: Mon, 1 Jul 2019 01:49:45 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [ANNOUNCE] xfs-linux: for-next *rebased* to 73d30d48749f
Message-ID: <20190701084945.GA1356@infradead.org>
References: <20190630163404.GG1404256@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190630163404.GG1404256@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: xfs <linux-xfs@vger.kernel.org>

On Sun, Jun 30, 2019 at 09:34:04AM -0700, Darrick J. Wong wrote:
> **NOTE** I discovered while bisecting the previous for-next that I
> introduced a build failure in "xfs: move xfs_ino_geometry to xfs_shared.h"
> that I hadn't noticed because apparently 0day doesn't do commit by
> commit build tests anymore?  (Frankly, it doesn't tell me /anything/
> unless it finds failures, so I think I'm not going to rely on cloud
> kernel build tests anymore.)

The buildbot doesn't seem to work at all basically.  Once it a while
it reports occasional errors for week old trees, but otherwise it
stays entirely silent, even for completely b0rked trees.  I've been
bitten by this more than once in the last weeks.
