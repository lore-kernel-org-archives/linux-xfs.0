Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:44766 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750732AbeEGOs0 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 7 May 2018 10:48:26 -0400
Date: Mon, 7 May 2018 07:48:25 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 02/10] xfs: catch log items multiply joined to a
 transaction
Message-ID: <20180507144825.GD7476@infradead.org>
References: <20180502080157.11386-1-david@fromorbit.com>
 <20180502080157.11386-3-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180502080157.11386-3-david@fromorbit.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org

Looks good, but I think this should be moved later in the series
until you have actually fixed the existing issues that it did catch.

Then again once the log item descriptor is removed later in the series
the flag added here becomes rather pointless as the core linked list
debugging would also find these issues.

In case it stays in:

Reviewed-by: Christoph Hellwig <hch@lst.de>
