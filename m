Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 28 Apr 2008 15:59:44 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m3SMxO9U014712
	for <xfs@oss.sgi.com>; Mon, 28 Apr 2008 15:59:27 -0700
Received: from sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 9D7A210D0062
	for <xfs@oss.sgi.com>; Mon, 28 Apr 2008 16:00:06 -0700 (PDT)
Received: from sandeen.net (sandeen.net [209.173.210.139]) by cuda.sgi.com with ESMTP id fgDNpnBvBwR1hzaz for <xfs@oss.sgi.com>; Mon, 28 Apr 2008 16:00:06 -0700 (PDT)
Message-ID: <481656F6.5030300@sandeen.net>
Date: Mon, 28 Apr 2008 18:00:06 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: Problems with xfs_grow on large LVM + XFS filesystem 20TB size
 check 2 failed
References: <6A32BC807C106440B7E23208F280DDAF01D21F36FD@bcmail1.VIDMARK.LOCAL> <481650F5.40205@sandeen.net> <6A32BC807C106440B7E23208F280DDAF01D21F3718@bcmail1.VIDMARK.LOCAL>
In-Reply-To: <6A32BC807C106440B7E23208F280DDAF01D21F3718@bcmail1.VIDMARK.LOCAL>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Lance Reed <lreed@brightcove.com>
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

Lance Reed wrote:
> Thanks for the quick response.
> 
> Actually, I was able to run an xfs_repair and all was well.(took 45 minutes...)
> 
> But I would love to be able to expand the XFS file system out to the max.
> 
> I guess I could expand it in < 2TB increments then maybe?
> 
> Thanks for the update and I will look around.
> 
> I did find this which I think is related.
> 
> http://oss.sgi.com/archives/xfs/2008-01/msg00097.html

Yep, I think expanding it in, say, 1T increments should be fine, and it
 should all (I think...) end up the same as if you'd done it all at once
(modulo the bug, of course...)

-Eric
