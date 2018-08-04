Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:40532 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732601AbeHDLGR (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 4 Aug 2018 07:06:17 -0400
Date: Sat, 4 Aug 2018 02:06:19 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [ANNOUNCE] xfs-linux: for-next updated to a0e336ba3e3d
Message-ID: <20180804090619.GA1888@infradead.org>
References: <20180803191730.GX30972@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180803191730.GX30972@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: xfs <linux-xfs@vger.kernel.org>, Andreas Gruenbacher <agruenba@redhat.com>

> Andreas Gruenbacher (6):
>       [3d7b6b21f6c5] iomap: mark newly allocated buffer heads as new
>       [ebf00be37de3] iomap: complete partial direct I/O writes synchronously
>       [19e0c58f6552] iomap: generic inline data handling
>       [e184fde6f3f5] iomap: add private pointer to struct iomap
>       [ec181f6782d8] iomap: support direct I/O to inline data
>       [806a1477b10a] iomap: add inline data support to iomap_readpage_actor

Did you rebase the tree?  We really need to keep the iomap base
branch stable as the gfs2 tree is also based on it and we want to avoid
duplicate commits.
