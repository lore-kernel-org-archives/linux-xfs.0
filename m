Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o8H1hQjM029948 for <xfs@oss.sgi.com>; Thu, 16 Sep 2010 20:43:26 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 7F6DC11E65A1
	for <xfs@oss.sgi.com>; Thu, 16 Sep 2010 18:56:14 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail12.adl6.internode.on.net
	[150.101.137.97]) by cuda.sgi.com with ESMTP id
	2wV9YwH1jhyAC25X for <xfs@oss.sgi.com>;
	Thu, 16 Sep 2010 18:56:14 -0700 (PDT)
Date: Fri, 17 Sep 2010 11:44:12 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: The segment fault with NULL point using when recovering failure
Message-ID: <20100917014412.GK24409@dastard>
References: <AANLkTimR-dBLmQQ-Nh0mmjHJMfFidePKxfO6P76y48n8@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <AANLkTimR-dBLmQQ-Nh0mmjHJMfFidePKxfO6P76y48n8@mail.gmail.com>
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
To: Mike Gao <ygao.linux@gmail.com>
Cc: xfs@oss.sgi.com

On Wed, Sep 15, 2010 at 10:59:07AM -0500, Mike Gao wrote:
> xlog_recover_process_iunlinks(
>     xlog_t        *log)
> {
>                 /*
>                  * Reacquire the agibuffer and continue around
>                  * the loop. This should never fail as we know
>                  * the buffer was good earlier on.
>                  */
>                 error = xfs_read_agi(mp, NULL, agno, &agibp);
>                 ASSERT(error == 0);
>                 agi = XFS_BUF_TO_AGI(agibp);
> 
> }
> If no defined DEBUG, ASSERT will not work and agibp could be ZERO if there
> is a error in xfs_read_agi.
> And the comment shouldn't say it never fail because  xfs_read_agi will
> return error in function and it does when there is forced shutdown.

Have you seen a failure here?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
