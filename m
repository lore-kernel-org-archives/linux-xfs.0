Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 26 Jun 2008 14:08:16 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m5QL8CNS018767
	for <xfs@oss.sgi.com>; Thu, 26 Jun 2008 14:08:12 -0700
Received: from bob.dscon.sk (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 96E1C123508F
	for <xfs@oss.sgi.com>; Thu, 26 Jun 2008 14:09:12 -0700 (PDT)
Received: from bob.dscon.sk (bob.dscon.sk [88.86.113.10]) by cuda.sgi.com with ESMTP id DKvcBdP7VTH4G1XV for <xfs@oss.sgi.com>; Thu, 26 Jun 2008 14:09:12 -0700 (PDT)
Date: Thu, 26 Jun 2008 23:09:04 +0200
Subject: Re: is the flush-on-close-after-truncate still needed?
Message-ID: <20080626210904.GA15920@bob.dscon.sk>
References: <4859415B.3000009@sandeen.net> <200806181049.07812.dchinner@agami.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200806181049.07812.dchinner@agami.com>
From: xfs@bob.dscon.sk (DS)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

Hmm, but file overwrite in perl/php is slow, very slow.

Which FS is best for me?
XFS - perl/php overwrite problem
EXT3 - 32000 subdirs limit
REISER - no future
JFS - ?

DS

On Wed, Jun 18, 2008 at 10:49:07AM -0700, Dave Chinner wrote:
> On Wednesday 18 June 2008 10:09 am, Eric Sandeen wrote:
> > After Lachlan's fix to separate on-disk and in-memory sizes, and only
> > update on-disk when data is on-disk
> > (http://www.linux.sgi.com/archives/xfs/2007-05/msg00020.html) is the
> > XFS_ITRUNCATED flag / flush-on-close-after-truncate still needed?
> 
> Yes, because waiting 30s before writing back /etc/fstab after it
> has been modified will result in lots of bug reports of /etc/fstab
> being zero length after a crash instead of being full of NULLs.
> We have had very few reports of zero length files or files with
> NULLs since this change was made (regardless of the file size 
> update ordering changes). i.e. if we remove this code then the
> common case where NULL files occurred will return - only this
> time as zero length files.
> 
> Cheers,
> 
> Dave.
> 
> 
