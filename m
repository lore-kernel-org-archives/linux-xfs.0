Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mailrelay.collogia.de ([194.8.207.98]:50509 "HELO
        mailrelay.collogia.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with SMTP id S1751050AbdHUIBG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 21 Aug 2017 04:01:06 -0400
From: Markus Stockhausen <stockhausen@collogia.de>
Subject: another possible integer truncation in xfs
Date: Mon, 21 Aug 2017 08:01:03 +0000
Message-ID: <12EF8D94C6F8734FB2FF37B9FBEDD173010E035CD2@EXCHANGE.collogia.de>
Content-Language: de-DE
Content-Type: multipart/mixed;
        boundary="----=_NextPartTM-000-dcdd7352-d849-4199-9e30-d9e31d3a7c1d"
MIME-Version: 1.0
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: "pmenzel@molgen.mpg.de" <pmenzel@molgen.mpg.de>, "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>


This is a multi-part message in MIME format.

------=_NextPartTM-000-dcdd7352-d849-4199-9e30-d9e31d3a7c1d
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

Hi Christoph,=0A=
=0A=
out of curiosity I looked for other use cases of min_t in xfs. At least =0A=
until 4.12 there is a similar constellation in xfs_dir2_leaf_readbuf:=0A=
=0A=
  if (trim_map) {=0A=
    mip->map_blocks -=3D geo->fsbcount;=0A=
    /*=0A=
     * Loop to get rid of the extents for the=0A=
     * directory block.=0A=
     */=0A=
    for (i =3D geo->fsbcount; i > 0; ) {=0A=
      j =3D min_t(int, map->br_blockcount, i);=0A=
      map->br_blockcount -=3D j;=0A=
      map->br_startblock +=3D j;=0A=
      map->br_startoff +=3D j;=0A=
=0A=
The loop could go havoc if map->br_blockcount is larger than =0A=
2G. If you think it could classify for stable feel free to add it too.=0A=
=0A=
Best regards.=0A=
=0A=
Markus=0A=
------=_NextPartTM-000-dcdd7352-d849-4199-9e30-d9e31d3a7c1d
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

------=_NextPartTM-000-dcdd7352-d849-4199-9e30-d9e31d3a7c1d--
