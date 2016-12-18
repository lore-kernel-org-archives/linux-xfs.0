Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:51928 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1759425AbcLRCwr (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sat, 17 Dec 2016 21:52:47 -0500
Subject: Re: [PATCH] xfs_io: implement 'utimes' command
References: <1482026266-6988-1-git-send-email-deepa.kernel@gmail.com>
 <90aed6a0-f407-d915-ab39-eef8cab89169@sandeen.net>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <ecef76a5-ef46-8791-79a4-31cfc593efed@sandeen.net>
Date: Sat, 17 Dec 2016 20:52:45 -0600
MIME-Version: 1.0
In-Reply-To: <90aed6a0-f407-d915-ab39-eef8cab89169@sandeen.net>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Deepa Dinamani <deepa.kernel@gmail.com>, linux-xfs@vger.kernel.org
Cc: arnd@arndb.de, y2038@lists.linaro.org

On 12/17/16 8:40 PM, Eric Sandeen wrote:
> This needs some attention across all of xfs_io, but you might want
> to return 0 for now for consistency with other commands.
> 
> -Eric

sorry, signed off too early, there were more comments below :)
 
>> +
>> +	return 0;
>> +}
>> +
>> +void
>> +utimes_init(void)
>> +{
>> +	utimes_cmd.name = "utimes";
>> +	utimes_cmd.cfunc = utimes_f;
>> +	utimes_cmd.argmin = 4;
>> +	utimes_cmd.argmax = 4;
>> +	utimes_cmd.flags = CMD_NOMAP_OK | CMD_FOREIGN_OK;
>> +	utimes_cmd.args = _("atime_sec atime_nsec mtime_sec mtime_nsec");
>> +	utimes_cmd.oneline = _("Update file times of the current file");
>> +	utimes_cmd.help = utimes_help;
>> +
>> +	add_command(&utimes_cmd);
>> +}
>> diff --git a/libxcmd/input.c b/libxcmd/input.c
>> index 5a7dce3..2fdb3e8 100644
>> --- a/libxcmd/input.c
>> +++ b/libxcmd/input.c
>> @@ -327,6 +327,28 @@ timestr(
>>  }
>>  
>>  /*
>> + * Convert from a pair of arbitrary user strings into a timespec.
>> + */
>> +
>> +int
>> +timespec_from_string(
>> +	const char	* secs,
>> +	const char	* nsecs,
>> +	struct timespec	* ts)
>> +{
>> +	char* p;
>> +	if (!secs || !nsecs || !ts)
>> +		return -1;
>> +	ts->tv_sec = strtoull(secs, &p, 0);
>> +	if (*p)
>> +		return -1;
>> +	ts->tv_nsec = strtoull(nsecs, &p, 0);
>> +	if (*p)
>> +		return -1;
>> +	return 0;
> I'd return 1/0 not -1/0 - not that big a deal, but the reason
> the i.e. prid_from_string() functions return -1 on error
> is because they actually return an ID, which is >= 0, so
> it detects "== -1" as an error, and can't simply test
> 1/0.
> 
> 
>> +}
>> +
>> +/*
>>   * Convert from arbitrary user strings into a numeric ID.
>>   * If it's all numeric, we convert that inplace, else we do
>>   * the name lookup, and return the found identifier.
>> diff --git a/man/man8/xfs_io.8 b/man/man8/xfs_io.8
>> index 2c56f09..3ffe439 100644
>> --- a/man/man8/xfs_io.8
>> +++ b/man/man8/xfs_io.8
>> @@ -589,6 +589,17 @@ Copy data into the open file beginning at
>>  Copy up to
>>  .I length
>>  bytes of data.
>> +.RE
>> +.PD
>> +.TP
>> +.TP
> don't need two .TPs, a patch to remove the others is pending.
> 
> thanks,
> -Eric
> 
>> +.BI utimes " atime_sec atime_nsec mtime_sec mtime_nsec"
>> +The utimes command changes the atime and mtime of the current file.
>> +sec uses UNIX timestamp notation and is the seconds elapsed since
>> +1970-01-01 00:00:00 UTC.
>> +nsec is the nanoseconds since the sec. This value needs to be in
>> +the range 0-999999999 with UTIME_NOW and UTIME_OMIT being exceptions.
>> +Each (sec, nsec) pair constitutes a single timestamp value.
>>  
>>  .SH MEMORY MAPPED I/O COMMANDS
>>  .TP
>> @@ -875,6 +886,7 @@ verbose output will be printed.
>>  .BR fstatfs (2),
>>  .BR fsync (2),
>>  .BR ftruncate (2),
>> +.BR futimens (3),
>>  .BR mmap (2),
>>  .BR msync (2),
>>  .BR open (2),
