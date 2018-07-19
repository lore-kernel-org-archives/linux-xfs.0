Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:42340 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727615AbeGSVQH (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 19 Jul 2018 17:16:07 -0400
Date: Thu, 19 Jul 2018 16:31:20 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 08/14] xfs: support embedded dfops in transaction
Message-ID: <20180719203120.GF29404@bfoster>
References: <20180719134919.29939-1-bfoster@redhat.com>
 <20180719134919.29939-9-bfoster@redhat.com>
 <20180719161825.GE29404@bfoster>
 <20180719194759.GA6558@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180719194759.GA6558@infradead.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-xfs@vger.kernel.org

On Thu, Jul 19, 2018 at 12:47:59PM -0700, Christoph Hellwig wrote:
> On Thu, Jul 19, 2018 at 12:18:26PM -0400, Brian Foster wrote:
> > FYI, this accidentally leaves off libxfs/xfs_rtbitmap.c, which also
> > requires the xfs_defer.h include treatment.
> 
> I wonder if we shouldn't just move struct xfs_defer_ops to xfs_trans.h
> instead.

I thought about doing that, was curious how many files I'd have to
modify and ended up just plowing through them all. :P I'm happy to move
the struct def over if nobody objects.

Brian
