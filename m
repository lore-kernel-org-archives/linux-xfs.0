Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:40788 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752108AbeA0SE7 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 27 Jan 2018 13:04:59 -0500
Date: Sat, 27 Jan 2018 10:04:39 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 5/7] iomap: warn on zero-length mappings
Message-ID: <20180127180439.GH9068@magnolia>
References: <151701540938.3070.15043243007590700677.stgit@magnolia>
 <151701544071.3070.9611886870612110372.stgit@magnolia>
 <20180127073450.GE11515@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180127073450.GE11515@infradead.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: bfoster@redhat.com, linux-xfs@vger.kernel.org

On Fri, Jan 26, 2018 at 11:34:50PM -0800, Christoph Hellwig wrote:
> > -	if (WARN_ON(iomap.offset > pos))
> > +	if (WARN_ON(iomap.offset > pos) || WARN_ON(iomap.length == 0))
> 
> Btw, shouldn't this be one WARN_ON with both conditions inside?
> It's not like we can spot which one it was based on the output
> anyway.
> 
> Alternatively just have two conditionals, which allows us to spot
> what went wrong.

Ah, right, I forgot that WARN_ON doesn't print the failing condition
unlike our ASSERT.

--D

> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
