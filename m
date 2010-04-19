Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o3J96dAn204525 for <xfs@oss.sgi.com>; Mon, 19 Apr 2010 04:06:40 -0500
Received: from bork.lsof.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id D2AAD2D05CB
	for <xfs@oss.sgi.com>; Mon, 19 Apr 2010 02:08:36 -0700 (PDT)
Received: from bork.lsof.org (bork.lsof.org [87.253.148.42]) by cuda.sgi.com
	with ESMTP id V0pP4yUDEgDuTPl0 for <xfs@oss.sgi.com>;
	Mon, 19 Apr 2010 02:08:36 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
	by bork.lsof.org (Postfix) with ESMTP id 08495B8CA
	for <xfs@oss.sgi.com>; Mon, 19 Apr 2010 11:08:36 +0200 (CEST)
Received: from bork.lsof.org ([127.0.0.1])
	by localhost (bork.lsof.org [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Cx5+qCpiYZOf for <xfs@oss.sgi.com>;
	Mon, 19 Apr 2010 11:08:34 +0200 (CEST)
Received: from bork.lsof.org (localhost [127.0.0.1])
	by bork.lsof.org (Postfix) with ESMTP id EE6B6B847
	for <xfs@oss.sgi.com>; Mon, 19 Apr 2010 11:08:33 +0200 (CEST)
References: <cone.1271414893.151380.55874.1001@bork.lsof.org>
	<20100416234724.GD2493@dastard>
Message-ID: <cone.1271668113.965996.76612.1001@bork.lsof.org>
From: Roel van Meer <rolek@bokxing.nl>
Subject: Re: 2.6.32.11 hangs with xfstest 104
Date: Mon, 19 Apr 2010 11:08:33 +0200
Mime-Version: 1.0
Content-Disposition: inline
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
To: xfs@oss.sgi.com

Dave Chinner writes:

>> I've been running xfstests on a slackware linux server with kernel
>> 2.6.32.11.
>> I've noticed that xfstest # 104 reliably hangs the kernel. Attached
>> are two call traces.
> 
> Yes, it does, and has done since test 104 was written to exercise a
> growfs deadlock years ago. I re-enabled it in the auto group because
> it's been fixed it and those fixes are now in the 2.6.34-rc tree.

Aha, thanks. I can confirm that I did see the problem with 2.6.33.2 but that 
I cannot reproduce it with 2.6.34-rc4, so everything seems to be like it 
should be.

Thanks again,

roel

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
