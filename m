Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:42410 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752562AbeGBNu1 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 2 Jul 2018 09:50:27 -0400
Date: Mon, 2 Jul 2018 06:50:21 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 12/24] xfs: remove xfs_bmapi_write() dfops param
Message-ID: <20180702135021.GL19162@infradead.org>
References: <20180628163636.52564-1-bfoster@redhat.com>
 <20180628163636.52564-13-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180628163636.52564-13-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: linux-xfs@vger.kernel.org

On Thu, Jun 28, 2018 at 12:36:24PM -0400, Brian Foster wrote:
> Now that all callers use ->t_dfops, the xfs_bmapi_write() dfops
> parameter is no longer necessary. Remove it and access ->t_dfops
> directly. This patch does not change behavior.
> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
