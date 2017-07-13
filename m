Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:37653 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750877AbdGMHSE (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 13 Jul 2017 03:18:04 -0400
Date: Thu, 13 Jul 2017 00:18:02 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: xfstests failures with current kernel/xfsprogs/xfstests
Message-ID: <20170713071802.GC2433@infradead.org>
References: <20170712114433.GA2231@infradead.org>
 <20170712162954.GA4220@magnolia>
 <dba1ac97-e3b9-bddd-61e5-78f164d3dc50@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <dba1ac97-e3b9-bddd-61e5-78f164d3dc50@sandeen.net>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>, Christoph Hellwig <hch@infradead.org>, linux-xfs@vger.kernel.org

On Wed, Jul 12, 2017 at 11:53:02AM -0500, Eric Sandeen wrote:
> 
> 
> On 07/12/2017 11:29 AM, Darrick J. Wong wrote:
> >> generic/417 seems to fail to recover things on a r/o to r/w mount.
> >>
> >> I thoght Eric had a fix for this, but it seems like it didn't get merge.
> > He did, but Dave wanted to know more about the side effects of recovering
> > unlinked inodes on the rootfs during the ro->rw mount and the thread died
> > after that.
> > 
> 
> Because I really don't know how to answer that.  I didn't see a way to
> address the vague concerns.  I tried to find a way to make a test which
> does this, but wasn't able to come up with any way to produce the old/lost
> orphans on a kernel with the fix.

Can you just repost the latest series for another round of review?
