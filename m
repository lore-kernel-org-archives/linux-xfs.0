Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n5BHVXY7163837 for <xfs@oss.sgi.com>; Thu, 11 Jun 2009 12:31:33 -0500
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id EAED61AB6C33
	for <xfs@oss.sgi.com>; Thu, 11 Jun 2009 10:31:49 -0700 (PDT)
Received: from mail.sandeen.net (sandeen.net [209.173.210.139]) by
	cuda.sgi.com with ESMTP id 6b9ykvAPM0MeWNiU for
	<xfs@oss.sgi.com>; Thu, 11 Jun 2009 10:31:49 -0700 (PDT)
Message-ID: <4A313F84.20900@sandeen.net>
Date: Thu, 11 Jun 2009 12:31:48 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: Kernel 2.6.30: Memory/XFS leak, OOM killer kills many processes
References: <alpine.DEB.2.00.0906111158470.2563@p34.internal.lan>
	<alpine.DEB.2.00.0906111255280.6809@p34.internal.lan>
In-Reply-To: <alpine.DEB.2.00.0906111255280.6809@p34.internal.lan>
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
> 
> On Thu, 11 Jun 2009, Justin Piszcz wrote:
> 
>> Hello,
>>
>> I have a daily cron that backs up my root filesystem using xfsdump, it has 
>> remain unchanged for at least 7-10 kernel versions.  When I migrated to 
>> 2.6.30, when the xfsdump ran at its scheduled time, nearly all of my 
>> processes were killed due to an OOM situation, I can reproduce the situation.
>>
>> Kernel: 2.6.30
>> Dist: Debian Testing
>> xfsdump: 2.2.48-1
> 
> Kernel 2.6.29.4 does not exhibit this problem:
> 
> xfsdump: estimated dump size: 8694781376 bytes
> xfsdump: creating dump session media file 0 (media 0, file 0)
> xfsdump: dumping ino map
> xfsdump: dumping directories
> xfsdump: dumping non-directory files
> xfsdump: ending media file
> xfsdump: media file size 8294709848 bytes
> xfsdump: dump size (non-dir files) : 8208863560 bytes
> xfsdump: dump complete: 102 seconds elapsed
> xfsdump: Dump Status: SUCCESS
> 
> XFS(?) bug in 2.6.30.

Any chance for a bisect run? :)

Or, just as a thought, watch slabtop while you run the dump?

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
