Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mailrelay.collogia.de ([194.8.207.98]:59589 "HELO
        mailrelay.collogia.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with SMTP id S1750898AbdGFEpq (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 6 Jul 2017 00:45:46 -0400
From: Markus Stockhausen <stockhausen@collogia.de>
Subject: AW: XFS hang - 4.4.73 longterm
Date: Thu, 6 Jul 2017 04:45:43 +0000
Message-ID: <12EF8D94C6F8734FB2FF37B9FBEDD173010E027537@EXCHANGE.collogia.de>
References: <12EF8D94C6F8734FB2FF37B9FBEDD173010E02746C@EXCHANGE.collogia.de>
 <20170706002436.GA5068@magnolia>
In-Reply-To: <20170706002436.GA5068@magnolia>
Content-Language: de-DE
Content-Type: multipart/mixed;
        boundary="----=_NextPartTM-000-3cd04b0a-4ec3-4db4-a09e-3ff21e9c8b09"
MIME-Version: 1.0
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "'Darrick J. Wong'" <darrick.wong@oracle.com>
Cc: "'linux-xfs@vger.kernel.org'" <linux-xfs@vger.kernel.org>


This is a multi-part message in MIME format.

------=_NextPartTM-000-3cd04b0a-4ec3-4db4-a09e-3ff21e9c8b09
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

> Von: linux-xfs-owner@vger.kernel.org [mailto:linux-xfs-owner@vger.kernel.=
org] Im Auftrag von Darrick J. Wong
> Gesendet: Donnerstag, 6. Juli 2017 02:25
> An: Markus Stockhausen
> Cc: 'linux-xfs@vger.kernel.org'
> Betreff: Re: XFS hang - 4.4.73 longterm
>
> On Wed, Jul 05, 2017 at 07:19:28PM +0000, Markus Stockhausen wrote:
> > Hi,
> >=20
> > we are using a NFS/XFS fileserver and installed the current 4.4.73 long=
term kernel.
> > From time to time (reason currently unidentified) it spits blocked for=
=20
> > 120s messages Like the attached ones. Any ideas what might be the=20
> > reason? I can reproduce it With some effort. So in case you want some m=
ore logging don't hesitate to ask.
> >=20
> > For more details see=20
> > https://bugzilla.kernel.org/show_bug.cgi?id=3D196259
> >=20
> > [1248134.772889] INFO: task nfsd:1623 blocked for more than 120 seconds=
.
> > [1248134.772895]       Tainted: G          I     4.4.73-2.el7.centos.x8=
6_64 #1
> > [1248134.772897] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" dis=
ables this message.
> > [1248134.772899] nfsd            D ffff880bbf08b9c8     0  1623      2 =
0x00000080
> > [1248134.772905]  ffff880bbf08b9c8 ffff880be0875400 ffff880bbf080000=20
> > ffff880bbf08c000 [1248134.772908]  0000000000000000 7fffffffffffffff=20
> > ffff880bbf08bb38 ffffffff816fbb40 [1248134.772911]  ffff880bbf08b9e0=20
> > ffffffff816fb2d5 ffff880c176d6d00 ffff880bbf08ba88 [1248134.772915] Cal=
l Trace:
> > [1248134.772923]  [<ffffffff816fbb40>] ? bit_wait+0x50/0x50=20
> > [1248134.772926]  [<ffffffff816fb2d5>] schedule+0x35/0x80=20
> > [1248134.772929]  [<ffffffff816fdfe7>] schedule_timeout+0x237/0x2d0=20
> > [1248134.772935]  [<ffffffff8161ee0e>] ? ip_output+0x6e/0xe0=20
> > [1248134.772938]  [<ffffffff8161e502>] ? __ip_local_out+0x92/0x110=20
> > [1248134.772941]  [<ffffffff810f303a>] ? ktime_get+0x3a/0x90=20
> > [1248134.772944]  [<ffffffff816fbb40>] ? bit_wait+0x50/0x50=20
> > [1248134.772947]  [<ffffffff816faa46>] io_schedule_timeout+0xa6/0x110=20
> > [1248134.772950]  [<ffffffff816fbb5b>] bit_wait_io+0x1b/0x60=20
> > [1248134.772952]  [<ffffffff816fb8ee>] __wait_on_bit_lock+0x4e/0xb0=20
> > [1248134.772958]  [<ffffffff81189759>] __lock_page+0xb9/0xe0
>
> Waiting for a page lock with ILOCK held...
>
> > [1248134.772962]  [<ffffffff810c2910>] ?=20
> > autoremove_wake_function+0x40/0x40
> > [1248134.773007]  [<ffffffffa08d7c70>]=20
> > xfs_find_get_desired_pgoff.isra.10+0x1e0/0x2d0 [xfs] [1248134.773039] =
=20
> > [<ffffffffa08d7f9d>] xfs_seek_hole_data+0x23d/0x2c0 [xfs]=20
> > [1248134.773054]  [<ffffffffa05d942c>] ?=20
> > nfs4_preprocess_stateid_op+0x11c/0x430 [nfsd] [1248134.773086] =20
> > [<ffffffffa08d803c>] xfs_file_llseek+0x1c/0x40 [xfs] [1248134.773090] =
=20
> > [<ffffffff8120633e>] vfs_llseek+0x2e/0x30 [1248134.773101] =20
> > [<ffffffffa05c6080>] nfsd4_seek+0x80/0xe0 [nfsd] [1248134.773112] =20
> > [<ffffffffa05c8416>] nfsd4_proc_compound+0x3b6/0x710 [nfsd]=20
> > [1248134.773121]  [<ffffffffa05b4f2e>] nfsd_dispatch+0xce/0x270 [nfsd]=
=20
> > [1248134.773142]  [<ffffffffa01a5134>] svc_process_common+0x454/0x720=20
> > [sunrpc] [1248134.773151]  [<ffffffffa05b4880>] ?=20
> > nfsd_destroy+0x60/0x60 [nfsd] [1248134.773168]  [<ffffffffa01a5505>]=20
> > svc_process+0x105/0x1c0 [sunrpc] [1248134.773177] =20
> > [<ffffffffa05b4970>] nfsd+0xf0/0x160 [nfsd] [1248134.773180] =20
> > [<ffffffff8109d755>] kthread+0xe5/0x100 [1248134.773183] =20
> > [<ffffffff8109d670>] ? kthread_park+0x60/0x60 [1248134.773187] =20
> > [<ffffffff816ff1cf>] ret_from_fork+0x3f/0x70 [1248134.773190] =20
>  > [<ffffffff8109d670>] ? kthread_park+0x60/0x60 [1248134.773193]=20
> > INFO: task nfsd:1624 blocked for more than 120 seconds.
> > [1248134.773195]       Tainted: G          I     4.4.73-2.el7.centos.x8=
6_64 #1
> > [1248134.773197] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" dis=
ables this message.
> > [1248134.773198] nfsd            D ffff880bbf1a7738     0  1624      2 =
0x00000080
> > [1248134.773202]  ffff880bbf1a7738 ffffffff81a79500 ffff880bbf081500=20
> > ffff880bbf1a8000 [1248134.773205]  ffff8802334477a8 ffff880233447790=20
> > ffffffff00000000 ffffffff00000001 [1248134.773208]  ffff880bbf1a7750=20
> > ffffffff816fb2d5 ffff880bbf081500 ffff880bbf1a77e0 [1248134.773211] Cal=
l Trace:
> > [1248134.773214]  [<ffffffff816fb2d5>] schedule+0x35/0x80=20
> > [1248134.773217]  [<ffffffff816fdab5>]=20
> > rwsem_down_write_failed+0x1f5/0x320
> > [1248134.773243]  [<ffffffffa089e722>] ?=20
> > xfs_bmap_search_extents+0x72/0xe0 [xfs] [1248134.773273] =20
> > [<ffffffffa08cd212>] ? __xfs_get_blocks+0x162/0x800 [xfs]=20
> > [1248134.773276]  [<ffffffff81346433>]=20
> > call_rwsem_down_write_failed+0x13/0x20
> > [1248134.773279]  [<ffffffff816fd35d>] ? down_write+0x2d/0x40=20
> > [1248134.773311]  [<ffffffffa08e459a>] xfs_ilock+0xea/0x130 [xfs]
>
>...and waiting for the ILOCK with page lock held.
>
> This is the known deadlock in SEEK_HOLE/SEEK_DATA; I have patches queued =
to fix it in 4.13, as soon as the dust settles and I send the pull req.

Short, precise, frightening.

Can you advise what will the best option to avoid that error.=20
First things that come to my mind would be:

- get back to original 3.10 stable kernel from CentOS Distro=20
- lower NFS mount version
- Maybe remove some single patch that introduced the error?

Thanks in advance.

Markus
------=_NextPartTM-000-3cd04b0a-4ec3-4db4-a09e-3ff21e9c8b09
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

------=_NextPartTM-000-3cd04b0a-4ec3-4db4-a09e-3ff21e9c8b09--
