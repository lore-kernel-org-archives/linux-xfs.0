Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:33828 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727529AbeJKNaD (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 11 Oct 2018 09:30:03 -0400
Date: Wed, 10 Oct 2018 23:04:20 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 17/18] xfs_metadump: remove shadow variable
Message-ID: <20181011060420.GQ20811@infradead.org>
References: <1539201682-22198-1-git-send-email-sandeen@redhat.com>
 <1539201682-22198-18-git-send-email-sandeen@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1539201682-22198-18-git-send-email-sandeen@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@redhat.com>
Cc: linux-xfs@vger.kernel.org

On Wed, Oct 10, 2018 at 03:01:21PM -0500, Eric Sandeen wrote:
> "length" is used in 2 nested inner scopes, which is fairly unclear and
> generates a sparse warning.  Rename the inner scope variable for clarity.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>

Looks fine,

Reviewed-by: Christoph Hellwig <hch@lst.de>
