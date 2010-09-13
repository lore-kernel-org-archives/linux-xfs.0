Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o8D84ftA059869 for <xfs@oss.sgi.com>; Mon, 13 Sep 2010 03:04:42 -0500
Received: from bork.lsof.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 85FDE11E4274
	for <xfs@oss.sgi.com>; Mon, 13 Sep 2010 01:17:07 -0700 (PDT)
Received: from bork.lsof.org (bork.lsof.org [87.253.148.42]) by cuda.sgi.com
	with ESMTP id i3pNDmaFyfWBRLXD for <xfs@oss.sgi.com>;
	Mon, 13 Sep 2010 01:17:07 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
	by bork.lsof.org (Postfix) with ESMTP id 45DB5B836
	for <xfs@oss.sgi.com>; Mon, 13 Sep 2010 10:05:27 +0200 (CEST)
Received: from bork.lsof.org ([127.0.0.1])
	by localhost (bork.lsof.org [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 9J6eiMOgB7bc for <xfs@oss.sgi.com>;
	Mon, 13 Sep 2010 10:05:25 +0200 (CEST)
Received: from bork.lsof.org (localhost [127.0.0.1])
	by bork.lsof.org (Postfix) with ESMTP id 4BA17B832
	for <xfs@oss.sgi.com>; Mon, 13 Sep 2010 10:05:25 +0200 (CEST)
References: <4C8A4395.5070702@kickstone.com> <4C8B27E4.2050102@kickstone.com>
	<20100911082330.GG705@dastard> <4C8BDAC8.8010203@hardwarefreak.com>
Message-ID: <cone.1284365125.256876.62928.1001@bork.lsof.org>
From: Roel van Meer <rolek@bokxing.nl>
Subject: Re: XFS defragmentation issue
Date: Mon, 13 Sep 2010 10:05:25 +0200
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

Stan Hoeppner writes:

> Out of curiosity, who here schedules automatic xfs_fsr runs, and with
> what frequency?  Currently I just run it manually now and then when
> performance starts to seem sluggish.

I run it daily during the week, at a time when load is practically nil, on 
two boxes with 24TB storage each, divided into six parts of about 4GB. A 
10-pass xfs_fsr run usually completes in under one hour, except on monday, 
when it takes three to four hours.

I don't have any stats on the net effect, though.

Regards,

roel

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
