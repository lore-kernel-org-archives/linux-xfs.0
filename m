Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:43403 "EHLO
        ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752072AbdJICSK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 8 Oct 2017 22:18:10 -0400
Date: Mon, 9 Oct 2017 13:13:12 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 21/25] xfs: scrub extended attributes
Message-ID: <20171009021312.GC3666@dastard>
References: <150706324963.19351.17715069858921948692.stgit@magnolia>
 <150706338252.19351.5670406854902904109.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <150706338252.19351.5670406854902904109.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Tue, Oct 03, 2017 at 01:43:02PM -0700, Darrick J. Wong wrote:
> +/* Extended Attributes */
> +
> +struct xfs_scrub_xattr {
> +	struct xfs_attr_list_context	context;
> +	struct xfs_scrub_context	*sc;
> +};

A comment here explaining that we are using the listattr callback
infrastructure to scrub the xattr?  And, now that I've got to the
rest of the code, that we don't validate the pointers/values in the
attribute records when doing dabtree record check because we are
doing that indirectly afterwards by reading every attribute value.
And that this follows the pointers for remote attr blocks and reads
them, hence checking the remote attr is valid via verifiers?

And, with that out of the way, what about attributes that listent
skips? i.e. those with the flag that says they are not valid? We
don't check they exist or are valid, and their existence would be
a case for preening the xattr tree...

Otherwise this seems pretty straight forward...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
