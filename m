Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q2ENL7Fv006077 for <xfs@oss.sgi.com>; Wed, 14 Mar 2012 18:21:07 -0500
Received: from sam.nabble.com (sam.nabble.com [216.139.236.26]) by
	cuda.sgi.com with ESMTP id vPJUywia4iSxMDxF (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 14 Mar 2012 16:21:05 -0700 (PDT)
Received: from isper.nabble.com ([192.168.236.156])
	by sam.nabble.com with esmtp (Exim 4.72)
	(envelope-from <lists@nabble.com>) id 1S7xVA-0007Ej-ND
	for xfs@oss.sgi.com; Wed, 14 Mar 2012 16:21:04 -0700
Message-ID: <33506375.post@talk.nabble.com>
Date: Wed, 14 Mar 2012 16:21:04 -0700 (PDT)
From: troby <Thorn.Roby@harlandfs.com>
Subject: Re: How to deal with XFS stripe geometry mismatch with hardware RAID5
In-Reply-To: <20120314210514.GA46448@nsrc.org>
MIME-Version: 1.0
References: <33498437.post@talk.nabble.com>
	<4F605877.2030304@hardwarefreak.com>
	<33504048.post@talk.nabble.com> <20120314210514.GA46448@nsrc.org>
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
To: xfs@oss.sgi.com




Brian Candler wrote:
> 
> On Wed, Mar 14, 2012 at 10:43:44AM -0700, troby wrote:
>> Mongo pre-allocates its datafiles and zero-fills them (there is a short
>> header at the start of each, not rewritten as far as I know)  and then
>> writes to them sequentially, wrapping around when it hits the end. In
>> this
>> case the entire load is inserts, no updates, hence the sequential writes.
>> The data will not wrap around for about 6 months, at which time old files
>> will be overwritten starting from the beginning. The BBU is functioning
>> and
>> the cache is set to write-back. The files are memory-mapped, I'll check
>> whether fsync is used. Flushing is done about every 30 seconds and takes
>> about 8 seconds.
> 
> How much data has been added to mongodb in those 30 seconds?
> 
>    typically 2.5 MB
> 
> If everything really was being written sequentially then I reckon you
> could
> write about 6.6GB in that time (11 disks x 75MB/sec x 8 seconds). From
> your
> posting I suspect you are not achieving that level of performance :-)
> 
> If it really is being written sequentially to a continguous file then the
> stripe alignment won't make any difference, because this is just a big
> pre-allocated file, and XFS will do its best to give one big contiguous
> chunk of space for it.
> 
> Anwyay, you don't need to guess these things, you can easily find out.
> 
> (1) Is the file preallocated and contiguous, or fragmented?
> 
>     # xfs_bmap /path/to/file
> 
> All seem to have a single extent:
> this is a currently active file:
> lfs.303:
>         0: [0..4192255]: 36322376672..36326568927
> 
> this is an old file:
> lfs.3:
>         0: [0..1048575]: 2039336992..2040385567
> 
> 
> 
> This will show you if you get one huge extent. If you get a number of
> large
> extents (say 100MB+) that would be fine for performance too.  If you get
> lots of shrapnel then there's a problem.
> 
> (2) Are you really writing sequentially?
> 
>     # btrace /dev/whatever | grep ' [DC] '
> 
> This will show you block requests dispatched [D] and completed [C] to the
> controller.
> 
> I'm not familiar with the btrace output, but here's the summary of roughly
> 5 minutes:
> 
> Total (8,16):
>  Reads Queued:      16,914,    1,888MiB  Writes Queued:      47,147,   
> 1,438MiB
>  Read Dispatches:   16,914,    1,888MiB  Write Dispatches:   47,050,   
> 1,438MiB
>  Reads Requeued:         0               Writes Requeued:         0
>  Reads Completed:   16,914,    1,888MiB  Writes Completed:   47,050,   
> 1,438MiB
>  Read Merges:            0,        0KiB  Write Merges:           97,     
> 592KiB
>  IO unplugs:        17,060               Timer unplugs:           6
> 
> Throughput (R/W): 5,528KiB/s / 4,209KiB/s
> Events (8,16): 418,873 entries
> Skips: 0 forward (0 -   0.0%)
> 
> 
> And here is some of the detail:
> 
> 8,16   0     2251     7.674877079  5364  C   R 42376096952 + 256 [0]
>   8,16   0     2252     7.675031410  5364  C   R 4046119976 + 256 [0]
>   8,16   0     2259     7.689553858  5364  D   R 4046120232 + 256 [mongod]
>   8,16   0     2260     7.689812456  5364  C   R 4046120232 + 256 [0]
>   8,16   0     2267     7.690973707  5364  D   R 42376097208 + 256
> [mongod]
>   8,16   0     2268     7.691225467  5364  C   R 42376097208 + 256 [0]
>   8,16   0     2275     7.699438100  5364  D   R 21964732520 + 256
> [mongod]
>   8,16   0     2276     7.699688313     0  C   R 21964732520 + 256 [0]
>   8,16   0     2283     7.700493875  5364  D   R 4046120488 + 256 [mongod]
>   8,16   0     2284     7.700749134  5364  C   R 4046120488 + 256 [0]
>   8,16   0     2291     7.703460687  5364  D   R 42376097464 + 256
> [mongod]
>   8,16   0     2292     7.703707154  5364  C   R 42376097464 + 256 [0]
>   8,16   2      928     7.730573720  5364  D   R 21964760296 + 256
> [mongod]
>   8,16   0     2293     7.747651477     0  C   R 21964760296 + 256 [0]
>   8,16   0     2300     7.754517529  5364  D   R 4046120744 + 256 [mongod]
>   8,16   0     2301     7.754781549  5364  C   R 4046120744 + 256 [0]
>   8,16   0     2308     7.760712917  5364  D   R 42376097720 + 256
> [mongod]
>   8,16   0     2309     7.761392841  5364  C   R 42376097720 + 256 [0]
>   8,16   2      935     7.769193162  5597  D   R 4046121000 + 256 [mongod]
>   8,16   0     2310     7.769458041     0  C   R 4046121000 + 256 [0]
>   8,16   2      942     7.773021214  5597  D   R 42376097976 + 256
> [mongod]
>   8,16   0     2311     7.773290126     0  C   R 42376097976 + 256 [0]
>   8,16   2      949     7.780080336  5597  D   R 4046121256 + 256 [mongod]
>   8,16   0     2312     7.780346410     0  C   R 4046121256 + 256 [0]
>   8,16   2      956     7.808903046  5597  D   R 42376098232 + 256
> [mongod]
>   8,16   0     2313     7.809197289     0  C   R 42376098232 + 256 [0]
>   8,16   2      963     7.816907787  5597  D   R 4046121512 + 256 [mongod]
>   8,16   0     2314     7.817182676     0  C   R 4046121512 + 256 [0]
>   8,16   2      970     7.827457411  5597  D   R 42376098488 + 256
> [mongod]
>   8,16   0     2315     7.827730410     0  C   R 42376098488 + 256 [0]
>   8,16   0     2316     7.833225453     0  C   R 4046121768 + 256 [0]
>   8,16   1     2410     7.844128616 37922  D   W 60216121432 + 80
> [flush-8:16]
>   8,16   1     2411     7.844140476 37922  D   W 60216121528 + 256
> [flush-8:16]
>   8,16   1     2412     7.844145438 37922  D   W 60216121784 + 256
> [flush-8:16]
>   8,16   1     2413     7.844149939 37922  D   W 60216122040 + 256
> [flush-8:16]
>   8,16   1     2414     7.844154486 37922  D   W 60216122296 + 256
> [flush-8:16]
>   8,16   1     2415     7.844159104 37922  D   W 60216122552 + 256
> [flush-8:16]
>   8,16   1     2416     7.844163489 37922  D   W 60216122808 + 256
> [flush-8:16]
>   8,16   1     2417     7.844169195 37922  D   W 60216123064 + 256
> [flush-8:16]
>   8,16   1     2418     7.844173666 37922  D   W 60216123320 + 256
> [flush-8:16]
>   8,16   1     2419     7.844178182 37922  D   W 60216123576 + 208
> [flush-8:16]
>   8,16   1     2420     7.844182518 37922  D   W 60216123800 + 256
> [flush-8:16]
>   8,16   1     2421     7.844186886 37922  D   W 60216124056 + 256
> [flush-8:16]
>   8,16   1     2422     7.844191572 37922  D   W 60216124312 + 256
> [flush-8:16]
>   8,16   1     2423     7.844195825 37922  D   W 60216124568 + 256
> [flush-8:16]
>   8,16   1     2424     7.844200405 37922  D   W 60216124824 + 256
> [flush-8:16]
>   8,16   1     2425     7.844205039 37922  D   W 60216125080 + 256
> [flush-8:16]
>   8,16   1     2426     7.844209304 37922  D   W 60216125336 + 256
> [flush-8:16]
>   8,16   1     2427     7.844213483 37922  D   W 60216125592 + 256
> [flush-8:16]
>   8,16   1     2428     7.844217895 37922  D   W 60216125848 + 256
> [flush-8:16]
>   8,16   1     2429     7.844222295 37922  D   W 60216126104 + 256
> [flush-8:16]
>   8,16   1     2430     7.844226651 37922  D   W 60216126360 + 256
> [flush-8:16]
>   8,16   1     2431     7.844230959 37922  D   W 60216126616 + 256
> [flush-8:16]
>   8,16   1     2432     7.844235575 37922  D   W 60216126872 + 256
> [flush-8:16]
>   8,16   1     2433     7.844239866 37922  D   W 60216127128 + 256
> [flush-8:16]
>   8,16   1     2434     7.844244274 37922  D   W 60216127384 + 256
> [flush-8:16]
>   8,16   1     2435     7.844249817 37922  D   W 60216127640 + 256
> [flush-8:16]
>   8,16   1     2436     7.844254266 37922  D   W 60216127896 + 256
> [flush-8:16]
>   8,16   1     2437     7.844258706 37922  D   W 60216128152 + 256
> [flush-8:16]
>   8,16   1     2438     7.844263213 37922  D   W 60216128408 + 256
> [flush-8:16]
>   8,16   1     2439     7.844267570 37922  D   W 60216128664 + 256
> [flush-8:16]
> 
> 
> And at a higher level:
> 
>     # strace -p <pid-of-mongodb-process>
> 
> will show you the seek/write/read operations that the application is
> performing.
> 
> Once you have the answers to those, you can make a better judgement as to
> what's happening.
> 
> (3) One other thing to check:
> 
> cat /sys/block/xxx/bdi/read_ahead_kb
> cat /sys/block/xxx/queue/max_sectors_kb
> 
> Increasing those to 1024 (echo 1024 > ....) may make some improvement.
> 
>     They were 128 - I increased the first, but trying to write the second
> gave me a write error.
> 
>> One thing I'm wondering is whether the incorrect stripe structure I
>> specified with mkfs is actually written into the file system structure
> 
> I am guessing that probably things like chunks of inodes are
> stripe-aligned. 
> But if you're really writing sequentially to a huge contiguous file then
> it
> won't matter anyway.
> 
> Regards,
> 
> Brian.
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs
> 
> 

-- 
View this message in context: http://old.nabble.com/How-to-deal-with-XFS-stripe-geometry-mismatch-with-hardware-RAID5-tp33498437p33506375.html
Sent from the Xfs - General mailing list archive at Nabble.com.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
