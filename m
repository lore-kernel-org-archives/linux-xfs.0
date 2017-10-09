Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:46169 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755014AbdJIVOX (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 9 Oct 2017 17:14:23 -0400
Date: Mon, 9 Oct 2017 14:14:19 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 21/25] xfs: scrub extended attributes
Message-ID: <20171009211419.GV7122@magnolia>
References: <150706324963.19351.17715069858921948692.stgit@magnolia>
 <150706338252.19351.5670406854902904109.stgit@magnolia>
 <20171009021312.GC3666@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171009021312.GC3666@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org

On Mon, Oct 09, 2017 at 01:13:12PM +1100, Dave Chinner wrote:
> On Tue, Oct 03, 2017 at 01:43:02PM -0700, Darrick J. Wong wrote:
> > +/* Extended Attributes */
> > +
> > +struct xfs_scrub_xattr {
> > +	struct xfs_attr_list_context	context;
> > +	struct xfs_scrub_context	*sc;
> > +};
> 
> A comment here explaining that we are using the listattr callback
> infrastructure to scrub the xattr?

New comments:

/*
 * Check that an extended attribute key can be looked up by hash.
 *
 * We use the XFS attribute list iterator (i.e. xfs_attr_list_int_ilocked)
 * to call this function for every attribute key in an inode.  Once
 * we're here, we load the attribute value to see if any errors happen,
 * or if we get more or less data than we expected.
 */

...comes before the definition of xfs_scrub_xattr_listent, and...

/*
 * Look up every xattr in this file by name.
 *
 * Use the backend implementation of xfs_attr_list to call
 * xfs_scrub_xattr_listent on every attribute key in this inode.
 * In other words, we use the same iterator/callback mechanism
 * that listattr uses to scrub extended attributes, though in our
 * _listent function, we check the value of the attribute.
 *
 * The VFS only locks i_rwsem when modifying attrs, so keep all
 * three locks held because that's the only way to ensure we're
 * the only thread poking into the da btree.  We traverse the da
 * btree while holding a leaf buffer locked for the xattr name
 * iteration, which doesn't really follow the usual buffer
 * locking order.
 */

...comes right before the call to xfs_attr_list_int_ilocked.

> And, now that I've got to the rest of the code, that we don't validate
> the pointers/values in the attribute records when doing dabtree record
> check because we are doing that indirectly afterwards by reading every
> attribute value.

Correct.

> And that this follows the pointers for remote attr blocks and reads
> them, hence checking the remote attr is valid via verifiers?

Correct.

> And, with that out of the way, what about attributes that listent
> skips?

Oops, I forgot those.

> i.e. those with the flag that says they are not valid?  We don't check
> they exist or are valid, and their existence would be a case for
> preening the xattr tree...

Good point, I'll add those.

> Otherwise this seems pretty straight forward...

Woot.

--D

> 
> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
