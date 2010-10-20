Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o9K3270U012290 for <xfs@oss.sgi.com>; Tue, 19 Oct 2010 22:02:07 -0500
Received: from greer.hardwarefreak.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id A854B105F6A
	for <xfs@oss.sgi.com>; Tue, 19 Oct 2010 20:03:20 -0700 (PDT)
Received: from greer.hardwarefreak.com (mo-65-41-216-221.sta.embarqhsd.net
	[65.41.216.221]) by cuda.sgi.com with ESMTP id B24oAhsEMPBgKcj4
	for <xfs@oss.sgi.com>; Tue, 19 Oct 2010 20:03:20 -0700 (PDT)
Received: from [192.168.100.53] (gffx.hardwarefreak.com [192.168.100.53])
	by greer.hardwarefreak.com (Postfix) with ESMTP id 057AE6C126
	for <xfs@oss.sgi.com>; Tue, 19 Oct 2010 22:03:19 -0500 (CDT)
Message-ID: <4CBE5BF7.1090001@hardwarefreak.com>
Date: Tue, 19 Oct 2010 22:03:19 -0500
From: Stan Hoeppner <stan@hardwarefreak.com>
MIME-Version: 1.0
Subject: Re: avoid mbox file fragmentation
References: <4CBE2403.8070108@hardwarefreak.com>
	<20101019234217.GD12506@dastard>
In-Reply-To: <20101019234217.GD12506@dastard>
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

Dave Chinner put forth on 10/19/2010 6:42 PM:

> I've explained how allocsize works, and that speculative allocation
> gets truncated away whenteh file is closed. Hence is the application
> is doing:
> 
> 	open()
> 	seek(EOF)
> 	write()
> 	close()

I don't know if it changes anything in the sequence above, but Dovecot
uses mmap i/o.  As I've said, I'm not a dev.  Just thought this
could/might be relevant.  Would using mmap be compatible with physical
preallocation?

-- 
Stan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
