Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:38830 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755636AbeEaQEe (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 31 May 2018 12:04:34 -0400
Date: Thu, 31 May 2018 18:11:03 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 06/18] xfs: make xfs_writepage_map extent map centric
Message-ID: <20180531161103.GA30465@lst.de>
References: <20180530100013.31358-1-hch@lst.de> <20180530100013.31358-7-hch@lst.de> <20180530173955.GF112411@bfoster.bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180530173955.GF112411@bfoster.bfoster>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, Dave Chinner <dchinner@redhat.com>

On Wed, May 30, 2018 at 01:39:56PM -0400, Brian Foster wrote:
> I believe Dave originally intended to split this up into multiple
> patches. Dave, did you happen to get anywhere with that before Christoph
> pulled this in?

I've split a few bits off.

> 
> If not, could we at least split off some of the behavior changes into
> separate patches? For example, dropping the !mapped && uptodate check
> that causes us to writeback zeroed blocks over unwritten extents is a
> behavior change that warrants a separate patch.

But that is the one part I can't easily split off.  It would require
tons of spurious changes to the old system of buffer flags, which
might be doable but would be removed in the next patch.
