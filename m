Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:32848 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727307AbeGaJ6U (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 31 Jul 2018 05:58:20 -0400
Date: Tue, 31 Jul 2018 01:19:10 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 07/15] xfs: automatic dfops buffer relogging
Message-ID: <20180731081910.GI16028@infradead.org>
References: <20180730164520.36882-1-bfoster@redhat.com>
 <20180730164520.36882-8-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180730164520.36882-8-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: linux-xfs@vger.kernel.org

On Mon, Jul 30, 2018 at 12:45:12PM -0400, Brian Foster wrote:
> Buffers that are held across deferred operations are explicitly
> joined to the dfops structure to ensure appropriate relogging.
> While buffers are currently joined explicitly, we can detect the
> conditions that require relogging at dfops finish time by inspecting
> the transaction item list for held buffers.
> 
> Replace the xfs_defer_bjoin() infrastructure with such detection and
> automatic relogging of held buffers. This eliminates the need for
> the per-dfops buffer list, replaced by an on-stack variant in
> xfs_defer_trans_roll().

Looks good modulo added error checking as noted by Darrick:

Reviewed-by: Christoph Hellwig <hch@lst.de>
