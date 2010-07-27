Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o6RCoDbp186335 for <xfs@oss.sgi.com>; Tue, 27 Jul 2010 07:50:14 -0500
Received: from greer.hardwarefreak.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id EB47215C9169
	for <xfs@oss.sgi.com>; Tue, 27 Jul 2010 06:00:38 -0700 (PDT)
Received: from greer.hardwarefreak.com (mo-65-41-216-221.sta.embarqhsd.net
	[65.41.216.221]) by cuda.sgi.com with ESMTP id swPk6CgfLKfMSkwR
	for <xfs@oss.sgi.com>; Tue, 27 Jul 2010 06:00:38 -0700 (PDT)
Received: from [192.168.100.53] (gffx.hardwarefreak.com [192.168.100.53])
	by greer.hardwarefreak.com (Postfix) with ESMTP id 08FCD6C309
	for <xfs@oss.sgi.com>; Tue, 27 Jul 2010 07:53:18 -0500 (CDT)
Message-ID: <4C4ED871.1090108@hardwarefreak.com>
Date: Tue, 27 Jul 2010 08:00:33 -0500
From: Stan Hoeppner <stan@hardwarefreak.com>
MIME-Version: 1.0
Subject: Re: High latencies writing to a memory mapped file
References: <20100722144706.GA2840@BohrerMBP.rgmadvisors.com>	<20100727092452.GA23307@citd.de>
	<20100727124750.30bb3209@harpe.intellique.com>
In-Reply-To: <20100727124750.30bb3209@harpe.intellique.com>
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

Emmanuel Florac put forth on 7/27/2010 5:47 AM:
> Le Tue, 27 Jul 2010 11:24:52 +0200
> Matthias Schniedermeyer <ms@citd.de> =E9crivait:
> =

>> In case anybody has an idea what i could do to identify and/or
>> isolate the root-cause, i'm open for suggestions.
>>
> =

> I'd thought that the io scheduler is the culprit. I've generally found
> that the default CFQ scheduler (default) is terrible for file servers.

Agreed.  The scheduler may not be the cause of his issue, but switching to
deadline or noop should certainly help overall I/O a bit.  I'm no fan of CFQ
either.  I've been using deadline for quite a while and it seems to be good
for local single disk and JBOD,  as well as for Linux software RAID to local
disks.  Deadline and noop are both good choices if using a good intelligent
PCI RAID controller, or if doing I/O over a FC/iSCSI HBA to a SAN controlle=
r;
in fact noop probably shouldn't be used with anything but intelligent I/O
controllers.

My informal testing some time ago revealed that deadline will pick up some =
of
the performance slack if you're unable to use NCQ due to a crappy SATA
chipset/HBA and/or drive firmware (or both).  Testing also showed that it
basically ties noop when used with Qlogic 4Gb FC HBAs and IBM and Nexsan SAN
array controllers.  Deadline just seems to work pretty well with anything,
picking up slack when lacking intelligent I/O hardware, and not really gett=
ing
in the way when you have it.

** Testing will reveal which is better for a given server/storage and
application mix.  Such testing is why I only include deadline in my custom
kernels (that and the fact I like to keep my kernels tight, as small as
possible--dropping CFQ and noop simply cuts a little more dead weight from =
the
binary).

-- =

Stan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
