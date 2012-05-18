Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q4IExRV7196977 for <xfs@oss.sgi.com>; Fri, 18 May 2012 09:59:27 -0500
Received: from mail.linuxsystems.it (mail.linuxsystems.it [2.119.245.41]) by
	cuda.sgi.com with ESMTP id ncX6X9eRifnX9iDZ for
	<xfs@oss.sgi.com>; Fri, 18 May 2012 07:59:24 -0700 (PDT)
Received: from [192.168.2.4] (unknown [192.168.2.4])
	by mail.linuxsystems.it (Postfix) with ESMTPSA id 1A4C57743
	for <xfs@oss.sgi.com>; Fri, 18 May 2012 16:59:19 +0200 (CEST)
Message-ID: <4FB66430.9040202@linuxsystems.it>
Date: Fri, 18 May 2012 17:01:04 +0200
From: =?ISO-8859-1?Q?Niccol=F2_Belli?= <darkbasic@linuxsystems.it>
MIME-Version: 1.0
Subject: Re: How to recover data from an xfs partition
References: <4FAE9DBF.1090505@linuxsystems.it> <20120518143143.GN16099@sgi.com>
In-Reply-To: <20120518143143.GN16099@sgi.com>
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

Hi,

Il 18/05/2012 16:31, Ben Myers ha scritto:
> I recommend you give it a shot with the latest xfsprogs.  However, it may=
 be
> that your filesystem has been corrupted beyond repair.

I succeeded recovering something with xfsprogs 3.1.8, but no more than =

1GB of data (~5%).

Fortunately I managed to save some precious config files, considering I =

had a 6 months old backup the disaster is a bit less catastrophic.

I had a bad time replacing corrupted data from the other ten ext4 =

virtual machines, but they didn't give me too much troubles compared to =

xfs. How ironic that the data loss happened during the installation of =

the backup system...

To be honest I don't know if I will use xfs anymore, unfortunately I =

need per-directory quota and it is the only viable solution.

Niccol=F2

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
