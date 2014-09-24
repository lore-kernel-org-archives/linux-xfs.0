Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id F149E7F3F
	for <xfs@oss.sgi.com>; Tue, 23 Sep 2014 22:05:18 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id D058D8F8054
	for <xfs@oss.sgi.com>; Tue, 23 Sep 2014 20:05:18 -0700 (PDT)
Received: from greer.hardwarefreak.com (mo-65-41-216-221.sta.embarqhsd.net
	[65.41.216.221]) by cuda.sgi.com with ESMTP id sZ3ZSKP8yf7oIjlG
	for <xfs@oss.sgi.com>; Tue, 23 Sep 2014 20:05:14 -0700 (PDT)
Message-ID: <542234F6.4080000@hardwarefreak.com>
Date: Tue, 23 Sep 2014 22:05:26 -0500
From: stan hoeppner <stan@hardwarefreak.com>
MIME-Version: 1.0
Subject: Re: How to format RAID1 correctly
References: <5422146A.90206@evermeet.cx> <54222763.40107@sandeen.net>
	<5422285B.6010306@evermeet.cx>
In-Reply-To: <5422285B.6010306@evermeet.cx>
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

On 09/23/2014 09:11 PM, Helmut Tessarek wrote:
> On 23.09.14 22:07 , Eric Sandeen wrote:
>> but!  your raid doesn't have a 64k stripe, so that doesn't apply.
> 
> Yep, that's true, but see below.
> 
>> no geometry because md0 raid1 doesn't export any stripe geometry.
> 
> [root@atvie01s ~]# cat /proc/mdstat
> Personalities : [raid1]
> md0 : active raid1 sdb1[0] sdd1[1]
>       3906784064 blocks super 1.2 [2/2] [UU]
>       bitmap: 0/30 pages [0KB], 65536KB chunk
> 
> So for some reason it shows a 64k chunk size even for RAID1.
> 
> That was what got me confused.


It confuses many people who are new to md RAID1.  The above is the
*bitmap* chunk size, not the array chunk size.  There is no array chunk
size for RAID1 as there is no striping.  You must have striping to have
chunks.  With md RAID1 every 4KB page write is simply mirrored to each
physical disk.

Cheers,
Stan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
