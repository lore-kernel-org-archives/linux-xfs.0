Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 28 Apr 2008 15:40:33 -0700 (PDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m3SMeLFA013200
	for <xfs@oss.sgi.com>; Mon, 28 Apr 2008 15:40:21 -0700
Received: from mail.brightcove.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 54D7715FED11
	for <xfs@oss.sgi.com>; Mon, 28 Apr 2008 15:41:01 -0700 (PDT)
Received: from mail.brightcove.com (mail.brightcove.com [38.113.27.188]) by cuda.sgi.com with ESMTP id v1TbZpHsthn4tC3R for <xfs@oss.sgi.com>; Mon, 28 Apr 2008 15:41:01 -0700 (PDT)
From: Lance Reed <lreed@brightcove.com>
Date: Mon, 28 Apr 2008 18:40:08 -0400
Subject: RE: Problems with xfs_grow on large LVM + XFS filesystem 20TB size
 check 2 failed
Message-ID: <6A32BC807C106440B7E23208F280DDAF01D21F3718@bcmail1.VIDMARK.LOCAL>
References: <6A32BC807C106440B7E23208F280DDAF01D21F36FD@bcmail1.VIDMARK.LOCAL>
 <481650F5.40205@sandeen.net>
In-Reply-To: <481650F5.40205@sandeen.net>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

Thanks for the quick response.

Actually, I was able to run an xfs_repair and all was well.(took 45 minutes...)

But I would love to be able to expand the XFS file system out to the max.

I guess I could expand it in < 2TB increments then maybe?

Thanks for the update and I will look around.

I did find this which I think is related.

http://oss.sgi.com/archives/xfs/2008-01/msg00097.html


Thanks again.

Lance


-----Original Message-----

Subject: Re: Problems with xfs_grow on large LVM + XFS filesystem 20TB size check 2 failed

Lance Reed wrote:
> I recently experienced a problem trying to expand an existing LVM + XFS installation.
> The core problem was that xfs_growfs did not correctly resize the XFS filesystem while trying to expand from 11 TB to about 21 TB.
>
> The previous setup had 5 x 2.18 TB LUNs using LVM2 for a total of just under 11 TB.
> This is a 64bit Linux system.
> Linux nfs3 2.6.18-8.1.15.el5 #1 SMP Mon Oct 22 08:32:28 EDT 2007 x86_64 x86_64 x86_64 GNU/Linux
> CentOS release 5 (Final)
>
> XFS versions:
> xfsprogs-2.9.4-1.el5.centos
> xfsdump-2.2.46-1.el5.centos
> kmod-xfs-0.4-1.2.6.18_8.1.15.el5
>
...

> Thanks in advance for any help....

You probably hit:

TAKE 959978 - growing an XFS filesystem by more than 2TB is broken
http://oss.sgi.com/archives/xfs/2007-01/msg00053.html

which unfortunately probably was never backported to the centos5 xfs
module.  Hmm maybe I should do that.  :(

Dave, do you remember what the fs looked like after hitting that bug?

You may want to read through the "Repairing a possibly incomplete
xfs_growfs command?" thread from earlier, on this list...

I assume you need to try to recover this fs...?  If so I'd not try
shrinking or doing anything else to the fs until there's a chance to see
what shape it's in at this point.

-Eric
