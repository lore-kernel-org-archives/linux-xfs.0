Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mASMixtV020638 for <xfs@oss.sgi.com>; Fri, 28 Nov 2008 16:45:00 -0600
Received: from mail.lichtvoll.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 0A832161FA90
	for <xfs@oss.sgi.com>; Fri, 28 Nov 2008 14:44:58 -0800 (PST)
Received: from mail.lichtvoll.de (mondschein.lichtvoll.de [194.150.191.11]) by
	cuda.sgi.com with ESMTP id gs3BZXFzoDvd0bN1 for
	<xfs@oss.sgi.com>; Fri, 28 Nov 2008 14:44:58 -0800 (PST)
Received: from shambhala.lichtvoll.local
	(DSL01.83.171.186.41.ip-pool.NEFkom.net [83.171.186.41])
	by mail.lichtvoll.de (Postfix) with ESMTPSA id 393125AE40
	for <xfs@oss.sgi.com>; Fri, 28 Nov 2008 23:39:25 +0100 (CET)
From: Martin Steigerwald <Martin@lichtvoll.de>
Subject: Re: truncated files
Date: Fri, 28 Nov 2008 23:39:23 +0100
References: <200811252244.14718.Martin@Lichtvoll.de>
	<20081126225931.GK6291@disturbed>
	<200811282302.42809.Martin@lichtvoll.de>
	(sfid-20081128_231257_150156_A8F131E7)
In-Reply-To: <200811282302.42809.Martin@lichtvoll.de>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200811282339.24197.Martin@lichtvoll.de>
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

Am Freitag 28 November 2008 schrieb Martin Steigerwald:
> Am Mittwoch 26 November 2008 schrieb Dave Chinner:
> > On Wed, Nov 26, 2008 at 09:49:18AM +0100, Martin Steigerwald wrote:
> > > Am Dienstag 25 November 2008 schrieb Dave Chinner:
> > > > On Tue, Nov 25, 2008 at 10:44:14PM +0100, Martin Steigerwald 
wrote:
> > > > > Hi!
> > > > >
> > > > > Today on one try to hibernate via tuxonice it machine appeared
> > > > > dead. I am
> > > >
> > > >                       ^^^^^^^^^
> > > > When (not if) suspend to disk/resume fails, you get to keep all
> > > > the broken pieces of your filesystem. It works most of the time,
> > > > but it has some fundamentally broken corner cases that you
> > > > probably just hit....
> > >
> > > Well I use TuxOnIce for a reason! I had uptimes of up to 70 days
> > > with it already. And they are usually only interrupted by kernel
> > > updates or manual shutdowns. I was never convinced by in-kernel
> > > solutions for hibernate.
> >
> > Sure, though I'm not convinced that TuxOnIce is any better because
> > it still uses the same fundamental design as the in-kernel ones.
>
> Might be.
>
> But something is fishy here. I had it a second time today. This time I
> know for sure that the machine freezed hard. Mouse pointer froze and
> the machine didn't even respond to a ping anymore. Nothing in logs -
> doesn't surprise me.
>
> I didn't have this issue with 2.6.26, and I also don't think I had it
> with 2.6.27.5. I will downgrade to 2.6.27.5 now.

I wonder about those truncated files nonetheless. As I don't think that 
KDE is writing config files all the time. Well I might be wrong, but I 
didn't even change KDE configuration during time of the crash... OTOH XFS 
uses a in memory inode size and should be safe with the point in time 
when it writes the size to disk as far as I read here. Well this time at 
least again the file "kdeglobals" was affected and this file might be 
written rather often.

Anyway, since I am not even using an official TuxOnIce patch... lets see 
what the downgrade to 2.6.27.5 brings - no time to really dig deeper into 
that right now.

Maybe I should update notebook kernels a little less. 2.6.25.3,6,8,10 
worked nicer than 2.6.26.5 which has had hangs on USB sound on my T23 
Amarok machine, especially after several hibernate cycles.

Or use the Debian distro kernel, but I never had much luck with hibernate 
with that. Might be worth trying again.

-- 
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
