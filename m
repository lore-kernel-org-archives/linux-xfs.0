Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 29 Apr 2008 09:43:43 -0700 (PDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m3TGhA7s027069
	for <xfs@oss.sgi.com>; Tue, 29 Apr 2008 09:43:18 -0700
Message-ID: <48175046.5050405@sandeen.net>
Date: Tue, 29 Apr 2008 11:43:50 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: Problems with xfs_grow on large LVM + XFS filesystem 20TB size
 check 2 failed
References: <6A32BC807C106440B7E23208F280DDAF01D21F36FD@bcmail1.VIDMARK.LOCAL> <481650F5.40205@sandeen.net> <6A32BC807C106440B7E23208F280DDAF01D21F3718@bcmail1.VIDMARK.LOCAL> <481656F6.5030300@sandeen.net> <48166E18.10008@sgi.com> <48166F42.50104@sandeen.net> <6A32BC807C106440B7E23208F280DDAF01D21F384B@bcmail1.VIDMARK.LOCAL>
In-Reply-To: <6A32BC807C106440B7E23208F280DDAF01D21F384B@bcmail1.VIDMARK.LOCAL>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Lance Reed <lreed@brightcove.com>
Cc: "markgw@sgi.com" <markgw@sgi.com>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>

Lance Reed wrote:
> Thanks so much for all the info!
> 
> I am currently looking over the
> http://oss.sgi.com/archives/xfs/2008-01/msg00097.html
> post to figure  out if I need to do antyhing manual to finish expanding the filesystem.
> 
> If it is possible to expand in increments less than 2 TB, is there a way to do this via xfs_growfs?  I am a bit confused by the -D and -R options and which one would be relevant here.  Or do I have to shrink the LVM Logical Volume first and then just run "xfs_grow /mntpoint".
> Also, can I run with the "-n" option to confirm if the xfs_growfs command "should" complete correctly each time? (looking for docs on this...)
> 
> Is there any reason I couldn't grab a newerer release of the XFS tools, etc, and compile for CentOs 5.0 and use them in this case?

Well, it's there's a kernel bug when growing by >2T so it's not just a
tools issue...

>From what Mark said it sounds like growing 2T at a time is fine.

you can specify sizes on the xfs_growfs commandline, as specified in the
man page.

-Eric
