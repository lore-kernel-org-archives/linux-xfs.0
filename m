Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p6EI3FpN151653 for <xfs@oss.sgi.com>; Thu, 14 Jul 2011 13:03:15 -0500
Received: from mail-fx0-f47.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id ADBFA1E61B59
	for <xfs@oss.sgi.com>; Thu, 14 Jul 2011 11:03:14 -0700 (PDT)
Received: from mail-fx0-f47.google.com (mail-fx0-f47.google.com
	[209.85.161.47]) by cuda.sgi.com with ESMTP id ReZbdBxhxlt8xlYS
	for <xfs@oss.sgi.com>; Thu, 14 Jul 2011 11:03:14 -0700 (PDT)
Received: by fxg11 with SMTP id 11so1367178fxg.6
	for <xfs@oss.sgi.com>; Thu, 14 Jul 2011 11:03:13 -0700 (PDT)
Message-ID: <4E1F2F5D.8060505@gmail.com>
Date: Thu, 14 Jul 2011 20:03:09 +0200
From: Peter Klotz <peter.klotz99@gmail.com>
MIME-Version: 1.0
Subject: Re: BUG: soft lockup - is this XFS problem?
References: <20090105064838.GA5209@wotan.suse.de>
	<20110714112324.GM30145@sliepen.org>
In-Reply-To: <20110714112324.GM30145@sliepen.org>
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
To: Guus Sliepen <Guus.Sliepen@astro.su.se>, Nick Piggin <npiggin@suse.de>, Christoph Hellwig <hch@infradead.org>, Roman Kononov <kernel@kononov.ftml.net>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com

On 07/14/2011 01:23 PM, Guus Sliepen wrote:

> I'm having a problem with a system having an XFS filesystem on RAID locking up
> fairly consistently when writing large amounts of data to it, with several
> kernels, including 2.6.38.2 and 2.6.39.3, on both AMD and Intel multi-core
> processors. The kernel always logs this several times:
>
> BUG: soft lockup - CPU#2 stuck for 67s! [kswapd0:33]
...
>> I believe this patch should solve it. Please test and confirm before
>> I send it upstream.
>
> Further comments on that thread in 2009 indicated the patch was very useful,
> but it doesn't seem to have been applied upstream. Is there any reason this
> patch should not be applied?

Hello Guus

This Bugzilla entry documents the XFS bug from 2009 in detail including 
links:

http://oss.sgi.com/bugzilla/show_bug.cgi?id=805

The problem was finally solved by a patch proposed by Linus. This is the 
reason the original patch developed by Nick never made it into the kernel.

My tests back then showed that both patches fixed the problem.

It seems you have found a test case where just Nick's patch helps.

Regards, Peter.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
