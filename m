Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 15 Jul 2007 19:25:30 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l6G2PObm002388
	for <xfs@oss.sgi.com>; Sun, 15 Jul 2007 19:25:25 -0700
Date: Mon, 16 Jul 2007 12:25:18 +1000
From: David Chinner <dgc@sgi.com>
Subject: Re: XFS + RAID1 strange message
Message-ID: <20070716022518.GH12413810@sgi.com>
References: <20070713151058.GA24153@gepard>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070713151058.GA24153@gepard>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Dawid 'Kuba' Chrzan <qba@f-net.pl>
Cc: xfs@oss.sgi.com

On Fri, Jul 13, 2007 at 05:10:58PM +0200, Dawid 'Kuba' Chrzan wrote:
> Hi
> 
> I got linux box
> Linux gepard 2.6.17-pp3 #6 SMP Tue Feb 13 12:50:39 CET 2007 i686 unknown

You *really* don't want to be using that kernel for XFS. Please
upgrade to at least 2.6.17.7 to avoid the dir2 corruption bug
in that release.

http://oss.sgi.com/projects/xfs/faq.html#dir2

> When i reboot , halt the server i always get 
> Jul 12 18:25:14 gepard kernel: Starting XFS recovery on filesystem: md2
> (logdev: internal)
> Jul 12 18:25:14 gepard kernel: Ending XFS recovery on filesystem: md2
> (logdev: internal)
> 
> such errors. Only on md2.
> qba@gepard:~$ mount  | grep md2
> /dev/md2 on /usr type xfs (rw)

I assume you mean when the system boots - those timestamps are from your
boot log above. What is it that you think is incorrect about these
messages? They are information indicating a successful log recovery
which means your /usr filesystem is not being cleanly unmounted by your
shutdown scripts. This is just saying that log recover occurred on
that filesystem and everything is ok.

> Is it normal message , and i should not worry about it?

Yes, you'll see this message for any filesystem that wasn't cleanly
unmounted and if it succeeds then you have nothing to worry about.

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
