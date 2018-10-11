Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:33614 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727065AbeJKNYN (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 11 Oct 2018 09:24:13 -0400
Date: Wed, 10 Oct 2018 22:58:32 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 02/18] xfs_db: convert single-bit bitfields  to bools
Message-ID: <20181011055832.GB20811@infradead.org>
References: <1539201682-22198-1-git-send-email-sandeen@redhat.com>
 <1539201682-22198-3-git-send-email-sandeen@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1539201682-22198-3-git-send-email-sandeen@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@redhat.com>
Cc: linux-xfs@vger.kernel.org

On Wed, Oct 10, 2018 at 03:01:06PM -0500, Eric Sandeen wrote:
> Sparse doesn't like signed single-bit bitfields, and they may as well
> just be booleans.
> 
> Fixes sparse warnings about this.

Looks good, although we could still do bool bitfields to save a tiny
bit of space if we areally cared:

Reviewed-by: Christoph Hellwig <hch@lst.de>
