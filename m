Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:36086 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751535AbeGBNpu (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 2 Jul 2018 09:45:50 -0400
Date: Mon, 2 Jul 2018 06:45:50 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 05/24] xfs: use ->t_dfops for recovery of [b|c]ui log
 items
Message-ID: <20180702134550.GE19162@infradead.org>
References: <20180628163636.52564-1-bfoster@redhat.com>
 <20180628163636.52564-6-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180628163636.52564-6-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: linux-xfs@vger.kernel.org

On Thu, Jun 28, 2018 at 12:36:17PM -0400, Brian Foster wrote:
> Log recovery passes down a central dfops structure to recovery
> handlers for bui and cui log items. Each of these handlers allocates
> and commits a transaction and defers any remaining operations to be
> completed by the main recovery sequence.
> 
> Since dfops outlives the transaction in this context, set and clear
> ->t_dfops appropriately such that the *_finish_item() paths and
> below (i.e., xfs_bmapi*()) can expect to find the dfops in the
> transaction without it being committed with the dfops attached. This
> is required because transaction commit expects that an associated
> dfops is finished and in this context the dfops may be populated at
> commit time.

Do we want comments explaining this in the code?

Otherwise looks fine:

Reviewed-by: Christoph Hellwig <hch@lst.de>
