Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:44466 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751835AbdKWIaT (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 23 Nov 2017 03:30:19 -0500
Date: Thu, 23 Nov 2017 00:30:19 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfs: Don't trim extents for fiemap
Message-ID: <20171123083019.GA20221@infradead.org>
References: <1511424369-28740-1-git-send-email-nborisov@suse.com>
 <20171123081504.GB24556@infradead.org>
 <480e7347-fac1-12c0-f64b-f95d40f49366@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <480e7347-fac1-12c0-f64b-f95d40f49366@suse.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Nikolay Borisov <nborisov@suse.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-xfs@vger.kernel.org, sandeen@redhat.com, darrick.wong@oracle.com

On Thu, Nov 23, 2017 at 10:28:39AM +0200, Nikolay Borisov wrote:
> What you are saying is that iomap currently always trims the returned
> range from the underlying filesystem so doing trimming in the fs is
> redundant and I can just pass XFS_BMAPI_ENTIRE indiscriminately ?

I think so.  But the theory needs proper valiation first, so please
do a full test run with that change.
