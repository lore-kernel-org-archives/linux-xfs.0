Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:55230 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726207AbeHESO0 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 5 Aug 2018 14:14:26 -0400
Date: Sun, 5 Aug 2018 09:08:58 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [ANNOUNCE] xfs-linux: for-next updated to a0e336ba3e3d
Message-ID: <20180805160858.GZ30972@magnolia>
References: <20180803191730.GX30972@magnolia>
 <20180804090619.GA1888@infradead.org>
 <CAHc6FU4dGZ_XC3ZPt6LJn8BqTZ_VJVK=4Z6vyG41_oGRV1CzVA@mail.gmail.com>
 <20180805073714.GA7787@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180805073714.GA7787@infradead.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: Andreas Gruenbacher <agruenba@redhat.com>, xfs <linux-xfs@vger.kernel.org>

On Sun, Aug 05, 2018 at 12:37:14AM -0700, Christoph Hellwig wrote:
> On Sat, Aug 04, 2018 at 04:25:26PM +0200, Andreas Gruenbacher wrote:
> > > Did you rebase the tree?  We really need to keep the iomap base
> > > branch stable as the gfs2 tree is also based on it and we want to avoid
> > > duplicate commits.
> > 
> > Those hashes look okay to me. We only depend on the iomap-4.19-merge
> > branch, and that hasn't changed in a while and is still consistent
> > with the gfs2 for-next branch.
> 
> Ok, I guess we are fine then.  Listing these as new comments just
> looked suspicious.

Oops, yeah, sorry.  When I generated the announce message I forgot to
tell git to start from the iomap branch merge instead of 'v4.18-rc4'.
Sorry about that; the iomap stuff are all the same patches from before.

--D

> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
