Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 05 Apr 2007 01:17:57 -0700 (PDT)
Received: from mail3b1.westend.com (mail3b.westend.com [212.117.79.78])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l358HrfB010719
	for <xfs@oss.sgi.com>; Thu, 5 Apr 2007 01:17:55 -0700
Date: Thu, 5 Apr 2007 10:17:51 +0200
From: Thomas Kaehn <tk@westend.com>
Subject: Re: Strange delete performance using XFS
Message-ID: <20070405081751.GD2759@mail3b.westend.com>
References: <20070404130535.GE18320@mail3b.westend.com> <Pine.LNX.4.64.0704040928110.7309@p34.internal.lan> <20070404134724.GF18320@mail3b.westend.com> <Pine.LNX.4.64.0704040957120.7309@p34.internal.lan> <Pine.LNX.4.64.0704041012500.7309@p34.internal.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <Pine.LNX.4.64.0704041012500.7309@p34.internal.lan>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: xfs@oss.sgi.com

Hi Justin,

On Wed, Apr 04, 2007 at 10:13:36AM -0400, Justin Piszcz wrote:
> I used the DEFAULT create options for XFS as I find it highly optimizes 
> itself (at least with SW raid) with the exception of the ROOT FS, I had 
> that optimized awhile ago and I kept it:
> 
> /dev/md2       /            xfs 
> logbufs=8,logbsize=262144,biosize=16,noatime,nodiratime,nobarrier  0  1
> 
> 
> For my regular RAID5s though I use defaults,noatime.

I've disabled barriers, too, and performance increased dramatically.

However I am not aware of the consequences of disabling write barriers.
The FAQ generally recommends using write barriers except when having
a battery-backed cache (this 3ware has not).

| # time for i in `seq 1 100000`; do dd if=/dev/zero of=$i bs=1k count=20 >/dev/null 2>&1; done
| 
| real    3m52.182s
| user    0m30.482s
| sys     3m16.152s
| 
| # time \rm -rf y
| 
| real    0m16.327s
| user    0m0.052s
| sys     0m8.305s

So I am unsure if disabling is an option for me. I could imagine
that write barriers are not properly supported by 3ware or have
to be fine tuned at the kernel or SCSI level.

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
