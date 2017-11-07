Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:46397 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755169AbdKGHRL (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 7 Nov 2017 02:17:11 -0500
Date: Mon, 6 Nov 2017 23:17:10 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v3 12/14] generic/204: break out of fs-filling loop early
 if we ENOSPC
Message-ID: <20171107071709.GA4586@infradead.org>
References: <150957278824.18388.17975162441125293654.stgit@magnolia>
 <150957286222.18388.3253654888670864191.stgit@magnolia>
 <20171107015411.GA28335@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171107015411.GA28335@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: eguan@redhat.com, linux-xfs@vger.kernel.org, fstests@vger.kernel.org

On Mon, Nov 06, 2017 at 05:54:11PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Use the available block count to compute the number of files we think
> we can create, rather than hardcoding a particular size.  This fixes
> the ENOSPC failures for xfs filesystems with rmap/reflink support.

This seems to work fine for me.  Note that even without 204 didn't
always fail for me on reflink filesystems, although it seems like it
failed more ofen than not:

Reviewed-by: Christoph Hellwig <hch@lst.de>
