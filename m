Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 04 Aug 2006 02:16:25 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id k749FwDW023218
	for <xfs@oss.sgi.com>; Fri, 4 Aug 2006 02:16:10 -0700
Message-ID: <44D30FAD.5070704@sgi.com>
Date: Fri, 04 Aug 2006 19:13:17 +1000
From: Timothy Shimmin <tes@sgi.com>
MIME-Version: 1.0
Subject: Re: "xfs_io -c chattr +i " on a symlink
References: <39340.62.159.242.114.1154679319.squirrel@otto.lonx.net>
In-Reply-To: <39340.62.159.242.114.1154679319.squirrel@otto.lonx.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-To: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Dan Am <xfs@lonx.net>
Cc: xfs@oss.sgi.com

Dan Am wrote:
> On Fri, August 4, 2006 6:20 am, Chris Wedgwood wrote:
>> I always disliked open/ioctl for this.  I think we should actually have
>> a separate syscall for chattr, etc. (FreeBSD does this I think?)
 >
> So how does "attr -s someAttribute symlink" work ? This does the job very
> well, distinguishing it from other filesystems.
> 

attr(1) sets the extended attribute and they are set by system calls.
It looks like you would need the -L option to attr(1) which ends up
calling the lsetxattr() syscall via the libattr library.
(Inode attributes shouldn't be confused with extended attributes, EAs, -
  a cause of much confusion for me and others in the past :)

--Tim
