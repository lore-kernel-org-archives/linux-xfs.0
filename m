Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 05 Apr 2007 03:21:49 -0700 (PDT)
Received: from lucidpixels.com (lucidpixels.com [75.144.35.66])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l35ALifB006633
	for <xfs@oss.sgi.com>; Thu, 5 Apr 2007 03:21:45 -0700
Date: Thu, 5 Apr 2007 06:21:43 -0400 (EDT)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: Strange delete performance using XFS
In-Reply-To: <20070405090333.GE2759@mail3b.westend.com>
Message-ID: <Pine.LNX.4.64.0704050621350.17700@p34.internal.lan>
References: <20070404130535.GE18320@mail3b.westend.com>
 <20070404154523.GA20096@tuatara.stupidest.org> <20070405072803.GB2759@mail3b.westend.com>
 <20070405090333.GE2759@mail3b.westend.com>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-1463747160-1411685764-1175768503=:17700"
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Thomas Kaehn <tk@westend.com>
Cc: Chris Wedgwood <cw@f00f.org>, xfs@oss.sgi.com

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---1463747160-1411685764-1175768503=:17700
Content-Type: TEXT/PLAIN; charset=iso-8859-1; format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE



On Thu, 5 Apr 2007, Thomas Kaehn wrote:

> Hi Chris,
>
> On Thu, Apr 05, 2007 at 09:28:03AM +0200, Thomas Kaehn wrote:
>> On Wed, Apr 04, 2007 at 08:45:23AM -0700, Chris Wedgwood wrote:
>>> On Wed, Apr 04, 2007 at 03:05:35PM +0200, Thomas Kaehn wrote:
>>>> The XFS was first created using default options and later on with
>>>> "-d su=3D64k,sw=3D2 -l su=3D64k" which improved overall performance
>>>> but not delete performance.
>>>
>>> have you tried w/o using the hw raid?
>>
>> I'am going to test with a single disk in the same machine.
>
> this is what I got with a single disk (defaults for mkfs.xfs, logbufs=3D8=
 for
> mount) in the same machine:
>
> | # time for i in `seq 1 100000`; do dd if=3D/dev/zero of=3D$i bs=3D1k co=
unt=3D20 >/dev/null 2>&1; done
> |
> | real    11m22.487s
> | user    0m30.278s
> | sys     2m33.762s
> | # time \rm -rf y
> |
> | real    8m20.963s
> | user    0m0.056s
> | sys     0m7.968s
>
> So there is no improvement for a single disk.
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

What kind of disks are you using? Maybe just slow disks??=

---1463747160-1411685764-1175768503=:17700--
