Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:39578 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751931AbeGBNsl (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 2 Jul 2018 09:48:41 -0400
Date: Mon, 2 Jul 2018 06:48:40 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 09/24] xfs: replace xfs_da_args->dfops accesses with
 ->t_dfops and remove
Message-ID: <20180702134840.GI19162@infradead.org>
References: <20180628163636.52564-1-bfoster@redhat.com>
 <20180628163636.52564-10-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180628163636.52564-10-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: linux-xfs@vger.kernel.org

On Thu, Jun 28, 2018 at 12:36:21PM -0400, Brian Foster wrote:
> Now that xfs_da_args->dfops is always assigned from a ->t_dfops
> pointer (or one that is immediately attached), replace all
> downstream accesses of the former with the latter and remove the
> field from struct xfs_da_args.
> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
