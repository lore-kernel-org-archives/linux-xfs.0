Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qA91MBsf043715 for <xfs@oss.sgi.com>; Thu, 8 Nov 2012 19:22:11 -0600
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	2kPFAbJemCPNsSqc for <xfs@oss.sgi.com>;
	Thu, 08 Nov 2012 17:24:09 -0800 (PST)
Date: Fri, 9 Nov 2012 12:24:05 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: xfs_quota -x -c 'report -u /dev/sde5' shows the duplicate result.
Message-ID: <20121109012405.GX6434@dastard>
References: <20121108222315.505370321@sgi.com>
	<20121108222315.709683665@sgi.com> <509C5885.5060300@eisoo.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <509C5885.5060300@eisoo.com>
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
To: "yyq@eisoo.com" <yyq@eisoo.com>
Cc: xfs@oss.sgi.com

On Fri, Nov 09, 2012 at 09:12:37AM +0800, yyq@eisoo.com wrote:
> Hi,
> 
>     When I use "xfs_quota -x -c 'report -u /dev/sde5'" to show
> /dev/sde5's quotas, and the result have two same block as below:

What version of xfs_quota are you using? What is the output of
/proc/mounts and /etc/mtab say?

And does the latest version of xfs_quota have the same problem?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
