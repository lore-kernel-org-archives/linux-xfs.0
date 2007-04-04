Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 04 Apr 2007 06:29:55 -0700 (PDT)
Received: from lucidpixels.com (lucidpixels.com [75.144.35.66])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l34DTlfB024034
	for <xfs@oss.sgi.com>; Wed, 4 Apr 2007 06:29:49 -0700
Date: Wed, 4 Apr 2007 09:29:46 -0400 (EDT)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: Strange delete performance using XFS
In-Reply-To: <20070404130535.GE18320@mail3b.westend.com>
Message-ID: <Pine.LNX.4.64.0704040928110.7309@p34.internal.lan>
References: <20070404130535.GE18320@mail3b.westend.com>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-1463747160-2087494152-1175693386=:7309"
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Thomas Kaehn <tk@westend.com>
Cc: xfs@oss.sgi.com

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---1463747160-2087494152-1175693386=:7309
Content-Type: TEXT/PLAIN; charset=iso-8859-1; format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE



On Wed, 4 Apr 2007, Thomas Kaehn wrote:

> Hi,
>
> I've got a strange problem on one machine using XFS. Deleting large
> directories (containing about 100000 files, 20k each) using "rm -rf"
> lasts nearly as long as creating the the files using a bash loop.
>
> The machine is running Debian Sarge with a vanilla 2.6.20.3 kernel.
> CPU: Dual Xeon(TM) CPU 3.20GHz
> RAM: 4 GB
> RAID10: 4x 320 GB disks connected to 3ware 9550SXU-8LP
> (Firmware Version =3D FE9X 3.08.00.004)
>
> The XFS was first created using default options and later on with
> "-d su=3D64k,sw=3D2 -l su=3D64k" which improved overall performance
> but not delete performance.
>
> Has anyone realized similar effects? On a different server (Dell 6850)
> the directory can be deleted within seconds. What could be the reason
> for the huge difference in delete performance?
>
> Please see below for "time" output.
>
> | # time for i in `seq 1 100000`; do dd if=3D/dev/zero of=3D$i bs=3D1k co=
unt=3D20 >/dev/null 2>&1; done
> |
> | real    6m6.814s
> | user    0m30.290s
> | sys     2m42.562s
> | # time rm -rf y
> |
> | real    5m18.034s
> | user    0m0.036s
> | sys     0m8.169s
>
> In contrast to this the result on the Dell machine looks more
> reasonable:
>
> | # time for i in `seq 1 100000`; do dd if=3D/dev/zero of=3D$i bs=3D1k co=
unt=3D20 >/dev/null 2>&1; done
> |
> | real    9m26.658s
> | user    0m24.134s
> | sys     3m3.623s
> | # time rm -rf x
> |
> | real    0m10.254s
> | user    0m0.124s
> | sys     0m10.105s
>
> Ciao,
> Thomas
>
> PS: Using JFS and ext3 it is also possible to delete the above directory
> in a couple of seconds. Only XFS seems problematic in this regard on
> this system.
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

Deletes on XFS is one area that is a little slower than other filesystems.=
=20
You can increase the log size during the creation of the filesystem and=20
also increase logbufs to 8 and that might help.=

---1463747160-2087494152-1175693386=:7309--
