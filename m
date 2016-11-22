Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:43315 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933482AbcKVRqM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 22 Nov 2016 12:46:12 -0500
Date: Tue, 22 Nov 2016 09:46:05 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: new helpers to clean up extent tree lookups V2
Message-ID: <20161122174605.GL16813@birch.djwong.org>
References: <1479746336-10986-1-git-send-email-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1479746336-10986-1-git-send-email-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org

On Mon, Nov 21, 2016 at 05:38:42PM +0100, Christoph Hellwig wrote:
> Now that Eric send out xfs_iext_count before I could get to it I need
> to get my other iext helpers out ASAP before running into another
> rebase :)
> 
> This series adds two new helpers that make iterating the extent list
> a lot cleaner.  They are the first step towards better abstracting out
> access to the extent list and thus allowing us to experiment with
> better data structures for it.  The next step is the manipulations
> in xfs_bmap_{add,del}_extent*, which will be more work than these
> helpers, but I have some of that in progress.
> 
> Changes since V1:
>  - incorporate review feedback from Brian (various minor items)

Looks reasonable to me, so for the whole series:
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
