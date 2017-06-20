Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:38089 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752477AbdFTUbn (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 20 Jun 2017 16:31:43 -0400
Date: Tue, 20 Jun 2017 22:31:41 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 1/2] xfs: rewrite xfs_dq_get_next_id using
        xfs_iext_lookup_extent
Message-ID: <20170620203141.GA578@lst.de>
References: <20170620090244.30876-1-hch@lst.de> <20170620090244.30876-2-hch@lst.de> <4c3c78ed-9fd3-7b37-65f8-8256a98be951@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4c3c78ed-9fd3-7b37-65f8-8256a98be951@sandeen.net>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org, agruenba@redhat.com

On Tue, Jun 20, 2017 at 03:17:59PM -0500, Eric Sandeen wrote:
> On 6/20/17 4:02 AM, Christoph Hellwig wrote:
> > This goes straight to a single lookup in the extent list and avoids a
> > roundtrip through two layers that don't add any value for the simple
> > quoata file that just has data or holes and no page cache, delayed
> > allocation, unwritten extent or COW fork (which btw, doesn't seem to
> > be handled by the existing SEEK HOLE/DATA code).
> 
> ok well that's a bit embarrassing for the original author.  :D
> 
> Much nicer, thanks.  I assume it passes the couple of xfstests that stress this?

Both of them.. (generic/244 and generic/400)
