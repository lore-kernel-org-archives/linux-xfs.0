Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 021D57F3F
	for <xfs@oss.sgi.com>; Wed, 24 Sep 2014 10:54:11 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id C223E8F8035
	for <xfs@oss.sgi.com>; Wed, 24 Sep 2014 08:54:07 -0700 (PDT)
Received: from atvie01s.evermeet.cx (evermeet.cx [77.244.245.66]) by
	cuda.sgi.com with ESMTP id FMs6nCbGC64UDayt (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 24 Sep 2014 08:54:00 -0700 (PDT)
Message-ID: <5422E912.1000708@evermeet.cx>
Date: Wed, 24 Sep 2014 11:53:54 -0400
From: Helmut Tessarek <tessarek@evermeet.cx>
MIME-Version: 1.0
Subject: Re: How to format RAID1 correctly
References: <5422146A.90206@evermeet.cx>
	<54222763.40107@sandeen.net>	<5422285B.6010306@evermeet.cx>
	<542234F6.4080000@hardwarefreak.com> <5422376D.3000204@evermeet.cx>
	<542243E6.1040302@hardwarefreak.com>
In-Reply-To: <542243E6.1040302@hardwarefreak.com>
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
To: Stan Hoeppner <stan@hardwarefreak.com>, Eric Sandeen <sandeen@sandeen.net>, xfs@oss.sgi.com

On 2014-09-24 0:09, Stan Hoeppner wrote:
> If you create any striped arrays, especially parity arrays, with md make
> sure to manually specify chunk size and match it to your workload.  The
> current default is 512KB.  This is too large for a great many workloads,
> specifically those that are metadata heavy or manipulate many small
> files.  512KB wastes space and with parity arrays causes RMW, hammering
> throughput and increasing latency.

Thanks again for the valueable information.

I used to work with databases on storage subsystems, so placing GBs of
database containers for tableapaces on arrays with a larger stripe size
was actually beneficial.
For log files and other data I usually used different cache settings and
strip sizes.

So how does this work with SW RAID?

Does the XFS chunk size equal the amount of data touched by a single r/w
operation?
I'm asking because data is usually written in page/extent sizes for
databases. Even if I have a container with 50GB, I might only have to
read/write a 4k page.

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
