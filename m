Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 04 Apr 2007 06:47:38 -0700 (PDT)
Received: from mail3b1.westend.com (mail3b.westend.com [212.117.79.78])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l34DlTfB027541
	for <xfs@oss.sgi.com>; Wed, 4 Apr 2007 06:47:31 -0700
Date: Wed, 4 Apr 2007 15:47:24 +0200
From: Thomas Kaehn <tk@westend.com>
Subject: Re: Strange delete performance using XFS
Message-ID: <20070404134724.GF18320@mail3b.westend.com>
References: <20070404130535.GE18320@mail3b.westend.com> <Pine.LNX.4.64.0704040928110.7309@p34.internal.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <Pine.LNX.4.64.0704040928110.7309@p34.internal.lan>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: xfs@oss.sgi.com

Hi Justin,

On Wed, Apr 04, 2007 at 09:29:46AM -0400, Justin Piszcz wrote:
> >Please see below for "time" output.
> >
> >| # time for i in `seq 1 100000`; do dd if=/dev/zero of=$i bs=1k count=20 
> >>/dev/null 2>&1; done
> >|
> >| real    6m6.814s
> >| user    0m30.290s
> >| sys     2m42.562s
> >| # time rm -rf y
> >|
> >| real    5m18.034s
> >| user    0m0.036s
> >| sys     0m8.169s

> Deletes on XFS is one area that is a little slower than other filesystems. 
> You can increase the log size during the creation of the filesystem and 
> also increase logbufs to 8 and that might help.

Thanks for your suggestions.

I also tried to increase the log size and logbufs mount option. This
optimizes create and delete times to the above values (with default options
both are around 9-10 minutes).

The strange thing is that on a similar Dell machines using XFS, too,
deletes take only ten seconds which would match user and system time.

More than five minutes for deleting 100000 files where ext3 needs
3 seconds on the same machine is actually more than a little bit slower
- to my mind there must be something wrong. JFS needs around 18 seconds.

However I am not sure if the problem is hardware or software related.
I've also tried to use the newest 3ware firmware - but this did not lead
to an improvement.

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
