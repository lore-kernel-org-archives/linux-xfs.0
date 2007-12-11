Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 11 Dec 2007 08:52:20 -0800 (PST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id lBBGqBXF032588
	for <xfs@oss.sgi.com>; Tue, 11 Dec 2007 08:52:15 -0800
Received: from nz-out-0506.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 55D1446BC2E
	for <xfs@oss.sgi.com>; Tue, 11 Dec 2007 08:52:17 -0800 (PST)
Received: from nz-out-0506.google.com (nz-out-0506.google.com [64.233.162.229]) by cuda.sgi.com with ESMTP id f25HHsNt7cPClegT for <xfs@oss.sgi.com>; Tue, 11 Dec 2007 08:52:17 -0800 (PST)
Received: by nz-out-0506.google.com with SMTP id x3so815140nzd
        for <xfs@oss.sgi.com>; Tue, 11 Dec 2007 08:52:15 -0800 (PST)
Message-ID: <cc7060690712110852v185362a4q21a8de1c7e7334e@mail.gmail.com>
Date: Tue, 11 Dec 2007 22:22:14 +0530
From: "Bhagi rathi" <jahnu77@gmail.com>
Subject: Re: TAKE 964002 - Don't wait for pending I/Os when purging blocks beyond eof.
In-Reply-To: <20071210055955.0F96358C4C34@chook.melbourne.sgi.com>
MIME-Version: 1.0
References: <20071210055955.0F96358C4C34@chook.melbourne.sgi.com>
Content-Type: text/plain
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Lachlan McIlroy <lachlan@sgi.com>
Cc: sgi.bugs.xfs@engr.sgi.com, xfs@oss.sgi.com

On Dec 10, 2007 11:29 AM, Lachlan McIlroy <lachlan@sgi.com> wrote:

> Don't wait for pending I/Os when purging blocks beyond eof.
>
> On last close of a file we purge blocks beyond eof.  The same
> code is used when we truncate the file size down.  In this case
> we need to wait for any pending I/Os for dirty pages beyond the
> new eof.  For the last close case we are not changing the file
> size and therefore do not need to wait for any I/Os to complete.
> This fixes a performance bottleneck where writes into the page
> cache and cache flushes can become mutually exclusive.


Lachlan,

How the following is addressed if we don't wait for I/O to complete during
close of the file and
issue truncate:

        - We didn't waited for the I/O to complete
        - Truncated blocks beyond EOF.
        - These blocks are re-used for another transaction as meta-data.
        - Meta-data flush was induced. However the flush of meta-data
reached first before the data I/O
          because of some issues with under-lying driver. Later the file I/O
over-written the meta-data I/O.
          We have corruption of data.

It seems the corruption could be in various ways. Isn't this the reason why
truncate has to wait
for the I/O to complete? I believe fundamental problem is once the blocks
are free'ed, the re-association should
not expect some I/O in concurrent to those same block addresses.

-Cheers,
 Bhagi.


>
>
> Date:  Mon Dec 10 16:59:09 AEDT 2007
> Workarea:  redback.melbourne.sgi.com:/home/lachlan/isms/2.6.x-vniowait
> Inspected by:  pleckie
> Author:  lachlan
>
> The following file(s) were checked into:
>  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb
>
>
> Modid:  xfs-linux-melb:xfs-kern:30220a
> fs/xfs/xfs_inode.c - 1.489 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/> xfs_inode.c.diff?r1=text&tr1=1.489&r2=text&tr2=1.488&f=h
>
> http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_inode.c.diff?r1=text&tr1=1.489&r2=text&tr2=1.488&f=h
>        - Don't wait for pending I/Os when purging blocks beyond eof.
>
>
>
>
>


[[HTML alternate version deleted]]
