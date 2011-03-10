Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with SMTP id
	p2AFmL9q110090 for <xfs@oss.sgi.com>; Thu, 10 Mar 2011 09:48:26 -0600
Received: from greer.hardwarefreak.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with SMTP id 0161F1DE4E39
	for <xfs@oss.sgi.com>; Thu, 10 Mar 2011 07:51:01 -0800 (PST)
Received: from greer.hardwarefreak.com (mo-65-41-216-221.sta.embarqhsd.net
	[65.41.216.221]) by cuda.sgi.com with SMTP id b6HnFg6ochr8lCka
	for <xfs@oss.sgi.com>; Thu, 10 Mar 2011 07:51:01 -0800 (PST)
Received: from [192.168.100.53] (gffx.hardwarefreak.com [192.168.100.53])
	by greer.hardwarefreak.com (Postfix) with ESMTP id 96FD06C168
	for <xfs@oss.sgi.com>; Thu, 10 Mar 2011 09:51:00 -0600 (CST)
Message-ID: <4D78F364.5000000@hardwarefreak.com>
Date: Thu, 10 Mar 2011 09:51:00 -0600
From: Stan Hoeppner <stan@hardwarefreak.com>
MIME-Version: 1.0
Subject: Re: Many-metadata performance still at a loss
References: <alpine.LNX.2.01.1103101507120.5379@obet.zrqbmnf.qr>
In-Reply-To: <alpine.LNX.2.01.1103101507120.5379@obet.zrqbmnf.qr>
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

Jan Engelhardt put forth on 3/10/2011 8:14 AM:
> Hi,
> 
> 
> Between 2.6.33 and 2.6.37 there was a lot of interesting announcements 
> with regards to XFS performance. However, now that I booted into 
> 2.6.37.2, I still see the metadata slowness from earlier.
> (Basically `time (tar -xf linux-2.6.37.tar.gz; sync)` - ext4 gets the 
> job done in like 15-20 seconds, xfs is still syncing after 11 minutes.)
> 
> Was there something I missed?

Yes.  You have to add "delaylog" to your mount options to enable the
metadata performance enhancement.  It won't be the default setting until
2.6.39.

-- 
Stan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
