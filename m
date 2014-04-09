Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 3D74B7F63
	for <xfs@oss.sgi.com>; Wed,  9 Apr 2014 15:55:12 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id A5FD6AC001
	for <xfs@oss.sgi.com>; Wed,  9 Apr 2014 13:55:11 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id mjkAZOA6HzcsDDKo for <xfs@oss.sgi.com>;
	Wed, 09 Apr 2014 13:55:10 -0700 (PDT)
Message-ID: <5345B3AD.5020805@sandeen.net>
Date: Wed, 09 Apr 2014 15:55:09 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH] xfs_io: fix random pread/pwrite to honor offset
References: <53459C4E.9030902@sandeen.net> <5345B209.5040906@sgi.com>
In-Reply-To: <5345B209.5040906@sgi.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Mark Tinguely <tinguely@sgi.com>
Cc: xfs-oss <xfs@oss.sgi.com>

On 4/9/14, 3:48 PM, Mark Tinguely wrote:
> On 04/09/14 14:15, Eric Sandeen wrote:
>> xfs_io's pread & pwrite claim to support a random IO mode
>> where it will do random IOs between offset & offset+len.
>>
>> However, offset was ignored, and we did the IOs between 0
>> and len instead.
>>
>> Clang caught this by pointing out that the calculated/normalized
>> "offset" variable was never read.
>>
>> (NB: If the range is larger than RAND_MAX, these functions don't
>> work, but that's always been true, so I'll leave it for another
>> day...)
>>
>> Signed-off-by: Eric Sandeen<sandeen@redhat.com>
>> ---
>>
>> I haven't tested this w/ xfstests but I don't see anyone who calls
>> pread/pwrite with "-R" (and it's not documented in the manpage!)
>>
>> diff --git a/io/pread.c b/io/pread.c
>> index a42baed..465c22b 100644
>> --- a/io/pread.c
>> +++ b/io/pread.c
>> @@ -246,7 +246,7 @@ read_random(
> 
> offset can be the end of file offset. Do we care that the read (/write)
> could start or end past the end of file?

It now behaves the same as a normal forward read does if you tell it
to go past EOF:

xfs_io> truncate 1g
xfs_io> pread 1g 1m
read 0/1048576 bytes at offset 1073741824
0.000000 bytes, 0 ops; 0.0000 sec (0.000000 bytes/sec and 0.0000 ops/sec)
xfs_io> pread -R 1g 1m
read 0/1048576 bytes at offset 1073741824
0.000000 bytes, 0 ops; 0.0000 sec (0.000000 bytes/sec and 0.0000 ops/sec)

so I think it's ok?

>>
>>       *total = 0;
>>       while (count > 0) {
>> -        off = ((random() % range) / buffersize) * buffersize;
>> +        off = ((offset + (random() % range)) / buffersize) * buffersize;
>>           bytes = do_pread(fd, off, buffersize, buffersize);
>>           if (bytes == 0)
>>               break;
> 
> Looks like this was introduced in:
> commit 8fb2237e65555ff540e8b6108ffccfffefe239ac
> Author: Nathan Scott <nathans@sgi.com>
> Date:   Fri Nov 11 14:25:18 2005 +0000
> 
> Provide further debugging options and tweaks for analysing the read/write paths.
> Merge of master-melb:xfs-cmds:24372a by kenmcd.
> 
>  ---
> 
> If it was broken for 8.5 years, I think it could be removed.

Eh, could, or we could fix it.  :)  I suppose this means it needs a test... :/

-Eric

> --Mark.
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
