Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:49190 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751931AbeGBNxC (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 2 Jul 2018 09:53:02 -0400
Date: Mon, 2 Jul 2018 06:53:01 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 17/24] xfs: use ->t_dfops for collapse/insert range
 operations
Message-ID: <20180702135301.GQ19162@infradead.org>
References: <20180628163636.52564-1-bfoster@redhat.com>
 <20180628163636.52564-18-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180628163636.52564-18-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: linux-xfs@vger.kernel.org

On Thu, Jun 28, 2018 at 12:36:29PM -0400, Brian Foster wrote:
> Use ->t_dfops for the collapse and insert range transactions. These
> are the only callers of the respective bmap helpers, so replace the
> unnecessary dfops parameters with direct accesses to ->t_dfops.
> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
