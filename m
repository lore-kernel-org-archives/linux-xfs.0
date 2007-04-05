Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 05 Apr 2007 02:03:40 -0700 (PDT)
Received: from mail3b1.westend.com (mail3b.westend.com [212.117.79.78])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l3593afB021908
	for <xfs@oss.sgi.com>; Thu, 5 Apr 2007 02:03:38 -0700
Date: Thu, 5 Apr 2007 11:03:33 +0200
From: Thomas Kaehn <tk@westend.com>
Subject: Re: Strange delete performance using XFS
Message-ID: <20070405090333.GE2759@mail3b.westend.com>
References: <20070404130535.GE18320@mail3b.westend.com> <20070404154523.GA20096@tuatara.stupidest.org> <20070405072803.GB2759@mail3b.westend.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20070405072803.GB2759@mail3b.westend.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Chris Wedgwood <cw@f00f.org>
Cc: xfs@oss.sgi.com

Hi Chris,

On Thu, Apr 05, 2007 at 09:28:03AM +0200, Thomas Kaehn wrote:
> On Wed, Apr 04, 2007 at 08:45:23AM -0700, Chris Wedgwood wrote:
> > On Wed, Apr 04, 2007 at 03:05:35PM +0200, Thomas Kaehn wrote:
> > > The XFS was first created using default options and later on with
> > > "-d su=64k,sw=2 -l su=64k" which improved overall performance
> > > but not delete performance.
> > 
> > have you tried w/o using the hw raid?
> 
> I'am going to test with a single disk in the same machine. 

this is what I got with a single disk (defaults for mkfs.xfs, logbufs=8 for
mount) in the same machine:

| # time for i in `seq 1 100000`; do dd if=/dev/zero of=$i bs=1k count=20 >/dev/null 2>&1; done
| 
| real    11m22.487s
| user    0m30.278s
| sys     2m33.762s
| # time \rm -rf y
| 
| real    8m20.963s
| user    0m0.056s
| sys     0m7.968s

So there is no improvement for a single disk.

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
