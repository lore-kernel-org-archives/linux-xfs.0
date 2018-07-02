Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:39966 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751581AbeGBNtl (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 2 Jul 2018 09:49:41 -0400
Date: Mon, 2 Jul 2018 06:49:41 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 11/24] xfs: use ->t_dfops for all xfs_bmapi_write()
 callers
Message-ID: <20180702134941.GK19162@infradead.org>
References: <20180628163636.52564-1-bfoster@redhat.com>
 <20180628163636.52564-12-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180628163636.52564-12-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: linux-xfs@vger.kernel.org

On Thu, Jun 28, 2018 at 12:36:23PM -0400, Brian Foster wrote:
> Attach ->t_dfops for all remaining callers of xfs_bmapi_write().
> This prepares the latter to no longer require a separate dfops
> parameter.
> 
> Note that xfs_symlink() already uses ->t_dfops. Fix up the local
> references for consistency.

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
