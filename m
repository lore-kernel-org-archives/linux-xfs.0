Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q4INYnfL258530 for <xfs@oss.sgi.com>; Fri, 18 May 2012 18:34:49 -0500
Received: from mail.linuxsystems.it (mail.linuxsystems.it [2.119.245.41]) by
	cuda.sgi.com with ESMTP id v2HoaGFb3EUIhxvK for
	<xfs@oss.sgi.com>; Fri, 18 May 2012 16:34:47 -0700 (PDT)
Received: from [192.168.2.4] (unknown [192.168.2.4])
	by mail.linuxsystems.it (Postfix) with ESMTPSA id 8E718786B
	for <xfs@oss.sgi.com>; Sat, 19 May 2012 01:34:46 +0200 (CEST)
Message-ID: <4FB6DD00.5010004@linuxsystems.it>
Date: Sat, 19 May 2012 01:36:32 +0200
From: =?ISO-8859-1?Q?Niccol=F2_Belli?= <darkbasic@linuxsystems.it>
MIME-Version: 1.0
Subject: Re: How to recover data from an xfs partition
References: <4FAE9DBF.1090505@linuxsystems.it> <20120518143143.GN16099@sgi.com>
	<4FB66430.9040202@linuxsystems.it> <4FB68AF6.1090303@sandeen.net>
	<4FB6B7AB.8030405@linuxsystems.it> <4FB6D17A.7070408@sandeen.net>
In-Reply-To: <4FB6D17A.7070408@sandeen.net>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"; Format="flowed"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

Il 19/05/2012 00:47, Eric Sandeen ha scritto:
> TBH I'd be as likely to
> blame the SSD, as anything.

I didn't even need to fsck the SSD's partition... Something gone mad in =

the Xen code and it corrupted my data, that was the problem.
I managed to rescue the vast majority of the data in my ext4 partitions, =

but not in the xfs one. Who should I blame for this? xfs? the fate? I =

really don't know it, I'm just reporting what happened compared to =

another fs but I cannot guarantee the bug threated all the partitions =

the same way :)

Niccol=F2

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
