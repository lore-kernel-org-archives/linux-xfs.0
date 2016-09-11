Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:57326 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755569AbcIKM5H (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 11 Sep 2016 08:57:07 -0400
Date: Sun, 11 Sep 2016 05:57:06 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 34/71] xfs: support bmapping delalloc extents in the CoW
 fork
Message-ID: <20160911125706.GC1399@infradead.org>
References: <147216791538.867.12413509832420924168.stgit@birch.djwong.org>
 <147216814006.867.6404376654574855233.stgit@birch.djwong.org>
 <20160906152553.GA9760@infradead.org>
 <20160906234001.GN30056@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20160906234001.GN30056@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: Christoph Hellwig <hch@infradead.org>, "Darrick J. Wong" <darrick.wong@oracle.com>, linux-xfs@vger.kernel.org, xfs@oss.sgi.com

On Wed, Sep 07, 2016 at 09:40:01AM +1000, Dave Chinner wrote:
> On Tue, Sep 06, 2016 at 08:25:53AM -0700, Christoph Hellwig wrote:
> > FYI, this has some major conflicts with the iomap updates - we'll need
> > to know from Dave which one should go in first.
> 
> I've already got the iomap updates in my local tree, so they will go
> in first.

Can you push that tree out so we get the reflink code rebase against
it ASAP?
