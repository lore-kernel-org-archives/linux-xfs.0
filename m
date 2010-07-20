Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o6KH66fA031248 for <xfs@oss.sgi.com>; Tue, 20 Jul 2010 12:06:07 -0500
Received: from greer.hardwarefreak.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 3D1331B8B73B
	for <xfs@oss.sgi.com>; Tue, 20 Jul 2010 10:09:06 -0700 (PDT)
Received: from greer.hardwarefreak.com (mo-65-41-216-221.sta.embarqhsd.net
	[65.41.216.221]) by cuda.sgi.com with ESMTP id WCZQ9SNe7xCmd5CE
	for <xfs@oss.sgi.com>; Tue, 20 Jul 2010 10:09:06 -0700 (PDT)
Received: from [192.168.100.53] (gffx.hardwarefreak.com [192.168.100.53])
	by greer.hardwarefreak.com (Postfix) with ESMTP id 858606C011
	for <xfs@oss.sgi.com>; Tue, 20 Jul 2010 12:09:06 -0500 (CDT)
Message-ID: <4C45D831.5010102@hardwarefreak.com>
Date: Tue, 20 Jul 2010 12:09:05 -0500
From: Stan Hoeppner <stan@hardwarefreak.com>
MIME-Version: 1.0
Subject: Re: Slow delete
References: <AANLkTinPmhJRD3CDdsHtkLFzYd2jF9ee7gPqgO6XBSfl@mail.gmail.com>	<201007121417.14097@zmi.at>
	<1279565697.1855.136.camel@doink> <201007201304.28490@zmi.at>
In-Reply-To: <201007201304.28490@zmi.at>
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

Michael Monnerie put forth on 7/20/2010 6:04 AM:

> Can someone guess the exact problems that can happen with delayed 
> transaction on a crash?

The only real crash scenario difference, as I understand it, is that with
delayed logging enabled you'll potentially lose more data due to crash as more
is held memory resident with delayed logging enabled.  The characteristics of
the data loss are the same with and without this enabled, it's just
potentially more severe with delayed logging enabled.

If your systems are prone to power loss, hardware failures, or kernel panics,
I'd not enable delayed logging.  If your systems are rock solid, and you can
benefit from the minor decrease in file fragmentation and the increase in mass
file delete speed, then enable it.

-- 
Stan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
