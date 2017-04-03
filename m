Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:51224 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750855AbdDCS5D (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 3 Apr 2017 14:57:03 -0400
Date: Mon, 3 Apr 2017 11:57:02 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfs: fix over-copying of getbmap parameters from
 userspace
Message-ID: <20170403185702.GA28344@infradead.org>
References: <20170403173430.GL4864@birch.djwong.org>
 <20170403173619.GM4864@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170403173619.GM4864@birch.djwong.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: xfs <linux-xfs@vger.kernel.org>, Eric Sandeen <sandeen@redhat.com>, Christoph Hellwig <hch@infradead.org>

> +	 * so using a straight memory copy should work fine.

I'd skip this half of the comment.

Otherwise looks fine:

Reviewed-by: Christoph Hellwig <hch@lst.de>
