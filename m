Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 4978C7F51
	for <xfs@oss.sgi.com>; Mon, 20 May 2013 16:52:28 -0500 (CDT)
Date: Mon, 20 May 2013 16:52:27 -0500
From: Ben Myers <bpm@sgi.com>
Subject: Re: [PATCH 07/14] xfs: xfs_attr_shortform_allfit() does not handle
	attr3 format.
Message-ID: <20130520215227.GE20028@sgi.com>
References: <1369007481-15185-1-git-send-email-david@fromorbit.com>
	<1369007481-15185-8-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1369007481-15185-8-git-send-email-david@fromorbit.com>
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On Mon, May 20, 2013 at 09:51:14AM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> xfstests generic/117 fails with:
> 
> XFS: Assertion failed: leaf->hdr.info.magic == cpu_to_be16(XFS_ATTR_LEAF_MAGIC)
> 
> indicating a function that does not handle the attr3 format
> correctly. Fix it.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>

Looks good.  Applied.

Reviewed-by: Ben Myers <bpm@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
