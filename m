Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p18JvZal145695
	for <linux-xfs@oss.sgi.com>; Tue, 8 Feb 2011 13:57:35 -0600
Received: from mout.perfora.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 1ADB2FD27EA
	for <linux-xfs@oss.sgi.com>; Tue,  8 Feb 2011 12:00:08 -0800 (PST)
Received: from mout.perfora.net (mout.perfora.net [74.208.4.195]) by
	cuda.sgi.com with ESMTP id el7wl7sc9xL1Nl2R for
	<linux-xfs@oss.sgi.com>; Tue, 08 Feb 2011 12:00:08 -0800 (PST)
Message-ID: <4D51A0BC.6070201@lueckdatasystems.com>
Date: Tue, 08 Feb 2011 14:59:56 -0500
From: Michael Lueck <mlueck@lueckdatasystems.com>
MIME-Version: 1.0
Subject: Re: xfsdump SGI_FS_BULKSTAT errno = 22, how could this IRIX bug get
	into	Ubuntu 10.04 Lucid between kernels 2.6.32-27 and 2.6.32-26?
References: <iibmah$dlp$1@dough.gmane.org> <4D49A35B.6030009@sgi.com>
	<20110203045836.GV11040@dastard>
	<4D4ABEF7.7000400@lueckdatasystems.com>
	<20110204000823.GW11040@dastard>
	<4D517FD2.5040509@lueckdatasystems.com>
	<20110208195256.GA25601@dastard>
In-Reply-To: <20110208195256.GA25601@dastard>
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
> The man pages, perhaps? i.e. 'man xfs_db' and 'man xfs_repair'

I did, and oddly enough I did not find "<dev>" in the example syntax...

> Substitute /dev/sda, /dev/sdb or whatever your filesystem is on for
> "<dev>" in the above commands.

aaaahhh, THAT explains the curve ball. ;-)

I will IPL the server to the latest kernel and run the tests immediately.

Thank you so much for the explanation!

Sincerely,

-- 
Michael Lueck
Lueck Data Systems
http://www.lueckdatasystems.com/

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
