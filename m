Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:36508 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727401AbeGSUfQ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 19 Jul 2018 16:35:16 -0400
Date: Thu, 19 Jul 2018 12:50:39 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 02/14] xfs: use ->t_dfops in log recovery intent
 processing
Message-ID: <20180719195039.GC6558@infradead.org>
References: <20180719134919.29939-1-bfoster@redhat.com>
 <20180719134919.29939-3-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180719134919.29939-3-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: linux-xfs@vger.kernel.org

On Thu, Jul 19, 2018 at 09:49:07AM -0400, Brian Foster wrote:
> xlog_finish_defer_ops() processes the deferred operations collected
> over the entire intent recovery sequence. We can't xfs_defer_init()
> here because the dfops is already populated. Attach it manually and
> eliminate the last caller of xfs_defer_finish() that doesn't pass
> ->t_dfops.

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
