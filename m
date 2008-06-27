Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 27 Jun 2008 00:12:17 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m5R7CDgD004260
	for <xfs@oss.sgi.com>; Fri, 27 Jun 2008 00:12:13 -0700
Received: from bob.dscon.sk (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 92015D645FE
	for <xfs@oss.sgi.com>; Fri, 27 Jun 2008 00:13:14 -0700 (PDT)
Received: from bob.dscon.sk (bob.dscon.sk [88.86.113.10]) by cuda.sgi.com with ESMTP id goATRVc99NbTPR8h for <xfs@oss.sgi.com>; Fri, 27 Jun 2008 00:13:14 -0700 (PDT)
Date: Fri, 27 Jun 2008 09:13:12 +0200
Subject: Re: is the flush-on-close-after-truncate still needed?
Message-ID: <20080627071312.GB15920@bob.dscon.sk>
References: <4859415B.3000009@sandeen.net> <200806181049.07812.dchinner@agami.com> <20080626210904.GA15920@bob.dscon.sk> <486407EB.70703@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <486407EB.70703@sandeen.net>
From: xfs@bob.dscon.sk (DS)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs@oss.sgi.com

Thanx for interest.

There is no chance to change all scripts (too many customers and
thousands and thousands perl/php skripts).

I think it isn't right way compiling own perl/php libs with needed changes on
open/fopen function.

DS

On Thu, Jun 26, 2008 at 04:19:39PM -0500, Eric Sandeen wrote:
> DS wrote:
> > Hmm, but file overwrite in perl/php is slow, very slow.
> 
> If you have control over your perl/php, perhaps you can change it to do
> unlink/create/write instead of truncate/write?
> 
> -Eric
> 
> > Which FS is best for me?
> > XFS - perl/php overwrite problem
> > EXT3 - 32000 subdirs limit
> > REISER - no future
> > JFS - ?
> > 
> > DS
> > 
> > On Wed, Jun 18, 2008 at 10:49:07AM -0700, Dave Chinner wrote:
> >> On Wednesday 18 June 2008 10:09 am, Eric Sandeen wrote:
> >>> After Lachlan's fix to separate on-disk and in-memory sizes, and only
> >>> update on-disk when data is on-disk
> >>> (http://www.linux.sgi.com/archives/xfs/2007-05/msg00020.html) is the
> >>> XFS_ITRUNCATED flag / flush-on-close-after-truncate still needed?
> >> Yes, because waiting 30s before writing back /etc/fstab after it
> >> has been modified will result in lots of bug reports of /etc/fstab
> >> being zero length after a crash instead of being full of NULLs.
> >> We have had very few reports of zero length files or files with
> >> NULLs since this change was made (regardless of the file size 
> >> update ordering changes). i.e. if we remove this code then the
> >> common case where NULL files occurred will return - only this
> >> time as zero length files.
> >>
> >> Cheers,
> >>
> >> Dave.
> >>
> >>
> > 
> > 
> 
