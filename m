Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:59318 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727318AbfEJRYq (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 10 May 2019 13:24:46 -0400
Date: Fri, 10 May 2019 10:24:46 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/6] xfs: refactor small allocation helper to skip cntbt
 attempt
Message-ID: <20190510172446.GA18992@infradead.org>
References: <20190509165839.44329-1-bfoster@redhat.com>
 <20190509165839.44329-2-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190509165839.44329-2-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: linux-xfs@vger.kernel.org

This looks pretty sensible to me.  What confuses me a bit is that
the patch is much more (good!) refactoring than the actual change.

If you have to respin it maybe split it up, making the actual
behavior change even more obvious.

Otherwise:

Reviewed-by: Christoph Hellwig <hch@lst.de>
