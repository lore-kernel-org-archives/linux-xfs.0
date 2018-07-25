Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:56610 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726950AbeGYGN4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 25 Jul 2018 02:13:56 -0400
Date: Tue, 24 Jul 2018 22:04:02 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v2 08/15] xfs: support embedded dfops in transaction
Message-ID: <20180725050402.GA5802@infradead.org>
References: <20180723130414.47980-1-bfoster@redhat.com>
 <20180723130414.47980-9-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180723130414.47980-9-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: linux-xfs@vger.kernel.org

On Mon, Jul 23, 2018 at 09:04:07AM -0400, Brian Foster wrote:
> The dfops structure used by multi-transaction operations is
> typically stored on the stack and carried around by the associated
> transaction. The lifecycle of dfops does not quite match that of the
> transaction, but they are tightly related in that the former depends
> on the latter.
> 
> The relationship of these objects is tight enough that we can avoid
> the cumbersome boilerplate code required in most cases to manage
> them separately by just embedding an xfs_defer_ops in the
> transaction itself. This means that a transaction allocation returns
> with an initialized dfops, a transaction commit finishes pending
> deferred items before the tx commit, a transaction cancel cancels
> the dfops before the transaction and a transaction dup operation
> transfers the current dfops state to the new transaction.
> 
> The dup operation is slightly complicated by the fact that we can no
> longer just copy a dfops pointer from the old transaction to the new
> transaction. This is solved through a dfops move helper that
> transfers the pending items and other dfops state across the
> transactions. This also requires that transaction rolling code
> always refer to the transaction for the current dfops reference.
> 
> Finally, to facilitate incremental conversion to the internal dfops
> and continue to support the current external dfops mode of
> operation, create the new ->t_dfops_internal field with a layer of
> indirection. On allocation, ->t_dfops points to the internal dfops.
> This state is overridden by callers who re-init a local dfops on the
> transaction. Once ->t_dfops is overridden, the external dfops
> reference is maintained as the transaction rolls.
> 
> This patch adds the fundamental ability to support an internal
> dfops. All codepaths that perform deferred processing continue to
> override the internal dfops until they are converted over in
> subsequent patches.
> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
