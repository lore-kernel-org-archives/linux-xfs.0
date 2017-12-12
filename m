Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:40517 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750915AbdLLOgr (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 12 Dec 2017 09:36:47 -0500
Date: Tue, 12 Dec 2017 06:36:47 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfs: include the XFS magic number in magic.h
Message-ID: <20171212143647.GA10887@infradead.org>
References: <1513088469.3476.48.camel@linux.vnet.ibm.com>
 <20171212142615.GA25327@infradead.org>
 <1513089296.3476.52.camel@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1513089296.3476.52.camel@linux.vnet.ibm.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-xfs <linux-xfs@vger.kernel.org>

On Tue, Dec 12, 2017 at 09:34:56AM -0500, Mimi Zohar wrote:
> On Tue, 2017-12-12 at 06:26 -0800, Christoph Hellwig wrote:
> > On Tue, Dec 12, 2017 at 09:21:09AM -0500, Mimi Zohar wrote:
> > > Move the XFS_SB_MAGIC definition to magic.h.
> > 
> > NACK.  We want to keep the XFS code self-contained and no other part
> > of the kernel has any business knowing it anyway.
> 
> IMA policy rules can be defined in terms of magic numbers, but they
> need to be defined in magic.h.  Please reconsider...

That is completely bogus, and it should not be supported in any way.
File systems magic numbers are internal implementation details.
