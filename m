Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mailrelay.collogia.de ([194.8.207.98]:52121 "HELO
        mailrelay.collogia.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with SMTP id S1752146AbdGIRB3 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 9 Jul 2017 13:01:29 -0400
From: Markus Stockhausen <stockhausen@collogia.de>
Subject: AW: XFS hang - 4.4.73 longterm
Date: Sun, 9 Jul 2017 17:01:25 +0000
Message-ID: <12EF8D94C6F8734FB2FF37B9FBEDD173010E0284F8@EXCHANGE.collogia.de>
References: <12EF8D94C6F8734FB2FF37B9FBEDD173010E02746C@EXCHANGE.collogia.de>
 <20170706002436.GA5068@magnolia>
 <12EF8D94C6F8734FB2FF37B9FBEDD173010E027537@EXCHANGE.collogia.de>
 <20170707034713.GD4103@magnolia>
In-Reply-To: <20170707034713.GD4103@magnolia>
Content-Language: de-DE
Content-Type: multipart/mixed;
        boundary="----=_NextPartTM-000-800ab520-60a9-4435-a031-d6e5fd657e86"
MIME-Version: 1.0
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "'Darrick J. Wong'" <darrick.wong@oracle.com>
Cc: "'linux-xfs@vger.kernel.org'" <linux-xfs@vger.kernel.org>


This is a multi-part message in MIME format.

------=_NextPartTM-000-800ab520-60a9-4435-a031-d6e5fd657e86
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

> -----Urspr=FCngliche Nachricht-----
> Von: Darrick J. Wong [mailto:darrick.wong@oracle.com]=20
> Gesendet: Freitag, 7. Juli 2017 05:47
> An: Markus Stockhausen
> Cc: 'linux-xfs@vger.kernel.org'
> Betreff: Re: XFS hang - 4.4.73 longterm
>
> > > ...
> > > This is the known deadlock in SEEK_HOLE/SEEK_DATA; I have patches que=
ued to fix it in 4.13, as soon as the dust settles and I send the pull req.
> >=20
> > Short, precise, frightening.
> >=20
> > Can you advise what will the best option to avoid that error.=20
> > First things that come to my mind would be:
> >=20
> > - get back to original 3.10 stable kernel from CentOS Distro
> > - lower NFS mount version
> > - Maybe remove some single patch that introduced the error?
>
> Unfortunately, SEEK_HOLE (and the deadlocky code) go all the way back to =
the beginning of SEEK_HOLE support, so I don't know that=20
> there's a good workaround for this.  There's not really a way to shut off=
 support for it, either, that doesn't involve gross code surgery.

Not good news. Finally I disabled SEEK support in nfsd by partially reverti=
ng 3.18 patch=20
24bab491220faa446d94 "NFSD: Implement SEEK". While before NFS/XFS crashed w=
ith=20
active VM snapshots and heavy disk writes after minutes it now runs for 2 d=
ays of=20
intensive testing without errors.

At least now I have full discard support in side VMs (via hole punching of =
disk files).
I'm not familiar with SEEK_HOLE/SEEK_data feature. Do you see negative impa=
ct
if disabling these? In contrast to falling back to NFS 4 without seek + dis=
card support.

Markus=20
------=_NextPartTM-000-800ab520-60a9-4435-a031-d6e5fd657e86
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

------=_NextPartTM-000-800ab520-60a9-4435-a031-d6e5fd657e86--
