Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:53032 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752496AbeDPLbk (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 16 Apr 2018 07:31:40 -0400
Date: Mon, 16 Apr 2018 04:31:39 -0700
From: Matthew Wilcox <willy@infradead.org>
Subject: Re: [PATCH] fs: xfs: Change return type to vm_fault_t
Message-ID: <20180416113139.GB26022@bombadil.infradead.org>
References: <20180414200530.GA20184@jordon-HP-15-Notebook-PC>
 <20180414215937.GH5572@dastard>
 <20180414222407.GA15294@bombadil.infradead.org>
 <20180415072121.GA13601@infradead.org>
 <20180415111104.GB25513@bombadil.infradead.org>
 <20180415120426.GA10479@infradead.org>
 <20180415123427.GA11379@bombadil.infradead.org>
 <20180416085707.GB30363@infradead.org>
 <20180416111423.GA26022@bombadil.infradead.org>
 <20180416112353.GA22921@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180416112353.GA22921@infradead.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: Dave Chinner <david@fromorbit.com>, Souptick Joarder <jrdr.linux@gmail.com>, darrick.wong@oracle.com, linux-xfs@vger.kernel.org

On Mon, Apr 16, 2018 at 04:23:53AM -0700, Christoph Hellwig wrote:
> On Mon, Apr 16, 2018 at 04:14:23AM -0700, Matthew Wilcox wrote:
> > That's an unreasonable request.  It would (usually) require writing more
> > code to convert errnos into VM_FAULT returns.  And that code would get
> > precisely zero testing upstream because the next commit would come along
> > and delete it, replacing it with calls to common code.
> 
> Well, introduce the damn common code first.  It does not require
> using the typedef in any way.

Already done.

> In this current form of single patches:  NAK to anything I maintain
> or review.

Yeah, we already have a plan for dealing with arsehole or MIA maintainers.
Fortunately, you're not actually the maintainer for XFS, so it'll be up
to Darrick whether to take it or not.

