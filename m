Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mBUKOIjV027952 for <xfs@oss.sgi.com>; Tue, 30 Dec 2008 14:24:18 -0600
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id E0C1C179837B
	for <xfs@oss.sgi.com>; Tue, 30 Dec 2008 12:24:17 -0800 (PST)
Received: from mail.sandeen.net (sandeen.net [209.173.210.139]) by
	cuda.sgi.com with ESMTP id 0B4W0xgNotVtHY3C for
	<xfs@oss.sgi.com>; Tue, 30 Dec 2008 12:24:17 -0800 (PST)
Message-ID: <495A8351.3010604@sandeen.net>
Date: Tue, 30 Dec 2008 14:23:45 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH] xfs-cmds: fix parallel installs in include/ dirs
References: <49594CD9.3010402@sandeen.net>	<200812300907.31459.vapier@gentoo.org>	<20081230171825.GA31624@infradead.org>
	<200812301519.42689.vapier@gentoo.org>
In-Reply-To: <200812301519.42689.vapier@gentoo.org>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
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
To: Mike Frysinger <vapier@gentoo.org>
Cc: Christoph Hellwig <hch@infradead.org>, xfs-oss <xfs@oss.sgi.com>

Mike Frysinger wrote:
> On Tuesday 30 December 2008 12:18:25 Christoph Hellwig wrote:
>> On Tue, Dec 30, 2008 at 09:07:30AM -0500, Mike Frysinger wrote:
>>> acl-2.2.47 built fine for me with `./configure && make` and this patch
>>> ...
>> Works now after a make distclean for me.
>>
>>> that said, if the only purpose of this is to make sure there are symlinks
>>> in include/, why not do it at the tail end of configure ?  then there
>>> will be no weird parallel magic to worry about, and everything will
>>> always be available once configure has finished.
>> I'll leave that to Eric or anyone else who wants to play a build system
>> expert on TV :)
> 
> it's easy to do, i just dont know how people feel about the idea in general

Doesn't much matter to me; not sure what is customary.  Both ways work
fine, I think.

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
