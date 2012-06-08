Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q58JXxH1249041 for <xfs@oss.sgi.com>; Fri, 8 Jun 2012 14:34:00 -0500
Received: from smtp.internet-sicherheit.de (smtp.internet-sicherheit.de
	[194.94.127.56]) by cuda.sgi.com with ESMTP id 1FNQWNqVCDr8dDon
	(version=TLSv1 cipher=AES256-SHA bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Fri, 08 Jun 2012 12:33:58 -0700 (PDT)
Received: from [10.0.44.5] (unknown [10.0.44.5])
	by smtp.internet-sicherheit.de (Postfix) with ESMTP id BCB97EE0032
	for <xfs@oss.sgi.com>; Fri,  8 Jun 2012 21:33:55 +0200 (CEST)
Message-ID: <4FD253A5.3080800@internet-sicherheit.de>
Date: Fri, 08 Jun 2012 21:33:57 +0200
From: "Christian J. Dietrich" <dietrich@internet-sicherheit.de>
MIME-Version: 1.0
Subject: Re: Repeated XFS corruption on RAID-10 on Adaptec 51245
References: <4FD1C9B8.70907@internet-sicherheit.de>
	<4FD20483.2080105@sandeen.net>
In-Reply-To: <4FD20483.2080105@sandeen.net>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com


Eric,

thanks for your suggestions.

Am 08.06.2012 15:56, schrieb Eric Sandeen:
>> Naive, I would assume that running xfs_repair once would fix all errors.
>> My guess is that the underlying RAID volume (Adaptec 51245 RAID 10) is
>> somehow invalid (although I can not find any indicators confirming
>> this). Any suggestions?
> =

> If you suspect a problem with repair, you can try:
> =

> # umount /dev/sda
> # xfs_metadump -o /dev/sda - | xfs_mdrestore - filesystem.img
> # xfs_repair filesystem.img
> # xfs_repair filesystem.img
> =

> The image shouldn't take too much space, but 12T might take a little while
> to dump.
> If repair doesn't fix everything the first time please let us know.

Thanks, I can confirm that xfs_repair fixes everything on the first run.

> please make sure that you aren't running the old kmod-xfs (or was it
> xfs-kmod?) rpm.

No, I am using the default driver that comes with the distribution.

Thanks again, I consider the problem to be related to the combination of
controller and HDDs (and no longer to xfs) and will dig deeper into that
direction.

Chris

-- =

Christian J. Dietrich
Institute for Internet Security - if(is)
Westf=E4lische Hochschule University of Applied Sciences
https://www.internet-sicherheit.de


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
