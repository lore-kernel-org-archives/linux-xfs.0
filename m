Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q1E0CTdK052855 for <xfs@oss.sgi.com>; Mon, 13 Feb 2012 18:12:29 -0600
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	v2N6BBQLqO0XLwN4 for <xfs@oss.sgi.com>;
	Mon, 13 Feb 2012 16:12:28 -0800 (PST)
Date: Tue, 14 Feb 2012 11:12:24 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: BUG: soft lockup - CPU#0 stuck for 67s! [kworker/0:5:29244] /
	xfs_trans_committed_bulk
Message-ID: <20120214001224.GG14132@dastard>
References: <4F396BCF.8070008@fangornsrealm.eu>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4F396BCF.8070008@fangornsrealm.eu>
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
To: Alexander Schwarzkopf <alexander.schwarzkopf@fangornsrealm.eu>
Cc: xfs@oss.sgi.com

On Mon, Feb 13, 2012 at 09:00:15PM +0100, Alexander Schwarzkopf wrote:
> Hello,
> 
> I have found some hangs with XFS filesystem, but not with this problem.
> 
> Our File, NIS- and Webserver runs fine for some months. But then it
> starts hanging.

Most likely it is a known problem that has been fixed and has been
backported to 3.0-stable. I'd suggest moving to that kernel at
minimum....

Cheers,

Dave.

-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
