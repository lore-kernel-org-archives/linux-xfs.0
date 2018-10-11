Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:33796 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727529AbeJKN3N (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 11 Oct 2018 09:29:13 -0400
Date: Wed, 10 Oct 2018 23:03:30 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 15/18] xfs_repair: fix 'bno' shadow vars in scan.c
Message-ID: <20181011060330.GO20811@infradead.org>
References: <1539201682-22198-1-git-send-email-sandeen@redhat.com>
 <1539201682-22198-16-git-send-email-sandeen@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1539201682-22198-16-git-send-email-sandeen@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@redhat.com>
Cc: linux-xfs@vger.kernel.org

On Wed, Oct 10, 2018 at 03:01:19PM -0500, Eric Sandeen wrote:
> scan.c has 3 functions which accept 'bno' as an argument, but then use a
> local variable of the same name for a different purpose in an inner scope,
> which causes sparse warnings.
> Rename these inner-scope loop variables 'agbno' to fix this.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
