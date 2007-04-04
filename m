Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 04 Apr 2007 06:58:03 -0700 (PDT)
Received: from lucidpixels.com (lucidpixels.com [75.144.35.66])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l34DvufB030663
	for <xfs@oss.sgi.com>; Wed, 4 Apr 2007 06:57:57 -0700
Date: Wed, 4 Apr 2007 09:57:56 -0400 (EDT)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: Strange delete performance using XFS
In-Reply-To: <Pine.LNX.4.64.0704040951010.7309@p34.internal.lan>
Message-ID: <Pine.LNX.4.64.0704040957440.7309@p34.internal.lan>
References: <20070404130535.GE18320@mail3b.westend.com>
 <Pine.LNX.4.64.0704040928110.7309@p34.internal.lan> <20070404134724.GF18320@mail3b.westend.com>
 <Pine.LNX.4.64.0704040951010.7309@p34.internal.lan>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-1463747160-1613578982-1175695076=:7309"
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Thomas Kaehn <tk@westend.com>
Cc: xfs@oss.sgi.com

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---1463747160-1613578982-1175695076=:7309
Content-Type: TEXT/PLAIN; charset=iso-8859-1; format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE



On Wed, 4 Apr 2007, Justin Piszcz wrote:

>
>
> On Wed, 4 Apr 2007, Thomas Kaehn wrote:
>
>> Hi Justin,
>>=20
>> On Wed, Apr 04, 2007 at 09:29:46AM -0400, Justin Piszcz wrote:
>>>> Please see below for "time" output.
>>>>=20
>>>> | # time for i in `seq 1 100000`; do dd if=3D/dev/zero of=3D$i bs=3D1k=
 count=3D20
>>>>> /dev/null 2>&1; done
>>>> |
>>>> | real    6m6.814s
>>>> | user    0m30.290s
>>>> | sys     2m42.562s
>>>> | # time rm -rf y
>>>> |
>>>> | real    5m18.034s
>>>> | user    0m0.036s
>>>> | sys     0m8.169s
>>=20
>>> Deletes on XFS is one area that is a little slower than other filesyste=
ms.
>>> You can increase the log size during the creation of the filesystem and
>>> also increase logbufs to 8 and that might help.
>>=20
>> Thanks for your suggestions.
>>=20
>> I also tried to increase the log size and logbufs mount option. This
>> optimizes create and delete times to the above values (with default opti=
ons
>> both are around 9-10 minutes).
>>=20
>> The strange thing is that on a similar Dell machines using XFS, too,
>> deletes take only ten seconds which would match user and system time.
>>=20
>> More than five minutes for deleting 100000 files where ext3 needs
>> 3 seconds on the same machine is actually more than a little bit slower
>> - to my mind there must be something wrong. JFS needs around 18 seconds.
>>=20
>> However I am not sure if the problem is hardware or software related.
>> I've also tried to use the newest 3ware firmware - but this did not lead
>> to an improvement.
>>=20
>> Ciao,
>> Thomas
>> --=20
>> Thomas K=E4hn                   WESTEND GmbH  |  Internet-Business-Provi=
der
>> Technik                       CISCO Systems Partner - Authorized Reseller
>>                              Im S=FCsterfeld 6          Tel 0241/701333-=
18
>> tk@westend.com                D-52072 Aachen              Fax 0241/911879
>> - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
>> Die Gesellschaft ist eingetragen im Handelsregister Aachen unter HRB 7608
>> Gesch=E4ftsf=FChrer:           Thomas Neugebauer, Thomas Heller, Michael=
 Kolb
>>=20
>>=20
>
> I am running some benchmarks with SW raid and will prevent my findings=20
> shortly.

Removal tests coming shortly, benchmarking is always interesting.=

---1463747160-1613578982-1175695076=:7309--
