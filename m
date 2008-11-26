Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mAQ8sstM029202 for <xfs@oss.sgi.com>; Wed, 26 Nov 2008 02:54:55 -0600
Received: from mail.lichtvoll.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 645BF1603D90
	for <xfs@oss.sgi.com>; Wed, 26 Nov 2008 00:54:52 -0800 (PST)
Received: from mail.lichtvoll.de (mondschein.lichtvoll.de [194.150.191.11]) by
	cuda.sgi.com with ESMTP id CXxAgae3zjLgrBXl for
	<xfs@oss.sgi.com>; Wed, 26 Nov 2008 00:54:52 -0800 (PST)
Received: from shambala.of.teamix.net (blackhole.teamix.net [194.150.191.251])
	by mail.lichtvoll.de (Postfix) with ESMTPSA id 838555ADF2
	for <xfs@oss.sgi.com>; Wed, 26 Nov 2008 09:49:20 +0100 (CET)
From: Martin Steigerwald <Martin@lichtvoll.de>
Subject: Re: truncated files
Date: Wed, 26 Nov 2008 09:49:18 +0100
References: <200811252244.14718.Martin@Lichtvoll.de>
	<20081125222703.GE6291@disturbed>
	(sfid-20081126_093721_225409_0DE433F6)
In-Reply-To: <20081125222703.GE6291@disturbed>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200811260949.19642.Martin@lichtvoll.de>
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
To: xfs@oss.sgi.com

Am Dienstag 25 November 2008 schrieb Dave Chinner:
> On Tue, Nov 25, 2008 at 10:44:14PM +0100, Martin Steigerwald wrote:
> > Hi!
> >
> > Today on one try to hibernate via tuxonice it machine appeared dead.
> > I am
>
>                       ^^^^^^^^^
> When (not if) suspend to disk/resume fails, you get to keep all the
> broken pieces of your filesystem. It works most of the time, but it has
> some fundamentally broken corner cases that you probably just
> hit....

Well I use TuxOnIce for a reason! I had uptimes of up to 70 days with it 
already. And they are usually only interrupted by kernel updates or 
manual shutdowns. I was never convinced by in-kernel solutions for 
hibernate.

> > Similar stuff happened on the encfs encrypted KDE user that I use for
> > professional stuff - encfs is layered on top of XFS via FUSE:
>
> IIRC, FUSE cannot be suspended safely at all, so expect corruption
> of FUSE filesystems on a failed suspend.

Ok, fair enough. My private data isn't on encfs tough.

> I've never had a system that suspends reliably (let alone resumes
> from the suspend) so it's no real surprise that I don't trust
> suspend to disk....

Well I take it as bad luck then, especially since there are no hints that 
XFS had a problem. I am not sure whether the machine really was dead, but 
I can't reproduce what exactly happened. So thats it.

Ciao,
-- 
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
