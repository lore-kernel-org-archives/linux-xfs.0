Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o3LG9idx125729 for <xfs@oss.sgi.com>; Wed, 21 Apr 2010 11:09:44 -0500
Received: from greer.hardwarefreak.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 9C0CD12E6309
	for <xfs@oss.sgi.com>; Wed, 21 Apr 2010 09:11:44 -0700 (PDT)
Received: from greer.hardwarefreak.com (mo-65-41-216-221.sta.embarqhsd.net
	[65.41.216.221]) by cuda.sgi.com with ESMTP id 8CF5bDjtn6EhRVGO
	for <xfs@oss.sgi.com>; Wed, 21 Apr 2010 09:11:44 -0700 (PDT)
Received: from [192.168.100.53] (gffx.hardwarefreak.com [192.168.100.53])
	by greer.hardwarefreak.com (Postfix) with ESMTP id 1AEFF6C306
	for <xfs@oss.sgi.com>; Wed, 21 Apr 2010 11:11:44 -0500 (CDT)
Message-ID: <4BCF23BF.8070305@hardwarefreak.com>
Date: Wed, 21 Apr 2010 11:11:43 -0500
From: Stan Hoeppner <stan@hardwarefreak.com>
MIME-Version: 1.0
Subject: Re: xfs crash forensics
References: <20100421131207.3c845ba9@harpe.intellique.com>	<4BCEE469.8040701@hardwarefreak.com>
	<20100421152751.24c833f2@harpe.intellique.com>
In-Reply-To: <20100421152751.24c833f2@harpe.intellique.com>
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

Emmanuel Florac put forth on 4/21/2010 8:27 AM:
> Le Wed, 21 Apr 2010 06:41:29 -0500
> Stan Hoeppner <stan@hardwarefreak.com> =E9crivait:
> =

>> Smells like a disk going bad.  What does SMART say about the disk
>> attached to port 11?
>>
> =

> surprisingly, absolutely nothing after the reboot. The disk just
> "cleaned up" all by itself. There are any registered alarms on the
> controller, too.

You need to dig for more information on drive scsi6.  The messages logged
appear to be saying that many sectors were replaced with spares and the
originals marked bad.  Additionally, there appears to have been a bus
timeout during the same time period.  This leads me to believe that drive is
faulty and should be replaced.  Use smartctl or other tools to grab the
SMART data from that drive.  I'm not sure exactly how to do so with drives
connected to a 3ware controller.  IIRC smartctl needs some extra switches
for 3ware cards.  Google is your friend here.

Please don't go on as if nothing happened and everything is fine now.  You
need to find out if that drive is indeed going bad, which appears, from
here, to be the case.

-- =

Stan


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
