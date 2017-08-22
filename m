Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mailrelay.collogia.de ([194.8.207.98]:19827 "HELO
        mailrelay.collogia.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with SMTP id S1751362AbdHVRVL (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 22 Aug 2017 13:21:11 -0400
From: Markus Stockhausen <stockhausen@collogia.de>
Subject: AW: another possible integer truncation in xfs
Date: Tue, 22 Aug 2017 17:20:56 +0000
Message-ID: <12EF8D94C6F8734FB2FF37B9FBEDD173010E0364FB@EXCHANGE.collogia.de>
References: <12EF8D94C6F8734FB2FF37B9FBEDD173010E035CD2@EXCHANGE.collogia.de>
 <20170821081603.GA6581@lst.de>,<20170822164134.GV4796@magnolia>
In-Reply-To: <20170822164134.GV4796@magnolia>
Content-Language: de-DE
Content-Type: multipart/mixed;
        boundary="----=_NextPartTM-000-4abe830b-0773-4213-affe-4d603bfbc226"
MIME-Version: 1.0
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>, Christoph Hellwig <hch@lst.de>
Cc: "pmenzel@molgen.mpg.de" <pmenzel@molgen.mpg.de>, "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>


This is a multi-part message in MIME format.

------=_NextPartTM-000-4abe830b-0773-4213-affe-4d603bfbc226
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

> Von: Darrick J. Wong [darrick.wong@oracle.com]=0A=
> Gesendet: Dienstag, 22. August 2017 18:41=0A=
> An: Christoph Hellwig=0A=
> Cc: Markus Stockhausen; pmenzel@molgen.mpg.de; linux-xfs@vger.kernel.org=
=0A=
> Betreff: Re: another possible integer truncation in xfs=0A=
> =0A=
> On Mon, Aug 21, 2017 at 10:16:03AM +0200, Christoph Hellwig wrote:=0A=
> > On Mon, Aug 21, 2017 at 08:01:03AM +0000, Markus Stockhausen wrote:=0A=
> > > Hi Christoph,=0A=
> > >=0A=
> > > out of curiosity I looked for other use cases of min_t in xfs. At lea=
st=0A=
> > > until 4.12 there is a similar constellation in xfs_dir2_leaf_readbuf:=
=0A=
> > >=0A=
> > >   if (trim_map) {=0A=
> > >     mip->map_blocks -=3D geo->fsbcount;=0A=
> > >     /*=0A=
> > >      * Loop to get rid of the extents for the=0A=
> > >      * directory block.=0A=
> > >      */=0A=
> > >     for (i =3D geo->fsbcount; i > 0; ) {=0A=
> > >       j =3D min_t(int, map->br_blockcount, i);=0A=
> > >       map->br_blockcount -=3D j;=0A=
> > >       map->br_startblock +=3D j;=0A=
> > >       map->br_startoff +=3D j;=0A=
> > >=0A=
> > > The loop could go havoc if map->br_blockcount is larger than=0A=
> > > 2G. If you think it could classify for stable feel free to add it too=
.=0A=
> =0A=
> "2G"... are you concerned about an integer overflow if map->br_blockcount=
=0A=
> is a value larger than 2147483647, or if *map itself represents an=0A=
> extent longer than 2GiB?  (I'm pretty sure you're talking about the=0A=
> first scenario, but the units here are ambiguous.)=0A=
> =0A=
> I /think/ the correct answer here is that file extent records can't ever=
=0A=
> be longer than 2^20 blocks so this min_t ought to be fine.=0A=
=0A=
Hi Darrick,=0A=
=0A=
It was just the same educated guess as the first spotting. 64 bit=0A=
variables minified by their lower 32 bits. Thus truncation "could" =0A=
lead to strange side effects. If it cannot happen - sorry for the =0A=
noise.=0A=
=0A=
Markus=0A=
=0A=
> --D=0A=
> =0A=
> > I don't think it has a chance to be larger in practice, but we should=
=0A=
> > fix it anyway.  I'll prepare a patch.=0A=
> >=0A=
> > Thanks for spotting this!=0A=
> > --=0A=
------=_NextPartTM-000-4abe830b-0773-4213-affe-4d603bfbc226
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

------=_NextPartTM-000-4abe830b-0773-4213-affe-4d603bfbc226--
