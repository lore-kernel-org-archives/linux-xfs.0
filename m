Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:33738 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727529AbeJKN0r (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 11 Oct 2018 09:26:47 -0400
Date: Wed, 10 Oct 2018 23:01:05 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 10/18] avl64: export avl64_firstino / avl64_firstino from
 avl64.h
Message-ID: <20181011060105.GJ20811@infradead.org>
References: <1539201682-22198-1-git-send-email-sandeen@redhat.com>
 <1539201682-22198-11-git-send-email-sandeen@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1539201682-22198-11-git-send-email-sandeen@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@redhat.com>
Cc: linux-xfs@vger.kernel.org

On Wed, Oct 10, 2018 at 03:01:14PM -0500, Eric Sandeen wrote:
> These are flagged by the sparse checker as possibly static.
> They are actually not used at this point; avl64.c has a few unused
> functions and/or ones that could be made static, but for now just silence
> the warnings, and save deeper surgery for later.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>

They've been unused for how long?  I'd favor just removing them, but
until that happens:

Reviewed-by: Christoph Hellwig <hch@lst.de>
