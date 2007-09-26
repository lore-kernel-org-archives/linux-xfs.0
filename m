Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 26 Sep 2007 08:03:49 -0700 (PDT)
Received: from smtp101-mob.biz.mail.re2.yahoo.com (smtp101-mob.biz.mail.re2.yahoo.com [206.190.36.116])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with SMTP id l8QF3aSZ031820
	for <linux-xfs@oss.sgi.com>; Wed, 26 Sep 2007 08:03:38 -0700
Message-ID: <1254510454-1190819012-cardhu_decombobulator_blackberry.rim.net-1744849406-@bxe108.bisx.prod.on.blackberry>
Reply-To: b.j.smith@ieee.org
References: <498689.78850.qm@web32907.mail.mud.yahoo.com><Pine.LNX.4.64.0709251938400.7763@p34.internal.lan><20070926082322.GA30287@p15145560.pureserver.info><Pine.LNX.4.64.0709260442070.31289@p34.internal.lan><20070926084924.GB30287@p15145560.pureserver.info><Pine.LNX.4.64.0709260549250.4769@p34.internal.lan>
In-Reply-To: <Pine.LNX.4.64.0709260549250.4769@p34.internal.lan>
Subject: Re: mkfs options for a 16x hw raid5 and xfs (mostly large files)
From: "=?utf-8?B?QnJ5YW4gSiBTbWl0aA==?=" <b.j.smith@ieee.org>
Date: Wed, 26 Sep 2007 15:03:29 +0000
Content-Type: text/plain
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Justin Piszcz <jpiszcz@lucidpixels.com>, xfs-bounce@oss.sgi.com, Ralf Gross <Ralf-Lists@ralfgross.de>
Cc: linux-xfs@oss.sgi.com, linux-raid@vger.kernel.org

Everyone can play local benchmarking games all they want,
and software RAID will almost always be faster, significantly at times.

What matters is actual, multiple client performance under full load.
Anything less is a completely irrelevant.
--  
Bryan J Smith - mailto:b.j.smith@ieee.org  
http://thebs413.blogspot.com  
Sent via BlackBerry from T-Mobile  
    

-----Original Message-----
From: Justin Piszcz <jpiszcz@lucidpixels.com>

Date: Wed, 26 Sep 2007 05:52:39 
To:Ralf Gross <Ralf-Lists@ralfgross.de>
Cc:linux-xfs@oss.sgi.com, linux-raid@vger.kernel.org
Subject: Re: mkfs options for a 16x hw raid5 and xfs (mostly large files)




On Wed, 26 Sep 2007, Ralf Gross wrote:

> Justin Piszcz schrieb:
>> What was the command line you used for that output?
>> tiobench.. ?
>
> tiobench --numruns 3 --threads 1 --threads 2 --block 4096 --size 20000
>
> --size 20000 because the server has 16 GB RAM.
>
> Ralf
>
>

Here is my output on my SW RAID5 keep in mind it is currently being used so the numbers are a little slower than they probably should be:

My machine only has 8 GiB of memory but I used the same command you did:

This is with the 2.6.22.6 kernel, the 2.6.23-rcX/final when released is supposed to have the SW RAID5 accelerator code, correct?

Unit information
================
File size = megabytes
Blk Size  = bytes
Rate      = megabytes per second
CPU%      = percentage of CPU used during the test
Latency   = milliseconds
Lat%      = percent of requests that took longer than X seconds
CPU Eff   = Rate divided by CPU% - throughput per cpu load

Sequential Reads
                               File  Blk   Num                   Avg      Maximum      Lat%     Lat%    CPU
Identifier                    Size  Size  Thr   Rate  (CPU%)  Latency    Latency      >2s      >10s    Eff
---------------------------- ------ ----- ---  ------ ------ --------- -----------  -------- -------- -----
2.6.22.6                     20000  4096    1  523.01 45.79%     0.022      510.77   0.00000  0.00000  1142
2.6.22.6                     20000  4096    2  501.29 85.84%     0.046      855.59   0.00000  0.00000   584

Random Reads
                               File  Blk   Num                   Avg      Maximum      Lat%     Lat%    CPU
Identifier                    Size  Size  Thr   Rate  (CPU%)  Latency    Latency      >2s      >10s    Eff
---------------------------- ------ ----- ---  ------ ------ --------- -----------  -------- -------- -----
2.6.22.6                     20000  4096    1    0.90 0.276%    13.003       74.41   0.00000  0.00000   326
2.6.22.6                     20000  4096    2    1.61 1.167%    14.443      126.43   0.00000  0.00000   137

Sequential Writes
                               File  Blk   Num                   Avg      Maximum      Lat%     Lat%    CPU
Identifier                    Size  Size  Thr   Rate  (CPU%)  Latency    Latency      >2s      >10s    Eff
---------------------------- ------ ----- ---  ------ ------ --------- -----------  -------- -------- -----
2.6.22.6                     20000  4096    1  363.46 75.72%     0.030     2757.45   0.00000  0.00000   480
2.6.22.6                     20000  4096    2  394.45 287.9%     0.056     2798.92   0.00000  0.00000   137

Random Writes
                               File  Blk   Num                   Avg      Maximum      Lat%     Lat%    CPU
Identifier                    Size  Size  Thr   Rate  (CPU%)  Latency    Latency      >2s      >10s    Eff
---------------------------- ------ ----- ---  ------ ------ --------- -----------  -------- -------- -----
2.6.22.6                     20000  4096    1    3.16 1.752%     0.011        1.02   0.00000  0.00000   180
2.6.22.6                     20000  4096    2    3.07 3.769%     0.013        0.10   0.00000  0.00000    82
