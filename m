Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 564B67F4E
	for <xfs@oss.sgi.com>; Mon,  8 Sep 2014 04:47:19 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 366668F8040
	for <xfs@oss.sgi.com>; Mon,  8 Sep 2014 02:47:16 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	epdsR31eE5pxGU4g for <xfs@oss.sgi.com>;
	Mon, 08 Sep 2014 02:47:14 -0700 (PDT)
Date: Mon, 8 Sep 2014 19:46:59 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Is XFS suitable for 350 million files on 20TB storage?
Message-ID: <20140908094659.GC30012@dastard>
References: <540986B1.4080306@profihost.ag>
	<20140905123058.GA29710@bfoster.bfoster>
	<5409AF40.10801@profihost.ag> <20140905230528.GO20473@dastard>
	<540AB933.4030707@profihost.ag>
	<20140906150412.GB23506@bfoster.bfoster>
	<20140906225654.GB9955@dastard> <540D6A6C.9090801@profihost.ag>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <540D6A6C.9090801@profihost.ag>
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
To: Stefan Priebe - Profihost AG <s.priebe@profihost.ag>
Cc: Brian Foster <bfoster@redhat.com>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On Mon, Sep 08, 2014 at 10:35:56AM +0200, Stefan Priebe - Profihost AG wrote:
> Thanks,
> 
> upgraded to 3.16.2 and xfsprogs 3.2.1. Let's see how it behaves with finobt.

You need to mkfs the filesystem to use finobt - it's not something
that an upgrade will just switch on. i.e.

# mkfs.xfs -m crc=1,finobt=1 <dev>

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
