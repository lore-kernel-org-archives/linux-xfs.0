Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 29 Apr 2008 09:55:52 -0700 (PDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m3TGseGO028894
	for <xfs@oss.sgi.com>; Tue, 29 Apr 2008 09:55:24 -0700
Message-ID: <481752F9.8040600@sandeen.net>
Date: Tue, 29 Apr 2008 11:55:21 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: Problems with xfs_grow on large LVM + XFS filesystem 20TB size
 check 2 failed
References: <6A32BC807C106440B7E23208F280DDAF01D21F36FD@bcmail1.VIDMARK.LOCAL> <481650F5.40205@sandeen.net> <6A32BC807C106440B7E23208F280DDAF01D21F3718@bcmail1.VIDMARK.LOCAL> <481656F6.5030300@sandeen.net> <48166E18.10008@sgi.com> <48166F42.50104@sandeen.net> <6A32BC807C106440B7E23208F280DDAF01D21F384B@bcmail1.VIDMARK.LOCAL> <48175046.5050405@sandeen.net> <6A32BC807C106440B7E23208F280DDAF01D21F3870@bcmail1.VIDMARK.LOCAL>
In-Reply-To: <6A32BC807C106440B7E23208F280DDAF01D21F3870@bcmail1.VIDMARK.LOCAL>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Lance Reed <lreed@brightcove.com>
Cc: "markgw@sgi.com" <markgw@sgi.com>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>

Lance Reed wrote:
> Thanks,
> 
> Sorry, I am a bit confused on the "data section" vs. the "real-time section"?
> 
> Is it enough to just run "xfs_growfs -D XXX  /mntpoint" and the rest should fall into place.
> 
> Again, sorry for being dense.
> I really appraciate the rapid feedback.
> 

Unless you specifically made a filesystem with a realtime subvol, just
ignore it, it's not created by default.

So yes, -D <size> (in blocks) is what you want.  A little cumbersome but
not too bad :)

-Eric
