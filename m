Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:49752 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755757AbeFOHzA (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 15 Jun 2018 03:55:00 -0400
Date: Fri, 15 Jun 2018 10:03:27 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: iomap preparations for GFS2 v2
Message-ID: <20180615080326.GB19525@lst.de>
References: <20180614120457.28285-1-hch@lst.de> <CAHc6FU4nQ562SxepV1=dqcuuuPBWOTXr4sAiY_5H-Z7uOaTNng@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHc6FU4nQ562SxepV1=dqcuuuPBWOTXr4sAiY_5H-Z7uOaTNng@mail.gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Andreas Gruenbacher <agruenba@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org, Dan Williams <dan.j.williams@intel.com>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, cluster-devel <cluster-devel@redhat.com>, linux-ext4 <linux-ext4@vger.kernel.org>

On Thu, Jun 14, 2018 at 03:04:38PM +0200, Andreas Gruenbacher wrote:
> I saw that you've pushed this onto the gfs2-iomap branch in your xfs
> repository. I've rebased the gfs2 iomap-write branch onto that;
> there's a trivial patch for adding a private pointer to struct iomap
> at the head of that branch that would sense to move to the shared
> branch as well now.

Please send that patch out ASAP.

> The next step would probably be to start using iomap_readpage /
> iomap_readpages in gfs2 for block size == page size. This requires
> adding inline data support to iomap_readpage which is trivial, but
> because of gfs2's reliance on buffer heads, that alone isn't enough.

Is it?  At least for block size == page size we will only call
readpage on a pristine, newly allocated page.  So buffer heads won't
be in the game at that point, and the iomap buffered write code will
just allocate them for you once we start a write operation, or take
a page fault that makes the page writable.
