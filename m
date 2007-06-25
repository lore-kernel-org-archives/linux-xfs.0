Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 25 Jun 2007 06:09:02 -0700 (PDT)
Received: from lucidpixels.com (lucidpixels.com [75.144.35.66])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l5PD8wdo027823
	for <xfs@oss.sgi.com>; Mon, 25 Jun 2007 06:09:00 -0700
Date: Mon, 25 Jun 2007 09:08:59 -0400 (EDT)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: 128k proved to be optimal for max_sectors_kb
Message-ID: <Pine.LNX.4.64.0706250906370.15590@p34.internal.lan>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: xfs@oss.sgi.com

Dave,

You stated earlier why I used 128k for max_sectors_kb?  It seems to offer 
the best performance overall (in terms of overall-bonnie runtime as well)

p34-4096,15696M,77157,98.6667,443058,87.6667,176913,32,79369.7,99,472359,34,594.1,0,16:100000:16/64,1131.67,9.66667,4966,14,3184,19.3333,1222.67,11,4871.33,14.3333,2470,17.3333
p34-1024,15696M,77509.7,99,427413,85.3333,165722,30.3333,80305,99,443508,32,624.533,0.333333,16:100000:16/64,1103,9.33333,4853.67,13.3333,3180,19,1239,11,4301.33,13,2627,19
p34-512,15696M,76935.3,99,448343,87.6667,175319,32,78003,99,465689,33.6667,606.367,0.333333,16:100000:16/64,1148.33,9.33333,3240.33,9.33333,3014.33,18,1203.67,10.6667,5193.33,14.6667,2521.33,16.6667
p34-128,15696M,76202.3,99,443103,85,189716,34.6667,79552,99,507271,39.6667,607.067,0,16:100000:16/64,1153,10,13434,36,2769.67,16.3333,1201.67,10.6667,3951.33,12,2665.67,19

max_sectors_kb = 4
$ dd if=/dev/zero of=file.out1 bs=1M count=10240
10240+0 records in
10240+0 records out
10737418240 bytes (11 GB) copied, 124.779 seconds, 86.1 MB/s

max_sectors_kb = 8
$ dd if=/dev/zero of=file.out2 bs=1M count=10240
10240+0 records in
10240+0 records out
10737418240 bytes (11 GB) copied, 55.4848 seconds, 194 MB/s

max_sectors_kb = 16
$ dd if=/dev/zero of=file.out3 bs=1M count=10240
10240+0 records in
10240+0 records out
10737418240 bytes (11 GB) copied, 37.6886 seconds, 285 MB/s

max_sectors_kb = 32
$ dd if=/dev/zero of=file.out4 bs=1M count=10240
10240+0 records in
10240+0 records out
10737418240 bytes (11 GB) copied, 26.2875 seconds, 408 MB/s

max_sectors_kb = 64
$ dd if=/dev/zero of=file.out5 bs=1M count=10240
10240+0 records in
10240+0 records out
10737418240 bytes (11 GB) copied, 24.8301 seconds, 432 MB/s

max_sectors_kb = 128
$ dd if=/dev/zero of=file.out6 bs=1M count=10240
10240+0 records in
10240+0 records out
10737418240 bytes (11 GB) copied, 22.6298 seconds, 474 MB/s
10737418240 bytes (11 GB) copied, 22.6298 seconds, 460 MB/s [again]
10737418240 bytes (11 GB) copied, 22.9520 seconds, 468 MB/s [again]

max_sectors_kb = 256
$ dd if=/dev/zero of=file.out7 bs=1M count=10240
10240+0 records in
10240+0 records out
10737418240 bytes (11 GB) copied, 22.5042 seconds, 477 MB/s
10737418240 bytes (11 GB) copied, 23.3488 seconds, 460 MB/s [again]
10737418240 bytes (11 GB) copied, 23.3488 seconds, 431 MB/s [again]
10737418240 bytes (11 GB) copied, 23.3488 seconds, 434 MB/s [again]

max_sectors_kb = 512
$ dd if=/dev/zero of=file.out8 bs=1M count=10240
10240+0 records in
10240+0 records out
10737418240 bytes (11 GB) copied, 23.6269 seconds, 454 MB/s

max_sectors_kb = 1024
$ dd if=/dev/zero of=file.out9 bs=1M count=10240
10737418240 bytes (11 GB) copied, 22.3177 seconds, 481 MB/s
10737418240 bytes (11 GB) copied, 22.8935 seconds, 469 MB/s [again]
10737418240 bytes (11 GB) copied, 23.4506 seconds, 458 MB/s [again]
10737418240 bytes (11 GB) copied, 23.5932 seconds, 455 MB/s [again]

Justin.
