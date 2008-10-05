Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 05 Oct 2008 04:54:39 -0700 (PDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m95BsYG8003626
	for <xfs@oss.sgi.com>; Sun, 5 Oct 2008 04:54:34 -0700
Received: from sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 767CC1B56C06
	for <xfs@oss.sgi.com>; Sun,  5 Oct 2008 04:56:11 -0700 (PDT)
Received: from sandeen.net (sandeen.net [209.173.210.139]) by cuda.sgi.com with ESMTP id srCLJp2xlqYXcGOq for <xfs@oss.sgi.com>; Sun, 05 Oct 2008 04:56:11 -0700 (PDT)
Message-ID: <48E8AB5A.7080301@sandeen.net>
Date: Sun, 05 Oct 2008 06:56:10 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: PARTIAL TAKE 987159 - Fix extent list corruption in xfs_iext_irec_compact_full().
References: <20080923032821.A91D758C52AE@chook.melbourne.sgi.com>
In-Reply-To: <20080923032821.A91D758C52AE@chook.melbourne.sgi.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Lachlan McIlroy <lachlan@sgi.com>
Cc: xfs@oss.sgi.com

Lachlan McIlroy wrote:
> Fix extent list corruption in xfs_iext_irec_compact_full().
> 
> If we don't move all the records from the next buffer into the current buffer
> then we need to update the er_extoff field of the next buffer as we shift the
> remaining records to the start of the buffer.
> 
> Date:  Tue Sep 23 13:20:30 AEST 2008
> Workarea:  redback.melbourne.sgi.com:/home/lachlan/isms/2.6.x-xfs
> Inspected by:  
> sandeen@sandeen.net
> cattelan@thebarn.com
> Author:  lachlan
> 
> The following file(s) were checked into:
>   longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb
> 
> 
> Modid:  xfs-linux-melb:xfs-kern:32165a
> fs/xfs/xfs_inode.c - 1.521 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/> xfs_inode.c.diff?r1=text&tr1=1.521&r2=text&tr2=1.520&f=h
> http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_inode.c.diff?r1=text&tr1=1.521&r2=text&tr2=1.520&f=h
> 	- Fix extent list corruption in xfs_iext_irec_compact_full().

Are there plans to try to get this, and possibly the compact_full
removal pushed into 2.6.27 still?  (and maybe even 2.6.26.x?)

-Eric
