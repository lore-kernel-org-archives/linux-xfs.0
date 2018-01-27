Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:59595 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751520AbeA0Hew (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 27 Jan 2018 02:34:52 -0500
Date: Fri, 26 Jan 2018 23:34:50 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 5/7] iomap: warn on zero-length mappings
Message-ID: <20180127073450.GE11515@infradead.org>
References: <151701540938.3070.15043243007590700677.stgit@magnolia>
 <151701544071.3070.9611886870612110372.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <151701544071.3070.9611886870612110372.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: bfoster@redhat.com, linux-xfs@vger.kernel.org

> -	if (WARN_ON(iomap.offset > pos))
> +	if (WARN_ON(iomap.offset > pos) || WARN_ON(iomap.length == 0))

Btw, shouldn't this be one WARN_ON with both conditions inside?
It's not like we can spot which one it was based on the output
anyway.

Alternatively just have two conditionals, which allows us to spot
what went wrong.
