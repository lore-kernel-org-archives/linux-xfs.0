Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:45660 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932406AbcKOOSF (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 15 Nov 2016 09:18:05 -0500
Date: Tue, 15 Nov 2016 06:18:04 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH RFC 2/4] xfs: logically separate iomap range from
 allocation range
Message-ID: <20161115141804.GB18630@infradead.org>
References: <1478636856-7590-1-git-send-email-bfoster@redhat.com>
 <1478636856-7590-3-git-send-email-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1478636856-7590-3-git-send-email-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: linux-xfs@vger.kernel.org

On Tue, Nov 08, 2016 at 03:27:34PM -0500, Brian Foster wrote:
> The xfs_file_iomap_begin_delay() function currently converts the bmbt
> record output from the xfs_bmapi_reserve_delalloc() call to the iomap
> mapping for the higher level iomap code. In preparation to reuse
> xfs_file_iomap_begin_delay() for data fork and COW fork allocation,
> logically separate the iomap mapping provided to the caller from the
> bmbt record returned by xfs_bmapi_reserve_delalloc().
> 
> This is necessary because while COW reservation involves delalloc
> allocation to the COW fork, the mapping returned to the caller must
> still refer to the shared blocks from the data fork. Note that this
> patch does not change behavior in any way.

On it's own this patch looks highly confusing.  I'll keep reading
the rest of the series if it makes more sense with that, but in doubt
it probably should be merged into whatever patches it helps with.
