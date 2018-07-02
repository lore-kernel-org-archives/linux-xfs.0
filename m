Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:35772 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752110AbeGBNpL (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 2 Jul 2018 09:45:11 -0400
Date: Mon, 2 Jul 2018 06:43:04 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 01/24] xfs: cow unwritten conversion uses uninitialized
 dfops
Message-ID: <20180702134304.GA19162@infradead.org>
References: <20180628163636.52564-1-bfoster@redhat.com>
 <20180628163636.52564-2-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180628163636.52564-2-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: linux-xfs@vger.kernel.org

On Thu, Jun 28, 2018 at 12:36:13PM -0400, Brian Foster wrote:
> A couple COW fork unwritten extent conversion helpers pass an
> uninitialized dfops pointer to xfs_bmapi_write(). This does not
> cause problems because conversion does not use a transaction or the
> dfops structure for the COW fork.  Drop the uninitialized usage of
> dfops in these codepaths and pass NULL along to xfs_bmapi_write()
> instead.

Looks good.

Is this something we should maybe queue up for 4.18?

Reviewed-by: Christoph Hellwig <hch@lst.de>
