Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p1O9NhpT125788 for <xfs@oss.sgi.com>; Thu, 24 Feb 2011 03:23:43 -0600
Received: from ipmail05.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 2E3062F8E46
	for <xfs@oss.sgi.com>; Thu, 24 Feb 2011 01:26:27 -0800 (PST)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	uC0A4bHoVyJDDxrB for <xfs@oss.sgi.com>;
	Thu, 24 Feb 2011 01:26:27 -0800 (PST)
Date: Thu, 24 Feb 2011 20:26:25 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: write 'O_DIRECT' file w/odd amount of data: desirable result?
Message-ID: <20110224092625.GA3087@dastard>
References: <4D648D7D.7040500@tlinx.org> <4D64E2BB.7010000@draigBrady.com>
	<4D654C2E.2000703@tlinx.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4D654C2E.2000703@tlinx.org>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: "Linda A. Walsh" <lkml@tlinx.org>
Cc: PXXdraig Brady <P@draigBrady.com>, LKML <linux-kernel@vger.kernel.org>, xfs-oss <xfs@oss.sgi.com>

On Wed, Feb 23, 2011 at 10:04:30AM -0800, Linda A. Walsh wrote:
> 
> 
> FWIW -- xfs-oss, included as 'last line' was of minor interest; known bug on
> this kernel?:
> Linux Ishtar 2.6.35.7-T610-Vanilla-1 #2 SMP PREEMPT Mon Oct 11
> 17:19:41 PDT 2010 x86_64 x86_64 x86_64 GNU/Linux
....
> Of *SIGNIFICANT* note.  In trying to create an empty file of the size
> used, from scratch, using 'xfs_mkfile', I got an error:
> 
> > xfs_mkfile 5776419696 testfile
> pwrite64: Invalid argument

xfs_mkfile does not create an "empty" file. It creates a file that
is full of zeros.

iAnd you're getting that erro because:

5776419696 / 512 = 11,282,069.7188

the last write is not a multiple of the sector size and xfs_mkfile
uses direct IO. It has always failed when you try to do this. If you
want to create allocated, zeroed files of abitrary size, then use:

xfs_io -f -c "truncate $size" -c "resvsp 0 $size" $filename

to preallocate it. it'll be much, much faster than xfs_mkfile.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
