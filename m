Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p0R5EoBN190411 for <xfs@oss.sgi.com>; Wed, 26 Jan 2011 23:14:50 -0600
Received: from greer.hardwarefreak.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id A0BDD27FDB2
	for <xfs@oss.sgi.com>; Wed, 26 Jan 2011 21:17:14 -0800 (PST)
Received: from greer.hardwarefreak.com (mo-65-41-216-221.sta.embarqhsd.net
	[65.41.216.221]) by cuda.sgi.com with ESMTP id JKQdx4ODpLEXABTE
	for <xfs@oss.sgi.com>; Wed, 26 Jan 2011 21:17:14 -0800 (PST)
Received: from [192.168.100.53] (gffx.hardwarefreak.com [192.168.100.53])
	by greer.hardwarefreak.com (Postfix) with ESMTP id CDC636C0CE
	for <xfs@oss.sgi.com>; Wed, 26 Jan 2011 23:17:13 -0600 (CST)
Message-ID: <4D40FFD9.80707@hardwarefreak.com>
Date: Wed, 26 Jan 2011 23:17:13 -0600
From: Stan Hoeppner <stan@hardwarefreak.com>
MIME-Version: 1.0
Subject: Re: xfs: very slow after mount, very slow at umount
References: <4D40C8D1.8090202@teksavvy.com> <20110127033011.GH21311@dastard>
	<4D40EB2F.2050809@teksavvy.com>
In-Reply-To: <4D40EB2F.2050809@teksavvy.com>
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

Mark Lord put forth on 1/26/2011 9:49 PM:

> agcount=7453

That's probably a bit high Mark, and very possibly the cause of your problems.
:)  Unless the disk array backing this filesystem has something like 400-800
striped disk drives.  You said it's a single 2TB drive right?

The default agcount for a single drive filesystem is 4 allocation groups.  For
mdraid (of any number of disks/configuration) it's 16 allocation groups.

Why/how did you end up with 7452 allocation groups?  That can definitely cause
some performance issues due to massively excessive head seeking, and possibly
all manner of weirdness.

-- 
Stan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
