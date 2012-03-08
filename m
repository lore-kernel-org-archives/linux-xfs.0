Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q28MGjfo089371 for <xfs@oss.sgi.com>; Thu, 8 Mar 2012 16:16:45 -0600
Received: from mail.sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com
	with ESMTP id 8A8tcV7IxlodE9Ed for <xfs@oss.sgi.com>;
	Thu, 08 Mar 2012 14:16:44 -0800 (PST)
Message-ID: <4F592FCB.6090006@sandeen.net>
Date: Thu, 08 Mar 2012 16:16:43 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH] xfs_io: deprecate the "-F" foreign flag
References: <4F2AC948.1050909@redhat.com> <4F592728.9060706@sgi.com>
In-Reply-To: <4F592728.9060706@sgi.com>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Mark Tinguely <tinguely@sgi.com>
Cc: Christoph Hellwig <hch@infradead.org>, Eric Sandeen <sandeen@redhat.com>, xfs-oss <xfs@oss.sgi.com>

On 3/8/12 3:39 PM, Mark Tinguely wrote:
> On 02/02/12 11:35, Eric Sandeen wrote:

...

>> @@ -282,10 +274,10 @@ open_f(
>>           return 0;
>>       }
>>
>> -    while ((c = getopt(argc, argv, "FRacdfm:nrstx")) != EOF) {
>> +    while ((c = getopt(argc, argv, "Racdfm:nrstx")) != EOF) {
>>           switch (c) {
>>           case 'F':
>> -            flags |= IO_FOREIGN;
>> +            /* Ignored / deprecated now, handled automatically */
>>               break;
> 
> 
> The "-F" is still in the command line open's help in open.
> 
> cxfs_io> help open
> open [-acdrstx] [path] -- open the file specified by path
> 
>  opens a new file in the requested mode
> 
>  Example:
>  'open -cd /tmp/data' - creates/opens data file read-write for direct IO
> 
>  Opens a file for subsequent use by all of the other xfs_io commands.
>  With no arguments, open uses the stat command to show the current file.
>  -F -- foreign filesystem file, disallow XFS-specific commands
>  -a -- open with the O_APPEND flag (append-only mode)
>  -d -- open with O_DIRECT (non-buffered IO, note alignment constraints)
>  -f -- open with O_CREAT (create the file if it doesn't exist)
>  -m -- permissions to use in case a new file is created (default 0600)
>  -n -- open with O_NONBLOCK
>  -r -- open with O_RDONLY, the default is O_RDWR
>  -s -- open with O_SYNC
>  -t -- open with O_TRUNC (truncate the file to zero length if it exists)
>  -R -- mark the file as a realtime XFS file immediately after opening it
>  Note1: usually read/write direct IO requests must be blocksize aligned;
>         some kernels, however, allow sectorsize alignment for direct IO.
>  Note2: the bmap for non-regular files can be obtained provided the file
>         was opened correctly (in particular, must be opened read-only).
> 
> 
> The "F" was taken out of the command line's getopt(), so it can't be
> specified. I guess either put the "F" back in the the open.c getopt()
> or take it complete from the command line.

Ah crud, sorry.  Patch shortly.

-Eric

> xfs_io> open -F somefile
> open: invalid option -- 'F'
> open [-acdrstx] [path] -- open the file specified by path
> 
> Thanks,
> 
> --Mark Tinguely
> tinguely@sgi.com
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
