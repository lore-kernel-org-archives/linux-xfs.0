Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:48862 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751931AbeGBNwa (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 2 Jul 2018 09:52:30 -0400
Date: Mon, 2 Jul 2018 06:52:27 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 15/24] xfs: remove xfs_bmapi_remap() dfops param
Message-ID: <20180702135227.GO19162@infradead.org>
References: <20180628163636.52564-1-bfoster@redhat.com>
 <20180628163636.52564-16-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180628163636.52564-16-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: linux-xfs@vger.kernel.org

On Thu, Jun 28, 2018 at 12:36:27PM -0400, Brian Foster wrote:
> All xfs_bmapi_remap() callers already use ->t_dfops. Note that
> deferred completion context unconditionally sets ->t_dfops if it
> hasn't already been set by the caller. Remove the unnecessary
> parameter and access ->t_dfops directly.
> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
