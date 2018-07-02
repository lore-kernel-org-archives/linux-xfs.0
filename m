Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:36190 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751535AbeGBNq0 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 2 Jul 2018 09:46:26 -0400
Date: Mon, 2 Jul 2018 06:46:25 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 06/24] xfs: use ->t_dfops for attr set/remove operations
Message-ID: <20180702134625.GF19162@infradead.org>
References: <20180628163636.52564-1-bfoster@redhat.com>
 <20180628163636.52564-7-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180628163636.52564-7-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: linux-xfs@vger.kernel.org

On Thu, Jun 28, 2018 at 12:36:18PM -0400, Brian Foster wrote:
> Attach the local dfops to the transaction allocated for xattr add
> and remove operations. Add an earlier initialization in
> xfs_attr_remove() to ensure the structure is valid if it remains
> unused at transaction commit time.

Looks fine:

Reviewed-by: Christoph Hellwig <hch@lst.de>
