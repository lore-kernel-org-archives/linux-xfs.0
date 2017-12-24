Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:59676 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750846AbdLXTvw (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sun, 24 Dec 2017 14:51:52 -0500
Subject: Re: [PATCH] xfs_io: fix exitcode handling (was Re: generic/399 and
 xfs_io pwrite command)
References: <7235f31f-5427-ff12-11f9-cba98431e71c@tuxera.com>
 <20171204222842.GX4094@dastard>
 <35d2712c-b036-d017-2d42-f74bbc4444a9@tuxera.com>
 <20171205211850.GA5858@dastard> <20171206002638.GB5858@dastard>
 <20171207140519.GB3486@bfoster.bfoster>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <9b5928ec-cb2d-52b3-fb4f-cab39c7e0830@sandeen.net>
Date: Sun, 24 Dec 2017 11:51:49 -0800
MIME-Version: 1.0
In-Reply-To: <20171207140519.GB3486@bfoster.bfoster>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>, Dave Chinner <david@fromorbit.com>
Cc: Ari Sundholm <ari@tuxera.com>, fstests@vger.kernel.org, Emil Karlson <jkarlson@tuxera.com>, linux-xfs@vger.kernel.org

On 12/7/17 6:05 AM, Brian Foster wrote:
> On Wed, Dec 06, 2017 at 11:26:38AM +1100, Dave Chinner wrote:

...

>> diff --git a/io/copy_file_range.c b/io/copy_file_range.c
>> index d1dfc5a5e33a..9b737eff4c02 100644
>> --- a/io/copy_file_range.c
>> +++ b/io/copy_file_range.c
>> @@ -92,6 +92,7 @@ copy_range_f(int argc, char **argv)
>>  	int ret;
>>  	int fd;
>>  
>> +	exitcode = 1;
>>  	while ((opt = getopt(argc, argv, "s:d:l:")) != -1) {
>>  		switch (opt) {
>>  		case 's':
>> @@ -132,6 +133,8 @@ copy_range_f(int argc, char **argv)
>>  
>>  	ret = copy_file_range(fd, &src, &dst, len);
>>  	close(fd);
>> +	if (ret >= 0)
>> +		exitcode = 0;
> I don't think it's appropriate to blindly overwrite the global exitcode
> value like this. What about the case where multiple commands are chained
> together? Should we expect an error code if any of the commands failed
> or only the last?
> 
> For example:
> 
>   xfs_io -c "pwrite ..." <file>
> 
> ... returns an error if the write fails, while:
> 
>   xfs_io -c "pwrite ..." -c "fadvise ..." <file>
> 
> ... would never so long as the fadvise succeeds.
> 
> Brian

<late to the party>

Seems we need to start by defining the expected behavior, which so far
has been pretty ad-hoc.

AFAICT this is the expected/desired behavior:

exitcode is the global xfs_io exit code and indicates that any error
has occurred during processing.  It should never get reset to 0.
Using something like do_error to print the failure & set the exitcode
would seem to make sense.

Chained commands continue until some ->cfunc (foo_f()) returns nonzero,
but a nonzero return does /not/ affect exitcode, it simply stops chained
command processing.

It's not clear to me when a cfunc-> /should/ return non-zero and stop
the processing.

-Eric
