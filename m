Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q7GIOijg177019 for <xfs@oss.sgi.com>; Thu, 16 Aug 2012 13:24:44 -0500
Date: Thu, 16 Aug 2012 13:24:40 -0500
From: Ben Myers <bpm@sgi.com>
Subject: Re: [PATCH] xfs: kill struct declarations in xfs_mount.h
Message-ID: <20120816182440.GZ29979@sgi.com>
References: <501943B1.5090300@inktank.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <501943B1.5090300@inktank.com>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Alex Elder <elder@inktank.com>
Cc: xfs@oss.sgi.com

On Wed, Aug 01, 2012 at 09:56:49AM -0500, Alex Elder wrote:
> I noticed that "struct xfs_mount_args" was still declared in
> "fs/xfs/xfs_mount.h".  That struct doesn't even exist any more (and
> is obviously not referenced elsewhere in that header file).  While
> in there, delete four other unneeded struct declarations in that
> file.
> 
> Doing so highlights that "fs/xfs/xfs_trace.h" was relying indirectly
> on "xfs_mount.h" to be #included in order to declare "struct
> xfs_bmbt_irec", so add that declaration to resolve that issue.
> 
> Signed-off-by: Alex Elder <elder@inktank.com>

Looks fine to me.
Reviewed-by: Ben Myers <bpm@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
