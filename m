Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:35989 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1758752AbcLSK03 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 19 Dec 2016 05:26:29 -0500
Date: Mon, 19 Dec 2016 02:26:28 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfs_quota: handle wrapped id from GETNEXTQUOTA
Message-ID: <20161219102628.GC25661@infradead.org>
References: <ce6f019b-e851-eef0-17aa-b98e3a563de4@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ce6f019b-e851-eef0-17aa-b98e3a563de4@sandeen.net>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: linux-xfs <linux-xfs@vger.kernel.org>

On Fri, Dec 16, 2016 at 06:13:53PM -0600, Eric Sandeen wrote:
> The GETNEXTQUOTA interface in the kernel had a bug
> (at least in xfs) where if we pass in UINT_MAX as the
> ID, it incremented, warpped, and returned 0 for the next
> id.  This would cause userspace to start querying
> again at zero, and an xfs_quota "report" command would
> loop forever.  This occurred if a quota ID near
> UINT max existed, and later offsets within the block
> wrapped the xfs_dqid_t.
> 
> This will also be fixed in the kernel, but we should also
> catch this in userspace, and stop the loop if it happens.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>

Looks fine,

Reviewed-by: Christoph Hellwig <hch@lst.de>
