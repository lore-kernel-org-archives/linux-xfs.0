Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:46857 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750731AbdLLO0P (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 12 Dec 2017 09:26:15 -0500
Date: Tue, 12 Dec 2017 06:26:15 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfs: include the XFS magic number in magic.h
Message-ID: <20171212142615.GA25327@infradead.org>
References: <1513088469.3476.48.camel@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1513088469.3476.48.camel@linux.vnet.ibm.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
Cc: linux-xfs <linux-xfs@vger.kernel.org>, Christoph Hellwig <hch@infradead.org>

On Tue, Dec 12, 2017 at 09:21:09AM -0500, Mimi Zohar wrote:
> Move the XFS_SB_MAGIC definition to magic.h.

NACK.  We want to keep the XFS code self-contained and no other part
of the kernel has any business knowing it anyway.
