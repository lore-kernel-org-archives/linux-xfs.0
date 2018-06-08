Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:53522 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752716AbeFHQtP (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 8 Jun 2018 12:49:15 -0400
Date: Fri, 8 Jun 2018 09:49:09 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: NULL pointer dereference in xfs_trans_binval() when mounting and
 operating a crafted xfs image
Message-ID: <20180608164909.GQ25007@magnolia>
References: <66348561-0B03-4CAE-893A-25161D66D6AF@gatech.edu>
 <fff2a2c8-b607-05ea-e97e-f53f054fb428@sandeen.net>
 <5627CC54-D26D-4946-BEAD-6770E7D8A883@gatech.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5627CC54-D26D-4946-BEAD-6770E7D8A883@gatech.edu>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Xu, Wen" <wen.xu@gatech.edu>
Cc: Eric Sandeen <sandeen@sandeen.net>, "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>

On Thu, Jun 07, 2018 at 10:25:56PM +0000, Xu, Wen wrote:
> I tested the patch that works.

ok.  Eric, would you mind adding a tested-by to the patch and sending it
with '[PATCH]' subject as a separate thread?

--D

> Thanks,
> Wen
> 
> > On Jun 7, 2018, at 6:01 PM, Eric Sandeen <sandeen@sandeen.net> wrote:
> > 
> > if (bp && (xfs_da_shrink_inode(args, 0, bp) != 0))
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
