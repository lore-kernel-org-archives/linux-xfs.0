Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:36143 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S965686AbdKQQrq (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 17 Nov 2017 11:47:46 -0500
Date: Fri, 17 Nov 2017 08:47:45 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfs: fix type usage
Message-ID: <20171117164745.GA17447@infradead.org>
References: <20171116194344.GJ5119@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171116194344.GJ5119@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: xfs <linux-xfs@vger.kernel.org>, Eric Sandeen <sandeen@redhat.com>

On Thu, Nov 16, 2017 at 11:43:44AM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Be consistent about using uint32_t/uint8_t instead of u32/u8.  This is
> more so that we don't have to maintain /those/ types in xfsprogs.

Hmm..  The u* types are pretty common all over the kernel.  They
probably will creep back eventually..  But if this is easier the
change is fine with me:

Reviewed-by: Christoph Hellwig <hch@lst.de>
