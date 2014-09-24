Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 048007F3F
	for <xfs@oss.sgi.com>; Tue, 23 Sep 2014 21:11:44 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id D2F628F8039
	for <xfs@oss.sgi.com>; Tue, 23 Sep 2014 19:11:43 -0700 (PDT)
Received: from atvie01s.evermeet.cx (evermeet.cx [77.244.245.66]) by
	cuda.sgi.com with ESMTP id MsFaggxQmvLN0OjN (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 23 Sep 2014 19:11:42 -0700 (PDT)
Message-ID: <5422285B.6010306@evermeet.cx>
Date: Tue, 23 Sep 2014 22:11:39 -0400
From: Helmut Tessarek <tessarek@evermeet.cx>
MIME-Version: 1.0
Subject: Re: How to format RAID1 correctly
References: <5422146A.90206@evermeet.cx> <54222763.40107@sandeen.net>
In-Reply-To: <54222763.40107@sandeen.net>
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
To: Eric Sandeen <sandeen@sandeen.net>, xfs@oss.sgi.com

On 23.09.14 22:07 , Eric Sandeen wrote:
> but!  your raid doesn't have a 64k stripe, so that doesn't apply.

Yep, that's true, but see below.

> no geometry because md0 raid1 doesn't export any stripe geometry.

[root@atvie01s ~]# cat /proc/mdstat
Personalities : [raid1]
md0 : active raid1 sdb1[0] sdd1[1]
      3906784064 blocks super 1.2 [2/2] [UU]
      bitmap: 0/30 pages [0KB], 65536KB chunk

So for some reason it shows a 64k chunk size even for RAID1.

That was what got me confused.

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
