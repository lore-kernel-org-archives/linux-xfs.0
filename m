Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:38834 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755580AbeEaQFJ (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 31 May 2018 12:05:09 -0400
Date: Thu, 31 May 2018 18:11:38 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 07/18] xfs: remove the now unused XFS_BMAPI_IGSTATE flag
Message-ID: <20180531161138.GB30465@lst.de>
References: <20180530100013.31358-1-hch@lst.de> <20180530100013.31358-8-hch@lst.de> <20180531134637.GA2997@bfoster.bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180531134637.GA2997@bfoster.bfoster>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org

On Thu, May 31, 2018 at 09:46:38AM -0400, Brian Foster wrote:
> On Wed, May 30, 2018 at 12:00:02PM +0200, Christoph Hellwig wrote:
> > Signed-off-by: Christoph Hellwig <hch@lst.de>
> > ---
> 
> The change looks Ok... It's clearly reasonable to remove a flag that is
> no longer used, but why is it no longer used? The previous patch drops
> it to "make xfs_writepage_map() extent map centric," but the description
> doesn't exactly explain why (and it's not immediately clear to me
> amongst all the other code changes).

My refactoring moves this into a separate patch with a proper changelog,
I'll send it out in a bit.
