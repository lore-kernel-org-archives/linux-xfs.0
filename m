Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:55730 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725781AbfEOGu7 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 15 May 2019 02:50:59 -0400
Date: Tue, 14 May 2019 23:50:59 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 02/11] libxfs: remove xfs_inode_log_item ili_flags
Message-ID: <20190515065059.GB29211@infradead.org>
References: <1557519510-10602-1-git-send-email-sandeen@redhat.com>
 <1557519510-10602-3-git-send-email-sandeen@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1557519510-10602-3-git-send-email-sandeen@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@redhat.com>
Cc: linux-xfs@vger.kernel.org

On Fri, May 10, 2019 at 03:18:21PM -0500, Eric Sandeen wrote:
> ili_flags is only set to zero and asserted to be zero; it serves
> no purpose, so remove it.
> 
> (it was renamed to ili_lock_flags in the kernel in commit 898621d5,
> for some reason userspace had both, with ili_flags ~unused)

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
