Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:35656 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751546AbdLEBej (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 4 Dec 2017 20:34:39 -0500
Date: Mon, 4 Dec 2017 17:34:22 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH] xfs: remove "no-allocation" reservations for file
 creations
Message-ID: <20171205013422.GC19219@magnolia>
References: <20170821082404.3387-1-hch@lst.de>
 <20170823202213.GA4796@magnolia>
 <20170824004755.GC21024@dastard>
 <20170829180445.GU4757@magnolia>
 <20170903072513.GA14807@lst.de>
 <20170903153150.GE4073@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170903153150.GE4073@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org

On Sun, Sep 03, 2017 at 08:31:50AM -0700, Darrick J. Wong wrote:
> On Sun, Sep 03, 2017 at 09:25:13AM +0200, Christoph Hellwig wrote:
> > Looks like this didn't make the 4.14 for-next branch either.  I guess
> > we'll just consider it for the next round?
> 
> Yes, it caused a number of new xfstests failures due to new ENOSPC
> messages in the golden output so I decided to defer action on it until
> someone can assess and fix the problems appropriately.  The worst part
> was that the new failures are intermittent.

Heh, a customer slammed right into this, so I'll try to pick up this
patch again and fix all the xfstests....

--D

> --D
> 
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
