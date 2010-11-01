Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oA1ARc0T201183 for <xfs@oss.sgi.com>; Mon, 1 Nov 2010 05:27:38 -0500
Received: from server655-han.de-nserver.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 09A07142392
	for <xfs@oss.sgi.com>; Mon,  1 Nov 2010 03:28:59 -0700 (PDT)
Received: from server655-han.de-nserver.de (server655-han.de-nserver.de
	[85.158.177.45]) by cuda.sgi.com with ESMTP id l73FIOYQHaAtVO1W
	for <xfs@oss.sgi.com>; Mon, 01 Nov 2010 03:28:59 -0700 (PDT)
Message-ID: <4CCE9669.4030904@profihost.ag>
Date: Mon, 01 Nov 2010 11:28:57 +0100
From: Stefan Priebe - Profihost AG <s.priebe@profihost.ag>
MIME-Version: 1.0
Subject: Re: Pid: 8345, comm: rsync Not tainted 2.6.32.22intel #1
References: <4CC67450.9020602@profihost.ag>	<20101026092205.086c0d89@galadriel.home>	<4CC68249.7050409@profihost.ag>	<4CCE73C8.8070705@profihost.ag>
	<20101101111142.5db7fa4e@galadriel.home>
In-Reply-To: <20101101111142.5db7fa4e@galadriel.home>
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
To: Emmanuel Florac <eflorac@intellique.com>
Cc: xfs@oss.sgi.com

>> but today i got again hundrets of these messages:
>> [318343.901809] Filesystem "sdc3": XFS internal error
>> xfs_da_do_buf(2)
>
> That's weird. What do "uname -a" and "free" tells? I'm wondering if
> there isn't some low memory condition at work here.
# uname -a
Linux server 2.6.32.22intel #1 SMP Tue Sep 21 11:05:46 CEST 2010 x86_64 
GNU/Linux

# free
              total       used       free     shared    buffers     cached
Mem:      16470416   15098888    1371528          0         48    6019036
-/+ buffers/cache:    9079804    7390612
Swap:      1469908          0    1469908

Stefan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
