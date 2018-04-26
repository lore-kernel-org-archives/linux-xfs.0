Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-it0-f46.google.com ([209.85.214.46]:35238 "EHLO
        mail-it0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752897AbeDZH1u (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 26 Apr 2018 03:27:50 -0400
Received: by mail-it0-f46.google.com with SMTP id 186-v6so22555596itu.0
        for <linux-xfs@vger.kernel.org>; Thu, 26 Apr 2018 00:27:50 -0700 (PDT)
Date: Thu, 26 Apr 2018 00:27:47 -0700
From: Omar Sandoval <osandov@osandov.com>
Subject: Re: [PATCH] iomap: add a swapfile activation function
Message-ID: <20180426072747.GA25194@vader>
References: <20180418025023.GM24738@magnolia>
 <20180424173539.GB25233@infradead.org>
 <20180425234622.GC1661@magnolia>
 <20180426055727.GA24887@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180426055727.GA24887@infradead.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>, xfs <linux-xfs@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-mm@kvack.org, Aleksei Besogonov <cyberax@amazon.com>

On Wed, Apr 25, 2018 at 10:57:27PM -0700, Christoph Hellwig wrote:
> On Wed, Apr 25, 2018 at 04:46:22PM -0700, Darrick J. Wong wrote:
> > (I mean, we /could/ just treat the swapfile as an unbreakable rdma/dax
> > style lease, but ugh...)
> 
> That is what I think it should be long term, instead of a strange
> parallel I/O path.
> 
> But in the mean time we have a real problem with supporting swap files,
> so we should merge the approaches from you and Aleksei and get something
> in ASAP.

I'm planning to do something along these lines for Btrfs, as well (have
swap_activate add the swap extents itself), because the previous thing I
tried with going through ->read_iter() and ->write_iter() ran into too
many locking issues (i.e., GFP_NOFS can suddenly go through FS locks).
