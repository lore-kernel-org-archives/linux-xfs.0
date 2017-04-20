Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:47134 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1032084AbdDTRpI (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 20 Apr 2017 13:45:08 -0400
Subject: Re: [PATCH] xfs_io: add missed inode command into man page
References: <1492708017-14163-1-git-send-email-zlang@redhat.com>
 <20170420172309.GD23371@birch.djwong.org>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <15dca057-8757-8453-ddf9-7f7e394a8731@sandeen.net>
Date: Thu, 20 Apr 2017 12:45:07 -0500
MIME-Version: 1.0
In-Reply-To: <20170420172309.GD23371@birch.djwong.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>, Zorro Lang <zlang@redhat.com>
Cc: linux-xfs@vger.kernel.org

On 4/20/17 12:23 PM, Darrick J. Wong wrote:
> On Fri, Apr 21, 2017 at 01:06:57AM +0800, Zorro Lang wrote:
>> There's an "inode" command in xfs_io, it's used to query physical
>> information about an inode. But there's not any information about
>> it in xfs_io and other related man pages. So document this command
>> in the xfs_io man page now.
>>
>> Signed-off-by: Zorro Lang <zlang@redhat.com>
>> ---
>>  man/man8/xfs_io.8 | 17 +++++++++++++++++
>>  1 file changed, 17 insertions(+)
>>
>> diff --git a/man/man8/xfs_io.8 b/man/man8/xfs_io.8
>> index 19e1ae4..ceb6cf4 100644
>> --- a/man/man8/xfs_io.8
>> +++ b/man/man8/xfs_io.8
>> @@ -650,6 +650,23 @@ sec uses UNIX timestamp notation and is the seconds elapsed since
>>  nsec is the nanoseconds since the sec. This value needs to be in
>>  the range 0-999999999 with UTIME_NOW and UTIME_OMIT being exceptions.
>>  Each (sec, nsec) pair constitutes a single timestamp value.
>> +.RE
>> +.PD
>> +.TP
>> +.BI " inode [ [ -n ] " number " ] [ -v ]"
>> +The inode command querys physical information about an inode, it
> 
> "queries"
> 
>> +returns 1 if any inode number greater than 32 bits exists in the
> 
> Technically, it returns 1 if any inode number would overflow 32 bits,
> which is to say that it returns 1 if any inode number is greater than
> 2^32-1.
> 
>> +filesystem, or 0 if none exist by default. The
> 
> You could leave out "by default".

I think that the intent here was to say that by default (i.e. with no
other options given, this is what the command does - return 1 or 0 based on
whether or not any any inode number exceeding 32 bits is currently in use.

>> +.I number
>> +is used to specify an inode number, then inode command returns this
>> +inode number if it's in use, or 0 if not. But if use
> 
> "If an inode /number/ is given, this command returns that inode number if
> the inode is in use, or zero if not."?
> 
>> +.B \-n
>> +with
>> +.I number
>> +, the next used inode number after this number will be returned, or 0
>> +if can't find the next one.
> 
> "If -n is given with /number/, the next inode number in use will be
> returned, or zero if there aren't any more"?
> 
>> +.B \-v
>> +for verbose mode, the inode number's size in bits will be displayed.

This is how I would describe the behavior, feel free to use as much or
as little as you like:

With no arguments, the inode command will return 1 or 0, indicating whether
or not any inode numbers greater than 32 bits are currently in use in the
filesystem.

If given an inode /number/ as an argument, the command will return /number/ or
0, depending on whether or not inode /number/ is in use.

With -n /number/, the command will return the next inode number after /number/
which is in use.

With -v, the command will also report the number of bits (32 or 64) used
by the inode number printed in the result; if no inode /number/ was specified
on the commandline, the maximum possible inode number in the system will be
printed along with its size.

> (What a strange command...)

yup.

-Eric

> --D
> 
>>  
>>  .SH MEMORY MAPPED I/O COMMANDS
>>  .TP
>> -- 
>> 2.7.4
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
