Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mB63WbAT005591 for <xfs@oss.sgi.com>; Fri, 5 Dec 2008 21:32:38 -0600
Received: from sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 2CFBA16C7F90
	for <xfs@oss.sgi.com>; Fri,  5 Dec 2008 19:32:36 -0800 (PST)
Received: from sandeen.net (sandeen.net [209.173.210.139]) by cuda.sgi.com
	with ESMTP id o2MgijfmMNFxD2dw for <xfs@oss.sgi.com>;
	Fri, 05 Dec 2008 19:32:36 -0800 (PST)
Message-ID: <4939F104.9060201@sandeen.net>
Date: Fri, 05 Dec 2008 21:27:00 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: kernel 2.6.27.7 problem
References: <20081206023608.GA22135@bob.dscon.sk>
In-Reply-To: <20081206023608.GA22135@bob.dscon.sk>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
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
To: DS <xfs@bob.dscon.sk>
Cc: xfs@oss.sgi.com

DS wrote:
> Hi,
> 
> I have trouble with xfs after upgrade kernel 2.6.24.3 -> 2.6.27.7.
> 
> Message on console:
>  end_request: I/O error, dev sde, sector 351572544
>  I/O error in filesystem ("sde1") meta-data dev sde1 block 0x14f49201
>  ("xlog_iodone") error 5 buf count 9728
>  xfs_force_shutdown(sde1,0x2) called from line 1056 of file
>  fs/xfs/xfs_log.c.  Return address = 0xffffffff80373233
>  Filesystem "sde1": Log I/O Error Detected.  Shutting down filesystem:
>  sde1
>  Please umount the filesystem, and rectify the problem(s)

No messages before that?  It's telling you that you had an IO error
(under the filesystem, potentially a storage proboblem).

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
