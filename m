Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:56262 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750789AbdAMRNN (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 13 Jan 2017 12:13:13 -0500
Date: Fri, 13 Jan 2017 09:13:12 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v2 3/5] xfs: reuse iomap delalloc code for COW fork
 reservation
Message-ID: <20170113171312.GB27605@infradead.org>
References: <1484157249-464-1-git-send-email-bfoster@redhat.com>
 <1484157249-464-4-git-send-email-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1484157249-464-4-git-send-email-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: linux-xfs@vger.kernel.org

On Wed, Jan 11, 2017 at 12:54:07PM -0500, Brian Foster wrote:
> COW fork reservation (delayed allocation) is implemented in
> xfs_reflink_reserve_cow() and is generally based on the traditional data
> fork delalloc logic in xfs_file_iomap_begin_delay(). In preparation for
> further changes to implement more aggressive COW fork preallocation,
> refactor the COW reservation code to reuse xfs_file_iomap_begin_delay()
> for data fork allocation as well as COW fork reservation. This patch
> does not change behavior.

I'm still trying to understand the point of patches 1-3:  there is no
functionality, but a lot of new code is added to reuse some other code.

How would patch 5 look like without that "reuse"?
