Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 04 Apr 2007 07:22:18 -0700 (PDT)
Received: from mail3b1.westend.com (mail3b.westend.com [212.117.79.78])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l34EMBfB005858
	for <xfs@oss.sgi.com>; Wed, 4 Apr 2007 07:22:12 -0700
Date: Wed, 4 Apr 2007 16:21:42 +0200
From: Thomas Kaehn <tk@westend.com>
Subject: Re: Strange delete performance using XFS
Message-ID: <20070404142142.GG18320@mail3b.westend.com>
References: <20070404130535.GE18320@mail3b.westend.com> <Pine.LNX.4.64.0704040928110.7309@p34.internal.lan> <20070404134724.GF18320@mail3b.westend.com> <Pine.LNX.4.64.0704040957120.7309@p34.internal.lan> <Pine.LNX.4.64.0704041012330.7309@p34.internal.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <Pine.LNX.4.64.0704041012330.7309@p34.internal.lan>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: xfs@oss.sgi.com

Hi Justin,

On Wed, Apr 04, 2007 at 10:12:48AM -0400, Justin Piszcz wrote:
> On Wed, 4 Apr 2007, Justin Piszcz wrote:
> >On Wed, 4 Apr 2007, Thomas Kaehn wrote:
> >$ time for i in `seq 1 100000`; do dd if=/dev/zero of=$i bs=1k count=20 
> >>/dev/null 2>&1; done
> >
> >1. Six 400GB SATA drives using SW RAID5:
> >real    6m24.411s
> >user    0m43.097s
> >sys     2m17.350s
> >
> 
> The removals:
> The benchmark:
> $ time rm -rf test
> 
> 1. Six 400GB SATA drives using SW RAID5:
> real    0m33.996s
> user    0m0.057s
> sys     0m8.101s

thanks for your bechmark. To my mind this clearly shows that my
setup is wrong at some point. I'll try again with your mount options.

Ciao,
Thomas
-- 
Thomas Kähn                   WESTEND GmbH  |  Internet-Business-Provider
Technik                       CISCO Systems Partner - Authorized Reseller
                              Im Süsterfeld 6          Tel 0241/701333-18
tk@westend.com                D-52072 Aachen              Fax 0241/911879
- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
Die Gesellschaft ist eingetragen im Handelsregister Aachen unter HRB 7608
Geschäftsführer:           Thomas Neugebauer, Thomas Heller, Michael Kolb
