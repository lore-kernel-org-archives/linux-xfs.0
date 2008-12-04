Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mB4El8LQ009563 for <xfs@oss.sgi.com>; Thu, 4 Dec 2008 08:47:09 -0600
Received: from one.firstfloor.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 680D716958E3
	for <xfs@oss.sgi.com>; Thu,  4 Dec 2008 06:47:05 -0800 (PST)
Received: from one.firstfloor.org (one.firstfloor.org [213.235.205.2]) by
	cuda.sgi.com with ESMTP id aA5drg6wBmeZvBAu for
	<xfs@oss.sgi.com>; Thu, 04 Dec 2008 06:47:05 -0800 (PST)
Date: Thu, 4 Dec 2008 15:58:10 +0100
From: Andi Kleen <andi@firstfloor.org>
Subject: Re: Device loses barrier support (was: Fixed patch for simple
	barriers.)
Message-ID: <20081204145810.GR6703@one.firstfloor.org>
References: <Pine.LNX.4.64.0812040009340.15169@hs20-bc2-1.build.redhat.com>
	<20081204100050.GN6703@one.firstfloor.org>
	<Pine.LNX.4.64.0812040836480.6118@hs20-bc2-1.build.redhat.com>
	<20081204142015.GQ6703@one.firstfloor.org>
	<Pine.LNX.4.64.0812040913510.6118@hs20-bc2-1.build.redhat.com>
Mime-Version: 1.0
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0812040913510.6118@hs20-bc2-1.build.redhat.com>
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

> You start pvmove. The filesystem doesn't know about pvmove.
> 
> The next time filesystem does somethig, it submits these 3 requests and 
> the 2nd fill unexpectedly fail.

Again the file systems handle failing barriers and they expect it.

> 
> So the fact that pvmove drains the request queue won't help you.

Help you against what? 

> 
> > > finished after the 2nd write) and you are in an interrupt context, where 
> > > you can't reissue -EOPNOTSUPP request. So what do you want to do?
> > 
> > The barrier aware file systems I know of just resubmit synchronously when 
> > a barrier fails.
> 
> ... and produce structure corruption for certain period in time, because 
> the writes meant to be ordered are submitted unordered.

No there is nothing unordered. The file system path typically looks like

commit of a transaction
	if (i have never seen a barrier failing) 
		write block with barrier
		if (EOPNOTSUPP) {
			record failure
			submit synchronously
		}
	} else
		submit synchronously


So if a pvmove barrier fails it will just submit synchronously.

The write block with barrier bit varies, jbd/gfs2 do it synchronously
too and xfs does it asynchronously (with io done callbacks), but
in both cases they handle an EOPNOTSUPP comming out in the final
io done.

When the pvmove migrates from no barrier support to barrier support
there won't be any barrier on the file system for the time of the
current mount, but that's also fine.

-Andi

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
