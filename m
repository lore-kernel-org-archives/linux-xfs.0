Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:49799 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751521AbdDNHmu (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 14 Apr 2017 03:42:50 -0400
Date: Fri, 14 Apr 2017 00:42:44 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: Deadlock between block allocation and block truncation
Message-ID: <20170414074244.GA18519@infradead.org>
References: <800468eb-3ded-9166-20a4-047de8018582@gmail.com>
 <20170412161017.GA16590@infradead.org>
 <af73ca2f-5840-1399-9902-8f7482e29e49@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <af73ca2f-5840-1399-9902-8f7482e29e49@gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Nikolay Borisov <n.borisov.lkml@gmail.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-xfs@vger.kernel.org

On Thu, Apr 13, 2017 at 04:52:03PM +0300, Nikolay Borisov wrote:
> On a different note - do you think that reducing the unmapped extents
> from 2 to 1 would introduce any performance degradation during
> truncation?

There will be some.  But now that we have the CIL it will just
additional in-kernel overhead instead of overhead in the on-disk
log.

> Looking around the code this define is only used when doing
> truncation, so perhaps a better thing to do would be to turn this
> xfs_bunmapi arg to a boolean which signal whether we are doing
> truncation or not. And if it is set to true have xfs_bunmapi unmap all
> possible extents from only a single AG? I'm going to sift through the
> git history to figure out where this requirement of maximum 2 extent
> came to truncate, came.

We have the problem with all transactions that could lock multiple AGF
headers, so that's not going to cut it.

I think we could do multiple transactions IFF in the same AG.  I'll
need to check if that's worth it.  And on top of that I have started
entirely reworking what is currently xfs_bunmapi, but that will have
to wait until after a fix for your issue.
