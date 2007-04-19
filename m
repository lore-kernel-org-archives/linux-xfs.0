Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 19 Apr 2007 06:43:37 -0700 (PDT)
Received: from mail.interline.it (mail.interline.it [195.182.241.4])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l3JDhWfB032373
	for <xfs@oss.sgi.com>; Thu, 19 Apr 2007 06:43:35 -0700
Received: from localhost (localhost [127.0.0.1])
	by mail.interline.it (Postfix) with ESMTP id 599D1EE7
	for <xfs@oss.sgi.com>; Thu, 19 Apr 2007 15:42:20 +0200 (CEST)
Received: from mail.interline.it ([127.0.0.1])
	by localhost (pin [127.0.0.1]) (amavisd-new, port 10024) with ESMTP
	id 23588-03 for <xfs@oss.sgi.com>;
	Thu, 19 Apr 2007 15:41:43 +0200 (CEST)
From: "Daniele P." <daniele@interline.it>
Subject: Re: Inode usage
Date: Thu, 19 Apr 2007 15:42:53 +0200
References: <4627283E.7060000@start.no> <20070419131442.GC32602149@melbourne.sgi.com>
In-Reply-To: <20070419131442.GC32602149@melbourne.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704191542.53366.daniele@interline.it>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

On Thursday 19 April 2007 15:14, you wrote:
> On Thu, Apr 19, 2007 at 10:28:46AM +0200, Stein M. Hugubakken wrote:
> > Hi!
> >
> > I have a lot of free inodes on my xfs-partitions and was wondering
> > about what impact this has on performance or memory?
>
> None.  The number of free inodes is a made up number. ;)

That's for normal usage.
Well, David don't forget what you tell me some time ago about
xfs_repair


  In terms of inode count, I generally use the rule that for every
  10million inodes you need a gigabyte of RAM for repair - you needed
  about 500MB for 6million inodes.


The inode count also affects xfsdump/xfsrestore operations but I don't
know the details. There was a huge improvement in performances for
partial dump with xfsprogs-2.8.16 IIRC.

Regards,
Daniele P.
