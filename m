Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mASM2nd2018354 for <xfs@oss.sgi.com>; Fri, 28 Nov 2008 16:02:49 -0600
Received: from mail.lichtvoll.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id F2227161F34C
	for <xfs@oss.sgi.com>; Fri, 28 Nov 2008 14:02:46 -0800 (PST)
Received: from mail.lichtvoll.de (mondschein.lichtvoll.de [194.150.191.11]) by
	cuda.sgi.com with ESMTP id IxIeAU2buQhxHiVo for
	<xfs@oss.sgi.com>; Fri, 28 Nov 2008 14:02:46 -0800 (PST)
Received: from shambhala.lichtvoll.local
	(DSL01.83.171.186.41.ip-pool.NEFkom.net [83.171.186.41])
	by mail.lichtvoll.de (Postfix) with ESMTPSA id 7574B5AE40
	for <xfs@oss.sgi.com>; Fri, 28 Nov 2008 23:02:43 +0100 (CET)
From: Martin Steigerwald <Martin@lichtvoll.de>
Subject: Re: truncated files
Date: Fri, 28 Nov 2008 23:02:42 +0100
References: <200811252244.14718.Martin@Lichtvoll.de>
	<200811260949.19642.Martin@lichtvoll.de>
	<20081126225931.GK6291@disturbed>
	(sfid-20081127_152602_825156_3113CDB4)
In-Reply-To: <20081126225931.GK6291@disturbed>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200811282302.42809.Martin@lichtvoll.de>
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

Am Mittwoch 26 November 2008 schrieb Dave Chinner:
> On Wed, Nov 26, 2008 at 09:49:18AM +0100, Martin Steigerwald wrote:
> > Am Dienstag 25 November 2008 schrieb Dave Chinner:
> > > On Tue, Nov 25, 2008 at 10:44:14PM +0100, Martin Steigerwald wrote:
> > > > Hi!
> > > >
> > > > Today on one try to hibernate via tuxonice it machine appeared
> > > > dead. I am
> > >
> > >                       ^^^^^^^^^
> > > When (not if) suspend to disk/resume fails, you get to keep all the
> > > broken pieces of your filesystem. It works most of the time, but it
> > > has some fundamentally broken corner cases that you probably just
> > > hit....
> >
> > Well I use TuxOnIce for a reason! I had uptimes of up to 70 days with
> > it already. And they are usually only interrupted by kernel updates
> > or manual shutdowns. I was never convinced by in-kernel solutions for
> > hibernate.
>
> Sure, though I'm not convinced that TuxOnIce is any better because
> it still uses the same fundamental design as the in-kernel ones.

Might be.

But something is fishy here. I had it a second time today. This time I 
know for sure that the machine freezed hard. Mouse pointer froze and the 
machine didn't even respond to a ping anymore. Nothing in logs - doesn't 
surprise me.

I didn't have this issue with 2.6.26, and I also don't think I had it with 
2.6.27.5. I will downgrade to 2.6.27.5 now.

> > > I've never had a system that suspends reliably (let alone resumes
> > > from the suspend) so it's no real surprise that I don't trust
> > > suspend to disk....
> >
> > Well I take it as bad luck then, especially since there are no hints
> > that XFS had a problem. I am not sure whether the machine really was
> > dead, but I can't reproduce what exactly happened. So thats it.
>
> And therein lies the problem. I can't get suspend/resume to work
> reliably on anything I own, so I can't do anything about problems
> reported as a result of suspend/resume. Hell, I even considered
> running linux on my new laptop inside a virtual machine on windows
> just so I could have functioning suspend/resume....

Then you really had back luck. TuxOnIce works stable for me - at least it 
did so for a long long while, until my recent kernel.

Ciao,
-- 
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
