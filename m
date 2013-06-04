Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id F410329DF8
	for <xfs@oss.sgi.com>; Tue,  4 Jun 2013 17:28:38 -0500 (CDT)
Date: Tue, 4 Jun 2013 17:28:38 -0500
From: Ben Myers <bpm@sgi.com>
Subject: Re: [PATCH 4/6] xfs: fix remote attribute invalidation for a leaf
Message-ID: <20130604222838.GN20932@sgi.com>
References: <1370237332-24757-1-git-send-email-david@fromorbit.com>
	<1370237332-24757-5-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1370237332-24757-5-git-send-email-david@fromorbit.com>
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

On Mon, Jun 03, 2013 at 03:28:49PM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> When invalidating an attribute leaf block block, there might be
> remote attributes that it points to. With the recent rework of the
> remote attribute format, we have to make sure we calculate the
> length of the attribute correctly. We aren't doing that in
> xfs_attr3_leaf_inactive(), so fix it.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>

Applied.  Looks like the rest need to be reposted due to various review
comments and, #2 still needs review.

-Ben

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
