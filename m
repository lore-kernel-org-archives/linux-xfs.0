Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id DD8067F3F
	for <xfs@oss.sgi.com>; Tue, 23 Sep 2014 23:09:01 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id CB94E304032
	for <xfs@oss.sgi.com>; Tue, 23 Sep 2014 21:08:58 -0700 (PDT)
Received: from greer.hardwarefreak.com (mo-65-41-216-221.sta.embarqhsd.net
	[65.41.216.221]) by cuda.sgi.com with ESMTP id h44o89fdek3uFVET
	for <xfs@oss.sgi.com>; Tue, 23 Sep 2014 21:08:57 -0700 (PDT)
Message-ID: <542243E6.1040302@hardwarefreak.com>
Date: Tue, 23 Sep 2014 23:09:10 -0500
From: Stan Hoeppner <stan@hardwarefreak.com>
MIME-Version: 1.0
Subject: Re: How to format RAID1 correctly
References: <5422146A.90206@evermeet.cx>
	<54222763.40107@sandeen.net>	<5422285B.6010306@evermeet.cx>
	<542234F6.4080000@hardwarefreak.com> <5422376D.3000204@evermeet.cx>
In-Reply-To: <5422376D.3000204@evermeet.cx>
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
To: Helmut Tessarek <tessarek@evermeet.cx>, Eric Sandeen <sandeen@sandeen.net>, xfs@oss.sgi.com

On 09/23/2014 10:15 PM, Helmut Tessarek wrote:
> On 23.09.14 23:05 , stan hoeppner wrote:
>> It confuses many people who are new to md RAID1.  The above is the
>> *bitmap* chunk size, not the array chunk size.  There is no array chunk
>> size for RAID1 as there is no striping.  You must have striping to have
>> chunks.  With md RAID1 every 4KB page write is simply mirrored to each
>> physical disk.
> 
> Thanks for the info. I'm used to big ass storage subsystems, but new to SW
> RAID. I seems I have some catching up to do.

If you create any striped arrays, especially parity arrays, with md make
sure to manually specify chunk size and match it to your workload.  The
current default is 512KB.  This is too large for a great many workloads,
specifically those that are metadata heavy or manipulate many small
files.  512KB wastes space and with parity arrays causes RMW, hammering
throughput and increasing latency.

Cheers,
Stan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
