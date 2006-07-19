Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 18 Jul 2006 19:23:31 -0700 (PDT)
Received: from orca.ele.uri.edu (orca.ele.uri.edu [131.128.51.63])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id k6J2NADW007736
	for <xfs@oss.sgi.com>; Tue, 18 Jul 2006 19:23:10 -0700
Subject: Re: stable xfs
From: Ming Zhang <mingz@ele.uri.edu>
Reply-To: mingz@ele.uri.edu
In-Reply-To: <20060719095400.A1936041@wobbly.melbourne.sgi.com>
References: <1153150223.4532.24.camel@localhost.localdomain>
	 <20060719095400.A1936041@wobbly.melbourne.sgi.com>
Content-Type: text/plain
Date: Tue, 18 Jul 2006 21:15:53 -0400
Message-Id: <1153271753.2669.276.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-To: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Nathan Scott <nathans@sgi.com>
Cc: xfs@oss.sgi.com

thanks a lot for this detail explanation!

i will check both 2.6.17 -stable release and sles kernel. unfortunately,
i only play with RHEL so far.

Ming

On Wed, 2006-07-19 at 09:54 +1000, Nathan Scott wrote:
> On Mon, Jul 17, 2006 at 11:30:23AM -0400, Ming Zhang wrote:
> > Hi All
> > 
> > We want to use XFS in all of our production servers but feel a little
> > scary about the corruption problems seen in this list. I wonder which
> > 2.6.16+ kernel we can use in order to get a stable XFS? Thanks!
> 
> Use the latest 2.6.17 -stable release, or a vendor kernel (SLES is
> particularly good with XFS, as SGI works closely with SUSE).
> 
> The current batch of corruption reports is due to one unfortunate
> bug that has slipped through our QA testing net, which happily is
> a fairly rare occurence (it was a very subtle bug).
> 
> XFS also tends to get a bad rap (IMO) from the way it reports on-disk
> corruption and I/O errors in critical data structures, which is quite
> different to many other filesystems - it dumps a stack trace into the
> system log (alot of people mistake that for a panic) and "shuts down"
> the filesystem, with subsequent accesses returning errors until the
> problem is resolved.
> 
> > ps, one friend mentioned that XFS has some issue with LVM+MD under it.
> > Is this true?
> 
> No.
> 
> cheers.
> 
