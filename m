Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 25 Mar 2008 11:49:27 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m2PInG5C014650
	for <xfs@oss.sgi.com>; Tue, 25 Mar 2008 11:49:19 -0700
Received: from sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id EBD826E6300
	for <xfs@oss.sgi.com>; Tue, 25 Mar 2008 11:49:50 -0700 (PDT)
Received: from sandeen.net (sandeen.net [209.173.210.139]) by cuda.sgi.com with ESMTP id dIBSnEWZEL5KKiER for <xfs@oss.sgi.com>; Tue, 25 Mar 2008 11:49:50 -0700 (PDT)
Message-ID: <47E9494D.8080807@sandeen.net>
Date: Tue, 25 Mar 2008 13:49:49 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: Serious XFS crash
References: <20080325185453.3a1957dd@galadriel.home>
In-Reply-To: <20080325185453.3a1957dd@galadriel.home>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Emmanuel Florac <eflorac@intellique.com>
Cc: xfs@oss.sgi.com

Emmanuel Florac wrote:
> Here is the setup : Debian sarge running kernel 2.6.18.8 smp (clean
> build), xfsprogs version 2.6.20 (not used). An 8TB xfs filesystem broke
> apart losing roughly 2TB of data in about 350 (big) files :
> 
> Mar 22 12:38:18 system3 kernel: 0x0: c0 49 00 35 6a bc c3 80 fd d4 64
> f8 16 ec b9 85 
> Mar 22 12:38:18 system3 kernel: Filesystem "md0": XFS internal error
> xfs_da_do_buf(2) at line 2084 of file fs/xfs/xfs_da_btree.c.  Caller
> 0xc0214fe8

Out of curiosity, what was the storage setup for that 8T volume?  (md I
guess, but what was behind it?)

Also what architecture was this?

-Eric
