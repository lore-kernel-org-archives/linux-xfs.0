Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o2FEdNcU056116 for <xfs@oss.sgi.com>; Mon, 15 Mar 2010 09:39:24 -0500
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id F3E0424A03C
	for <xfs@oss.sgi.com>; Mon, 15 Mar 2010 07:40:58 -0700 (PDT)
Received: from mail.sandeen.net (64-131-60-146.usfamily.net [64.131.60.146])
	by cuda.sgi.com with ESMTP id wF7DKyH61nJNoq3t for
	<xfs@oss.sgi.com>; Mon, 15 Mar 2010 07:40:58 -0700 (PDT)
Message-ID: <4B9E46F9.8090209@sandeen.net>
Date: Mon, 15 Mar 2010 09:40:57 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: 2.6.33 crash: invalid opcode: 0000 [#1] SMP: EIP: [<c11a018b>]
	assfail+0x1b/0x20 SS:ESP 0068:f687bf14
References: <alpine.DEB.2.00.1003150528060.6999@p34.internal.lan>
In-Reply-To: <alpine.DEB.2.00.1003150528060.6999@p34.internal.lan>
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
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: linux-kernel@vger.kernel.org, xfs@oss.sgi.com

Justin Piszcz wrote:
> Specifications:
> 
> 2.6.33
> 32bit
> Debian Testing
> 
> On Mar 14th, my server hung up:
> 
> Mar 14 00:00:22 server1 kernel: [488470.189675] ------------[ cut here
> ]------------
> Mar 14 00:00:22 server1 kernel: [488470.189679] invalid opcode: 0000
> [#1] SMP
> Mar 14 00:00:22 server1 kernel: [488470.189681] last sysfs file:
> /sys/devices/pci0000:00/0000:00:0e.0/host0/target0:0:0/0:0:0:0/block/sda/uevent
> 
> Mar 14 00:00:22 server1 kernel: [488470.189704] Process xfssyncd (pid:
> 584, ti=f687a000 task=f70fa400 task.ti=f687a000)
> Mar 14 00:00:22 server1 kernel: [488470.189705] Stack:
> Mar 14 00:00:22 server1 kernel: [488470.189721] Call Trace:
> Mar 14 00:00:22 server1 kernel: [488470.189739] Code: 00 e8 ea e5 01 00
> 83 c4 14 c3 8d b6 00 00 00 00 83 ec 10 89 4c 24 0c 89 54 24 08 89 44 24
> 04 c7 04 24 30 ab 42 c1 e8 7c 11 1c 00 <0f> 0b eb fe 90 55 57 89 cf 56
> 89 c6 b8 80 b0 52 c1 83 e6 07 53
> Mar 14 00:00:22 server1 kernel: [488470.189739] EIP: [<c11a018b>]
> assfail+0x1b/0x20 SS:ESP 0068:f687bf14
> 
> Is this a bug related to AMD (CPU) or XFS?

Hard to know without seeing the rest of the stack trace, is this all you got?

You hit an assertion failure in xfs.

Are you running with CONFIG_XFS_DEBUG?

-Eric

> Justin.
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
