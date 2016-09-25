Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:59143 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1031643AbcIYDra (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 24 Sep 2016 23:47:30 -0400
Date: Sat, 24 Sep 2016 20:47:28 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: only do a single COW fork lookup in writeback
Message-ID: <20160925034728.GA21561@infradead.org>
References: <1474730361-5234-1-git-send-email-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1474730361-5234-1-git-send-email-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

On Sat, Sep 24, 2016 at 08:19:19AM -0700, Christoph Hellwig wrote:
> I've got a bug report with a slightly older version of the reflink
> code, in which I get a bogus NULL xfs_bmbt_rec_host pointer back from
> xfs_iext_bno_to_ext in xfs_reflink_find_cow_mapping.  I've not
> reproduced that bug myself yet, but what's clear from the report is
> that it's not just inefficient but also potentially dangerous to
> do the blind dereference in xfs_reflink_find_cow_mapping after
> we dropped the ilock from the previous xfs_reflink_find_cow_mapping
> call.

FYI, based on further analsys I suspect that a xfs_reflink_end_cow
called from xfs_end_io cause the extent index to be invalid during
the xfs_reflink_find_cow_mapping mapping, as that can easily shift
the extent indices around and race with writeback elsewhere on the
same file.
