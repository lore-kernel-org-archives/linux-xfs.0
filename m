Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q1ED24mC094446 for <xfs@oss.sgi.com>; Tue, 14 Feb 2012 07:02:04 -0600
Received: from smtprelay04.ispgateway.de (smtprelay04.ispgateway.de
	[80.67.31.32]) by cuda.sgi.com with ESMTP id ApXlMYhRA35Akk1T
	for <xfs@oss.sgi.com>; Tue, 14 Feb 2012 05:02:03 -0800 (PST)
Message-ID: <4F3A5B49.6020803@cape-horn-eng.com>
Date: Tue, 14 Feb 2012 14:02:01 +0100
From: Richard Ems <richard.ems@cape-horn-eng.com>
MIME-Version: 1.0
Subject: Re: XFS unlink still slow on 3.1.9 kernel ?
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
To: xfs@oss.sgi.com, Stan Hoeppner <stan@hardwarefreak.com>

Hi Stan,

I was not subscribed to the list so I did not get your mail. I
subscribed now, but apparently and admin has to aprove the subscription
since I am not getting any confirmation email. so this will take some time.

> On 2/13/2012 10:57 AM, Richard Ems wrote:
>> The case is connected through SCSI.
> =

> Do you mean iSCSI?  Does the host on which you're running your "find
> dir" command have a 1GbE or 10GbE connection to the InforTrend unit?
> More than one connection using bonding or multipath?  Direct connected
> or through a switch(es)?  What brand is the switch(es)?  Switch(es)
> under heavy load?

NO. SCSI. Not iSCSI. No switches, it's direct attached through a LSI
SCSI Controller:

lspci shows:

LSI Logic / Symbios Logic 53c1030 PCI-X Fusion-MPT Dual Ultra320 SCSI



> If it's a single direct 1GbE connection it's possible you're running out
> of host pipe bandwidth which is only ~100MB/s in each direction.  Check
> iotop/iostat while running your command to see if you're peaking the
> interface with either read or write bytes.  If either are at or above
> 100MB/s then your host pipe is full, thus this is a significant part of
> your high run time problem.

This does not apply, or?


> Also check the performance data in the management interface on the
> InforTrend unit to see if you're hitting any limits there (if it has
> such a feature).  RAID6 is numerically intensive and that particular
> controller may not have the ASIC horsepower to keep up with the IOPS
> workload you're throwing at it.

There is no performance data in the management interface to check.


> Lastly, please paste the exact command or script you refer to as "find
> dir" which is generating the workload in question.

See previous answers to the list. You will see all commands there.

Thanks,
Richard



-- =

Richard Ems       mail: Richard.Ems@Cape-Horn-Eng.com

Cape Horn Engineering S.L.
C/ Dr. J.J. D=F3mine 1, 5=BA piso
46011 Valencia
Tel : +34 96 3242923 / Fax 924
http://www.cape-horn-eng.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
