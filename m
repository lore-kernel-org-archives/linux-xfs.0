Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 658D87CA0
	for <xfs@oss.sgi.com>; Thu, 30 Jun 2016 01:04:18 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 261D4304032
	for <xfs@oss.sgi.com>; Wed, 29 Jun 2016 23:04:15 -0700 (PDT)
Received: from hotel311.server4you.de (hotel311.server4you.de [85.25.146.15])
	by cuda.sgi.com with ESMTP id TTufZYY2pKALjPgg (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 29 Jun 2016 23:04:12 -0700 (PDT)
Subject: Re: crash in xfs in current
References: <48817b4c-26f4-5eb6-8a97-d8fa34fe7f6a@monom.org>
	<20160607134442.GA1803@infradead.org>
	<CAAA5faFWyPDienm2NbHkafZh-RvbjJp6f_zDq62z6rC1d1Vzyw@mail.gmail.com>
	<CAAA5faGXHJZPWkkxDM-kvHqh--hPhnD1Y8RuaaSmuzgiz=_LDg@mail.gmail.com>
	<CAAA5faEDdR_L6y9ShhUcermgvjtmzNCzwoYeENjx+8RUEMdwaA@mail.gmail.com>
	<20160609022238.GY26977@dastard>
	<CAAA5faGL_Nyu=jW2Vrgr_m7crhnB9BriWWzMAPODbiQATFhS=Q@mail.gmail.com>
	<00bbe658-a891-3771-ca1d-5661a8b6ab61@sandeen.net>
	<CAAA5faH7RA=_WByj6uh4yVCLgwxkLh88CkrtTOa-qJqdyEDT-A@mail.gmail.com>
	<CAAA5faGTL4i3YS_oLxoeetpsEt+q59dmc2L7Kc-b5khzoV0GvA@mail.gmail.com>
	<20160622014253.GS12670@dastard>
From: Daniel Wagner <wagi@monom.org>
Message-ID: <c5c53ec1-cc9f-2b50-079a-4d0b4f405558@monom.org>
Date: Thu, 30 Jun 2016 08:04:09 +0200
MIME-Version: 1.0
In-Reply-To: <20160622014253.GS12670@dastard>
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
To: Dave Chinner <david@fromorbit.com>, Reinoud Koornstra <reinoudkoornstra@gmail.com>
Cc: Christoph Hellwig <hch@infradead.org>, Eric Sandeen <sandeen@sandeen.net>, viro@zeniv.linux.org.uk, xfs@oss.sgi.com

> Ok, that's good to hear. Now for some more testing: Al Viro just
> pushed some fixes to the parallel lookup code that may fix this
> problem. Al asked this question:
> 
> | Can that be triggered on 4e82901 + cherry-pick of e7d6ef979?
> | Same for 9f541801 + e7d6ef979?
> 
> Those commits are all in the current Linus tree - would you be
> able to test them? (i.e. check out tree to 4e82901, then just
> cherry pick the single commit (e7d6ef979) on top of that).

Finally I found some time to do some testing.

In one shell, git did some checkouts:

  while true; do git checkout master && git checkout b4.0; done

While in the other shell I just rebuild a kernel:

  while true; do make clean && make -j200; done

4e82901              crashed after 10 minutes
4e82901 + e7d6ef979  no crash after 4 hours
9f541801             no crash after 2 hours
9f541801 + e7d6ef979 no crash after 12 hours

cheers,
daniel

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
