Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:46178 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932845AbeFUTrz (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 21 Jun 2018 15:47:55 -0400
Date: Thu, 21 Jun 2018 12:47:38 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH] xfs_bmap: don't reject -e
Message-ID: <20180621194738.GF4838@magnolia>
References: <20180621184945.GE4838@magnolia>
 <9abcfd43-7d1f-bc8f-299b-0d015c4f2241@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9abcfd43-7d1f-bc8f-299b-0d015c4f2241@sandeen.net>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Eric Sandeen <sandeen@redhat.com>, xfs <linux-xfs@vger.kernel.org>

On Thu, Jun 21, 2018 at 02:32:44PM -0500, Eric Sandeen wrote:
> On 6/21/18 1:49 PM, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > The xfs_io bmap command has an -e switch that prints delalloc extents
> > without fsync'ing the file first.  The xfs_bmap manpage says it'll pass
> > -e through, but it doesn't.  Fix the script and fix the weird manpage
> > discrepancy where it doesn't list -e in the available options but
> > discusses it anyway.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> 
> need to fix it all up for "-c" as well, right?

The cow fork bmap only works if CONFIG_XFS_DEBUG=y (per review comment
when reflink was being developed) so I never bothered wiring it up from
xfs_bmap.sh, only xfs_io.

> and I think:
> 
> Fixes: 7536ce44f6 ("xfs_io: bmap should support querying CoW fork, shared blocks")

Ok.

--D

> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
