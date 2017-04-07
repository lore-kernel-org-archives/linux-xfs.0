Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:28373 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933735AbdDGPq3 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 7 Apr 2017 11:46:29 -0400
Date: Fri, 7 Apr 2017 08:46:23 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH] generic: test FIEMAP on extended attribute blocks
Message-ID: <20170407154623.GH10881@birch.djwong.org>
References: <20170406160130.GX4864@birch.djwong.org>
 <20170407092616.GT22845@eguan.usersys.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170407092616.GT22845@eguan.usersys.redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eryu Guan <eguan@redhat.com>
Cc: xfs <linux-xfs@vger.kernel.org>, fstests <fstests@vger.kernel.org>

On Fri, Apr 07, 2017 at 05:26:16PM +0800, Eryu Guan wrote:
> On Thu, Apr 06, 2017 at 09:01:30AM -0700, Darrick J. Wong wrote:
> > Make sure that FIEMAP produces some output when we add enough xattrs
> > to force the xattrs to be stored in an external block.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Test itself looks fine to me. But given that there's disagreement on
> fiemap on xattr (still an reasonable test?) and test crashes debug built
> & 512b block size XFS, I'll hold this test for now.

ext4 also implements fiemap on xattr, so at the very least we still need
to test that even if XFS ends up dropping xattr fiemap.

I'll push out a v2 of the xfs patch soon...

--D

> 
> Thanks,
> Eryu
> --
> To unsubscribe from this list: send the line "unsubscribe fstests" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
