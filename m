Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:51080 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752556AbeGBNyV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 2 Jul 2018 09:54:21 -0400
Date: Mon, 2 Jul 2018 06:54:20 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 20/24] xfs: remove unused btree cursor bc_private.a.dfops
 field
Message-ID: <20180702135420.GT19162@infradead.org>
References: <20180628163636.52564-1-bfoster@redhat.com>
 <20180628163636.52564-21-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180628163636.52564-21-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: linux-xfs@vger.kernel.org

On Thu, Jun 28, 2018 at 12:36:32PM -0400, Brian Foster wrote:
> The xfs_btree_cur.bc_private.a.dfops field is only ever initialized
> by the refcountbt cursor init function. The only caller of that
> function with a non-NULL dfops is from deferred completion context,
> which already has attached to ->t_dfops.
> 
> In addition to that, the only actual reference of a.dfops is the
> cursor duplication function, which means the field is effectively
> unused.
> 
> Remove the dfops field from the bc_private.a union. Any future users
> can acquire the dfops from the transaction. This patch does not
> change behavior.

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
