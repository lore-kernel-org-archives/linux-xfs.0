Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id B048E7F37
	for <xfs@oss.sgi.com>; Thu, 16 Jan 2014 15:11:19 -0600 (CST)
From: Shaun Gosse <sgosse@sgi.com>
Subject: RE: Files with non-ASCII names inaccessible after xfs_repair
Date: Thu, 16 Jan 2014 21:11:15 +0000
Message-ID: <8D3FA7645C1CFC4E9E783D22B4C708644AB368@P-EXMB2-DC21.corp.sgi.com>
References: <20140113192732.GI3469@dastard>
	<0E45339E-04C4-4775-B6B0-FC55245B0AED@kotlarek.com>
	<20140114022414.GM3469@dastard>
	<BE0C947E-37DE-4CA1-B120-59B95E1E8EB8@kotlarek.com>
	<20140115015350.GR3469@dastard>
	<61E74CEF-8244-4E90-BA7D-91D54DADC3C1@kotlarek.com>
	<20140115034803.GT3469@dastard>
	<1E5E569C-2E11-42A1-A771-89D4800BC412@kotlarek.com>
	<20140115063722.GW3469@dastard>	<52D6AF1A.8010604@sandeen.net>
	<20140115210803.GX3469@dastard> <52D84757.9080907@dermichi.com>
In-Reply-To: <52D84757.9080907@dermichi.com>
Content-Language: en-US
MIME-Version: 1.0
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
To: Michael Weissenbacher <mw@dermichi.com>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>

> That's easy actually, since ASCII is a 7-bit code it can only contain char values between 0-127 or in other words the highest bit must not be set in any char. But probably this strict check could break other stuff.

As long as you exclude extended ascii and data corruption, I don't know what else that could break. My guess would be that ASCII as understood by XFS users would be the 0-127 and not the various mix of extensions. If you want to include support for extended ascii...then I don't think there's any way to determine non-probabilistically the difference between ASCII and UTF based on the data itself.

I have no idea what the current behavior is with respect to extended ASCII (whether it's supported, or works, or anything).

Cheers,
-Shaun

-----Original Message-----
From: xfs-bounces@oss.sgi.com [mailto:xfs-bounces@oss.sgi.com] On Behalf Of Michael Weissenbacher
Sent: Thursday, January 16, 2014 2:56 PM
To: xfs@oss.sgi.com
Subject: Re: Files with non-ASCII names inaccessible after xfs_repair

Hi!
>
> The utf-8 patches add a "is this valid utf-8" check to all the 
> operations that care. We could probably do that for the ASCII-CI stuff 
> if you can define what ASCII means....
>
That's easy actually, since ASCII is a 7-bit code it can only contain char values between 0-127 or in other words the highest bit must not be set in any char. But probably this strict check could break other stuff.

cheers,
Michael

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
