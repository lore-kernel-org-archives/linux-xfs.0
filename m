Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 04 Apr 2007 07:35:52 -0700 (PDT)
Received: from mail3b1.westend.com (mail3b.westend.com [212.117.79.78])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l34EZkfB008940
	for <xfs@oss.sgi.com>; Wed, 4 Apr 2007 07:35:47 -0700
Date: Wed, 4 Apr 2007 16:35:33 +0200
From: Thomas Kaehn <tk@westend.com>
Subject: Re: Strange delete performance using XFS
Message-ID: <20070404143533.GF12481@mail3b.westend.com>
References: <20070404130535.GE18320@mail3b.westend.com> <Pine.LNX.4.64.0704040928110.7309@p34.internal.lan> <20070404134724.GF18320@mail3b.westend.com> <Pine.LNX.4.64.0704040957120.7309@p34.internal.lan> <Pine.LNX.4.64.0704041012330.7309@p34.internal.lan> <20070404142142.GG18320@mail3b.westend.com> <Pine.LNX.4.64.0704041023570.7309@p34.internal.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <Pine.LNX.4.64.0704041023570.7309@p34.internal.lan>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: xfs@oss.sgi.com

Hi Justin,

On Wed, Apr 04, 2007 at 10:24:42AM -0400, Justin Piszcz wrote:
> >On Wed, Apr 04, 2007 at 10:12:48AM -0400, Justin Piszcz wrote:
> >>On Wed, 4 Apr 2007, Justin Piszcz wrote:
> >>>On Wed, 4 Apr 2007, Thomas Kaehn wrote:
> >>>$ time for i in `seq 1 100000`; do dd if=/dev/zero of=$i bs=1k count=20
> >>>>/dev/null 2>&1; done
> >>>
> My guess is mkfs.xfs cannot optimzie for your array like it can with a SW 
> RAID device because it cannot see what is undereath it.  Have you tried 
> making a SW RAID?  I also use optimized parameters for my SW RAID1/5 as 
> well FYI.

I guess this might be the problem. I've already tried to alter
the stripe unit to match the RAID stripe size: "-d su=64k,sw=2 -l su=64k".

Maybe the 3ware controller can't deal with the kind of read and write
patterns needed by XFS. But in this case other people should have
realized similar problems.

On a different system with a 3ware 9500S-4LP using 4 disks as RAID5
setup I get a better (but not really good) result for delete
performance (I've taken only 50000 files in this case as the system's
CPU is much slower):

| # time for i in `seq 1 50000`; do dd if=/dev/zero of=$i
| bs=1k count=20 >/dev/null 2>&1; done
| 
| real    18m21.643s
| user    0m55.727s
| sys     3m12.140s
| backup:/srv/x# cd ..
| backup:/srv# rm -rf x
| 
| # time rm -rf x
| 
| real    5m7.845s
| user    0m0.160s
| sys     0m11.369s


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
