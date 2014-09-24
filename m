Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 768397F3F
	for <xfs@oss.sgi.com>; Tue, 23 Sep 2014 21:05:16 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 5BAA9304048
	for <xfs@oss.sgi.com>; Tue, 23 Sep 2014 19:05:13 -0700 (PDT)
Received: from atvie01s.evermeet.cx (evermeet.cx [77.244.245.66]) by
	cuda.sgi.com with ESMTP id gvDLIWajZ4uNoz7T (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 23 Sep 2014 19:05:05 -0700 (PDT)
Received: from [10.0.0.40] (135-23-85-229.cpe.pppoe.ca [135.23.85.229])
	(authenticated bits=0)
	by atvie01s.evermeet.cx (8.14.9/8.14.9) with ESMTP id s8O252Cq008420
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES128-SHA bits=128 verify=NO)
	for <xfs@oss.sgi.com>; Wed, 24 Sep 2014 04:05:04 +0200
Message-ID: <542226CD.6050106@evermeet.cx>
Date: Tue, 23 Sep 2014 22:05:01 -0400
From: Helmut Tessarek <tessarek@evermeet.cx>
MIME-Version: 1.0
Subject: Re: How to format RAID1 correctly
References: <5422146A.90206@evermeet.cx>
In-Reply-To: <5422146A.90206@evermeet.cx>
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
To: xfs@oss.sgi.com

On 23.09.14 20:46 , Helmut Tessarek wrote:
> So what is ultimately the correct way to format a RAID1?

According to sandeen in #xfs the correct way is:

mkfs.xfs /dev/md0

Makes sense, since no striping is involved.

Just wanted to clarify and I did.

Cheers,
 K. C.

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
