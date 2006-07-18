Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 18 Jul 2006 16:55:29 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id k6INslDW025447
	for <xfs@oss.sgi.com>; Tue, 18 Jul 2006 16:55:01 -0700
Date: Wed, 19 Jul 2006 09:54:00 +1000
From: Nathan Scott <nathans@sgi.com>
Subject: Re: stable xfs
Message-ID: <20060719095400.A1936041@wobbly.melbourne.sgi.com>
References: <1153150223.4532.24.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1153150223.4532.24.camel@localhost.localdomain>; from mingz@ele.uri.edu on Mon, Jul 17, 2006 at 11:30:23AM -0400
Sender: xfs-bounce@oss.sgi.com
Errors-To: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Ming Zhang <mingz@ele.uri.edu>
Cc: xfs@oss.sgi.com

On Mon, Jul 17, 2006 at 11:30:23AM -0400, Ming Zhang wrote:
> Hi All
> 
> We want to use XFS in all of our production servers but feel a little
> scary about the corruption problems seen in this list. I wonder which
> 2.6.16+ kernel we can use in order to get a stable XFS? Thanks!

Use the latest 2.6.17 -stable release, or a vendor kernel (SLES is
particularly good with XFS, as SGI works closely with SUSE).

The current batch of corruption reports is due to one unfortunate
bug that has slipped through our QA testing net, which happily is
a fairly rare occurence (it was a very subtle bug).

XFS also tends to get a bad rap (IMO) from the way it reports on-disk
corruption and I/O errors in critical data structures, which is quite
different to many other filesystems - it dumps a stack trace into the
system log (alot of people mistake that for a panic) and "shuts down"
the filesystem, with subsequent accesses returning errors until the
problem is resolved.

> ps, one friend mentioned that XFS has some issue with LVM+MD under it.
> Is this true?

No.

cheers.

-- 
Nathan
