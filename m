Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o4DHJrEY236903 for <xfs@oss.sgi.com>; Thu, 13 May 2010 12:19:53 -0500
Received: from greer.hardwarefreak.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id BA29913D18BC
	for <xfs@oss.sgi.com>; Thu, 13 May 2010 10:22:07 -0700 (PDT)
Received: from greer.hardwarefreak.com (mo-65-41-216-221.sta.embarqhsd.net
	[65.41.216.221]) by cuda.sgi.com with ESMTP id MhPsIOzbz2xOy8EF
	for <xfs@oss.sgi.com>; Thu, 13 May 2010 10:22:07 -0700 (PDT)
Received: from [192.168.100.53] (gffx.hardwarefreak.com [192.168.100.53])
	by greer.hardwarefreak.com (Postfix) with ESMTP id C6B556C2D1
	for <xfs@oss.sgi.com>; Thu, 13 May 2010 12:22:06 -0500 (CDT)
Message-ID: <4BEC3581.3020208@hardwarefreak.com>
Date: Thu, 13 May 2010 12:23:13 -0500
From: Stan Hoeppner <stan@hardwarefreak.com>
MIME-Version: 1.0
Subject: Re: bad primary superblock - bad magic number !!!
References: <28512276.post@talk.nabble.com>
	<4BE82955.2080009@sandeen.net>	<978493.86662.qm@web112902.mail.gq1.yahoo.com>	<20100510222211.3e73cdeb@galadriel.home>	<132290.52744.qm@web112902.mail.gq1.yahoo.com>	<20100512142902.47d1022a@harpe.intellique.com>	<606770.71420.qm@web112907.mail.gq1.yahoo.com>	<20100513114151.110fe8f9@galadriel.home>
	<408113.19031.qm@web112903.mail.gq1.yahoo.com>
In-Reply-To: <408113.19031.qm@web112903.mail.gq1.yahoo.com>
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

Leo Davis put forth on 5/13/2010 6:00 AM:
>> If I understand correctly, c0d0 represents a drive (the first one).
>> Apparently this drive is dead, or close. You should probably ditch it.
> 
> nope, c0d0 represents ( ControllerNumber[c0] LogicalDriveNumber[d0] )
> so its 12 disks in 2 partitions- c0d0 and c0d1
> c0d0 holds configuration information
> I boot from a different device, the raid set is used only for storing data.

Which model SmartArray controller is this?  Is it SCSI, SAS, or SATA?

If SAS or SATA, is there an expander in the enclosure?

What model is the external drive enclosure which houses the 12 drives?

-- 
Stan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
