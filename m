Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 17 Oct 2007 20:48:07 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with SMTP id l9I3lvlZ030868
	for <xfs@oss.sgi.com>; Wed, 17 Oct 2007 20:48:00 -0700
Message-ID: <4716D891.1060108@sgi.com>
Date: Thu, 18 Oct 2007 13:52:49 +1000
From: Lachlan McIlroy <lachlan@sgi.com>
Reply-To: lachlan@sgi.com
MIME-Version: 1.0
Subject: Re: [PATCH] flush inode when changing atime.
References: <200710170456.AA06101@TNESG9305.wm.jp.nec.com> <20071017090844.GZ995458@sgi.com>
In-Reply-To: <20071017090844.GZ995458@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: Utako Kusaka <u-kusaka@wm.jp.nec.com>, xfs@oss.sgi.com

David Chinner wrote:
> On Wed, Oct 17, 2007 at 01:56:00PM +0900, Utako Kusaka wrote:
>> Hi,
>>
>> The atime is changed for reading but it returns to a previous value
>> after unmount. i_update_core is still off after reading a file using
>> read(), readdir() and readlink(). So an inode isn't flushed to disk.
> 
> I think this was done by design - Christoph? I can't remember exactly
> as it was more than two years ago this change was made. It is effectively
> equivalent to using the relatime mount option.
> 
> The question is whether we want to change the default behaviour or
> whether we need to supply an "atimeisatime" mount option for those
> that really need atime to be updated on every access.
> 
If we change it back then will anything that scans the filesystem cause
inodes to be dirtied and create a lot of inode flush traffic that we
don't currently have?

>> I referred to following fix when I made a patch:
>> TAKE 946679 - fix, speedup and simplify atime handling
>> http://marc.info/?l=linux-xfs&m=113398234310217&w=4
> 
> Yes, that was the patch that removed the explicit atime updates
> in the XFS code. Your fix is reverting part of that change.
> 
>> --- linux-2.6-xfs.orig/fs/xfs/xfs_vnodeops.c	2007-10-15 15:50:10.000000000 +0900
>> +++ linux-2.6-xfs/fs/xfs/xfs_vnodeops.c	2007-10-15 16:49:35.000000000 +0900
>> @@ -1003,6 +1003,8 @@ xfs_readlink(
>>  		error = xfs_readlink_bmap(ip, link);
>>  	}
>>  
>> +	ip->i_update_core = 1;
>> +
> 
> If we are going to put these back in, then they should be
> calls to xfs_ichgtime_fast() so that we know what the reason
> for marking the core dirty is.
> 

xfs_ichgtime_fast() will also dirty the linux inode so that sync
will push out the change.
