Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n4FIoWAY053518 for <xfs@oss.sgi.com>; Fri, 15 May 2009 13:50:32 -0500
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 761DB19D15F3
	for <xfs@oss.sgi.com>; Fri, 15 May 2009 11:50:40 -0700 (PDT)
Received: from mail.sandeen.net (sandeen.net [209.173.210.139]) by
	cuda.sgi.com with ESMTP id 0H9MRb7sD7Wn9uxQ for
	<xfs@oss.sgi.com>; Fri, 15 May 2009 11:50:40 -0700 (PDT)
Message-ID: <4A0DB97F.4020201@sandeen.net>
Date: Fri, 15 May 2009 13:50:39 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH] xfsprogs:  add fallocate command to xfs_io
References: <4A077195.3070708@sandeen.net>
	<20090515171324.GA14804@infradead.org>
	<20090515172711.GA23630@infradead.org>
In-Reply-To: <20090515172711.GA23630@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs-oss <xfs@oss.sgi.com>

Christoph Hellwig wrote:
> On Fri, May 15, 2009 at 01:13:24PM -0400, Christoph Hellwig wrote:
>> On Sun, May 10, 2009 at 07:30:13PM -0500, Eric Sandeen wrote:
>>> Based on Dave's earlier patch, but now we have an fallocate
>>> glibc call... this also adds autoconf magic and a manpage 
>>> update.
>>>
>>> (hopefully not too #ifdef-heavy....)
>> Looks good to me and seems to work.
> 
> Actually that was spoken too fast.  On my Debian -testing system it
> detects fallocate as available because <linux/falloc.h> exists, but the
> glibc doesn't actually support a falloc(3) yet.  So either the detection
> needs to be improved or we need to use the raw syscall.

Ok, I think I know how to make the detection work better, I'll fix that up.

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
