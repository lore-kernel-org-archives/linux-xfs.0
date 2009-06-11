Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n5BGxsh0162874 for <xfs@oss.sgi.com>; Thu, 11 Jun 2009 11:59:54 -0500
Received: from lucidpixels.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 11C4E2EB778
	for <xfs@oss.sgi.com>; Thu, 11 Jun 2009 10:00:15 -0700 (PDT)
Received: from lucidpixels.com (lucidpixels.com [75.144.35.66]) by
	cuda.sgi.com with ESMTP id 5I2UIJlL58fSu7Dx for
	<xfs@oss.sgi.com>; Thu, 11 Jun 2009 10:00:15 -0700 (PDT)
Date: Thu, 11 Jun 2009 13:00:15 -0400 (EDT)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: Kernel 2.6.30: Memory/XFS leak, OOM killer kills many
 processes
In-Reply-To: <alpine.DEB.2.00.0906111158470.2563@p34.internal.lan>
Message-ID: <alpine.DEB.2.00.0906111255280.6809@p34.internal.lan>
References: <alpine.DEB.2.00.0906111158470.2563@p34.internal.lan>
MIME-Version: 1.0
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
To: linux-kernel@vger.kernel.org
Cc: xfs@oss.sgi.com



On Thu, 11 Jun 2009, Justin Piszcz wrote:

> Hello,
>
> I have a daily cron that backs up my root filesystem using xfsdump, it has 
> remain unchanged for at least 7-10 kernel versions.  When I migrated to 
> 2.6.30, when the xfsdump ran at its scheduled time, nearly all of my 
> processes were killed due to an OOM situation, I can reproduce the situation.
>
> Kernel: 2.6.30
> Dist: Debian Testing
> xfsdump: 2.2.48-1

Kernel 2.6.29.4 does not exhibit this problem:

xfsdump: estimated dump size: 8694781376 bytes
xfsdump: creating dump session media file 0 (media 0, file 0)
xfsdump: dumping ino map
xfsdump: dumping directories
xfsdump: dumping non-directory files
xfsdump: ending media file
xfsdump: media file size 8294709848 bytes
xfsdump: dump size (non-dir files) : 8208863560 bytes
xfsdump: dump complete: 102 seconds elapsed
xfsdump: Dump Status: SUCCESS

XFS(?) bug in 2.6.30.

Justin.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
