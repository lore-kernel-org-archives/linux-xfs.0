Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:50752 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752475AbeGBNxr (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 2 Jul 2018 09:53:47 -0400
Date: Mon, 2 Jul 2018 06:53:46 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 19/24] xfs: remove xfs_btree_cur bmbt dfops field
Message-ID: <20180702135346.GS19162@infradead.org>
References: <20180628163636.52564-1-bfoster@redhat.com>
 <20180628163636.52564-20-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180628163636.52564-20-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: linux-xfs@vger.kernel.org

On Thu, Jun 28, 2018 at 12:36:31PM -0400, Brian Foster wrote:
> All assignments of xfs_btree_cur.bc_private.b.dfops originate from
> ->t_dfops. Replace accesses of the former with the latter and remove
> the unnecessary field. This patch does not change behavior.
> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
