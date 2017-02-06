Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:48044 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751154AbdBFSlo (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 6 Feb 2017 13:41:44 -0500
Date: Mon, 6 Feb 2017 10:41:39 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: reflink direct I/O improvements V3
Message-ID: <20170206184139.GF3580@birch.djwong.org>
References: <20170206074738.13978-1-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170206074738.13978-1-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org

On Mon, Feb 06, 2017 at 08:47:34AM +0100, Christoph Hellwig wrote:
> This series improves the reflink direct I/O path, by avoiding a pointless
> detour through delayed allocations and doing the allocations directly
> from the iomap code.
> 
> Changes since V2:
>  - handle the new scheme to use unwritten extents for preallocation
>    properly
>  - fix up tracing for bounced dio writes

I think "xfs: reject all unaligned direct writes to reflinked files" is
missing from this patchset?  If so, you can send it as a reply to the
cover letter email.

--D

> Changes since V1:
>  - align the alignment code with the regular direct I/O path
>  - rebase on top the patches from Darrick to use unwritten extents
>    in the direct I/O COW path
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
