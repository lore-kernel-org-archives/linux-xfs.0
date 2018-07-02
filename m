Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:35772 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751922AbeGBNpK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 2 Jul 2018 09:45:10 -0400
Date: Mon, 2 Jul 2018 06:43:22 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 02/24] xfs: rename xfs_trans ->t_agfl_dfops to ->t_dfops
Message-ID: <20180702134322.GB19162@infradead.org>
References: <20180628163636.52564-1-bfoster@redhat.com>
 <20180628163636.52564-3-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180628163636.52564-3-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: linux-xfs@vger.kernel.org

On Thu, Jun 28, 2018 at 12:36:14PM -0400, Brian Foster wrote:
> The ->t_agfl_dfops field is currently used to defer agfl block frees
> from associated transaction contexts. While all known problematic
> contexts have already been updated to use ->t_agfl_dfops, the
> broader goal is defer agfl frees from all callers that already use a
> deferred operations structure. Further, the transaction field
> facilitates a good amount of code clean up where the transaction and
> dfops have historically been passed down through the stack
> separately.
> 
> Rename the field to something more generic to prepare to use it as
> such throughout XFS. This patch does not change behavior.
> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
