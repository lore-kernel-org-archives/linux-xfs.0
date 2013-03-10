Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id DD5207CBF
	for <xfs@oss.sgi.com>; Sun, 10 Mar 2013 17:56:03 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id AB01C8F8035
	for <xfs@oss.sgi.com>; Sun, 10 Mar 2013 15:56:03 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	SEEG05Uw1xt9bVS7 for <xfs@oss.sgi.com>;
	Sun, 10 Mar 2013 15:56:01 -0700 (PDT)
Date: Mon, 11 Mar 2013 09:56:00 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Null pointer dereference and following traces on 3.9-rc1
Message-ID: <20130310225600.GL23616@dastard>
References: <20130310154900.673deee0@ilfaris>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20130310154900.673deee0@ilfaris>
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
To: Julian Wollrath <jwollrath@web.de>
Cc: xfs@oss.sgi.com

On Sun, Mar 10, 2013 at 03:49:00PM +0100, Julian Wollrath wrote:
> Hello,
> 
> after a xfs_fsr run I found the following in my syslog:

If you can reproduce this, please run an event trace  gathering
the xfs_swap_extent* trace points while xfs_fsr is running so I can
determine if/why the swap extents code is corrupting inodes.

# trace-cmd record -e xfs_swap_extents\* xfs_fsr .....
<crash>
<kill xfs_fsr>
# trace-cmd report > trace_report.txt


Read here for a bit more detail on trace-cmd:

http://xfs.org/index.php/XFS_FAQ#Q:_What_information_should_I_include_when_reporting_a_problem.3F

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
