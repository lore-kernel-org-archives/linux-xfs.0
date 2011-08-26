Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p7QFbSeX114264 for <xfs@oss.sgi.com>; Fri, 26 Aug 2011 10:37:29 -0500
Subject: Re: [PATCH] xfsdump: refactor ring_create
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <1313422998-7263-1-git-send-email-wkendall@sgi.com>
References: <1313422998-7263-1-git-send-email-wkendall@sgi.com>
Date: Fri, 26 Aug 2011 10:37:25 -0500
Message-ID: <1314373045.2821.24.camel@doink>
MIME-Version: 1.0
Reply-To: aelder@sgi.com
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
To: Bill Kendall <wkendall@sgi.com>
Cc: xfs@oss.sgi.com

On Mon, 2011-08-15 at 10:43 -0500, Bill Kendall wrote:
> ring_create() takes a thread creation function pointer. The two
> callers of ring_create() pass pointers to identical but separate
> functions. This can be simplified by moving the thread creation
> code into ring_create() itself.
> 
> Signed-off-by: Bill Kendall <wkendall@sgi.com> 

Looks good.

Reviewed-by: Alex Elder <aelder@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
