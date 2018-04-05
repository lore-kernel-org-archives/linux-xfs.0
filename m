Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:55898 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750915AbeDEHQA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 5 Apr 2018 03:16:00 -0400
Date: Thu, 5 Apr 2018 00:16:00 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 6/6] xfs: delay quota timelimit init until after
 quotacheck
Message-ID: <20180405071600.GF17256@infradead.org>
References: <f0856054-551f-9139-39f7-1d5439910903@sandeen.net>
 <49eeb340-2ff2-c274-d26b-fd8edd982d61@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49eeb340-2ff2-c274-d26b-fd8edd982d61@sandeen.net>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: linux-xfs <linux-xfs@vger.kernel.org>

On Wed, Apr 04, 2018 at 02:12:40PM -0500, Eric Sandeen wrote:
> Initializing the time limits in the quota info requires reading
> the default quota block.  If it's corrupt, this yields even more
> dmesg spew before kernelspace gets around to properly detecting
> and repairing the corruption.
> 
> If we move the read and initialization until post-quotacheck,
> we can avoid the noisy read if it's corrupted.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
