Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:36258 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752273AbeGBNrp (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 2 Jul 2018 09:47:45 -0400
Date: Mon, 2 Jul 2018 06:47:45 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 07/24] xfs: remove dfops param in attr fork add path
Message-ID: <20180702134745.GG19162@infradead.org>
References: <20180628163636.52564-1-bfoster@redhat.com>
 <20180628163636.52564-8-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180628163636.52564-8-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: linux-xfs@vger.kernel.org

On Thu, Jun 28, 2018 at 12:36:19PM -0400, Brian Foster wrote:
> Now that the attribute fork add tx carries dfops along with the
> transaction, it is unnecessary to pass it down the stack. Remove the
> dfops parameter and access ->t_dfops directly where necessary. This
> patch does not change behavior.
> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
