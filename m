Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q8K4W20M028203 for <xfs@oss.sgi.com>; Wed, 19 Sep 2012 23:32:02 -0500
Received: from mailrelay.collogia.de (mailrelay.collogia.de [62.40.12.196]) by
	cuda.sgi.com with SMTP id zhyQ4e0ieZ0beeJM for
	<xfs@oss.sgi.com>; Wed, 19 Sep 2012 21:33:14 -0700 (PDT)
From: Markus Stockhausen <stockhausen@collogia.de>
Subject: RE: Writeback Stalls
Date: Thu, 20 Sep 2012 04:33:09 +0000
Message-ID: <12EF8D94C6F8734FB2FF37B9FBEDD1735831B7C9@EXCHANGE.collogia.de>
References: <12EF8D94C6F8734FB2FF37B9FBEDD1735831B7A3@EXCHANGE.collogia.de>,
	<20120919213427.GD31501@dastard>
In-Reply-To: <20120919213427.GD31501@dastard>
Content-Language: de-DE
Content-Type: multipart/mixed;
	boundary="----=_NextPartTM-000-2807fa22-003f-46c4-b67a-5f240b473b31"
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
To: Dave Chinner <david@fromorbit.com>
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>


This is a multi-part message in MIME format.

------=_NextPartTM-000-2807fa22-003f-46c4-b67a-5f240b473b31
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

> Fundamentally, you are doing it all wrong. High throughput, low=0A=
> latency NFS servers write dirty data to disk fast, not leave it=0A=
> memory until you run out of clean memory because that causes=0A=
> everything to block waiting for writeback IO completion to be ale to=0A=
> free memory...=0A=
=0A=
Maybe I did not make it clear enough. The above setup is only=0A=
for demonstration purposes. To expose the problem better. In=0A=
real life we can see stalls tat thange from 0.5-1 seconds. Even=0A=
with all caches active, small dirty writeback settings and unlimited=0A=
bandwidth.=0A=
=0A=
In between I found others complaining about the same problem:=0A=
=0A=
http://lwn.net/Articles/486313/=0A=
http://oss.sgi.com/archives/xfs/2011-09/msg00189.html=0A=
=0A=
So just one last question: Can I savely revert the the mentioned =0A=
commit d76ee18a8551e33ad7dbd55cac38bc7b094f3abb if I only =0A=
write data to a battery backed up hardware raid controller on a =0A=
server that is attached to an UPS?=0A=
=0A=
Thanks in advance.=0A=
=0A=
Markus=
------=_NextPartTM-000-2807fa22-003f-46c4-b67a-5f240b473b31
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

------=_NextPartTM-000-2807fa22-003f-46c4-b67a-5f240b473b31
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

------=_NextPartTM-000-2807fa22-003f-46c4-b67a-5f240b473b31--
