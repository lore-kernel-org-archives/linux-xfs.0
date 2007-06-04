Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 04 Jun 2007 02:07:53 -0700 (PDT)
Received: from mail5.voith.com (mail5.voith.com [62.225.5.140])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l5497iWt003384
	for <xfs@oss.sgi.com>; Mon, 4 Jun 2007 02:07:46 -0700
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----_=_NextPart_001_01C7A686.1D9B3AE1"
Subject: XFS with project quota under linux?
Date: Mon, 4 Jun 2007 10:55:35 +0200
Message-ID: <950DD867A5E1B04ABE82A56FCDC03A5E9CE8CF@HDHS0111.euro1.voith.net>
From: "Jahnke, Steffen" <Steffen.Jahnke@vs-hydro.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

This is a multi-part message in MIME format.

------_=_NextPart_001_01C7A686.1D9B3AE1
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

I recently switched the quota usrquota to pquota on our Altix 4700 under SL=
ES10. I then found out that the project quota is not updated if files are m=
oved within the same filesystem. E.g. if I move a file from a different pro=
ject to a new project it still belongs to the old project. The same thing h=
appens if I move a file which not belongs to any project but which is on th=
e filesystem mounted with pquota.

Some details of our system:

hdhu0250:/home/t # cat /etc/*release
LSB_VERSION=3D"core-2.0-noarch:core-3.0-noarch:core-2.0-ia64:core-3.0-ia64"
SGI ProPack 5SP1 for Linux, Build 501r2-0703010508
SUSE Linux Enterprise Server 10 (ia64)
VERSION =3D 10

hdhu0250:/home/t # uname -a
Linux hdhu0250 2.6.16.27-0.9-default #1 SMP Tue Feb 13 09:35:18 UTC 2007 ia=
64 ia64 ia64 GNU/Linux

hdhu0250:/home # rpm -qa |grep xfs
xfsdump-2.2.33-12.2
xfsprogs-2.7.11-18.2

Any help would be very appreciated. Maybe there is a developer version whic=
h is already to be able to handle pquota correctly??


Mit freundlichen Gr=FC=DFen  /  Best regards

Steffen Jahnke

---------------------------------------------------------------------------=
----
Voith Siemens Hydro Power Generation GmbH & Co. KG
VSEC-International - tts
Alexanderstrasse 11
89522 Heidenheim, Germany

Tel +49 7321 37 2955
Fax +49 7321 37 7601

E-Mail steffen.jahnke@vs-hydro.com
Internet http://www.voithsiemens.com
---------------------------------------------------------------------------=
----
Handelsregister:  Reg. Gericht Ulm, HRA 661052
Sitz der Gesellschaft: Heidenheim
Gesch=E4ftsf=FChrung:
Dr. Hermut Kormann (Vorsitzender), Dr. Hermann Jung,=20
Dr. Hans-Peter Sollinger, Dr. Hubert Lienhard, Peter Edelmann,
Martin Hennerici, Bertram Staudenmaier, Dr. Roland M=FCnch
Pers=F6nlich haftende Gesellschafterin:
J. M. Voith Verwaltungs GmbH
Reg. Gericht Ulm, HRB 661225
 <<Jahnke, Steffen.vcf>>=20

------_=_NextPart_001_01C7A686.1D9B3AE1
Content-Type: text/x-vcard;
	name="Jahnke, Steffen.vcf"
Content-Transfer-Encoding: base64
Content-Description: Jahnke, Steffen.vcf
Content-Disposition: attachment;
	filename="Jahnke, Steffen.vcf"

QkVHSU46VkNBUkQNClZFUlNJT046Mi4xDQpOOkphaG5rZTtTdGVmZmVuDQpG
TjpKYWhua2UsIFN0ZWZmZW4NCk9SRzpWU0g7dHRzDQpURUw7V09SSztWT0lD
RTorNDkgNzMyMSAzNyAyOTU1DQpBRFI7V09SSzo7dHRzO0FsZXhhbmRlcnN0
cmHfZSAxMTtIZWlkZW5oZWltOzs4OTUyMjtHZXJtYW55DQpMQUJFTDtXT1JL
O0VOQ09ESU5HPVFVT1RFRC1QUklOVEFCTEU6dHRzPTBEPTBBQWxleGFuZGVy
c3RyYT1ERmUgMTE9MEQ9MEFIZWlkZW5oZWltIDg5NTIyPTBEPTBBR2VybWFu
eQ0KRU1BSUw7UFJFRjtJTlRFUk5FVDpTdGVmZmVuLkphaG5rZUB2cy1oeWRy
by5jb20NClJFVjoyMDA3MDQxMlQxMTM3MDVaDQpFTkQ6VkNBUkQNCg==

------_=_NextPart_001_01C7A686.1D9B3AE1--
