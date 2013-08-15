Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 2731E7F55
	for <xfs@oss.sgi.com>; Thu, 15 Aug 2013 12:06:09 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 07D0E8F8084
	for <xfs@oss.sgi.com>; Thu, 15 Aug 2013 10:06:05 -0700 (PDT)
Received: from mx1.vr-web.de (mx0.vr-web.de [195.200.35.198]) by cuda.sgi.com
	with ESMTP id 5IG8uHm7Dx2Oxtjr for <xfs@oss.sgi.com>;
	Thu, 15 Aug 2013 10:06:04 -0700 (PDT)
Message-ID: <520D0A65.9060505@allmail.net>
Date: Thu, 15 Aug 2013 19:05:41 +0200
From: Michael Maier <m1278468@allmail.net>
MIME-Version: 1.0
Subject: Re: Failure growing xfs with linux 3.10.5
References: <52073905.8010608@allmail.net> <5207D9C4.7020102@sandeen.net>
	<52090C6C.6060604@allmail.net> <20130813000453.GQ12779@dastard>
	<520A5132.6090608@allmail.net> <520B1B4F.9070800@hardwarefreak.com>
	<520B9CCF.1040908@allmail.net> <520BBEFB.9030002@hardwarefreak.com>
	<520BC8B1.9060106@allmail.net> <520C02BE.6060506@hardwarefreak.com>
In-Reply-To: <520C02BE.6060506@hardwarefreak.com>
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
To: stan@hardwarefreak.com
Cc: Eric Sandeen <sandeen@sandeen.net>, xfs@oss.sgi.com

Stan Hoeppner wrote:
> On 8/14/2013 1:13 PM, Michael Maier wrote:
>> Stan Hoeppner wrote:
>>> If you keep growing until you consume the disk, you'll have ~100
>>> allocation groups.  Typically you'd want to have no more than 4 AGs per
>>> spindle.  You already have 42 (or 45) which will tend to seek the disk
>>> to death with many workloads, driving latency through the roof and
>>> decreasing throughput substantially.  Do you notice any performance
>>> problems yet?
>>
>> What are expected rates for copying e.g. a 10GB file? It's a Seagate
>> Barracuda 3000GB Model ST3000DM001 SATA connected to SATA 6 Gb/s chip.
>> The source and the destination FS is LUKS crypted. About 3 GB usable RAM
>> (cache), AMD FX-8350 processor @ max. 3800MHz.
> 
> Too many variables really to hazard a guess.  If you put a gun to my
> head, I'd say strictly looking at the ingest rate of the Seagate, at a
> little less than half capacity, writing about 1/3rd of the way down the
> platters, optimum throughput should be 80-100 MB/s or so in the last 3
> AGs, if free space isn't too heavily fragmented.

96MB/s / 40GB-file ~ 130GB free space. -> good guess!

[...]

> With so many smallish AGs, so many grow ops, and this backup workload,
> I'm curious as to what your free space map looks like.  Would you mind
> posting the output of the following command, if you can?
> 
> $ xfs_db -r -c freesp <dev>

after copying:
   from      to extents  blocks    pct
      1       1     193     193   0.00
      2       3      31      72   0.00
      4       7      10      60   0.00
      8      15       8      94   0.00
     16      31       9     210   0.00
     32      63      14     631   0.00
     64     127      20    1974   0.01
    128     255      16    2838   0.01
    256     511      12    4923   0.02
    512    1023      13   10065   0.04
   1024    2047      14   23417   0.10
   2048    4095      22   58439   0.25
   4096    8191       8   44159   0.19
   8192   16383       1    8192   0.04
  16384   32767       7  165001   0.71
  32768   65535       6  228278   0.99
 262144  524287       1  398328   1.72
1048576 2097151       2 3560198  15.39
2097152 4194303       1 3709535  16.04
4194304 7700480       2 14909432  64.47


Regards,
Michael.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
