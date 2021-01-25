Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6E506C433E0
	for <linux-xfs@archiver.kernel.org>; Mon, 25 Jan 2021 17:35:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 325D422B3F
	for <linux-xfs@archiver.kernel.org>; Mon, 25 Jan 2021 17:35:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729929AbhAYRdy (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 25 Jan 2021 12:33:54 -0500
Received: from 50-247-197-57-static.hfc.comcastbusiness.net ([50.247.197.57]:54812
        "EHLO microway.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1731067AbhAYRd0 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 25 Jan 2021 12:33:26 -0500
X-Greylist: delayed 474 seconds by postgrey-1.27 at vger.kernel.org; Mon, 25 Jan 2021 12:33:25 EST
Received: from [10.200.122.6] (unknown [10.200.122.6])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits))
        (No client certificate requested)
        by microway.com (Postfix) with ESMTPSA id 69E7F104C2
        for <linux-xfs@vger.kernel.org>; Mon, 25 Jan 2021 12:24:44 -0500 (EST)
DKIM-Filter: OpenDKIM Filter v2.11.0 microway.com 69E7F104C2
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microway.com;
        s=byedon; t=1611595484;
        bh=f1lveDBbPyxfy4mnMVaonoiXS1qHRAGvywrf6acATcw=;
        h=To:From:Subject:Date:From;
        b=FvCGKAKfFmv6dtu6rffdgubvNw6kvhpnCdu3N3pFUjeYZzs6xhp+iDs05io2xSuTa
         FzGygOdSNgRhBCwO5SgFhVKN0t9Ehk5p9A1vIcVJ5yUUTLB+cp5NjMkUEzxHDDlRjp
         Nvuzz795EH6JGVCzqFBePwd/Rux/nlGza2NnT1BCAA8lxO94K61Q2wcYymc7aazD8a
         dy13RgMGMPaju7k5w+AhHT5jgSJ04FVld5mu5TWbhPDRluqr11e6Xkg6cmoaFjpcQe
         IcplIudB2Jr1Hu1PF/ah+i9FtjbtfSVWLPRpjmFmHyWRkcaicxpD+AvVfucd43VvjZ
         CxdXQz4KYo3TA==
To:     linux-xfs@vger.kernel.org
From:   Rick Warner <rick@microway.com>
Subject: Huge reduction in write bandwidth with filesystem vs direct block
 device
Message-ID: <fdc3fca3-f6e9-d484-b0c5-9e7c8b71dfc4@microway.com>
Date:   Mon, 25 Jan 2021 12:23:57 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

We're working with NVME storage systems and are seeing a significant 
reduction in write speed with an XFS filesystem vs direct access to the 
block device.

Using a 5 disk software RAID5, we're able to get ~16GB/s write speed 
direct to the device.  If we put an XFS filesystem on the software RAID 
and run the same fio command (except --directory /xfs instead of 
--filename /dev/md11) we only get ~2.5GB/s write speed.

Are there any tunables that could improve this? Is performance 
degradation this big considered a bug?

The fio runs showing this are below:

*******Direct to /dev/md11 block device
[root@flashstore ~]# fio --filename=/dev/md11 --rw=write --numjobs=32 
--size=12G --bs=1M --name=1m --group_reporting
1m: (g=0): rw=write, bs=(R) 1024KiB-1024KiB, (W) 1024KiB-1024KiB, (T) 
1024KiB-1024KiB, ioengine=psync, iodepth=1
...
fio-3.7
Starting 32 processes
Jobs: 26 (f=26): 
[f(1),_(1),f(16),_(1),f(3),_(2),f(3),_(1),f(2),_(1),f(1)][100.0%][r=0KiB/s,w=0KiB/s][r=0,w=0 
IOPS][eta 00m:00s]
1m: (groupid=0, jobs=32): err= 0: pid=74592: Mon Jan 25 12:13:28 2021
   write: IOPS=15.4k, BW=15.0GiB/s (16.1GB/s)(384GiB/25551msec)
     clat (usec): min=230, max=31691, avg=2044.43, stdev=778.36
      lat (usec): min=245, max=31710, avg=2067.97, stdev=783.21
     clat percentiles (usec):
      |  1.00th=[  420],  5.00th=[ 1745], 10.00th=[ 1811], 20.00th=[ 1860],
      | 30.00th=[ 1893], 40.00th=[ 1926], 50.00th=[ 1942], 60.00th=[ 1975],
      | 70.00th=[ 2024], 80.00th=[ 2089], 90.00th=[ 2180], 95.00th=[ 2900],
      | 99.00th=[ 4490], 99.50th=[ 4883], 99.90th=[13829], 99.95th=[14746],
      | 99.99th=[20841]
    bw (  KiB/s): min=400606, max=679936, per=3.13%, avg=492489.85, 
stdev=53436.36, samples=1632
    iops        : min=  391, max=  664, avg=480.90, stdev=52.18, 
samples=1632
   lat (usec)   : 250=0.01%, 500=1.72%, 750=0.80%, 1000=0.09%
   lat (msec)   : 2=62.47%, 4=32.77%, 10=1.94%, 20=0.20%, 50=0.01%
   cpu          : usr=1.37%, sys=62.91%, ctx=38028757, majf=0, minf=60496
   IO depths    : 1=100.0%, 2=0.0%, 4=0.0%, 8=0.0%, 16=0.0%, 32=0.0%, 
 >=64=0.0%
      submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, 
 >=64=0.0%
      complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, 
 >=64=0.0%
      issued rwts: total=0,393216,0,0 short=0,0,0,0 dropped=0,0,0,0
      latency   : target=0, window=0, percentile=100.00%, depth=1

Run status group 0 (all jobs):
   WRITE: bw=15.0GiB/s (16.1GB/s), 15.0GiB/s-15.0GiB/s 
(16.1GB/s-16.1GB/s), io=384GiB (412GB), run=25551-25551msec

Disk stats (read/write):
     md11: ios=98/2237881, merge=0/0, ticks=0/0, in_queue=0, util=0.00%, 
aggrios=10252/73455, aggrmerge=20863/582117, aggrticks=4425/138224, 
aggrin_queue=130116, aggrutil=17.71%
   nvme2n1: ios=12427/88141, merge=25370/698549, ticks=5030/163534, 
in_queue=153382, util=16.71%
   nvme3n1: ios=12210/88148, merge=24728/698544, ticks=4979/162745, 
in_queue=152592, util=16.84%
   nvme4n1: ios=12246/88150, merge=24861/698524, ticks=4875/165703, 
in_queue=156034, util=16.81%
   nvme5n1: ios=12289/88146, merge=25200/698533, ticks=5013/164900, 
in_queue=154398, util=16.96%
   nvme6n1: ios=12343/88149, merge=25021/698553, ticks=6655/172464, 
in_queue=164291, util=17.71%
   nvme22n1: ios=0/0, merge=0/0, ticks=0/0, in_queue=0, util=0.00%

******* mkfs.xfs on /dev/md11 (w/ no flags) and fio run on that mount
[root@flashstore ~]# fio --directory=/xfs --rw=write --numjobs=32 
--size=12G --bs=1M --name=1m --group_reporting
1m: (g=0): rw=write, bs=(R) 1024KiB-1024KiB, (W) 1024KiB-1024KiB, (T) 
1024KiB-1024KiB, ioengine=psync, iodepth=1
...
fio-3.7
Starting 32 processes
1m: Laying out IO file (1 file / 12288MiB)
1m: Laying out IO file (1 file / 12288MiB)
1m: Laying out IO file (1 file / 12288MiB)
1m: Laying out IO file (1 file / 12288MiB)
1m: Laying out IO file (1 file / 12288MiB)
1m: Laying out IO file (1 file / 12288MiB)
1m: Laying out IO file (1 file / 12288MiB)
1m: Laying out IO file (1 file / 12288MiB)
1m: Laying out IO file (1 file / 12288MiB)
1m: Laying out IO file (1 file / 12288MiB)
1m: Laying out IO file (1 file / 12288MiB)
1m: Laying out IO file (1 file / 12288MiB)
1m: Laying out IO file (1 file / 12288MiB)
1m: Laying out IO file (1 file / 12288MiB)
1m: Laying out IO file (1 file / 12288MiB)
1m: Laying out IO file (1 file / 12288MiB)
1m: Laying out IO file (1 file / 12288MiB)
1m: Laying out IO file (1 file / 12288MiB)
1m: Laying out IO file (1 file / 12288MiB)
1m: Laying out IO file (1 file / 12288MiB)
1m: Laying out IO file (1 file / 12288MiB)
1m: Laying out IO file (1 file / 12288MiB)
1m: Laying out IO file (1 file / 12288MiB)
1m: Laying out IO file (1 file / 12288MiB)
1m: Laying out IO file (1 file / 12288MiB)
1m: Laying out IO file (1 file / 12288MiB)
1m: Laying out IO file (1 file / 12288MiB)
1m: Laying out IO file (1 file / 12288MiB)
1m: Laying out IO file (1 file / 12288MiB)
1m: Laying out IO file (1 file / 12288MiB)
1m: Laying out IO file (1 file / 12288MiB)
1m: Laying out IO file (1 file / 12288MiB)
Jobs: 11 (f=11): 
[_(6),W(1),_(4),W(1),_(8),W(1),_(3),W(8)][99.4%][r=0KiB/s,w=1213MiB/s][r=0,w=1213 
IOPS][eta 00m:01s]
1m: (groupid=0, jobs=32): err= 0: pid=74782: Mon Jan 25 12:20:32 2021
   write: IOPS=2431, BW=2432MiB/s (2550MB/s)(384GiB/161704msec)
     clat (usec): min=251, max=117777, avg=13006.54, stdev=23856.18
      lat (usec): min=270, max=117787, avg=13027.39, stdev=23851.96
     clat percentiles (usec):
      |  1.00th=[  359],  5.00th=[  371], 10.00th=[  383], 20.00th=[ 408],
      | 30.00th=[  424], 40.00th=[  453], 50.00th=[  537], 60.00th=[ 578],
      | 70.00th=[  619], 80.00th=[55313], 90.00th=[58459], 95.00th=[60556],
      | 99.00th=[63177], 99.50th=[64226], 99.90th=[66323], 99.95th=[68682],
      | 99.99th=[80217]
    bw (  KiB/s): min=55296, max=1054720, per=3.15%, avg=78557.24, 
stdev=41896.99, samples=10233
    iops        : min=   54, max= 1030, avg=76.67, stdev=40.92, 
samples=10233
   lat (usec)   : 500=46.14%, 750=31.31%, 1000=0.78%
   lat (msec)   : 2=0.03%, 4=0.01%, 10=0.01%, 20=0.01%, 50=0.59%
   lat (msec)   : 100=21.13%, 250=0.01%
   cpu          : usr=0.12%, sys=3.83%, ctx=86515, majf=0, minf=22227
   IO depths    : 1=100.0%, 2=0.0%, 4=0.0%, 8=0.0%, 16=0.0%, 32=0.0%, 
 >=64=0.0%
      submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, 
 >=64=0.0%
      complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, 
 >=64=0.0%
      issued rwts: total=0,393216,0,0 short=0,0,0,0 dropped=0,0,0,0
      latency   : target=0, window=0, percentile=100.00%, depth=1

Run status group 0 (all jobs):
   WRITE: bw=2432MiB/s (2550MB/s), 2432MiB/s-2432MiB/s 
(2550MB/s-2550MB/s), io=384GiB (412GB), run=161704-161704msec

Disk stats (read/write):
     md11: ios=1/6097731, merge=0/0, ticks=0/0, in_queue=0, util=0.00%, 
aggrios=23774/2849499, aggrmerge=34232/17493878, 
aggrticks=28040/18125298, aggrin_queue=18363574, aggrutil=80.03%
   nvme2n1: ios=28860/3419298, merge=41127/20992122, 
ticks=39496/23053174, in_queue=23421586, util=75.76%
   nvme3n1: ios=28440/3419396, merge=41081/20992524, 
ticks=34881/23067448, in_queue=23411872, util=80.03%
   nvme4n1: ios=28457/3419413, merge=41361/20992713, 
ticks=30990/21139316, in_queue=21420720, util=78.03%
   nvme5n1: ios=28131/3419446, merge=40331/20992920, 
ticks=29288/20184431, in_queue=20418749, util=77.00%
   nvme6n1: ios=28759/3419446, merge=41496/20992991, 
ticks=33587/21307424, in_queue=21508518, util=77.04%
   nvme22n1: ios=0/0, merge=0/0, ticks=0/0, in_queue=0, util=0.00%


Thanks,
Rick
