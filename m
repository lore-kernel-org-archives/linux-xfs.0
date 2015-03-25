Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id B9BD97F50
	for <xfs@oss.sgi.com>; Wed, 25 Mar 2015 15:52:04 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 41829AC002
	for <xfs@oss.sgi.com>; Wed, 25 Mar 2015 13:52:00 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	JXXGG9Zldfn4WjaA for <xfs@oss.sgi.com>;
	Wed, 25 Mar 2015 13:51:55 -0700 (PDT)
Date: Thu, 26 Mar 2015 07:51:52 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 1/2] xfs: pass attr geometry to attr leaf header
	conversion functions
Message-ID: <20150325205152.GZ28621@dastard>
References: <1424811024-24839-1-git-send-email-bfoster@redhat.com>
	<1424811024-24839-2-git-send-email-bfoster@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1424811024-24839-2-git-send-email-bfoster@redhat.com>
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
To: Brian Foster <bfoster@redhat.com>
Cc: xfs@oss.sgi.com

On Tue, Feb 24, 2015 at 03:50:23PM -0500, Brian Foster wrote:
> The firstused field of the xfs_attr3_leaf_hdr structure is subject to an
> overflow when fs blocksize is 64k. In preparation to handle this
> overflow in the header conversion functions, pass the attribute geometry
> to the functions that convert the in-core structure to and from the
> on-disk structure.
> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>

Hmmm. not sure I'm a great fan of this, but let's see.

Ok, this just a conversion patch, moving on to the second patch...

-Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
