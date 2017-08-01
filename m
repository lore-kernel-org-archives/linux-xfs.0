Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mailrelay.collogia.de ([194.8.207.98]:27995 "HELO
        mailrelay.collogia.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with SMTP id S1751877AbdHASx5 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 1 Aug 2017 14:53:57 -0400
From: Markus Stockhausen <stockhausen@collogia.de>
Subject: AW: Metadata corruption at xfs_attr3_leaf_write_verify()
Date: Tue, 1 Aug 2017 18:53:21 +0000
Message-ID: <12EF8D94C6F8734FB2FF37B9FBEDD173010E02F9D1@EXCHANGE.collogia.de>
References: <d161b07cad6536b0baf285328cf99500@mail.gmail.com>
 <A3EABCF079964F4FA6058F30EBF80FD8@alyakaslap>,<b1f0c224-11b6-ba24-23e4-187f13d5cf17@sandeen.net>
In-Reply-To: <b1f0c224-11b6-ba24-23e4-187f13d5cf17@sandeen.net>
Content-Language: de-DE
Content-Type: multipart/mixed;
        boundary="----=_NextPartTM-000-db07d644-e5f3-4cc0-82d4-3823872a979a"
MIME-Version: 1.0
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>, Alex Lyakas <alex@zadarastorage.com>, "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>
Cc: Shyam Kaushik <shyam@zadarastorage.com>, "bfoster@redhat.com" <bfoster@redhat.com>, "dchinner@redhat.com" <dchinner@redhat.com>, "david@fromorbit.com" <david@fromorbit.com>


This is a multi-part message in MIME format.

------=_NextPartTM-000-db07d644-e5f3-4cc0-82d4-3823872a979a
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

> Von: linux-xfs-owner@vger.kernel.org [linux-xfs-owner@vger.kernel.org]&qu=
ot; im Auftrag von &quot;Eric Sandeen [sandeen@sandeen.net]=0A=
> Gesendet: Dienstag, 1. August 2017 20:22=0A=
> An: Alex Lyakas; linux-xfs@vger.kernel.org=0A=
> Cc: Shyam Kaushik; bfoster@redhat.com; dchinner@redhat.com; david@fromorb=
it.com=0A=
> Betreff: Re: Metadata corruption at xfs_attr3_leaf_write_verify()=0A=
> =0A=
> On 8/1/17 12:30 PM, Alex Lyakas wrote:=0A=
> > Greetings XFS developers, David, Brian,=0A=
> >=0A=
> > We did additional debugging on this issue. The problematic flow happens=
 to be the following:=0A=
> >=0A=
> > - New inode (regular file) is being created.=0A=
> > - As part of creation, due to parent directory having a default ACL, in=
itial ACL is applied to the inode.=0A=
> > - This ACL is applied as an extended attribute with name "SGI_ACL_FILE"=
 and value length of 100 bytes.=0A=
> > - XFS tries to add this attribute into the inline inode attribute fork =
area (AKA shortform).=0A=
> > - But 100 bytes is too large for the shortform, so XFS creates an empty=
 shortform and then calls xfs_attr_shortform_to_leaf()=0A=
> > - This calls xfs_attr3_leaf_create() and creates a leaf with zero attri=
butes.=0A=
> > - Before XFS is able to add the attribute to the leaf, the xfsaild thre=
ad wants to write this leaf to disk, and trips over the assert in xfs_attr3=
_leaf_verify, that ichdr.count should not be 0=0A=
> >=0A=
> > So this seems like a race condition, where xfsaild writes a not-fully-p=
repared xfs_buf to disk. To my understanding this can lead to different kin=
ds of corruptions.=0A=
> =0A=
> Interesting, this seems possibly related to this commit, which=0A=
> addresses a similar issue only during log replay:=0A=
> =0A=
> commit 2e1d23370e75d7d89350d41b4ab58c7f6a0e26b2=0A=
> Author: Eric Sandeen <sandeen@redhat.com>=0A=
> Date:   Fri Dec 9 16:49:47 2016 +1100=0A=
> =0A=
>     xfs: ignore leaf attr ichdr.count in verifier during log replay=0A=
> =0A=
>     When we create a new attribute, we first create a shortform=0A=
>     attribute, and try to fit the new attribute into it.=0A=
>     If that fails, we copy the (empty) attribute into a leaf attribute,=
=0A=
>     and do the copy again.  Thus there can be a transient state where=0A=
>     we have an empty leaf attribute.=0A=
> =0A=
>     If we encounter this during log replay, the verifier will fail.=0A=
>     So add a test to ignore this part of the leaf attr verification=0A=
>     during log replay.=0A=
> =0A=
>     Thanks as usual to dchinner for spotting the problem.=0A=
> =0A=
>     Signed-off-by: Eric Sandeen <sandeen@redhat.com>=0A=
>     Reviewed-by: Christoph Hellwig <hch@lst.de>=0A=
>     Signed-off-by: Dave Chinner <david@fromorbit.com>=0A=
=0A=
The initial message dealt with kernel 3.18. If this is really related and w=
e=0A=
have similar behaviour through recent kernels - will the above patch =0A=
be helpful for 4.4 longterm?=0A=
=0A=
Markus=
------=_NextPartTM-000-db07d644-e5f3-4cc0-82d4-3823872a979a
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

------=_NextPartTM-000-db07d644-e5f3-4cc0-82d4-3823872a979a--
