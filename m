Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:33652 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726846AbeJKNY7 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 11 Oct 2018 09:24:59 -0400
Date: Wed, 10 Oct 2018 22:59:17 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 04/18] xfsprogs: avoid redefinition of NBBY
Message-ID: <20181011055917.GD20811@infradead.org>
References: <1539201682-22198-1-git-send-email-sandeen@redhat.com>
 <1539201682-22198-5-git-send-email-sandeen@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1539201682-22198-5-git-send-email-sandeen@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@redhat.com>
Cc: linux-xfs@vger.kernel.org

On Wed, Oct 10, 2018 at 03:01:08PM -0500, Eric Sandeen wrote:
> Include sys/param.h for NBBY definition.  Do this before our local
> guarded definition which is for platforms like android that don't have it,
> see commit:
> 
> c9a90185 xfsprogs: define NBBY if not defined by the system header files
> 
> Fixes sparse warnings about this redefinition.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
