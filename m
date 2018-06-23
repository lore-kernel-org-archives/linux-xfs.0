Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:46926 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751399AbeFWGrD (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 23 Jun 2018 02:47:03 -0400
Date: Fri, 22 Jun 2018 23:47:02 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v2 4/8] xfs: don't allow insert-range to shift extents
 past the maximum offset
Message-ID: <20180623064702.GA9497@infradead.org>
References: <152960586416.26246.8634761888260524091.stgit@magnolia>
 <152960588873.26246.17582272219031862067.stgit@magnolia>
 <20180622212104.GT4838@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180622212104.GT4838@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org, zlang@redhat.com, Christoph Hellwig <hch@infradead.org>, Allison Henderson <allison.henderson@oracle.com>

On Fri, Jun 22, 2018 at 02:21:04PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Zorro Lang reports that generic/485 blows an assert on a filesystem with
> 512 byte blocks.  The test tries to fallocate a post-eof extent at the
> maximum file size and calls insert range to shift the extents right by
> two blocks.  On a 512b block filesystem this causes startoff to overflow
> the 54-bit startoff field, leading to the assert.
> 
> Therefore, always check the rightmost extent to see if it would overflow
> prior to invoking the insert range machinery.
> 
> Reported-by: zlang@redhat.com
> Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=200137
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> Reviewed-by: Allison Henderson <allison.henderson@oracle.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
