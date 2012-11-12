Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qACMak0B257427 for <xfs@oss.sgi.com>; Mon, 12 Nov 2012 16:36:46 -0600
Message-ID: <50A17A74.40703@sgi.com>
Date: Mon, 12 Nov 2012 16:38:44 -0600
From: Andrew Dahl <adahl@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH 4/4] xfs: remove xfs_flushinval_pages
References: <1352455804-17045-1-git-send-email-david@fromorbit.com>
	<1352455804-17045-5-git-send-email-david@fromorbit.com>
In-Reply-To: <1352455804-17045-5-git-send-email-david@fromorbit.com>
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On 11/09/2012 04:10 AM, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> It's just a simple wrapper around VFS functionality, and is actually
> bugging in that it doesn't remove mappings before invalidating the
> page cache. Remove it and replace it with the correct VFS
> functionality.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---

Looks Good!

Reviewed-by: Andrew Dahl <adahl@sgi.com>


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
