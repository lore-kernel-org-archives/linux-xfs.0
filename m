Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:43630 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752121AbeFTIfQ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 20 Jun 2018 04:35:16 -0400
Date: Wed, 20 Jun 2018 00:42:34 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 2/2] xfs: kill __xfs_buf_submit_common()
Message-ID: <20180620074234.GD5257@infradead.org>
References: <20180618145244.30393-1-bfoster@redhat.com>
 <20180618145244.30393-3-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180618145244.30393-3-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: linux-xfs@vger.kernel.org, Christoph Hellwig <hch@infradead.org>

On Mon, Jun 18, 2018 at 10:52:44AM -0400, Brian Foster wrote:
> Now that there is only one caller, fold the common submission helper
> into __xfs_buf_submit().
> 
> Suggested-by: Christoph Hellwig <hch@infradead.org>
> Signed-off-by: Brian Foster <bfoster@redhat.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
