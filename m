Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id CC60C29DFE
	for <xfs@oss.sgi.com>; Fri, 12 Apr 2013 19:45:19 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id AD08C8F8040
	for <xfs@oss.sgi.com>; Fri, 12 Apr 2013 17:45:16 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	wufc2RtKjUsCt76F for <xfs@oss.sgi.com>;
	Fri, 12 Apr 2013 17:45:15 -0700 (PDT)
Date: Sat, 13 Apr 2013 10:45:12 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: xfs_fsr, sunit, and swidth
Message-ID: <20130413004512.GI30622@dastard>
References: <5142AE40.6040408@hardwarefreak.com>
	<20130315114538.GF6369@dastard>
	<5143F94C.1020708@hardwarefreak.com>
	<20130316072126.GG6369@dastard> <515082C3.2000006@binghamton.edu>
	<515361B5.8050603@hardwarefreak.com>
	<5155F2B2.1010308@binghamton.edu> <20130331012231.GJ6369@dastard>
	<515C3BF3.60601@binghamton.edu> <51684382.50008@binghamton.edu>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <51684382.50008@binghamton.edu>
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
To: Dave Hall <kdhall@binghamton.edu>
Cc: stan@hardwarefreak.com, "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On Fri, Apr 12, 2013 at 01:25:22PM -0400, Dave Hall wrote:
> Stan,
> 
> IDid this post get lost in the shuffle?  Looking at it I think it
> could have been a bit unclear.  What I need to do anyways is have a
> second, off-site copy of my backup data.  So I'm going to be
> building a second array.  In copying, in order to preserve the hard
> link structure of the source array I'd have to run a sequence of cp
> -al / rsync calls that would mimic what rsnapshot did to get me to
> where I am right now.  (Note that I could also potentially use rsync
> --link-dest.)
> So the question is how would the target xfs file system fare as far
> as my inode fragmentation situation is concerned?  I'm hoping that
> since the target would be a fresh file system, and since during the
> 'copy' phase I'd only be adding inodes, that the inode allocation
> would be more compact and orderly than what I have on the source
> array since.  What do you think?

Sure, it would be to start with, but you'll eventually end up in the
same place. Removing links from the forest is what leads to the
sparse free inode space, so even starting with a dense inode
allocation pattern, it'll turn sparse the moment you remove backups
from the forest....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
