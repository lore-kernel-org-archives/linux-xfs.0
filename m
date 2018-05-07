Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:41892 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751989AbeEGOof (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 7 May 2018 10:44:35 -0400
Date: Mon, 7 May 2018 07:44:34 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 2/2] xfs: clean up locking in xfs_file_iomap_begin
Message-ID: <20180507144434.GB7476@infradead.org>
References: <20180502055144.28851-1-david@fromorbit.com>
 <20180502055144.28851-3-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180502055144.28851-3-david@fromorbit.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org

Maybe its because I wrote a lot of the original code, but I really
don't see how this makes thing any more clean.
