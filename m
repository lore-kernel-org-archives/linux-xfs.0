Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 3B0237F3F
	for <xfs@oss.sgi.com>; Tue, 23 Sep 2014 22:16:11 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id BF180AC004
	for <xfs@oss.sgi.com>; Tue, 23 Sep 2014 20:16:07 -0700 (PDT)
Received: from atvie01s.evermeet.cx (evermeet.cx [77.244.245.66]) by
	cuda.sgi.com with ESMTP id h4MDOaj9xWUuApug (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 23 Sep 2014 20:16:05 -0700 (PDT)
Message-ID: <5422376D.3000204@evermeet.cx>
Date: Tue, 23 Sep 2014 23:15:57 -0400
From: Helmut Tessarek <tessarek@evermeet.cx>
MIME-Version: 1.0
Subject: Re: How to format RAID1 correctly
References: <5422146A.90206@evermeet.cx> <54222763.40107@sandeen.net>
	<5422285B.6010306@evermeet.cx> <542234F6.4080000@hardwarefreak.com>
In-Reply-To: <542234F6.4080000@hardwarefreak.com>
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
To: stan hoeppner <stan@hardwarefreak.com>, Eric Sandeen <sandeen@sandeen.net>, xfs@oss.sgi.com

On 23.09.14 23:05 , stan hoeppner wrote:
> It confuses many people who are new to md RAID1.  The above is the
> *bitmap* chunk size, not the array chunk size.  There is no array chunk
> size for RAID1 as there is no striping.  You must have striping to have
> chunks.  With md RAID1 every 4KB page write is simply mirrored to each
> physical disk.

Thanks for the info. I'm used to big ass storage subsystems, but new to SW
RAID. I seems I have some catching up to do.

-- 
regards Helmut K. C. Tessarek
lookup http://sks.pkqs.net for KeyID 0xC11F128D

/*
   Thou shalt not follow the NULL pointer for chaos and madness
   await thee at its end.
*/

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
