Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 7B9117F3F
	for <xfs@oss.sgi.com>; Wed, 10 Jul 2013 19:37:27 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 5A58030404E
	for <xfs@oss.sgi.com>; Wed, 10 Jul 2013 17:37:24 -0700 (PDT)
Received: from greer.hardwarefreak.com (mo-65-41-216-221.sta.embarqhsd.net
	[65.41.216.221]) by cuda.sgi.com with ESMTP id GIp7QILGKAzeisAB
	for <xfs@oss.sgi.com>; Wed, 10 Jul 2013 17:37:22 -0700 (PDT)
Received: from [192.168.100.53] (gffx.hardwarefreak.com [192.168.100.53])
	by greer.hardwarefreak.com (Postfix) with ESMTP id 7FF216C1B1
	for <xfs@oss.sgi.com>; Wed, 10 Jul 2013 19:37:22 -0500 (CDT)
Message-ID: <51DDFE44.9000606@hardwarefreak.com>
Date: Wed, 10 Jul 2013 19:37:24 -0500
From: Stan Hoeppner <stan@hardwarefreak.com>
MIME-Version: 1.0
Subject: Re: Corruption of root fs during git bisect of drm system hang
References: <20130710090634.GA356@x4>
In-Reply-To: <20130710090634.GA356@x4>
Reply-To: stan@hardwarefreak.com
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

On 7/10/2013 4:06 AM, Markus Trippelsdorf wrote:
> While bisecting a system hang, caused by the drm gpu subsystem, my root fs got
> corrupted:
...
> My root fs lives on a small SSD:
> 
> /dev/root on / type xfs (rw,relatime,attr2,inode64,logbsize=256k,noquota)
> /dev/root      xfs        30G   15G   16G  50% /

Does your SSD honor barriers and cache flushes?

-- 
Stan


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
