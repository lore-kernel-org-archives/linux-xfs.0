Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o4S0MP8l178900 for <xfs@oss.sgi.com>; Thu, 27 May 2010 19:22:26 -0500
Received: from greer.hardwarefreak.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id EA1D8157D3A0
	for <xfs@oss.sgi.com>; Thu, 27 May 2010 17:26:42 -0700 (PDT)
Received: from greer.hardwarefreak.com (mo-65-41-216-221.sta.embarqhsd.net
	[65.41.216.221]) by cuda.sgi.com with ESMTP id 1RlPDLq9U9jTY1hQ
	for <xfs@oss.sgi.com>; Thu, 27 May 2010 17:26:42 -0700 (PDT)
Received: from [192.168.100.53] (gffx.hardwarefreak.com [192.168.100.53])
	by greer.hardwarefreak.com (Postfix) with ESMTP id 999B06C2B0
	for <xfs@oss.sgi.com>; Thu, 27 May 2010 19:24:48 -0500 (CDT)
Message-ID: <4BFF0D94.5030903@hardwarefreak.com>
Date: Thu, 27 May 2010 19:25:56 -0500
From: Stan Hoeppner <stan@hardwarefreak.com>
MIME-Version: 1.0
Subject: Re: NOW: o_direct   --  WAS: Re: WARNING in xfs_lwr.c, xfs_write()
References: <20100523002023.41f5a5c8@aaa.pulp.binarylife.net>	<20100523101856.GL2150@dastard>	<20100523092344.0fcaab42@aaa.pulp.binarylife.net>	<4BF9FCA8.8090906@hardwarefreak.com>	<20100524143428.6f3a117c@abend.internal.xtremedata.com>	<20100526070620.GT2150@dastard>	<4BFD3926.6040208@hardwarefreak.com>
	<20100527114736.GA13112@infradead.org>
In-Reply-To: <20100527114736.GA13112@infradead.org>
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

Christoph Hellwig put forth on 5/27/2010 6:47 AM:
> O_DIRECT is not a Posix standard and not very portable.  It originated
> on IRIX, and Linux inherited it during the 2.4 kernel series days.
> These days FreeBSD/NetBSD and AIX support it as well, but for example
> Solaris, HP-UX and OpenBSD don't, nevermind Windows or Mac OS.
> 
> I have no idea why the MTAs don't want to use it - it's generally easier
> to use then memory mapped I/O, and has much more deterministic
> performance.

Thanks for the background Christoph.  I can now see why Postfix and Dovecot in
particular don't use O_DIRECT: portability.  They both are developed to run on
every Unix/like OS you mention above, half of which don't offer O_DIRECT.  I'm
guessing the same may likely be true for the other SMTP MTAs and IMAP servers.

-- 
Stan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
