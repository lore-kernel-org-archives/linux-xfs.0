Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p14EAbea019863
	for <linux-xfs@oss.sgi.com>; Fri, 4 Feb 2011 08:10:37 -0600
Received: from mout.perfora.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 8156B1DC6F2C
	for <linux-xfs@oss.sgi.com>; Fri,  4 Feb 2011 06:13:07 -0800 (PST)
Received: from mout.perfora.net (mout.perfora.net [74.208.4.195]) by
	cuda.sgi.com with ESMTP id CqBWgbSl4IpZd0mg for
	<linux-xfs@oss.sgi.com>; Fri, 04 Feb 2011 06:13:07 -0800 (PST)
Message-ID: <4D4C0965.9010905@lueckdatasystems.com>
Date: Fri, 04 Feb 2011 09:12:53 -0500
From: Michael Lueck <mlueck@lueckdatasystems.com>
MIME-Version: 1.0
Subject: Re: xfsdump SGI_FS_BULKSTAT errno = 22, how could this IRIX bug get
	into Ubuntu 10.04 Lucid between kernels 2.6.32-27 and 2.6.32-26?
References: <iibmah$dlp$1@dough.gmane.org> <4D49A35B.6030009@sgi.com>
	<20110203045836.GV11040@dastard>
	<4D4ABEF7.7000400@lueckdatasystems.com>
	<20110204000823.GW11040@dastard>
In-Reply-To: <20110204000823.GW11040@dastard>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@oss.sgi.com, Dann Frazier <dannf@debian.org>

Dave Chinner wrote:
> Ok, so xfsdump i seeing a short bulkstat, then an EINVAL returned
> from the next bulkstat. That's not a race condition, and makes me
> think you have some kind of on-disk corruption.

Very odd that some kind of on-disk corruption is suddenly causing xfsdump problems starting with Ubuntu 10.04 (Lucid) kernel 2.6.32-27 and persisting in 2.6.32-28.

And there is one other person who confirmed this xfsdump problem running Lucid with kernel 2.6.32-28. They reported their "me too" in the Ubuntu bug tracker.

Could it be that 2.6.32-26 and prior managed to write something to disk corrupted, and the newer code is tripping on it?

I shall reboot the server to the 2.6.32-28 kernel and perform the tests you requested.

Sincerely,

-- 
Michael Lueck
Lueck Data Systems
http://www.lueckdatasystems.com/

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
