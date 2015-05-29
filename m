Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id A711B7F3F
	for <xfs@oss.sgi.com>; Fri, 29 May 2015 17:27:28 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 965328F804C
	for <xfs@oss.sgi.com>; Fri, 29 May 2015 15:27:25 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	gDph3r4FBDv1Lycb for <xfs@oss.sgi.com>;
	Fri, 29 May 2015 15:27:19 -0700 (PDT)
Date: Sat, 30 May 2015 08:27:17 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: xfs_repair segfault + debug info
Message-ID: <20150529222717.GB24666@dastard>
References: <556871CD.6090507@pml.ac.uk>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <556871CD.6090507@pml.ac.uk>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Mike Grant <mggr@pml.ac.uk>
Cc: xfs@oss.sgi.com

On Fri, May 29, 2015 at 03:03:57PM +0100, Mike Grant wrote:
> We recently had a 180TB XFS filesystem go down after following some
> ill-considered advice from a Dell tech (re-onlining a maybe-failed disk,
> which one might think was ok..).  It's not irreplaceable data, but
> xfs_repair segfaults when trying to fix up and I thought that might be
> of interest here to help fix the segfault.  We're not expecting to
> recover the data, though it would be nice.
> 
> Partial logs & backtraces of xfs_repair runs using the latest Centos-7
> xfsprogs package and also run with the xfs_repair built from the git
> master, copies of core dumps and a metadump are at:
>  https://rsg.pml.ac.uk/shared_files/mggr/xfs_segfault

Given it is choking on directory corruption repair, I'd strong
recommend trying the current git version (3.2.3-rc1) here:

git://git.kernel.org/pub/scm/fs/xfs/xfsprogs-dev.git

> Maximum memory use was only about 1GB by the time of the crash, and
> there was 120GB+ of swap available, so I don't think that was an issue.
>  The command was "xfs_repair -v /dev/md0 -t 60 -P".
> 
> Run time is about 2 hours to a crash and we'll probably want to wipe and

Probably because you turned off prefetch, which makes it *slow*. :P

I'd build the new xfsprogs, restore the metadump to a file on a
different machine, and then run the new xfs_repair binary on the
restored metadump image. That will tell you pretty quickly if the
problem is solved. If it is solved, then you can run the new
xfs_repair on the real server.

Just remember, though, that even once the FS has been repaired,
you'll still have to search for data corruption manually and deal
with that...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
