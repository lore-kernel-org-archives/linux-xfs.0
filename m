Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:52116 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727507AbeJZUvG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 26 Oct 2018 16:51:06 -0400
Date: Fri, 26 Oct 2018 05:14:13 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 5/5] xfs: reverse search directory freespace indexes
Message-ID: <20181026121413.GB27890@infradead.org>
References: <20181024225716.19459-1-david@fromorbit.com>
 <20181024225716.19459-6-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181024225716.19459-6-david@fromorbit.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org

This:

>  	/* If we haven't get a search start block, set it now */
>  	if (fbno == -1)
		fbno = xfs_dir2_byte_to_db(args->geo, XFS_DIR2_FREE_OFFSET);

Can be removed now, as it will be overwritten again a few lines down.
