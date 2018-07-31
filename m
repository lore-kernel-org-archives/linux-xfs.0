Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:37992 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727307AbeGaKLG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 31 Jul 2018 06:11:06 -0400
Date: Tue, 31 Jul 2018 01:31:53 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 13/15] xfs: pass transaction to xfs_defer_add()
Message-ID: <20180731083153.GB9242@infradead.org>
References: <20180730164520.36882-1-bfoster@redhat.com>
 <20180730164520.36882-14-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180730164520.36882-14-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: linux-xfs@vger.kernel.org

This is the right patch to add an assert for a permanent transaction
in xfs_defer_add.

Except for that this looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
