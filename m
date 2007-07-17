Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 17 Jul 2007 00:29:49 -0700 (PDT)
Received: from gepard.f-net.pl ([212.244.116.162])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l6H7Tibm032022
	for <xfs@oss.sgi.com>; Tue, 17 Jul 2007 00:29:45 -0700
Received: from qba by gepard.f-net.pl with local (Exim 4.20)
	id 1IAhVA-0001id-NO
	for xfs@oss.sgi.com; Tue, 17 Jul 2007 09:29:44 +0200
Date: Tue, 17 Jul 2007 09:29:44 +0200
From: "Dawid 'Kuba' Chrzan" <qba@f-net.pl>
Subject: Re: XFS + RAID1 strange message
Message-ID: <20070717072944.GA27270@gepard>
References: <20070713151058.GA24153@gepard> <20070716022518.GH12413810@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Disposition: inline
In-Reply-To: <20070716022518.GH12413810@sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

On Mon, Jul 16, 2007 at 12:25:18PM +1000, David Chinner wrote:
> On Fri, Jul 13, 2007 at 05:10:58PM +0200, Dawid 'Kuba' Chrzan wrote:
> > Hi
> > 
> > I got linux box
> > Linux gepard 2.6.17-pp3 #6 SMP Tue Feb 13 12:50:39 CET 2007 i686 unknown
> 
> You *really* don't want to be using that kernel for XFS. Please
> upgrade to at least 2.6.17.7 to avoid the dir2 corruption bug
> in that release.
> 
> http://oss.sgi.com/projects/xfs/faq.html#dir2

It seems that i have to upgrade on all servers.

> 
> > When i reboot , halt the server i always get 
> > Jul 12 18:25:14 gepard kernel: Starting XFS recovery on filesystem: md2
> > (logdev: internal)
> > Jul 12 18:25:14 gepard kernel: Ending XFS recovery on filesystem: md2
> > (logdev: internal)
> > 
> > such errors. Only on md2.
> > qba@gepard:~$ mount  | grep md2
> > /dev/md2 on /usr type xfs (rw)
> 
> I assume you mean when the system boots - those timestamps are from your
> boot log above. What is it that you think is incorrect about these
> messages? They are information indicating a successful log recovery
> which means your /usr filesystem is not being cleanly unmounted by your
> shutdown scripts. This is just saying that log recover occurred on
> that filesystem and everything is ok.
> 

Yes , these are system boot logs. 
I understand completely that this is log informing about recovery of
log.
But why ? It seems that i have to investigate why /usr was not clenly
unmounted.

> > Is it normal message , and i should not worry about it?
> 
> Yes, you'll see this message for any filesystem that wasn't cleanly
> unmounted and if it succeeds then you have nothing to worry about.
> 

I know i know.... I was thinking rather about this if it is usual on
raid1 - or some bug with xfs on raid.

Thanks for help and advice.


-- 
Pozdrawiam, Dawid 'Kuba' Chrzan
http://f-net.pl  qba_nospam_@f-net.pl
RLU#212729   net/sys administrator

"Computer games don't affect kids; I mean if Pac-Man affected us as
kids, we'd all be running around in darkened rooms, munching magic pills
and listening to repetitive electronic music." - Kristian Wilson,
Nintendo Inc., 1989.
