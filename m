Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:46942 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750882AbdJ0QRo (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 27 Oct 2017 12:17:44 -0400
Date: Fri, 27 Oct 2017 09:17:39 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 06/10] xfs_repair: fix cowextsize field checking and
 repairing
Message-ID: <20171027161739.GI5483@magnolia>
References: <150905608689.28563.9670731739870415773.stgit@magnolia>
 <150905613147.28563.3642613984403228295.stgit@magnolia>
 <b57f41c8-ce22-043a-ba04-b1692530a4de@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b57f41c8-ce22-043a-ba04-b1692530a4de@sandeen.net>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: sandeen@redhat.com, linux-xfs@vger.kernel.org

On Thu, Oct 26, 2017 at 09:06:10PM -0500, Eric Sandeen wrote:
> On 10/26/17 5:15 PM, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > Make sure that we never leave the filesystem with a zero cowextsize hint
> > while the cowextsize inode flag is set.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Ok.  Is there anything that catches cowextsize set on di_version < 3?

No, because the inode core structure isn't large enough to have
cowextsize if version < 3.

--D

> 
> Reviewed-by: Eric Sandeen <sandeen@redhat.com>
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
