Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with SMTP id
	p2NLUbm6117378
	for <linux-xfs@oss.sgi.com>; Wed, 23 Mar 2011 16:30:42 -0500
Received: from mx5.twosigma.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with SMTP id 34F45140FD80
	for <linux-xfs@oss.sgi.com>; Wed, 23 Mar 2011 14:33:37 -0700 (PDT)
Received: from mx5.twosigma.com (mx5.twosigma.com [208.77.212.35]) by
	cuda.sgi.com with SMTP id c8nYEvhdaPW1SQmA for
	<linux-xfs@oss.sgi.com>; Wed, 23 Mar 2011 14:33:37 -0700 (PDT)
From: Sean Noonan <Sean.Noonan@twosigma.com>
Date: Wed, 23 Mar 2011 17:33:36 -0400
Subject: RE: XFS memory allocation deadlock in 2.6.38
Message-ID: <081DDE43F61F3D43929A181B477DCA95639B532C@MSXAOA6.twosigma.com>
References: <081DDE43F61F3D43929A181B477DCA95639B52E8@MSXAOA6.twosigma.com>
	<20110322232504.GC15270@dastard>
In-Reply-To: <20110322232504.GC15270@dastard>
Content-Language: en-US
MIME-Version: 1.0
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
To: 'Dave Chinner' <david@fromorbit.com>
Cc: "'linux-xfs@oss.sgi.com'" <linux-xfs@oss.sgi.com>, Martin Bligh <Martin.Bligh@twosigma.com>, Trammell Hudson <Trammell.Hudson@twosigma.com>

> What is the configuration of the machine you are testing on? I can't
> reproduce this on a current 2.6.39-tot tree on a 2p/2GB RAM VM that
> has it's blockdev images on a single SATA drive....

The machine we are testing with has 12 cores, 12 hyperthreaded siblings, and 48GB of RAM.  The filesystem is backed by a partition on one large hardware RAID.  There is a second bug we've run into that I'll report tomorrow.

Could you point me to the current tree you are working with?  2.6.39-tot doesn't mean anything to me.

Sean



_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
