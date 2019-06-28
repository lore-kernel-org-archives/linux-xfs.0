Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:46780 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726686AbfF1Dd0 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 27 Jun 2019 23:33:26 -0400
Date: Thu, 27 Jun 2019 20:33:03 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 07/13] xfs: allow merging ioends over append boundaries
Message-ID: <20190628033303.GA1404256@magnolia>
References: <20190627104836.25446-1-hch@lst.de>
 <20190627104836.25446-8-hch@lst.de>
 <20190627182309.GP5171@magnolia>
 <20190627214304.GB30113@42.do-not-panic.com>
 <20190628025204.GI30864@dhcp-12-102.nay.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190628025204.GI30864@dhcp-12-102.nay.redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Zorro Lang <zlang@redhat.com>
Cc: Luis Chamberlain <mcgrof@kernel.org>, Amir Goldstein <amir73il@gmail.com>, Christoph Hellwig <hch@lst.de>, Damien Le Moal <Damien.LeMoal@wdc.com>, Andreas Gruenbacher <agruenba@redhat.com>, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org

On Fri, Jun 28, 2019 at 10:52:04AM +0800, Zorro Lang wrote:
> On Thu, Jun 27, 2019 at 09:43:04PM +0000, Luis Chamberlain wrote:
> > On Thu, Jun 27, 2019 at 11:23:09AM -0700, Darrick J. Wong wrote:
> > > On Thu, Jun 27, 2019 at 12:48:30PM +0200, Christoph Hellwig wrote:
> > > > There is no real problem merging ioends that go beyond i_size into an
> > > > ioend that doesn't.  We just need to move the append transaction to the
> > > > base ioend.  Also use the opportunity to use a real error code instead
> > > > of the magic 1 to cancel the transactions, and write a comment
> > > > explaining the scheme.
> > > > 
> > > > Signed-off-by: Christoph Hellwig <hch@lst.de>
> > > 
> > > Reading through this patch, I have a feeling it fixes the crash that
> > > Zorro has been seeing occasionally with generic/475...
> > > 
> > > Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > Zorro, can you confirm? If so it would be great to also refer to
> > the respective bugzilla entry #203947 [0].
> 
> Sure, I'll give it a test. But it's so hard to reproduce, I need long enough
> time to prove "the panic's gone".
> 
> BTW, should I only merge this single patch to test, or merge your whole patchset
> with 13 patches?

Just this one patch.

--D

> Thanks,
> Zorro
> 
> > 
> > [0] https://bugzilla.kernel.org/show_bug.cgi?id=203947
> > 
> >   Luis
