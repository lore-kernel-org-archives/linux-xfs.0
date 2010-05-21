Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o4LBR9qr003761 for <xfs@oss.sgi.com>; Fri, 21 May 2010 06:27:09 -0500
Received: from mail-ew0-f228.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 2030A149B460
	for <xfs@oss.sgi.com>; Fri, 21 May 2010 04:30:45 -0700 (PDT)
Received: from mail-ew0-f228.google.com (mail-ew0-f228.google.com
	[209.85.219.228]) by cuda.sgi.com with ESMTP id
	z3hFAHwAD2fyU3Yv for <xfs@oss.sgi.com>;
	Fri, 21 May 2010 04:30:45 -0700 (PDT)
Received: by ewy28 with SMTP id 28so168275ewy.18
	for <xfs@oss.sgi.com>; Fri, 21 May 2010 04:29:26 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4BF62766.8070105@hardwarefreak.com>
References: <AANLkTilJD2Jfr4W97BiAlyc_7C9jLEhEzuEWSDyVKXYP@mail.gmail.com>
	<20100521041415.GW8120@dastard> <4BF62766.8070105@hardwarefreak.com>
Date: Fri, 21 May 2010 12:29:26 +0100
Message-ID: <AANLkTinobXUKRN0s_3Ia-5XBix05Tvhp36K5fUsysjh-@mail.gmail.com>
Subject: Re: Tuning XFS for real time audio on a laptop with encrypted LVM
From: Pedro Ribeiro <pedrib@gmail.com>
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
To: Stan Hoeppner <stan@hardwarefreak.com>, david@fromorbit.com
Cc: xfs@oss.sgi.com

On 21 May 2010 07:25, Stan Hoeppner <stan@hardwarefreak.com> wrote:
> Dave Chinner put forth on 5/20/2010 11:14 PM:
>
>> I only ever use the noop scheduler with XFS these days. CFQ has been
>> a steaming pile of ever changing regressions for the past 4 or 5
>> kernel releases, so i stopped using it. Besides, XFS is often 10-15%
>> faster on no-op for the same workload, anyway...
>
> IIRC the elevator sits below the FS in the stack, and has a tighter
> relationship to the block device driver and physical storage subsystem th=
an
> to the FS. =A0I have one box with a 7.2K 500GB WD drive and a sata_sil
> controller that doesn't support NCQ. =A0Without NCQ due to no controller
> support or ATA_horkage_NCQ blacklisted drives, the deadline and anticipat=
ory
> (now removed from the kernel IIRC) elevators yield vastly superior
> performance under load compared to CFQ or noop.
>
> Noop fits well with good hardware RAID, either local machine PCI/x/e RAID
> card or straight FC HBA talking to a SAN array controller. =A0CFQ just ge=
ts in
> the way with good hardware. =A0In some testing I've done with FC HBAs and
> target LUNs on IBM FasTt and Nexsan SAN arrays, deadline has shown a tiny
> advantage over noop with a few synthetic tests. =A0This testing was perfo=
rmed
> on SLED 10 and Debian Etch guests atop VMWare ESX 3 at night on weekends
> when load across the ESX blade farm was near zero, but it was still done =
in
> a virtual environment. =A0On bare hardware, I'm not sure one would get the
> same results. =A0Anyway, the deadline elevator gave such little advantage=
 over
> noop, I'd still recommend noop on good hardware due to zero CPU overhead.
> Deadline has a few fancy tricks so it will always eat more CPU, even thou=
gh
> it's a modest amount.
>
> I'd sum the elevator choice up this way: =A0If you have a good storage
> hardware and driver combo such as fast SATA disks with good NCQ, or just
> about any SCSI, SAS, RAID, or SAN setup, go with noop. =A0For lesser
> hardware/drivers, use deadline (i.e. lacking or crappy NCQ, or on laptops
> due to the slow 4200/5400 rpm drives, even if they do have good NCQ).
>
> I agree with Dave that CFQ isn't all that great, and in my testing it's e=
ven
> worse when used with Linux guests on ESX than it is on bare metal.
>
> Caveat: =A0I'm no expert, and I don't do storage subsystem performance te=
sting
> all day long. =A0I'm just reporting my first hand experience. =A0YMMV and=
 all
> the normal disclaimers apply.
>
> --
> Stan
>
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs
>

Thanks for the answers.

I do value my data a lot (that's why I changed from Windows some years
ago), and even though this is a laptop with battery protection I keep
crashing and hard locking it because I like always to use -rcX kernels
and to fool around with lots of dangerous stuff/settings/etc.

Actually that is one of the reasons I stick with XFS instead of going
to EXT4 or the like. I've been using and torturing XFS for a couple of
years now and I NEVER suffered any corruption, and only had a couple
of times where unimportant data loss happened, but it was completely
expected because I was an ass. I only lost the data that was unsynched
during the last minute though.

I forgot to say that I have a SATA-I 5400rpm hard drive, it does
support NCQ and since this is a laptop there is no RAID or similars.

I've been running a few tests with bonnie++ and hdparm. hdparm reports
my bare hard drive speed as 67 Mb/s for read. With bonnie++ the
maximum I can get is 52 Mb/s with noop and cfq and deadline only gives
me 48 Mb/s. This is not bad at all. noop is a tad faster in all the
tests and the only thing it performs worse is in read latency,
although read throughput appears to be the same.

So it is agreed that CFQ sucks right now. I'll continue my testing but
now with proper daily use to see which is better, deadline or noop.

Regards,
Pedro

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
