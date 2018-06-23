Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:46940 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751399AbeFWGrR (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 23 Jun 2018 02:47:17 -0400
Date: Fri, 22 Jun 2018 23:47:17 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v2 6/8] xfs: fix uninitialized field in rtbitmap fsmap
 backend
Message-ID: <20180623064717.GB9497@infradead.org>
References: <152960586416.26246.8634761888260524091.stgit@magnolia>
 <152960590105.26246.13020311829179912536.stgit@magnolia>
 <20180622212222.GU4838@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180622212222.GU4838@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org, Christoph Hellwig <hch@infradead.org>, Allison Henderson <allison.henderson@oracle.com>

On Fri, Jun 22, 2018 at 02:22:22PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Initialize the extent count field of the high key so that when we use
> the high key to synthesize an 'unknown owner' record (i.e. used space
> record) at the end of the queried range we have a field with which to
> compute rm_blockcount.  This is not strictly necessary because the
> synthesizer never uses the rm_blockcount field, but we can shut up the
> static code analysis anyway.
> 
> Coverity-id: 1437358
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> Reviewed-by: Allison Henderson <allison.henderson@oracle.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
