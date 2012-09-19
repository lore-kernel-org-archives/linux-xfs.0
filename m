Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q8JIZ4x2229968 for <xfs@oss.sgi.com>; Wed, 19 Sep 2012 13:35:04 -0500
Received: from mailrelay.collogia.de (mailrelay.collogia.de [62.40.12.196]) by
	cuda.sgi.com with SMTP id 93bdr9l3nSyEN1ci for
	<xfs@oss.sgi.com>; Wed, 19 Sep 2012 11:36:14 -0700 (PDT)
From: Markus Stockhausen <stockhausen@collogia.de>
Subject: Writeback Stalls
Date: Wed, 19 Sep 2012 18:36:11 +0000
Message-ID: <12EF8D94C6F8734FB2FF37B9FBEDD1735831B7A3@EXCHANGE.collogia.de>
Content-Language: de-DE
Content-Type: multipart/mixed;
	boundary="----=_NextPartTM-000-1b29904f-a9d6-4f79-a1d7-476e12f9fcdc"
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: "xfs@oss.sgi.com" <xfs@oss.sgi.com>


This is a multi-part message in MIME format.

------=_NextPartTM-000-1b29904f-a9d6-4f79-a1d7-476e12f9fcdc
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

Hello,=0A=
=0A=
I'm not sure if you can help me with the following problem but I must start=
 somewhere.=0A=
=0A=
We have an small sized VMWare infrastructure. 8 hosts with round about 50 V=
Ms. =0A=
Their images are hosted on 2 Ubuntu 12.04 NFS storage servers with each of =
them=0A=
having a 14 disk RAID 6 array. On top of the array runs a single XFS filesy=
stem with =0A=
round about 10TB of disk space.=0A=
=0A=
>From time to time we see stalls in the infrastructure. The machines become =
unresponsive=0A=
and hang for a few seconds. The controller was the first item to be under s=
uspect. =0A=
But after a lot examination we created a very artifical setup that shows th=
e real reasons=0A=
for the stalls: Writeback handling. The parameters are:=0A=
=0A=
- set NFS to async=0A=
- disable controller and disk writeback cache=0A=
- enable cgroup=0A=
- set dirty_background_bytes to some very high value (4GB)=0A=
- set dirty_bytes to some very high value (4GB)=0A=
- set dirty_expire_centisecs to to some very high value (60 secs)=0A=
- set blkio.throttle.write_bps_device to a very low value (2MB/sek)=0A=
=0A=
Now generate some write load on a Windows VM. During the test we observe wh=
at=0A=
is happening on the storage and the VM. The result is:=0A=
=0A=
- dirty pages are increasing=0A=
- writeback is constantly 0=0A=
- VM is working well=0A=
=0A=
At some point writeback is kicking in and all of a sudden the VM stalls. Du=
ring=0A=
this time the setup shows=0A=
=0A=
- most of the dirty pages are transfered to writeback pages=0A=
- writeback is done at the above set limit (2MB/sek)=0A=
- VM is not responding =0A=
=0A=
After writeback has finished everything goes back to normal. Additional rem=
ark:=0A=
VMs DO NOT hang if I create heavy writes on the XFS into non-VM related fil=
es.=0A=
=0A=
We are interested in this kind of setup for several reasons:=0A=
=0A=
1. Keep VMs reponsive=0A=
=0A=
2. Allow VMs to generate short spikes of write I/Os at a higher rate than t=
he =0A=
disk subsystem is capable of. =0A=
=0A=
3. Write this data back to the disk in the background over a longer period=
=0A=
of time. Ensure that a limited writeback rate keeps enough headroom so that=
=0A=
read I/Os are not delayed too much.=0A=
=0A=
Can you explain me if there is some blocking going on in XFS in the time=0A=
between start and end of writeback? If yes what can I do to achieve my=0A=
goals and stop the writeback stalls. =0A=
=0A=
For you help I thank you in advance.=0A=
=0A=
Markus=0A=
=0A=
=0A=
=0A=
=0A=
=0A=
=0A=
=0A=
=0A=
=0A=
=0A=
------=_NextPartTM-000-1b29904f-a9d6-4f79-a1d7-476e12f9fcdc
Content-Type: text/plain;
	name="InterScan_Disclaimer.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="InterScan_Disclaimer.txt"

****************************************************************************
Diese E-Mail enthält vertrauliche und/oder rechtlich geschützte
Informationen. Wenn Sie nicht der richtige Adressat sind oder diese E-Mail
irrtümlich erhalten haben, informieren Sie bitte sofort den Absender und
vernichten Sie diese Mail. Das unerlaubte Kopieren sowie die unbefugte
Weitergabe dieser Mail ist nicht gestattet.

Über das Internet versandte E-Mails können unter fremden Namen erstellt oder
manipuliert werden. Deshalb ist diese als E-Mail verschickte Nachricht keine
rechtsverbindliche Willenserklärung.

Collogia
Unternehmensberatung AG
Ubierring 11
D-50678 Köln

Vorstand:
Kadir Akin
Dr. Michael Höhnerbach

Vorsitzender des Aufsichtsrates:
Hans Kristian Langva

Registergericht: Amtsgericht Köln
Registernummer: HRB 52 497

This e-mail may contain confidential and/or privileged information. If you
are not the intended recipient (or have received this e-mail in error)
please notify the sender immediately and destroy this e-mail. Any
unauthorized copying, disclosure or distribution of the material in this
e-mail is strictly forbidden.

e-mails sent over the internet may have been written under a wrong name or
been manipulated. That is why this message sent as an e-mail is not a
legally binding declaration of intention.

Collogia
Unternehmensberatung AG
Ubierring 11
D-50678 Köln

executive board:
Kadir Akin
Dr. Michael Höhnerbach

President of the supervisory board:
Hans Kristian Langva

Registry office: district court Cologne
Register number: HRB 52 497

****************************************************************************

------=_NextPartTM-000-1b29904f-a9d6-4f79-a1d7-476e12f9fcdc
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

------=_NextPartTM-000-1b29904f-a9d6-4f79-a1d7-476e12f9fcdc--
