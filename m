Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 04 Apr 2007 13:45:12 -0700 (PDT)
Received: from lucidpixels.com (lucidpixels.com [75.144.35.66])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l34Kj4fB005320
	for <xfs@oss.sgi.com>; Wed, 4 Apr 2007 13:45:08 -0700
Date: Wed, 4 Apr 2007 16:45:03 -0400 (EDT)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: Strange delete performance using XFS
In-Reply-To: <20070404143533.GF12481@mail3b.westend.com>
Message-ID: <Pine.LNX.4.64.0704041644460.20373@p34.internal.lan>
References: <20070404130535.GE18320@mail3b.westend.com>
 <Pine.LNX.4.64.0704040928110.7309@p34.internal.lan> <20070404134724.GF18320@mail3b.westend.com>
 <Pine.LNX.4.64.0704040957120.7309@p34.internal.lan>
 <Pine.LNX.4.64.0704041012330.7309@p34.internal.lan> <20070404142142.GG18320@mail3b.westend.com>
 <Pine.LNX.4.64.0704041023570.7309@p34.internal.lan> <20070404143533.GF12481@mail3b.westend.com>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-1463747160-1667215911-1175719503=:20373"
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Thomas Kaehn <tk@westend.com>
Cc: xfs@oss.sgi.com

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---1463747160-1667215911-1175719503=:20373
Content-Type: TEXT/PLAIN; charset=iso-8859-1; format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE



On Wed, 4 Apr 2007, Thomas Kaehn wrote:

> Hi Justin,
>
> On Wed, Apr 04, 2007 at 10:24:42AM -0400, Justin Piszcz wrote:
>>> On Wed, Apr 04, 2007 at 10:12:48AM -0400, Justin Piszcz wrote:
>>>> On Wed, 4 Apr 2007, Justin Piszcz wrote:
>>>>> On Wed, 4 Apr 2007, Thomas Kaehn wrote:
>>>>> $ time for i in `seq 1 100000`; do dd if=3D/dev/zero of=3D$i bs=3D1k =
count=3D20
>>>>>> /dev/null 2>&1; done
>>>>>
>> My guess is mkfs.xfs cannot optimzie for your array like it can with a SW
>> RAID device because it cannot see what is undereath it.  Have you tried
>> making a SW RAID?  I also use optimized parameters for my SW RAID1/5 as
>> well FYI.
>
> I guess this might be the problem. I've already tried to alter
> the stripe unit to match the RAID stripe size: "-d su=3D64k,sw=3D2 -l su=
=3D64k".
>
> Maybe the 3ware controller can't deal with the kind of read and write
> patterns needed by XFS. But in this case other people should have
> realized similar problems.
>
> On a different system with a 3ware 9500S-4LP using 4 disks as RAID5
> setup I get a better (but not really good) result for delete
> performance (I've taken only 50000 files in this case as the system's
> CPU is much slower):
>
> | # time for i in `seq 1 50000`; do dd if=3D/dev/zero of=3D$i
> | bs=3D1k count=3D20 >/dev/null 2>&1; done
> |
> | real    18m21.643s
> | user    0m55.727s
> | sys     3m12.140s
> | backup:/srv/x# cd ..
> | backup:/srv# rm -rf x
> |
> | # time rm -rf x
> |
> | real    5m7.845s
> | user    0m0.160s
> | sys     0m11.369s
>
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

What do you get with ext3 when using time bash -c 'rm -f file; sync'=

---1463747160-1667215911-1175719503=:20373--
