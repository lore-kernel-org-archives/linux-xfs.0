Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-it0-f68.google.com ([209.85.214.68]:33125 "EHLO
        mail-it0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752170AbcLRThb (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 18 Dec 2016 14:37:31 -0500
Received: by mail-it0-f68.google.com with SMTP id c20so8284117itb.0
        for <linux-xfs@vger.kernel.org>; Sun, 18 Dec 2016 11:37:30 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <90aed6a0-f407-d915-ab39-eef8cab89169@sandeen.net>
References: <1482026266-6988-1-git-send-email-deepa.kernel@gmail.com> <90aed6a0-f407-d915-ab39-eef8cab89169@sandeen.net>
From: Deepa Dinamani <deepa.kernel@gmail.com>
Date: Sun, 18 Dec 2016 11:37:30 -0800
Message-ID: <CABeXuvpTAQpugPrFbhTktw2d5Eu6355W-_-iQ3mH=ER9Wrdbfg@mail.gmail.com>
Subject: Re: [PATCH] xfs_io: implement 'utimes' command
Content-Type: text/plain; charset=UTF-8
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: linux-xfs@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>, y2038 Mailman List <y2038@lists.linaro.org>

>> +     if (argc != 5)
>> +             return command_usage(&utimes_cmd);
>
> Because you set argsmin & argsmax to 4, it should be impossible
> to get here with anything other than argc=5 - it's caught
> elsewhere:

Yes, you are right. This was something I was using to debug.
I will remove this. Thanks.

>> +     /* Get the timestamps */
>> +     result = timespec_from_string(argv[1], argv[2], &t[0]);
>> +     if (result) {
>> +             fprintf(stderr, "Bad value for atime\n");
>> +             return 1;
>> +     }
>> +     result = timespec_from_string(argv[3], argv[4], &t[1]);
>> +     if (result) {
>> +             fprintf(stderr, "Bad value for mtime\n");
>> +             return 1;
>> +     }
>> +
>> +     /* Call futimens to update time. */
>> +     if (futimens(file->fd, t)) {
>> +             perror("futimens");
>> +             return 1;
>> +     }
>
> Most xfs_io functions return 0 even on errors, possibly after
> setting exit_code = 1 to change the ultimate exit code;
> returning 1 will cause all processing to stop, and/or kick you
> out of the interactive shell:
>
> $ xfs_io file
> xfs_io> utimes a b c d
> Bad value for atime
> $
>
> This needs some attention across all of xfs_io, but you might want
> to return 0 for now for consistency with other commands.

Will change to return 0 always. Thanks.

>>  /*
>> + * Convert from a pair of arbitrary user strings into a timespec.
>> + */
>> +
>> +int
>> +timespec_from_string(
>> +     const char      * secs,
>> +     const char      * nsecs,
>> +     struct timespec * ts)
>> +{
>> +     char* p;
>> +     if (!secs || !nsecs || !ts)
>> +             return -1;
>> +     ts->tv_sec = strtoull(secs, &p, 0);
>> +     if (*p)
>> +             return -1;
>> +     ts->tv_nsec = strtoull(nsecs, &p, 0);
>> +     if (*p)
>> +             return -1;
>> +     return 0;
>
> I'd return 1/0 not -1/0 - not that big a deal, but the reason
> the i.e. prid_from_string() functions return -1 on error
> is because they actually return an ID, which is >= 0, so
> it detects "== -1" as an error, and can't simply test
> 1/0.

Ok. Will change this to return 1/0.

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
>
> don't need two .TPs, a patch to remove the others is pending.

Ok, will remove it.

I will wait for a couple of days to see if there are any more comments
before submitting a v2.

-Deepa
