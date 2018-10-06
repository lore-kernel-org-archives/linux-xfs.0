Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:33222 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727563AbeJFRhJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 6 Oct 2018 13:37:09 -0400
Date: Sat, 6 Oct 2018 03:34:23 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 03/15] xfs: zero posteof blocks when cloning above eof
Message-ID: <20181006103423.GB25747@infradead.org>
References: <153870027422.29072.7433543674436957232.stgit@magnolia>
 <153870029414.29072.6572683664719818617.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <153870029414.29072.6572683664719818617.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: david@fromorbit.com, sandeen@redhat.com, Zorro Lang <zlang@redhat.com>, linux-xfs@vger.kernel.org, ocfs2-devel@oss.oracle.com, linux-fsdevel@vger.kernel.org, linux-btrfs@vger.kernel.org

On Thu, Oct 04, 2018 at 05:44:54PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> When we're reflinking between two files and the destination file range
> is well beyond the destination file's EOF marker, zero any posteof
> speculative preallocations in the destination file so that we don't
> expose stale disk contents.  The previous strategy of trying to clear
> the preallocations does not work if the destination file has the
> PREALLOC flag set.

But I think we should still drop speculative delalloc preallocations 
instead of zeroing them in addition to zeroing of any real blocks in
the data fork.
