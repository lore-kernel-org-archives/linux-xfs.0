Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:49168 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753022AbcKOSLK (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 15 Nov 2016 13:11:10 -0500
Date: Tue, 15 Nov 2016 13:11:08 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH RFC 2/4] xfs: logically separate iomap range from
 allocation range
Message-ID: <20161115181108.GD65218@bfoster.bfoster>
References: <1478636856-7590-1-git-send-email-bfoster@redhat.com>
 <1478636856-7590-3-git-send-email-bfoster@redhat.com>
 <20161115141804.GB18630@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20161115141804.GB18630@infradead.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-xfs@vger.kernel.org

On Tue, Nov 15, 2016 at 06:18:04AM -0800, Christoph Hellwig wrote:
> On Tue, Nov 08, 2016 at 03:27:34PM -0500, Brian Foster wrote:
> > The xfs_file_iomap_begin_delay() function currently converts the bmbt
> > record output from the xfs_bmapi_reserve_delalloc() call to the iomap
> > mapping for the higher level iomap code. In preparation to reuse
> > xfs_file_iomap_begin_delay() for data fork and COW fork allocation,
> > logically separate the iomap mapping provided to the caller from the
> > bmbt record returned by xfs_bmapi_reserve_delalloc().
> > 
> > This is necessary because while COW reservation involves delalloc
> > allocation to the COW fork, the mapping returned to the caller must
> > still refer to the shared blocks from the data fork. Note that this
> > patch does not change behavior in any way.
> 
> On it's own this patch looks highly confusing.  I'll keep reading
> the rest of the series if it makes more sense with that, but in doubt
> it probably should be merged into whatever patches it helps with.

Heh, Ok. I'll revisit this when the rest of the code is more fleshed
out.

Brian
