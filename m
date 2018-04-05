Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:55872 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750853AbeDEHPe (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 5 Apr 2018 03:15:34 -0400
Date: Thu, 5 Apr 2018 00:15:33 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 5/6] xfs: factor out quota time limit initialization
Message-ID: <20180405071533.GE17256@infradead.org>
References: <f0856054-551f-9139-39f7-1d5439910903@sandeen.net>
 <2d87ba58-f713-6326-8683-29185155ee58@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2d87ba58-f713-6326-8683-29185155ee58@sandeen.net>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: linux-xfs <linux-xfs@vger.kernel.org>

On Wed, Apr 04, 2018 at 02:10:20PM -0500, Eric Sandeen wrote:
> Factor out the time limit initialization from
> xfs_qm_init_quotainfo so that we can delay it until
> after quotacheck - it requires reading the default disk
> quotas, which may need repair.
> 
> No functional changes in this patch.

You have 75 characters per line for your changelog, use them!

Otherwise looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
