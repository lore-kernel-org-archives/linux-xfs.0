Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id E164129DF5
	for <xfs@oss.sgi.com>; Mon,  2 Nov 2015 20:13:01 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id BDEC7304053
	for <xfs@oss.sgi.com>; Mon,  2 Nov 2015 18:12:58 -0800 (PST)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	dB9OA88YkPPeAb79 for <xfs@oss.sgi.com>;
	Mon, 02 Nov 2015 18:12:54 -0800 (PST)
Date: Tue, 3 Nov 2015 13:12:32 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 2/2] xfs: invalidate cached acl if set via ioctl
Message-ID: <20151103021231.GA19199@dastard>
References: <1446217508-22157-1-git-send-email-agruenba@redhat.com>
	<20151102025352.GY19199@dastard>
	<1446493974-24669-3-git-send-email-agruenba@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1446493974-24669-3-git-send-email-agruenba@redhat.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Andreas Gruenbacher <agruenba@redhat.com>
Cc: Brian Foster <bfoster@redhat.com>, xfs@oss.sgi.com

On Mon, Nov 02, 2015 at 08:52:54PM +0100, Andreas Gruenbacher wrote:
> Setting or removing the "SGI_ACL_[FILE|DEFAULT]" attributes via the
> XFS_IOC_ATTRMULTI_BY_HANDLE ioctl completely bypasses the POSIX ACL
> infrastructure, like setting the "trusted.SGI_ACL_[FILE|DEFAULT]" xattrs
> did until commit 6caa1056.  Similar to that commit, invalidate cached
> acls when setting/removing them via the ioctl as well.
> 
> Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>

Thanks, Andreas. I've pulled the fixes in. I updated the original
patch with the fix in patch 1, and applied this patch. I'll push out
a rebased for-next branch after some further testing...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
