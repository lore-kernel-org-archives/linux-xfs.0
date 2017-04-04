Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:39877 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751175AbdDDGyU (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 4 Apr 2017 02:54:20 -0400
Date: Mon, 3 Apr 2017 23:54:17 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v2] xfs: fix kernel memory exposure problems
Message-ID: <20170404065417.GA3610@infradead.org>
References: <20170403173430.GL4864@birch.djwong.org>
 <20170403194233.GR4864@birch.djwong.org>
 <da88c312-42ad-49a3-9349-3372d8d4b127@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <da88c312-42ad-49a3-9349-3372d8d4b127@sandeen.net>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>, xfs <linux-xfs@vger.kernel.org>, Eric Sandeen <sandeen@redhat.com>, Christoph Hellwig <hch@infradead.org>

On Mon, Apr 03, 2017 at 03:06:42PM -0500, Eric Sandeen wrote:
> On 4/3/17 2:42 PM, Darrick J. Wong wrote:
> > On Mon, Apr 03, 2017 at 10:34:30AM -0700, Darrick J. Wong wrote:
> >> Fix a memory exposure problems in inumbers where we allocate an array of
> >> structures with holes, fail to zero the holes, then blindly copy the
> >> kernel memory contents (junk and all) into userspace.
> >>
> >> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> >> Reviewed-by: Christoph Hellwig <hch@lst.de>
> > 
> > BTW, I intend to send this patch (though not the getbmap patch) for 4.11
> > since kernel memory exposure is usually treated as a security problem.
> 
> I agree with that plan; if this change isn't safe I don't know what
> is ...

Yes.  Please send this for 4.11-rc.
