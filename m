Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:42840 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751945AbdIAPzY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 1 Sep 2017 11:55:24 -0400
Date: Fri, 1 Sep 2017 08:54:53 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH v2] xfs: fix compiler warnings
Message-ID: <20170901155453.GZ3775@magnolia>
References: <20170831233833.GT3775@magnolia>
 <20170901081005.GB32746@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170901081005.GB32746@infradead.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs <linux-xfs@vger.kernel.org>, Brian Foster <bfoster@redhat.com>, Dave Chinner <david@fromorbit.com>

On Fri, Sep 01, 2017 at 01:10:05AM -0700, Christoph Hellwig wrote:
> Can we please just ensure ASSERT always evaluates the argument,
> similar to BUG()?

Assuming you meant BUG_ON or something that actually takes a parameter,
yes you can do that, though now we have to fix up a bunch of things like
the xfs_trans debug counter asserts and anything that asserts on
xfs_isilocked.

-.text                         785555      0
+.text                         787843      0

I guess that's only 0.29% larger...

--D

> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
