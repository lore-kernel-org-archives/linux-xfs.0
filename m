Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:45048 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726771AbfEUT2n (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 21 May 2019 15:28:43 -0400
Date: Tue, 21 May 2019 12:28:41 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 07/12] libfrog: fix bitmap return values
Message-ID: <20190521192841.GA18265@infradead.org>
References: <155839420081.68606.4573219764134939943.stgit@magnolia>
 <155839424514.68606.14562327454853103352.stgit@magnolia>
 <5caa6c9e-3a42-6c8e-101b-c198af77e765@sandeen.net>
 <20190521170103.GD5141@magnolia>
 <c281d3c3-5385-90a3-125a-8a620944c971@sandeen.net>
 <20190521191946.GA5657@infradead.org>
 <d3a556b7-95ad-9fc9-1867-cd71d43f00e8@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d3a556b7-95ad-9fc9-1867-cd71d43f00e8@sandeen.net>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Christoph Hellwig <hch@infradead.org>, "Darrick J. Wong" <darrick.wong@oracle.com>, linux-xfs@vger.kernel.org

On Tue, May 21, 2019 at 02:20:51PM -0500, Eric Sandeen wrote:
> > On Tue, May 21, 2019 at 01:59:58PM -0500, Eric Sandeen wrote:
> >> So yeah I'm of the opinion that unless it's kernel(-ish?) code it should be
> >> positive, and I can send a patch to clean up stuff that's not.
> >>
> >> I can be swayed by counterarguments if you have them.  :)
> > 
> > What speaks against everything is negative?  It isn't like returning
> > positive errors really is a traditional userspace convention, as that
> > is return -1 (negative!) and look at errno..
> 
> Sorry, I wasn't clear - I meant returning negative errnos.  That's
> the part that's not consistent.

Yes.  And for libxfs/libfrog/etc stuff I think sticking to that and
always returning negative error values sounds sanest to me.  Note that
some userspace libraries have adopted that calling convention, for
example libaio.
