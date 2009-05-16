Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n4GM1jLi143970 for <xfs@oss.sgi.com>; Sat, 16 May 2009 17:01:45 -0500
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 31758FBF585
	for <xfs@oss.sgi.com>; Sat, 16 May 2009 15:06:51 -0700 (PDT)
Received: from mail.sandeen.net (sandeen.net [209.173.210.139]) by
	cuda.sgi.com with ESMTP id m8Xxj6yDXawpnS8l for
	<xfs@oss.sgi.com>; Sat, 16 May 2009 15:06:51 -0700 (PDT)
Message-ID: <4A0F37CF.4030709@sandeen.net>
Date: Sat, 16 May 2009 17:01:51 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH] xfsprogs: fix readline/editline for xfs_io and	xfs_quota
References: <4A0E177C.7070902@sandeen.net>
	<20090516203413.GB28186@infradead.org>
In-Reply-To: <20090516203413.GB28186@infradead.org>
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
> On Fri, May 15, 2009 at 08:31:40PM -0500, Eric Sandeen wrote:
>> It looks like libxcmd wasn't ever being built with -DENABLE_READLINE
>> even when it was asked for by configure --enable-readline=yes
>> so xfs_io & xfs_quota didn't get the functionality.
>>
>> This seems to fix it up for me (fixes editline too while we're
>> at it).
> 
> I've also been wondering for quite some while why xfs_io didn't have
> working readline support.
> 
> This patch makes it work for me and looks good:
> 
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> 
> (btw, any reason we don't enable readline support by default if
> we find the headers installed?)
> 

I dunno... Nathan, any idea?  Maybe some git-digging is in order.

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
