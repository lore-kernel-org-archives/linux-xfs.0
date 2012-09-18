Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q8INngHe116886 for <xfs@oss.sgi.com>; Tue, 18 Sep 2012 18:49:43 -0500
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	qVIdwAG5a4QThBGR for <xfs@oss.sgi.com>;
	Tue, 18 Sep 2012 16:50:52 -0700 (PDT)
Date: Wed, 19 Sep 2012 09:50:49 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [RFC, PATCH 0/102]: xfs: 3.0.x stable kernel update
Message-ID: <20120918235049.GB31501@dastard>
References: <1345698180-13612-1-git-send-email-david@fromorbit.com>
	<50587E28.7090704@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <50587E28.7090704@sgi.com>
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
To: Mark Tinguely <tinguely@sgi.com>
Cc: xfs@oss.sgi.com

On Tue, Sep 18, 2012 at 08:59:04AM -0500, Mark Tinguely wrote:
> This looks great. Like I said earlier, I did not find Brian Foster's
> log patch:
>   xfs: check for stale inode before acquiring iflock on push
>   Upstream commit: 9a3a5dab63461b84213052888bf38a962b22d035
> sample implementation listed on:
>   http://oss.sgi.com/archives/xfs/2012-09/msg00188.html
> 
> Reviewed-by: Mark Tinguely <tinguely@sgi.com>

Thatnks for looking over this, Mark.

The above patch does not directly apply to the 3.0.x branch because
the rework of the log item lock/push logic in the AIL was not
included in the series. Hence I'm not sure that backportingthis
patch is necessary because the problem only arose after we change
the locking/push logic...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
