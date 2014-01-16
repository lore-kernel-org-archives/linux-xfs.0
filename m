Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 566D37F37
	for <xfs@oss.sgi.com>; Thu, 16 Jan 2014 14:56:00 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 497038F804B
	for <xfs@oss.sgi.com>; Thu, 16 Jan 2014 12:55:57 -0800 (PST)
Received: from firestarter.dermichi.com (firestarter.dermichi.com
	[194.177.153.153]) by cuda.sgi.com with ESMTP id
	eS9q1NIbbOt0F6YR (version=TLSv1 cipher=AES256-SHA bits=256
	verify=NO) for <xfs@oss.sgi.com>;
	Thu, 16 Jan 2014 12:55:55 -0800 (PST)
Received: from 191-159-177-194.static.net4you.net ([194.177.159.191]
	helo=[192.168.17.116]) by firestarter.dermichi.com with esmtpsa
	(TLSv1:DHE-RSA-CAMELLIA256-SHA:256) (Exim 4.82)
	(envelope-from <mw@dermichi.com>) id 1W3tyk-0004pS-1h
	for xfs@oss.sgi.com; Thu, 16 Jan 2014 21:55:54 +0100
Message-ID: <52D84757.9080907@dermichi.com>
Date: Thu, 16 Jan 2014 21:55:51 +0100
From: Michael Weissenbacher <mw@dermichi.com>
MIME-Version: 1.0
Subject: Re: Files with non-ASCII names inaccessible after xfs_repair
References: <20140113192732.GI3469@dastard>	<0E45339E-04C4-4775-B6B0-FC55245B0AED@kotlarek.com>	<20140114022414.GM3469@dastard>	<BE0C947E-37DE-4CA1-B120-59B95E1E8EB8@kotlarek.com>	<20140115015350.GR3469@dastard>	<61E74CEF-8244-4E90-BA7D-91D54DADC3C1@kotlarek.com>	<20140115034803.GT3469@dastard>	<1E5E569C-2E11-42A1-A771-89D4800BC412@kotlarek.com>	<20140115063722.GW3469@dastard>
	<52D6AF1A.8010604@sandeen.net> <20140115210803.GX3469@dastard>
In-Reply-To: <20140115210803.GX3469@dastard>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

Hi!
>
> The utf-8 patches add a "is this valid utf-8" check to all the
> operations that care. We could probably do that for the ASCII-CI
> stuff if you can define what ASCII means....
>
That's easy actually, since ASCII is a 7-bit code it can only contain 
char values between 0-127 or in other words the highest bit must not be 
set in any char. But probably this strict check could break other stuff.

cheers,
Michael

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
