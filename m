Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oAP6wxEV235544 for <xfs@oss.sgi.com>; Thu, 25 Nov 2010 00:59:00 -0600
Received: from greer.hardwarefreak.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 9EA2313EBEAB
	for <xfs@oss.sgi.com>; Wed, 24 Nov 2010 23:00:38 -0800 (PST)
Received: from greer.hardwarefreak.com (mo-65-41-216-221.sta.embarqhsd.net
	[65.41.216.221]) by cuda.sgi.com with ESMTP id NK2BKPU1Ih7C6z8E
	for <xfs@oss.sgi.com>; Wed, 24 Nov 2010 23:00:38 -0800 (PST)
Received: from [192.168.100.53] (gffx.hardwarefreak.com [192.168.100.53])
	by greer.hardwarefreak.com (Postfix) with ESMTP id 950616C15D
	for <xfs@oss.sgi.com>; Thu, 25 Nov 2010 01:00:37 -0600 (CST)
Message-ID: <4CEE0995.9030900@hardwarefreak.com>
Date: Thu, 25 Nov 2010 01:00:37 -0600
From: Stan Hoeppner <stan@hardwarefreak.com>
MIME-Version: 1.0
Subject: Re: Verify filesystem is aligned to stripes
References: <4CED5BFC.8000906@shiftmail.org> <20101125054607.GM13830@dastard>
In-Reply-To: <20101125054607.GM13830@dastard>
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

Dave Chinner put forth on 11/24/2010 11:46 PM:

> Because writes for workloads like this are never full stripe writes.
> Hence reads must be done to pullin the rest of the stripe before the
> new parity can be calculated. This RMW cycle for small IOs has
> always been the pain point for stripe based parity protection. If
> you are doing lots of small IOs, RAID1 is your friend.

Do you really mean RAID1 here Dave, or RAID10?  If RAID1, please
elaborate a bit.  RAID1 traditionally has equal read performance to a
single device, and half the write performance of a single device.

-- 
Stan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
