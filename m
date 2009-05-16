Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n4GM8b5j144254 for <xfs@oss.sgi.com>; Sat, 16 May 2009 17:08:37 -0500
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 0DDA519D3E7D
	for <xfs@oss.sgi.com>; Sat, 16 May 2009 15:08:45 -0700 (PDT)
Received: from mail.sandeen.net (sandeen.net [209.173.210.139]) by
	cuda.sgi.com with ESMTP id sDKGHOedeG2GByK5 for
	<xfs@oss.sgi.com>; Sat, 16 May 2009 15:08:45 -0700 (PDT)
Message-ID: <4A0F396B.8010504@sandeen.net>
Date: Sat, 16 May 2009 17:08:43 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH] xfsprogs:  add fallocate command to xfs_io
References: <4A077195.3070708@sandeen.net>	<20090515171324.GA14804@infradead.org>	<20090515172711.GA23630@infradead.org>	<4A0DB97F.4020201@sandeen.net>
	<4A0DE88C.2040401@sandeen.net>
	<20090516204025.GC28186@infradead.org>
In-Reply-To: <20090516204025.GC28186@infradead.org>
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
> On Fri, May 15, 2009 at 05:11:24PM -0500, Eric Sandeen wrote:
>> Instead of above does this work better?
>>
>> (just change AC_TRY_COMPILE to AC_TRY_LINK)
> 
> Yes, that correctly detects fallocate as not present for me and
> thus gives a working fallocate.
> 
>> AC_DEFUN([AC_HAVE_FALLOCATE],
>>   [ AC_MSG_CHECKING([for fallocate])
>>     AC_TRY_LINK([
>> #include <linux/falloc.h>
>>     ], [
>>          fallocate(0, 0, 0, 0);
> 
> Why do you nee to include <linux/falloc.h> here anyway?  You don't use
> any of the constants, and the fallocate libc call must be in another
> headers, so it obviously compiles even without a defintion for it.

Well, the actual patch includes it for FALLOC_FL_KEEP_SIZE so it'd be
better to detect it at config time and if not there fail?


Or we could #ifndef and have a local define ...

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
