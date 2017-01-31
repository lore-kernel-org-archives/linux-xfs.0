Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:42546 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751990AbdAaNmw (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 31 Jan 2017 08:42:52 -0500
Date: Tue, 31 Jan 2017 05:42:51 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 5/7] xfs: verify free block header fields
Message-ID: <20170131134251.GB10866@infradead.org>
References: <148582218411.12293.806854574193653038.stgit@birch.djwong.org>
 <148582222091.12293.17492997585015211348.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <148582222091.12293.17492997585015211348.stgit@birch.djwong.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

Looks fine,

Reviewed-by: Christoph Hellwig <hch@lst.de>

Minor nitpick below:

> +	if (err || !(*bpp))

no need for the inner braces.
