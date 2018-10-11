Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:33788 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727529AbeJKN2z (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 11 Oct 2018 09:28:55 -0400
Date: Wed, 10 Oct 2018 23:03:12 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 14/18] xfs_logprint: fix shadow var in
 xlog_print_trans_buffer
Message-ID: <20181011060312.GN20811@infradead.org>
References: <1539201682-22198-1-git-send-email-sandeen@redhat.com>
 <1539201682-22198-15-git-send-email-sandeen@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1539201682-22198-15-git-send-email-sandeen@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@redhat.com>
Cc: linux-xfs@vger.kernel.org

On Wed, Oct 10, 2018 at 03:01:18PM -0500, Eric Sandeen wrote:
> xlog_print_trans_buffer takes 'i' as an argument, but then uses it later
> as a local byte counter.  Give the local var more useful, non-shadow
> name of "byte"
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
