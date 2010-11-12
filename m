Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oACMDOZu165957 for <xfs@oss.sgi.com>; Fri, 12 Nov 2010 16:13:24 -0600
Received: from greer.hardwarefreak.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 07D1D13B51C8
	for <xfs@oss.sgi.com>; Fri, 12 Nov 2010 14:14:53 -0800 (PST)
Received: from greer.hardwarefreak.com (mo-65-41-216-221.sta.embarqhsd.net
	[65.41.216.221]) by cuda.sgi.com with ESMTP id L4eiOeZQgO7HHp3b
	for <xfs@oss.sgi.com>; Fri, 12 Nov 2010 14:14:53 -0800 (PST)
Received: from [192.168.100.53] (gffx.hardwarefreak.com [192.168.100.53])
	by greer.hardwarefreak.com (Postfix) with ESMTP id 99E7E6C105
	for <xfs@oss.sgi.com>; Fri, 12 Nov 2010 16:14:52 -0600 (CST)
Message-ID: <4CDDBC5C.7020708@hardwarefreak.com>
Date: Fri, 12 Nov 2010 16:14:52 -0600
From: Stan Hoeppner <stan@hardwarefreak.com>
MIME-Version: 1.0
Subject: Re: xfs_repair of critical volume
References: <75C248E3-2C99-426E-AE7D-9EC543726796@ucsc.edu>	<4CCD3CE6.8060407@hardwarefreak.com>	<864DA9C9-B4A4-4B6B-A901-A457E2B9F5A5@ucsc.edu>
	<201011121422.28993@zmi.at>
In-Reply-To: <201011121422.28993@zmi.at>
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
To: xfs@oss.sgi.com

Michael Monnerie put forth on 11/12/2010 7:22 AM:

> I find the robustness of XFS amazing: You overwrote 1/5th of the disk 
> with zeroes, and it still works :-)

This isn't "robustness" Michael.  If anything it's a serious problem.
XFS is reporting that hundreds or thousands of files that have been
physically removed still exist.  Regardless of how he arrived at this
position, how is this "robust"?  Most people would consider this
inconsistency of state a "corruption" situation, not "robustness".

-- 
Stan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
