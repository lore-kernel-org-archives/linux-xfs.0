Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	n0BDkRMu025938 for <xfs@oss.sgi.com>; Sun, 11 Jan 2009 07:46:27 -0600
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 8F61217CDC74
	for <xfs@oss.sgi.com>; Sun, 11 Jan 2009 05:46:25 -0800 (PST)
Received: from mail.sandeen.net (sandeen.net [209.173.210.139]) by
	cuda.sgi.com with ESMTP id BQsU5DZT0Nxq2KGU for
	<xfs@oss.sgi.com>; Sun, 11 Jan 2009 05:46:25 -0800 (PST)
Message-ID: <4969F830.1060209@sandeen.net>
Date: Sun, 11 Jan 2009 07:46:24 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: mkfs.xfs with a 9TB realtime volume hangs
References: <alpine.DEB.2.00.0811141231390.23165@kurp.hut.fi>
	<49690F73.1070908@sandeen.net> <20090111103528.GA8071@disturbed>
In-Reply-To: <20090111103528.GA8071@disturbed>
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
To: Eric Sandeen <sandeen@sandeen.net>, Jan Wagner <jwagner@kurp.hut.fi>, xfs@oss.sgi.com

Dave Chinner wrote:
> On Sat, Jan 10, 2009 at 03:13:23PM -0600, Eric Sandeen wrote:


>> With the default 4k extent size this takes forever (the man page claims
>> default is 64k, maybe this got broken at some point).
> 
> It got changed a few years back by Nathan, IIRC. 

Yep, I found the commit yesterday, it was for buffered IO's benefit on
the rt subvol, to reduce unwritten extent conversion IIRC.

I was going to follow up w/ the commit etc yesterday, but the mailing
list was down (again, sigh - this is indicative of sgi's staunch
commitment to xfs, I'm sure) so had nothing to reply to.

-Eric

> I bet the time
> being taken a result of the blow-out in bitmap size caused by reducing
> the extent size. Given it is non-linear, it may have something to do
> with cache sizes as well.  e.g buftarg hashes not large enough.
> 
> Cheers,
> 
> Dave.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
