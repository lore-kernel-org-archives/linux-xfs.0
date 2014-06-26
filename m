Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id D2FAE7F90
	for <xfs@oss.sgi.com>; Thu, 26 Jun 2014 17:59:04 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id BEE638F8033
	for <xfs@oss.sgi.com>; Thu, 26 Jun 2014 15:59:01 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	JpnSzx5QuA4BRX5Z for <xfs@oss.sgi.com>;
	Thu, 26 Jun 2014 15:58:59 -0700 (PDT)
Date: Fri, 27 Jun 2014 08:58:57 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: xfs: possible irq lock inversion dependency detected
Message-ID: <20140626225857.GT9508@dastard>
References: <20140626142004.31b981dc@tlielax.poochiereds.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140626142004.31b981dc@tlielax.poochiereds.net>
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
To: Jeff Layton <jeff.layton@primarydata.com>
Cc: linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com

On Thu, Jun 26, 2014 at 02:20:04PM -0400, Jeff Layton wrote:
> While testing some knfsd patches on XFS today, I got this lockdep
> splatter. The kernel is a stock -rc2 kernel with a pile of knfsd
> patches on top. There are a couple of others in other areas, but
> nothing that would affect this.
> 
> Nothing crashed or seems to be hung, so I'm not sure if it's a real
> problem or not...

Known false positive. the problem is that lockdep is too stupid to
realise you can't mmap a directory inode, but it sees unused
directory inodes from memory reclaim in page faults (i.e. under the
mmap_sem) and so therefore thinks that taking a page fault in
readdir() while holding a directory inode lock on a referenced
directory inode will deadlock....

Teaching lockdep the intricacies of locking heirarchies is difficult
and painful. Fixing this one (and all the other stupidities lockdep
reports because of this) can't be done through annotations - it
requires rewriting a bunch of directory code to use different locks.
And, well, it ain't actually broken right now and there's other more
important issues to be fixed, so unless someone else beats me to
rewriting the readdir readahead code, lockdep is going to remain
unhappy about XFS.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
