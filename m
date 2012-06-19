Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q5JADSGB071837 for <xfs@oss.sgi.com>; Tue, 19 Jun 2012 05:13:28 -0500
Received: from atlas.fiton.is (atlas.fiton.is [62.145.135.105]) by
	cuda.sgi.com with ESMTP id qUts2N3wBLJ5Ccb8 (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 19 Jun 2012 03:13:26 -0700 (PDT)
Received: from localhost ([127.0.0.1]) by atlas.fiton.is for xfs@oss.sgi.com;
	Tue, 19 Jun 2012 10:13:35 +0000
Message-ID: <4FE050C2.8060601@fiton.is>
Date: Tue, 19 Jun 2012 10:13:22 +0000
From: =?ISO-8859-1?Q?Svavar_=D6rn_Eysteinsson?= <svavar@fiton.is>
MIME-Version: 1.0
Subject: Recommendation on XFS Filesystem Creation, Lefthand P4500, iSCSI
 ?
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

Hello List.

We recently purchased HP Lefthand 4500 G2 24TB iSCSI SAN Box.
The Box is configured in RAID6. (and yes, we are going to expand that with
another boxes in near future).

I'm running Centos 6.2 with the latest updates on the iSCSI initiator 
machine.
HP DL380 G7 with 24GB in RAM

I need to create a 7TB volume at the start, and grow it in near future.

Are there any recommendation on creating that XFS volume ? Particularly 
regarding
iSCSI and that big ?

This server will act as a fileserver for 50+ machines serving request 
with netatalk
and samba.

Surely I will need to use inode64 option. Right ?


Any recommendation would be much appreciated.

Thanks allot people.
Best regards,

Svavar
Reykjavik - Iceland






_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
