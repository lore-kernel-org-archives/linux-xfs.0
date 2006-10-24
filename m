Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 24 Oct 2006 10:15:17 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id k9OHFAaG003261
	for <xfs@oss.sgi.com>; Tue, 24 Oct 2006 10:15:10 -0700
Received: from postal1.et.byu.edu (postal1.et.byu.edu [128.187.48.11])
	by cuda.sgi.com (Spam Firewall) with ESMTP id CF0DD4D07A1
	for <xfs@oss.sgi.com>; Tue, 24 Oct 2006 10:14:24 -0700 (PDT)
Date: Tue, 24 Oct 2006 11:14:22 -0600 (MDT)
From: David Dougall <davidd@et.byu.edu>
Subject: Re: kernel panic after upgrading to 2.6
In-Reply-To: <453E494F.8080808@sandeen.net>
Message-ID: <Pine.LNX.4.58.0610241113090.8370@lewis.et.byu.edu>
References: <Pine.LNX.4.58.0610240938400.8370@lewis.et.byu.edu>
 <453E494F.8080808@sandeen.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs@oss.sgi.com

I actually did see that bug report.  That is why I have tried upgrading
now a few times.  I have run xfs_repair on all of my file systems since
upgrading this past time and I still get kernel panics.  I already have
2.8.10 as far as I can tell.  2.8.10-1 on debian.
--David Dougall


On Tue, 24 Oct 2006, Eric Sandeen wrote:

> David Dougall wrote:
> > I am running kernel 2.6.18 after trying 2.6.17.6 and 2.6.17.13 with
> > similar results.  I continue to have nfs servers kernel panic on a very
> > regular basis, every few days.  Sometimes I need to do an xfs_repair to
> > get the filesystem to remount.  I got the following kernel panic message
> > from the syslog this time:
> > Message from syslogd@nfs09 at Tue Oct 24 09:35:14 2006 ...
> > nfs09 kernel: Oops: 0000 [#1]
>
> If you ran 2.6.17 < 2.6.17.7, there was a bug:
>
> http://oss.sgi.com/projects/xfs/faq.html#dir2
>
> I would suggest getting xfsprogs v. 2.8.10 or newer, as referenced in
> the faq, repair your filesystem, and see if the problem is resolved.
>
> -Eric
>
>
>
