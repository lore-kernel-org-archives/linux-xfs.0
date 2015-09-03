Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 829CF7F90
	for <xfs@oss.sgi.com>; Thu,  3 Sep 2015 17:21:05 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 12E41AC001
	for <xfs@oss.sgi.com>; Thu,  3 Sep 2015 15:21:01 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	iD9VJZk4tAUbZWuN for <xfs@oss.sgi.com>;
	Thu, 03 Sep 2015 15:20:55 -0700 (PDT)
Date: Fri, 4 Sep 2015 08:20:23 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: every week new xfs errors
Message-ID: <20150903222023.GX3902@dastard>
References: <CAAA5faEq0quyfE4zFp1G_r+igZ_vufCN9yFM-5Lr1wzN9r16Lw@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAAA5faEq0quyfE4zFp1G_r+igZ_vufCN9yFM-5Lr1wzN9r16Lw@mail.gmail.com>
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
To: Reinoud Koornstra <reinoudkoornstra@gmail.com>
Cc: xfs@oss.sgi.com

On Thu, Sep 03, 2015 at 02:55:56PM -0600, Reinoud Koornstra wrote:
> Hi Everyone,
> 
> I am running xfs on a SSD.
> smartd reports this:
> 
> Device: /dev/sdb [SAT], Crucial_CT256M550SSD3, S/N:15020ED48DF8,
> WWN:5-00a075-10ed48df8, FW:MU02, 256 GB
> 
> I am running a compiled linux 4.1.6 kernel (before 4.1.2 and before
> that 3.18.x) on ubuntu 14.04
> xfs_repair had issues mostly every week to report.
> Now xfs_repair says it's finally clean.
> However:
> 
> reinoud@Mipam:/$ sudo xfs_db -r /dev/sdb1
> xfs_db> frag
> Metadata CRC error detected at block 0x773cac0/0x1000
> Metadata CRC error detected at block 0xee79570/0x1000
> Metadata CRC error detected at block 0x165b6020/0x1000
> actual 2891336, ideal 2888294, fragmentation factor 0.11%

You're running on a mounted filesystem? (the "-r" is only
necessary if the fs is mounted) If so, this is expected.

> There are still issue.
> Are there problems with running xfs on a SSD in general?
> It's fast and stable (seems like), but mostly i start noticing
> problems when i'm running git operations that fail, after that
> xfs_repair reports issues indeed.

Perhaps you'd like to start by reporting these issues, as solving
them is far more important that what the (useless) frag command
reports. Start here:

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
