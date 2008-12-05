Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mB53Rcko029414 for <xfs@oss.sgi.com>; Thu, 4 Dec 2008 21:27:39 -0600
Received: from sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 32CA61665BEE
	for <xfs@oss.sgi.com>; Thu,  4 Dec 2008 19:27:37 -0800 (PST)
Received: from sandeen.net (sandeen.net [209.173.210.139]) by cuda.sgi.com
	with ESMTP id ZiZoO8D8UvK28pvR for <xfs@oss.sgi.com>;
	Thu, 04 Dec 2008 19:27:37 -0800 (PST)
Message-ID: <49389F81.1090306@sandeen.net>
Date: Thu, 04 Dec 2008 21:26:57 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: Device loses barrier support
References: <Pine.LNX.4.64.0812040009340.15169@hs20-bc2-1.build.redhat.com>	<20081204100050.GN6703@one.firstfloor.org>	<Pine.LNX.4.64.0812040836480.6118@hs20-bc2-1.build.redhat.com>	<20081204142015.GQ6703@one.firstfloor.org>	<Pine.LNX.4.64.0812040913510.6118@hs20-bc2-1.build.redhat.com>	<20081204145810.GR6703@one.firstfloor.org>	<Pine.LNX.4.64.0812041139200.2434@hs20-bc2-1.build.redhat.com>	<20081204174838.GS6703@one.firstfloor.org>
	<Pine.LNX.4.64.0812041401210.23079@hs20-bc2-1.build.redhat.com>
In-Reply-To: <Pine.LNX.4.64.0812041401210.23079@hs20-bc2-1.build.redhat.com>
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
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Andi Kleen <andi-suse@firstfloor.org>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, Andi Kleen <andi@firstfloor.org>, Alasdair G Kergon <agk@redhat.com>, Milan Broz <mbroz@redhat.com>

Mikulas Patocka wrote:

> Another thing:
> 
> I'm wondering, where in fsync() does Linux wait for hardware disk cache to 
> be flushed? Isn't there a bug that fsync() will return before the cache is 
> flushed? I couldn't really find it. The last thing do_fsync calls is 
> filemap_fdatawait and it doesn't do cache flush (blkdev_issue_flush).

ext4, reiserfs, and xfs all call blkdev_issue_flush() in their ->fsync
file operations (or down that path).

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
