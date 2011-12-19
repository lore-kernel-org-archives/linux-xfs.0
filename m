Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pBJ1oW0H014311 for <xfs@oss.sgi.com>; Sun, 18 Dec 2011 19:50:32 -0600
Received: from mail.sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com
	with ESMTP id DTM3PVCSVFy7Vkx7 for <xfs@oss.sgi.com>;
	Sun, 18 Dec 2011 17:50:31 -0800 (PST)
Message-ID: <4EEE9866.2030603@sandeen.net>
Date: Sun, 18 Dec 2011 19:50:30 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: xfsdump
References: <CAEt9JqzmcRT2g6z1k3t5eFM7e1rvrrHQRf_enpvJx+HXgwOERA@mail.gmail.com>
In-Reply-To: <CAEt9JqzmcRT2g6z1k3t5eFM7e1rvrrHQRf_enpvJx+HXgwOERA@mail.gmail.com>
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
To: William Moss <bill.m.moss@gmail.com>
Cc: xfs@oss.sgi.com

On 12/17/11 11:22 AM, William Moss wrote:
> Since approx. kernel 2.6.35 (kernel.org <http://kernel.org>) I have
> been having a problem with xfsdump(8) with my custom compiled kernels
> but not with the one that comes with openSUSE. During a differential
> dump (1..9) it will lock up, become a kernel stuck process that
> cannot be killed, while determining the files that need to be dumped.
> This has not occurred with dump level zero nor with the kernel as
> supplied from openSUSE. I have played with the kernel options that
> seem relevant to xfs (a find for xfs as well as ACPI, etc.) and
> nothing seems to effect the problem. Other than this, everything
> works fine and the kernel has better performance and support in the
> areas that I compile it for with respect to my hardware. I was hoping
> that you could inform me as to what options for the kernel might
> cause this problem. Note that a reboot or even an 'init 0 --- init 3'
> will clear the problem for at least one more differential dump.
> 
> openSUSE: 11.4 CPU : AMD 64 AM2 socket RAM: 4GB DDR2 Drives: SATA/3
> Boot is a 650GB WD, /usr/local is a 1.5TB WD
> 
> Kernel: 3.1.4 I compile the kernel with the AMD64 optimization turned
> on.

If the kernel thread is really stuck, sysrq-D (or echo d > /proc/sysrq-trigger)
will show where the thread is; that'd at least provide some more concrete
information if the thread is really stuck somewhere.

-Eric

> Thank you!
> 
> 
> _______________________________________________ xfs mailing list 
> xfs@oss.sgi.com http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
