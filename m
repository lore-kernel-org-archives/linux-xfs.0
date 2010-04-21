Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o3LBdYL6108985 for <xfs@oss.sgi.com>; Wed, 21 Apr 2010 06:39:34 -0500
Received: from greer.hardwarefreak.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id B9C4A104960C
	for <xfs@oss.sgi.com>; Wed, 21 Apr 2010 04:41:32 -0700 (PDT)
Received: from greer.hardwarefreak.com (mo-65-41-216-221.sta.embarqhsd.net
	[65.41.216.221]) by cuda.sgi.com with ESMTP id Ehoo5fscF2OdTH96
	for <xfs@oss.sgi.com>; Wed, 21 Apr 2010 04:41:32 -0700 (PDT)
Received: from [192.168.100.53] (gffx.hardwarefreak.com [192.168.100.53])
	by greer.hardwarefreak.com (Postfix) with ESMTP id 7A0A16C347
	for <xfs@oss.sgi.com>; Wed, 21 Apr 2010 06:41:30 -0500 (CDT)
Message-ID: <4BCEE469.8040701@hardwarefreak.com>
Date: Wed, 21 Apr 2010 06:41:29 -0500
From: Stan Hoeppner <stan@hardwarefreak.com>
MIME-Version: 1.0
Subject: Re: xfs crash forensics
References: <20100421131207.3c845ba9@harpe.intellique.com>
In-Reply-To: <20100421131207.3c845ba9@harpe.intellique.com>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

Emmanuel Florac put forth on 4/21/2010 6:12 AM:

> 3w-9xxx: scsi6: AEN: WARNING (0x04:0x0023): Sector repair completed:port=11, LBA=0x54500741.
> 3w-9xxx: scsi6: AEN: WARNING (0x04:0x0023): Sector repair completed:port=11, LBA=0x54500C1F.
> 3w-9xxx: scsi6: AEN: WARNING (0x04:0x0023): Sector repair completed:port=11, LBA=0x5450104C.
> 3w-9xxx: scsi6: AEN: WARNING (0x04:0x0023): Sector repair completed:port=11, LBA=0x545010D8.
> 3w-9xxx: scsi6: AEN: WARNING (0x04:0x0023): Sector repair completed:port=11, LBA=0x5450110D.
> 3w-9xxx: scsi6: AEN: WARNING (0x04:0x0023): Sector repair completed:port=11, LBA=0x54501A23.
> 3w-9xxx: scsi6: AEN: WARNING (0x04:0x0023): Sector repair completed:port=11, LBA=0x54501B91.
> 3w-9xxx: scsi6: AEN: WARNING (0x04:0x0023): Sector repair completed:port=11, LBA=0x54501F10.
> 3w-9xxx: scsi6: AEN: WARNING (0x04:0x0023): Sector repair completed:port=11, LBA=0x545023FC.
> 3w-9xxx: scsi6: AEN: ERROR (0x04:0x0009): Drive timeout detected:port=11.
> 3w-9xxx: scsi6: AEN: WARNING (0x04:0x0023): Sector repair completed:port=11, LBA=0x54502400.
> 3w-9xxx: scsi6: AEN: WARNING (0x04:0x0023): Sector repair completed:port=11, LBA=0x5450256E.
> 3w-9xxx: scsi6: AEN: WARNING (0x04:0x0023): Sector repair completed:port=11, LBA=0x545028EB.
> 3w-9xxx: scsi6: AEN: WARNING (0x04:0x0023): Sector repair completed:port=11, LBA=0x54502F77.
> 3w-9xxx: scsi6: AEN: WARNING (0x04:0x0023): Sector repair completed:port=11, LBA=0x5450259E.
> 3w-9xxx: scsi6: AEN: WARNING (0x04:0x0023): Sector repair completed:port=11, LBA=0x54502DE0.
> 3w-9xxx: scsi6: AEN: WARNING (0x04:0x0023): Sector repair completed:port=11, LBA=0x54502A3B.
> 3w-9xxx: scsi6: AEN: WARNING (0x04:0x0023): Sector repair completed:port=11, LBA=0x54502A89.
> 3w-9xxx: scsi6: AEN: WARNING (0x04:0x0023): Sector repair completed:port=11, LBA=0x54503430.
> 3w-9xxx: scsi6: AEN: WARNING (0x04:0x0023): Sector repair completed:port=11, LBA=0x5450388C.
> 3w-9xxx: scsi6: AEN: WARNING (0x04:0x0023): Sector repair completed:port=11, LBA=0x5450394E.
> 3w-9xxx: scsi6: AEN: WARNING (0x04:0x0023): Sector repair completed:port=11, LBA=0x54503D78.
> 3w-9xxx: scsi6: AEN: WARNING (0x04:0x0023): Sector repair completed:port=11, LBA=0x54503EE6.
> 3w-9xxx: scsi6: AEN: WARNING (0x04:0x0023): Sector repair completed:port=11, LBA=0x545075ED.
> 3w-9xxx: scsi6: AEN: WARNING (0x04:0x0023): Sector repair completed:port=11, LBA=0x54507AD8.
> 3w-9xxx: scsi6: AEN: WARNING (0x04:0x0023): Sector repair completed:port=11, LBA=0x54507FC7.
> 3w-9xxx: scsi6: AEN: WARNING (0x04:0x0023): Sector repair completed:port=11, LBA=0x54508001.
> 3w-9xxx: scsi6: AEN: WARNING (0x04:0x0023): Sector repair completed:port=11, LBA=0x5450DB37.
> 3w-9xxx: scsi6: AEN: WARNING (0x04:0x0023): Sector repair completed:port=11, LBA=0x5450DE7E.
> 3w-9xxx: scsi6: AEN: WARNING (0x04:0x0023): Sector repair completed:port=11, LBA=0x5450DE86.
> 3w-9xxx: scsi6: AEN: WARNING (0x04:0x0023): Sector repair completed:port=11, LBA=0x5450FCE8.
> 3w-9xxx: scsi6: AEN: WARNING (0x04:0x0023): Sector repair completed:port=11, LBA=0x5451082F.
> 3w-9xxx: scsi6: ERROR: (0x06:0x0022): AEN drain failed during reset sequence.
> 3w-9xxx: scsi6: AEN: INFO (0x04:0x0001): Controller reset occurred:resets=1.
> 
> Does that smell of on-disk corruption? Hmmm.

Smells like a disk going bad.  What does SMART say about the disk attached
to port 11?

-- 
Stan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
