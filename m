Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:52902 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727079AbfHLITz (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 12 Aug 2019 04:19:55 -0400
Date: Mon, 12 Aug 2019 01:19:54 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v2 00/18] Delayed Attributes
Message-ID: <20190812081954.GA9484@infradead.org>
References: <20190809213726.32336-1-allison.henderson@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190809213726.32336-1-allison.henderson@oracle.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Allison Collins <allison.henderson@oracle.com>
Cc: linux-xfs@vger.kernel.org

Btw, this seems like the right series to also look into our problem
that large attributes are not updated transactionally.  We just do
a synchronous write (xfs_bwrite) for them but don't include them
in the transaction.  With the deferred operations and rolled
transactions that should be fairly easy to fix.
