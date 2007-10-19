Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 19 Oct 2007 03:11:46 -0700 (PDT)
Received: from cernmxlb.cern.ch (cernmx08.cern.ch [137.138.166.172])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with ESMTP id l9JABauw015817
	for <xfs@oss.sgi.com>; Fri, 19 Oct 2007 03:11:39 -0700
In-Reply-To: <20071019075949.GS995458@sgi.com>
References: <B4D42128-E5B2-48B1-AEF1-586FD90AF605@cern.ch> <20071018222357.GN995458@sgi.com> <F9DEBD65-7751-4187-97EF-1DF1F63B0888@cern.ch> <20071019075949.GS995458@sgi.com>
Mime-Version: 1.0 (Apple Message framework v752.2)
Message-Id: <F0994AEC-2781-44DB-84B5-B372DB6703E8@cern.ch>
From: Mario Kadastik <mario.kadastik@cern.ch>
Subject: Re: raw vs XFS sequential write and system load
Date: Fri, 19 Oct 2007 12:11:37 +0200
Content-Type: text/plain
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: xfs@oss.sgi.com

> Ah - 2.6.9. That explains the bad behaviour of XFS - it's locking all
> the system memory in the elevator because the depth is so large.
> i.e. throttle at 7/8 * 8192 requests, and each request will be
> 512k which means that we can have ~3.5GB of RAM locked in a single
> elevator queue before it will throttle. Effectively your config
> is running your machine out of available memory....
Ok, that explains a few things ...

>> However here I also
>> found that XFS was performing exactly the same as the direct raw
>> device. Also in the 5-10% region of io wait. Doing 2 parallel writes
>> to the filesystem increased the io wait to 25%. Doing parallel read
>> and write had the system at around 15-20% of io wait, the more
>> concrete numbers for some of the tests I did:
>>
>> 1 w 0 r: 10%
>> 2 w 0 r: 20%
>> 3 w 0 r: 33%
>> 4 w 0 r: 45%
>> 5 w 0 r: 50%
>>
>> 3 w 3 r: 50-60% (system still ca 20% idle)
>> 3 w 10 r: 50-80% (system ca 10% idle, over time system load increased
>> to 14)
>
> Now change thenr_request back to 128 and run the test again. What
> happens to your iowait? What happens to responsiveness?

1 w 0 r: 25-50% and the bo of vmstat is extremely fluctuating
2 w 0 r: 60-90% and fluctuations are big
3 w 0 r: 80-100%
4 w 0 r: 90+ %
5 w 0 r: 95+ %

3 w 3 r: 90% most of the time there is no cpu idle %
3 w 10 r: 95%, nothing idle
8 w 10 r: 95%, nothing idle

however the speeds seem to be quite stable in and out in the read 
+write tests around 50-70MB/s. You can see the system behaviour as I  
ramped up the tests here:

http://monitor.hep.kbfi.ee/?c=Jupiter% 
20SE&h=europa.hep.kbfi.ee&m=&r=hour&s=descending&hc=4

It was running in the end 8 w 10 r and the load kept at about 26 with  
cpus being in io wait. The disk rates aren't visible, but for an  
example here is some vmstat output when the test was running for  
quite some time already:
procs -----------memory---------- ---swap-- -----io---- --system--  
----cpu----
r  b   swpd   free   buff  cache   si   so    bi    bo   in    cs us  
sy id wa
1 26    144 516584    344 3378396    0    0 77760 37764 1859  3353   
0  5  0 95
1 25    144 526844    348 3356420    0    0 77888 69652 2177  4728   
0  7  0 93
0 27    144 438660    348 3450708    0    0 55296 36580 1270  2487   
0  4  0 96
0 26    144 467444    348 3419976    0    0 71616 66988 1870  3856   
0  7  0 93
3 27    144 534780    348 3362948    0    0 59392 45628 1374  3380   
0  5  0 95
0 27    144 545440    344 3349692    0    0 96256 57316 2462  3736   
0  7  0 93
0 26    144 438876    348 3464304    0    0 73664 38608 1798  2038   
0  3  0 97
10 20    144 480852    348 3410584    0    0 61568 53908 1549  3455   
0  5  0 95
0 26    144 530496    348 3356732    0    0 61376 57240 1620  4370   
0  6  0 95
0 23    144 582324    348 3302928    0    0 64000 42036 1433  3808   
0  4  0 96
8 18    144 493092    348 3401184    0    0 49728 55193 1502  2784   
0  4  0 96
0 26    144 513676    444 3375716    0    0 60832 73583 2033  4772   
3  6  0 91
0 26    144 460332    444 3437160    0    0 49024 46160 1434  2225   
0  4  0 96

so around 60MB/s reads and 50MB/s writes were ongoing in the system  
at the time. The main question now is wether this can be kept up  
stably. To test this I'd have to migrate data back to the new XFS  
(3.1TB of data) and wait and see. The system was responsive and if  
the load remains flat out, then I guess it is not such a big problem.  
The 3ware recommended value for 9550SX I think is 512 for the  
nr_request, so I tried that as well (changing live during the test)  
and the result was that io wait remaind around 93% (so dropped a few  
%), but the speed did increase to around 80-90MB/s on reads and  
around 70MB/s on writes. The system load itself remained at the same  
level. I'll let it run in the background for a longer period to see  
how things behave.

>> it was created with mkfs.xfs -d su=64k,sw=11 /dev/sdc to match the
>> underlying RAID5 of 12 disks and stripe size 64k.
>
> Add v2 logs, log stripe unit of 64k.

Did that.

> It *does*. It's the elevator queue depth! By setting it back to 8192
> you turned off the mechanism linux uses to maintain responsiveness
> under heavy I/O load.
Ok, 8192 is probably way too high, but I guess the 512 that was  
something I remember from 3ware should be about right?

>> It's probably a question
>> of tuning the kernel to act correctly, not try to do all at maximum
>> speed, but to do it in a stable way.
>
> By default it should do the right thing. You should not have to
> tweak anything at all. You're tweaking is causing the unstableness
> in the recent kernels. Use the defaults and your system should
> remain responsive under any I/o load you throw at it. High iowait
> time and/or high load average is *not* an indication of a problem,
> just that your system is under load and you're not cpu bound.

Well my question is wether or not one needs to tune also the VM  
management (dirty ratio etc) considering the high amount of data  
transfers. I haven't added network to the mesh yet until I put the  
new optimized system online for use and see how it performs. I guess  
having 8 pdflush -s in uninterruptible sleep can also cause problems  
and could maybe be handled better somehow?

Thanks a lot for the answers,

Mario




[[HTML alternate version deleted]]
