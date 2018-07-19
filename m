Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:36548 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727502AbeGSUho (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 19 Jul 2018 16:37:44 -0400
Date: Thu, 19 Jul 2018 12:53:06 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 05/14] xfs: remove unused deferred ops committed field
Message-ID: <20180719195306.GF6558@infradead.org>
References: <20180719134919.29939-1-bfoster@redhat.com>
 <20180719134919.29939-6-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180719134919.29939-6-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: linux-xfs@vger.kernel.org

On Thu, Jul 19, 2018 at 09:49:10AM -0400, Brian Foster wrote:
> dop_committed is set when deferred item processing rolls the
> transaction at least once, but is only ever accessed in tracepoints.
> The transaction roll/commit events are already available via
> independent tracepoints, so remove the otherwise unused field.
> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
