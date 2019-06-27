Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-pg1-f194.google.com ([209.85.215.194]:38576 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726441AbfF0VnH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 27 Jun 2019 17:43:07 -0400
Date: Thu, 27 Jun 2019 21:43:04 +0000
From: Luis Chamberlain <mcgrof@kernel.org>
Subject: Re: [PATCH 07/13] xfs: allow merging ioends over append boundaries
Message-ID: <20190627214304.GB30113@42.do-not-panic.com>
References: <20190627104836.25446-1-hch@lst.de>
 <20190627104836.25446-8-hch@lst.de>
 <20190627182309.GP5171@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190627182309.GP5171@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>, Zorro Lang <zlang@redhat.com>, Amir Goldstein <amir73il@gmail.com>
Cc: Christoph Hellwig <hch@lst.de>, Damien Le Moal <Damien.LeMoal@wdc.com>, Andreas Gruenbacher <agruenba@redhat.com>, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org

On Thu, Jun 27, 2019 at 11:23:09AM -0700, Darrick J. Wong wrote:
> On Thu, Jun 27, 2019 at 12:48:30PM +0200, Christoph Hellwig wrote:
> > There is no real problem merging ioends that go beyond i_size into an
> > ioend that doesn't.  We just need to move the append transaction to the
> > base ioend.  Also use the opportunity to use a real error code instead
> > of the magic 1 to cancel the transactions, and write a comment
> > explaining the scheme.
> > 
> > Signed-off-by: Christoph Hellwig <hch@lst.de>
> 
> Reading through this patch, I have a feeling it fixes the crash that
> Zorro has been seeing occasionally with generic/475...
> 
> Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

Zorro, can you confirm? If so it would be great to also refer to
the respective bugzilla entry #203947 [0].

[0] https://bugzilla.kernel.org/show_bug.cgi?id=203947

  Luis
