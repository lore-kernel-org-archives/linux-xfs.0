Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 21 Oct 2007 17:24:48 -0700 (PDT)
Received: from sandeen.net (sandeen.net [209.173.210.139])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with ESMTP id l9M0OhE8017633
	for <xfs@oss.sgi.com>; Sun, 21 Oct 2007 17:24:45 -0700
Message-ID: <471BEDCD.3040104@sandeen.net>
Date: Sun, 21 Oct 2007 19:24:45 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: mount: /dev/md0: can't read superblock
References: <6e0c99d0710201802v2f41577dv38281b936a2389bf@mail.gmail.com>
In-Reply-To: <6e0c99d0710201802v2f41577dv38281b936a2389bf@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Greg Martyn <greg.martyn@gmail.com>
Cc: xfs@oss.sgi.com

Greg Martyn wrote:
> Hi all,
> After running "xfs_fsr -v /home", I got a bunch of error messages
> saying that certain files (/home/.[three letters that i forgot])
> couldn't be removed. After that, my system stopped working properly,
> so I restarted. Now:
> 
> [root@localhost ~]# mount /dev/md0 /home/
> mount: /dev/md0: can't read superblock
> 
> uh oh.

dmesg says it's corrupted.

You should probably run repair on it.  But being raid, if something went
wrong w/ the raid, that could make it worse... run xfs_repair -n and see
what it *would* fix.

-Eric
