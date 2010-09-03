Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o83Dgu0h254080 for <xfs@oss.sgi.com>; Fri, 3 Sep 2010 08:42:56 -0500
Subject: Re: [GIT PULL] xfs: fixes for 2.6.36
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <20100903040850.GB705@dastard>
References: <20100903040850.GB705@dastard>
Date: Fri, 03 Sep 2010 08:42:48 -0500
Message-ID: <1283521368.3094.6.camel@doink>
Mime-Version: 1.0
Reply-To: aelder@sgi.com
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On Fri, 2010-09-03 at 14:08 +1000, Dave Chinner wrote:
> Hi Alex,
> 
> Can you please pull the following branch for your next 2.6.36
> bug-fix update to linus? Thanks.

Yes, I'll take it in today.  Thanks.	-Alex

> 
> The following changes since commit 2bfc96a127bc1cc94d26bfaa40159966064f9c8c:
> 
>   Linux 2.6.36-rc3 (2010-08-29 08:36:04 -0700)
> 
> are available in the git repository at:
>   git://git.kernel.org/pub/scm/linux/kernel/git/dgc/xfsdev.git 2.6.36-xfs-misc
> 
> Dave Chinner (2):
>       xfs: improve buffer cache hash scalability
>       xfs: prevent 32bit overflow in space reservation
> 
>  fs/xfs/linux-2.6/xfs_buf.c |    8 +-------
>  fs/xfs/linux-2.6/xfs_buf.h |    1 -
>  fs/xfs/xfs_vnodeops.c      |   13 ++++++++++---
>  3 files changed, 11 insertions(+), 11 deletions(-)



_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
