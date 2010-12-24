Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oBO0qLI1028076 for <xfs@oss.sgi.com>; Thu, 23 Dec 2010 18:52:21 -0600
Received: from greer.hardwarefreak.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id C690521B477
	for <xfs@oss.sgi.com>; Thu, 23 Dec 2010 16:54:19 -0800 (PST)
Received: from greer.hardwarefreak.com (mo-65-41-216-221.sta.embarqhsd.net
	[65.41.216.221]) by cuda.sgi.com with ESMTP id Hpuyi3M62X31lMxb
	for <xfs@oss.sgi.com>; Thu, 23 Dec 2010 16:54:19 -0800 (PST)
Received: from [192.168.100.53] (gffx.hardwarefreak.com [192.168.100.53])
	by greer.hardwarefreak.com (Postfix) with ESMTP id 456F56C14F
	for <xfs@oss.sgi.com>; Thu, 23 Dec 2010 18:54:19 -0600 (CST)
Message-ID: <4D13EF3B.2050401@hardwarefreak.com>
Date: Thu, 23 Dec 2010 18:54:19 -0600
From: Stan Hoeppner <stan@hardwarefreak.com>
MIME-Version: 1.0
Subject: Re: xfssyncd and disk spin down
References: <20101223165532.GA23813@peter.simplex.ro>	<4D13A30A.3090600@hardwarefreak.com>
	<20101223211650.GA19694@peter.simplex.ro>
In-Reply-To: <20101223211650.GA19694@peter.simplex.ro>
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

Petre Rodan put forth on 12/23/2010 3:16 PM:

> but my original mail had a different target really. I have to recognize that I don't know much about the inner-workings of a filesystem, but I find it odd that once there is no input from the outside, a process keeps writing to the drive indefinitely. in my very narrow thinking the fact that these writes dissapear after a remount would prove their redundance.

Ahh, quite right.  Sorry Petre.  This might shed some light on your
issue.  Old background thread:

http://oss.sgi.com/archives/xfs/2003-09/msg00674.html


Current documentation on this turnable knob:

http://www.mjmwired.net/kernel/Documentation/filesystems/xfs.txt

fs.xfs.xfssyncd_centisecs	(Min: 100  Default: 3000  Max: 720000)
	The interval at which the xfssyncd thread flushes metadata
	out to disk.  This thread will flush log activity out, and
	do some processing on unlinked inodes.

Maybe related or also worth mentioning:

fs.xfs.age_buffer_centisecs	(Min: 100  Default: 1500  Max: 720000)
	The age at which xfsbufd flushes dirty metadata buffers to disk.


As of 2.6.36, it looks like you can stretch this out to a more
reasonable (for your application) 12 minutes if you like.  I'm not sure
if the max value is different than 2.6.32.2 as I don't have a box or VM
available with 2.6.32.2.  Try bumping these values to 720000 and see if
that allows your disk to sleep for 12 mins.

-- 
Stan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
