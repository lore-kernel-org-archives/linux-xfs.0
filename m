Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 48DF67CA0
	for <xfs@oss.sgi.com>; Wed, 17 Aug 2016 11:24:03 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id E324B3040E0
	for <xfs@oss.sgi.com>; Wed, 17 Aug 2016 09:23:59 -0700 (PDT)
Received: from NAM02-SN1-obe.outbound.protection.outlook.com
	(mail-sn1nam02on0043.outbound.protection.outlook.com
	[104.47.36.43]) by cuda.sgi.com with ESMTP id 4XWwohOaLdS2NAEt
	(version=TLSv1 cipher=ECDHE-RSA-AES256-SHA bits=256 verify=NO)
	for <xfs@oss.sgi.com>; Wed, 17 Aug 2016 09:23:54 -0700 (PDT)
From: Jeff Gibson <jgibson@spscommerce.com>
Subject: Re: XFS on top of LVM span in AWS. Stripe or are AG's good enough?
Date: Wed, 17 Aug 2016 16:23:51 +0000
Message-ID: <CY1PR04MB201082A9ACE83B23FE701409AC140@CY1PR04MB2010.namprd04.prod.outlook.com>
References: <CY1PR04MB20100FE6C3039717BD27825AAC120@CY1PR04MB2010.namprd04.prod.outlook.com>
	<20160816005931.GD19025@dastard>
	<CY1PR04MB20106F50E177A61934986A92AC130@CY1PR04MB2010.namprd04.prod.outlook.com>,
	<6ec8fbba-27ff-7386-e72a-d9f8e81f9252@sandeen.net>
In-Reply-To: <6ec8fbba-27ff-7386-e72a-d9f8e81f9252@sandeen.net>
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
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

Thanks for the great info guys.

Sorry to beat a dead horse here. =A0Just to be absolutely clear-

> > I guess what I'm trying to ask is - will XFS *indirectly* compensate
> > if one subvolume is busier? =A0For example, if writes to a "slow"
> > subvolume and resident AGs take longer to complete, will XFS tend to
> > prefer to use other less-busy AGs more often (with the exception of
> > locality) for writes? =A0What is the basic algorithm for determining
> > where new data is written? =A0In load-balancer terms, does it
> > round-robin, pick the least busy, etc?
>=A0
> xfs has no notion of fast vs slow regions. =A0See above for the basic
> algorithm; it's round-robin for new directories, keep inodes and blocks
> near their parent if possible. =A0
So if one EBS LVM subvolume has subpar performance it will basically slow d=
own writes to the whole XFS volume. =A0XFS doesn't have any notion of a que=
ue per AG or any other mechanism for compensating uneven performance of AGs.


> There are a few other smaller-granularity
> heuristics related to stripe geometry as well.
Oh, cool. =A0Since I'm considering stripe vs. linear for the LVM volume, I'=
d be very interested in what these are.


Thank you again,
JG



_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
