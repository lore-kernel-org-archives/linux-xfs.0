Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:47048 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752167AbeGBNwF (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 2 Jul 2018 09:52:05 -0400
Date: Mon, 2 Jul 2018 06:52:00 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 14/24] xfs: remove xfs_bunmapi() dfops param
Message-ID: <20180702135200.GN19162@infradead.org>
References: <20180628163636.52564-1-bfoster@redhat.com>
 <20180628163636.52564-15-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180628163636.52564-15-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: linux-xfs@vger.kernel.org

On Thu, Jun 28, 2018 at 12:36:26PM -0400, Brian Foster wrote:
> Now that all xfs_bunmapi() callers use ->t_dfops, remove the
> unnecessary parameter and access ->t_dfops directly. This patch does
> not change behavior.
> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
