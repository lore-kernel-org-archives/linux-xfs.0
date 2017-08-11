Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:37232 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751955AbdHKLYe (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 11 Aug 2017 07:24:34 -0400
Date: Fri, 11 Aug 2017 04:24:32 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfs_db: reset metadump output flag
Message-ID: <20170811112432.GA10698@infradead.org>
References: <20170805161013.GJ24087@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170805161013.GJ24087@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Eric Sandeen <sandeen@redhat.com>, xfs <linux-xfs@vger.kernel.org>

On Sat, Aug 05, 2017 at 09:10:13AM -0700, Darrick J. Wong wrote:
> On the off chance that someone runs metadump more than once with the
> metadump file going to stdout and then not stdout, the stdout_metadump
> variable will not be reset before the second invocation.  Clear the
> status variable when we undo the stdout redirection.
> 
> Fixes-coverity-id: 1416140
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Looks good.  Seems like something we could even write a test case for :)
