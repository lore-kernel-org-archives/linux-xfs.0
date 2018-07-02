Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:52504 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752110AbeGBNzO (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 2 Jul 2018 09:55:14 -0400
Date: Mon, 2 Jul 2018 06:55:09 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 22/24] xfs: use ->t_dfops in cancel cow blocks operation
Message-ID: <20180702135509.GV19162@infradead.org>
References: <20180628163636.52564-1-bfoster@redhat.com>
 <20180628163636.52564-23-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180628163636.52564-23-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: linux-xfs@vger.kernel.org

On Thu, Jun 28, 2018 at 12:36:34PM -0400, Brian Foster wrote:
> Use ->t_dfops of the transaction from the caller. Reset it before we
> return to avoid leaks of local stack memory.

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
