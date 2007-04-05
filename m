Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 05 Apr 2007 03:50:17 -0700 (PDT)
Received: from mail3b1.westend.com (mail3b.westend.com [212.117.79.78])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l35AoCfB013090
	for <xfs@oss.sgi.com>; Thu, 5 Apr 2007 03:50:13 -0700
Date: Thu, 5 Apr 2007 12:50:06 +0200
From: Thomas Kaehn <tk@westend.com>
Subject: Re: Strange delete performance using XFS
Message-ID: <20070405105005.GF2759@mail3b.westend.com>
References: <20070404130535.GE18320@mail3b.westend.com> <20070404154523.GA20096@tuatara.stupidest.org> <20070405072803.GB2759@mail3b.westend.com> <20070405090333.GE2759@mail3b.westend.com> <Pine.LNX.4.64.0704050621350.17700@p34.internal.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <Pine.LNX.4.64.0704050621350.17700@p34.internal.lan>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: Chris Wedgwood <cw@f00f.org>, xfs@oss.sgi.com

Hi Justin,

On Thu, Apr 05, 2007 at 06:21:43AM -0400, Justin Piszcz wrote:
> >So there is no improvement for a single disk.
> >
> What kind of disks are you using? Maybe just slow disks??

I am using the following disks:

http://www.westerndigital.com/en/products/products.asp?DriveID=233

When disabling write barriers delete times are OK. I think that
the 3ware RAID controller could have a problem with it. I'll try to
contact 3ware in order to come to know if this feature is supported or
not.

Additionally I am going to try out some advices presented in the
3ware knowledge base.

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
