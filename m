Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 05 Apr 2007 04:11:46 -0700 (PDT)
Received: from lucidpixels.com (lucidpixels.com [75.144.35.66])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l35BBgfB018902
	for <xfs@oss.sgi.com>; Thu, 5 Apr 2007 04:11:43 -0700
Date: Thu, 5 Apr 2007 07:11:41 -0400 (EDT)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: Strange delete performance using XFS
In-Reply-To: <20070405105005.GF2759@mail3b.westend.com>
Message-ID: <Pine.LNX.4.64.0704050711090.17700@p34.internal.lan>
References: <20070404130535.GE18320@mail3b.westend.com>
 <20070404154523.GA20096@tuatara.stupidest.org> <20070405072803.GB2759@mail3b.westend.com>
 <20070405090333.GE2759@mail3b.westend.com> <Pine.LNX.4.64.0704050621350.17700@p34.internal.lan>
 <20070405105005.GF2759@mail3b.westend.com>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-1463747160-1637025469-1175771501=:17700"
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Thomas Kaehn <tk@westend.com>
Cc: Chris Wedgwood <cw@f00f.org>, xfs@oss.sgi.com

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---1463747160-1637025469-1175771501=:17700
Content-Type: TEXT/PLAIN; charset=iso-8859-1; format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE



On Thu, 5 Apr 2007, Thomas Kaehn wrote:

> Hi Justin,
>
> On Thu, Apr 05, 2007 at 06:21:43AM -0400, Justin Piszcz wrote:
>>> So there is no improvement for a single disk.
>>>
>> What kind of disks are you using? Maybe just slow disks??
>
> I am using the following disks:
>
> http://www.westerndigital.com/en/products/products.asp?DriveID=3D233
>
> When disabling write barriers delete times are OK. I think that
> the 3ware RAID controller could have a problem with it. I'll try to
> contact 3ware in order to come to know if this feature is supported or
> not.
>
> Additionally I am going to try out some advices presented in the
> 3ware knowledge base.
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

Ah, ok-- Keep us updated/let us know if you get any new findings/etc.

Something else you can try as well is turning off NCQ, that gave me a=20
10-35% performance boost depending on the benchmark.

Justin.=

---1463747160-1637025469-1175771501=:17700--
