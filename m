Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 10 Jun 2008 10:19:08 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m5AHJ6Vg018375
	for <xfs@oss.sgi.com>; Tue, 10 Jun 2008 10:19:06 -0700
Received: from smtp-out04.alice-dsl.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id B1E1120F15D
	for <xfs@oss.sgi.com>; Tue, 10 Jun 2008 10:20:01 -0700 (PDT)
Received: from smtp-out04.alice-dsl.net (smtp-out04.alice-dsl.net [88.44.63.6]) by cuda.sgi.com with ESMTP id 64lEEdH9NjCVy1Tq for <xfs@oss.sgi.com>; Tue, 10 Jun 2008 10:20:01 -0700 (PDT)
Subject: Re: XFS directory entries sort order
From: Andi Kleen <andi@firstfloor.org>
References: <200806101245.09950.dizzy@roedu.net>
Date: Tue, 10 Jun 2008 19:20:00 +0200
In-Reply-To: <200806101245.09950.dizzy@roedu.net> (dizzy@roedu.net's message of "Tue, 10 Jun 2008 12:45:09 +0300")
Message-ID: <87prqpp5q7.fsf@basil.nowhere.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: dizzy <dizzy@roedu.net>
Cc: xfs@oss.sgi.com

dizzy <dizzy@roedu.net> writes:

> Can someone tell me (in English or C :) ) the algorithm of the sorting order 
> of the entries in an XFS directory as I would get them with a readdir() (or 
> shell "find" command)?
>
> I am trying to figure it out by reading linux/fs/xfs/xfs_dir2*.c code but I 
> don't seem to be doing much progress and I was hoping maybe someone that 
> knows these details can help.

I believe it computes a hash over the name and then sorts by the hash
numerical value. At least the b*tree large directories do, small inline
directories might be different (XFS uses different algorithms for
different directory sizes)

The hash function is in xfs_da_btree.c:xfs_da_hashname()

With the recent case insensitive support there are also differences
on the file systems which have that enabled.

Also better don't rely on it never changing.

-Andi
