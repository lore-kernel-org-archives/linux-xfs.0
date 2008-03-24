Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 23 Mar 2008 21:01:49 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m2O41Xs5012732
	for <xfs@oss.sgi.com>; Sun, 23 Mar 2008 21:01:35 -0700
Received: from smtp-out03.alice-dsl.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 6F168100525C
	for <xfs@oss.sgi.com>; Sun, 23 Mar 2008 21:02:06 -0700 (PDT)
Received: from smtp-out03.alice-dsl.net (smtp-out03.alice-dsl.net [88.44.63.5]) by cuda.sgi.com with ESMTP id N5HWIJC5QipyMVxr for <xfs@oss.sgi.com>; Sun, 23 Mar 2008 21:02:06 -0700 (PDT)
Subject: Re: Poor VMWare disk performance on XFS partition
References: <876423.51989.qm@web52006.mail.re2.yahoo.com>
	<47E6C09E.5030601@sandeen.net>
From: Andi Kleen <andi@firstfloor.org>
Date: 24 Mar 2008 05:02:04 +0100
In-Reply-To: <47E6C09E.5030601@sandeen.net>
Message-ID: <87prtk7osj.fsf@basil.nowhere.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: "Hendrik ." <chasake@yahoo.com>, xfs@oss.sgi.com

Eric Sandeen <sandeen@sandeen.net> writes:
> 
> What does xfs_bmap and/or filefrag say, is this file indeed very
> fragmented?  

> And is it less so on ext3?  If the file is persistent then
> preallocating it would probably help.

Preallocating would prevent one of the main features of 
a sparse VM images: starting small and only growing as the
virtual machine needs more storage without having to
resize the virtual partitions.

I remember XFS had a mmap problem a long time ago (in 2.4) which
sounded similar (iirc it trickered with samba), but I thought
it was long fixed. The problem back then was that page
flushing on mmaps didn't get merged due to some unfortunate VM
interactions and then thousands of extents got created on flushing
a mmap. A lot of extents seems to make XFS slow.

-Andi
