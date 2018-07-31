Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:34884 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727015AbeGaJWO (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 31 Jul 2018 05:22:14 -0400
Date: Tue, 31 Jul 2018 00:43:13 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] misc: remove COPYING from doc/ Makefile
Message-ID: <20180731074313.GA19990@infradead.org>
References: <e4d64c9b-5a1a-54b5-8b69-463738c95307@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e4d64c9b-5a1a-54b5-8b69-463738c95307@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@redhat.com>
Cc: linux-xfs <linux-xfs@vger.kernel.org>

On Mon, Jul 30, 2018 at 10:41:54PM -0500, Eric Sandeen wrote:
> COPYING is gone now, so make doc-install breaks.
> 
> Fixes: 959ef98 ("xfsprogs: convert to SPDX license tags")
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>

The patch itself looks good, but I think we have a deeper problem,
in that there is no actual license information anywhere in xfsprogs now.

We need to fix that up similar to the LICENSES/ directory in the kernel.
SPDX tags are good and nice, but without an explanation what they mean
in the same source tree they are useless.
