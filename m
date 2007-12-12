Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 11 Dec 2007 20:03:27 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id lBC43LaN007217
	for <xfs@oss.sgi.com>; Tue, 11 Dec 2007 20:03:24 -0800
Message-ID: <475F5DC3.6070203@sgi.com>
Date: Wed, 12 Dec 2007 15:04:19 +1100
From: Lachlan McIlroy <lachlan@sgi.com>
Reply-To: lachlan@sgi.com
MIME-Version: 1.0
Subject: Re: TAKE 964002 - Don't wait for pending I/Os when purging blocks
 beyond eof.
References: <20071210055955.0F96358C4C34@chook.melbourne.sgi.com> <cc7060690712110852v185362a4q21a8de1c7e7334e@mail.gmail.com>
In-Reply-To: <cc7060690712110852v185362a4q21a8de1c7e7334e@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Bhagi rathi <jahnu77@gmail.com>
Cc: sgi.bugs.xfs@engr.sgi.com, xfs@oss.sgi.com

Bhagi rathi wrote:
> On Dec 10, 2007 11:29 AM, Lachlan McIlroy <lachlan@sgi.com> wrote:
> 
>> Don't wait for pending I/Os when purging blocks beyond eof.
>>
>> On last close of a file we purge blocks beyond eof.  The same
>> code is used when we truncate the file size down.  In this case
>> we need to wait for any pending I/Os for dirty pages beyond the
>> new eof.  For the last close case we are not changing the file
>> size and therefore do not need to wait for any I/Os to complete.
>> This fixes a performance bottleneck where writes into the page
>> cache and cache flushes can become mutually exclusive.
> 
> 
> Lachlan,
> 
> How the following is addressed if we don't wait for I/O to complete during
> close of the file and
> issue truncate:
> 
>         - We didn't waited for the I/O to complete
>         - Truncated blocks beyond EOF.
>         - These blocks are re-used for another transaction as meta-data.
>         - Meta-data flush was induced. However the flush of meta-data
> reached first before the data I/O
>           because of some issues with under-lying driver. Later the file I/O
> over-written the meta-data I/O.
>           We have corruption of data.
This case will not happen.  For a truncate down we may have dirty pages
beyond eof that are in the process of being written to disk while we are
trying to shrink the file - we need to wait for those.  In the case of
truncating blocks beyond eof on last close we are not changing the file
size and so there cannot be pages beyond eof.  Any I/O that may be in
progress will be within the file size and not to any of the blocks we
are trying to free.

> 
> It seems the corruption could be in various ways. Isn't this the reason why
> truncate has to wait
> for the I/O to complete?
Corruption could certainly occur if we don't wait for I/O.  I think the
reason this code was added was to synchronize with direct I/O unwritten
extent conversions which could occur after the direct writer thread has
released the iolock and so we can't use the iolock alone as an I/O barrier.

> I believe fundamental problem is once the blocks
> are free'ed, the re-association should
> not expect some I/O in concurrent to those same block addresses.
> 
> -Cheers,
>  Bhagi.
> 
> 
>>
>> Date:  Mon Dec 10 16:59:09 AEDT 2007
>> Workarea:  redback.melbourne.sgi.com:/home/lachlan/isms/2.6.x-vniowait
>> Inspected by:  pleckie
>> Author:  lachlan
>>
>> The following file(s) were checked into:
>>  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb
>>
>>
>> Modid:  xfs-linux-melb:xfs-kern:30220a
>> fs/xfs/xfs_inode.c - 1.489 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/>> xfs_inode.c.diff?r1=text&tr1=1.489&r2=text&tr2=1.488&f=h
> http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/> xfs_inode.c.diff?r1=text&tr1=1.489&r2=text&tr2=1.488&f=h
>> http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_inode.c.diff?r1=text&tr1=1.489&r2=text&tr2=1.488&f=h
>>        - Don't wait for pending I/Os when purging blocks beyond eof.
>>
>>
>>
>>
>>
> 
> 
> [[HTML alternate version deleted]]
> 
> 
> 
