Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o5IFZcAn229950 for <xfs@oss.sgi.com>; Fri, 18 Jun 2010 10:35:39 -0500
Received: from greer.hardwarefreak.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 502123E5286
	for <xfs@oss.sgi.com>; Fri, 18 Jun 2010 08:38:16 -0700 (PDT)
Received: from greer.hardwarefreak.com (mo-65-41-216-221.sta.embarqhsd.net
	[65.41.216.221]) by cuda.sgi.com with ESMTP id AsJ1vrk0MmRpS3ib
	for <xfs@oss.sgi.com>; Fri, 18 Jun 2010 08:38:16 -0700 (PDT)
Received: from [192.168.100.53] (gffx.hardwarefreak.com [192.168.100.53])
	by greer.hardwarefreak.com (Postfix) with ESMTP id AF5BE6C3A0
	for <xfs@oss.sgi.com>; Fri, 18 Jun 2010 10:38:15 -0500 (CDT)
Message-ID: <4C1B92E7.1050900@hardwarefreak.com>
Date: Fri, 18 Jun 2010 10:38:15 -0500
From: Stan Hoeppner <stan@hardwarefreak.com>
MIME-Version: 1.0
Subject: Re: Help with XFS -- use DS4700 Volume Copy feature for backing up
	the seismic date LUN
References: <OF4967B99D.609CC213-ONC1257745.0048E646-C1257745.004919A3@bergenofs.no>	<20100618132108.790921cf@harpe.intellique.com>	<OF450B8187.BD5256B0-ONC1257746.003E79FF-C1257746.003EE62C@bergenofs.no>	<20100618133458.6640ce96@harpe.intellique.com>	<OF0E234D8E.F048FF4D-ONC1257746.003FC10E-C1257746.00407333@bergenofs.no>	<20100618140028.05650928@harpe.intellique.com>	<4C1B6CB2.1020406@hardwarefreak.com>
	<20100618160410.034bc72f@harpe.intellique.com>
In-Reply-To: <20100618160410.034bc72f@harpe.intellique.com>
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

Emmanuel Florac put forth on 6/18/2010 9:04 AM:
> Le Fri, 18 Jun 2010 07:55:14 -0500
> Stan Hoeppner <stan@hardwarefreak.com> =E9crivait:
> =

>> Since he already has a FC SAN, going with something like a 4Gb FC
>> Nexsan Sataboy w/16 1TB drives would be a better option. =

> =

> Why not, actually anything that could hold a backup will do :)

That really depends on the size of one's filesystem(s) to be backed up and =
the
required backup schedule.

Backup times, optimal configurations:

            10TB FS     20TB FS    40TB FS

4Gb FC      7 hours     14 hours   28 hours
1GbE NFS   28 hours     56 hours  111 hours


With 4Gb FC one could backup 40TB in just over a day.  Using a 1GbE NAS fil=
er
it would take 4.6 days, almost an entire standard business _week_.  Now,
depending on the data, one could always tar the FS with compression and
substantially decrease these wire xfer times with either FC or NAS, which m=
ost
OPs would probably do with given the FS sizes involved.

And this is where the really nice high end arrays start to be worth their
price tag.  Even some upper midrange arrays, both SAN and NAS, have PIT
snapshot and LUN mirroring backup capabilities.  Both operations are much
faster than a filesystem level backup over the wire.

The DS4700 offers both a PIT snapshot feature called "FlashCopy" and a LUN
mirroring feature called "Volume Copy".  It would seem in the OP's case that
making use of the DS4700's Volume Copy feature would be of great benefit.  =
He
would simply make a Volume Copy of the current LUN holding the processed
seismic data using the System Storage DS4000 Storage Manager software.  He
should be able to schedule this operation to occur nightly, every other day,
weekly, biweekly, etc, or he could just run it manually occasionally if the
dataset doesn't change after it's been processed.

Again, given the OP's SAN hardware, this is really the only way to fly in t=
his
case.

-- =

Stan


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
