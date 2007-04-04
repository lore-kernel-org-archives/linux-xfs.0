Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 04 Apr 2007 07:24:50 -0700 (PDT)
Received: from lucidpixels.com (lucidpixels.com [75.144.35.66])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l34EOhfB006635
	for <xfs@oss.sgi.com>; Wed, 4 Apr 2007 07:24:45 -0700
Date: Wed, 4 Apr 2007 10:24:42 -0400 (EDT)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: Strange delete performance using XFS
In-Reply-To: <20070404142142.GG18320@mail3b.westend.com>
Message-ID: <Pine.LNX.4.64.0704041023570.7309@p34.internal.lan>
References: <20070404130535.GE18320@mail3b.westend.com>
 <Pine.LNX.4.64.0704040928110.7309@p34.internal.lan> <20070404134724.GF18320@mail3b.westend.com>
 <Pine.LNX.4.64.0704040957120.7309@p34.internal.lan>
 <Pine.LNX.4.64.0704041012330.7309@p34.internal.lan> <20070404142142.GG18320@mail3b.westend.com>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-1463747160-702127020-1175696682=:7309"
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Thomas Kaehn <tk@westend.com>
Cc: xfs@oss.sgi.com

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---1463747160-702127020-1175696682=:7309
Content-Type: TEXT/PLAIN; charset=iso-8859-1; format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE



On Wed, 4 Apr 2007, Thomas Kaehn wrote:

> Hi Justin,
>
> On Wed, Apr 04, 2007 at 10:12:48AM -0400, Justin Piszcz wrote:
>> On Wed, 4 Apr 2007, Justin Piszcz wrote:
>>> On Wed, 4 Apr 2007, Thomas Kaehn wrote:
>>> $ time for i in `seq 1 100000`; do dd if=3D/dev/zero of=3D$i bs=3D1k co=
unt=3D20
>>>> /dev/null 2>&1; done
>>>
>>> 1. Six 400GB SATA drives using SW RAID5:
>>> real    6m24.411s
>>> user    0m43.097s
>>> sys     2m17.350s
>>>
>>
>> The removals:
>> The benchmark:
>> $ time rm -rf test
>>
>> 1. Six 400GB SATA drives using SW RAID5:
>> real    0m33.996s
>> user    0m0.057s
>> sys     0m8.101s
>
> thanks for your bechmark. To my mind this clearly shows that my
> setup is wrong at some point. I'll try again with your mount options.
>
> Ciao,
> Thomas
> --=20
> Thomas K=E4hn                   WESTEND GmbH  |  Internet-Business-Provid=
er
> Technik                       CISCO Systems Partner - Authorized Reseller
>                              Im S=FCsterfeld 6          Tel 0241/701333-18
> tk@westend.com                D-52072 Aachen              Fax 0241/911879
> - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
> Die Gesellschaft ist eingetragen im Handelsregister Aachen unter HRB 7608
> Gesch=E4ftsf=FChrer:           Thomas Neugebauer, Thomas Heller, Michael =
Kolb
>
>

My guess is mkfs.xfs cannot optimzie for your array like it can with a SW=
=20
RAID device because it cannot see what is undereath it.  Have you tried=20
making a SW RAID?  I also use optimized parameters for my SW RAID1/5 as=20
well FYI.

Justin.=

---1463747160-702127020-1175696682=:7309--
