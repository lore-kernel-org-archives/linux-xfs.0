Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:48530 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750843AbdAMRMF (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 13 Jan 2017 12:12:05 -0500
Date: Fri, 13 Jan 2017 09:12:04 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v2 4/5] xfs: free cowblocks and retry on buffered write
 ENOSPC
Message-ID: <20170113171204.GA27605@infradead.org>
References: <1484157249-464-1-git-send-email-bfoster@redhat.com>
 <1484157249-464-5-git-send-email-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1484157249-464-5-git-send-email-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: linux-xfs@vger.kernel.org

On Wed, Jan 11, 2017 at 12:54:08PM -0500, Brian Foster wrote:
> XFS runs an eofblocks reclaim scan before returning an ENOSPC error to
> userspace for buffered writes. This facilitates aggressive speculative
> preallocation without causing user visible side effects such as
> premature ENOSPC.
> 
> Run a cowblocks scan in the same situation to reclaim lingering COW fork
> preallocation throughout the filesystem.

This should probably go into 4.10-rc..

Reviewed-by: Christoph Hellwig <hch@lst.de>
