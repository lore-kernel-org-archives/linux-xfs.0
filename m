Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q8LLLEik251233 for <xfs@oss.sgi.com>; Fri, 21 Sep 2012 16:21:14 -0500
Date: Fri, 21 Sep 2012 16:22:25 -0500
From: Ben Myers <bpm@sgi.com>
Subject: Re: [PATCH 0/6 V4] inode32/inode64 allocation changes
Message-ID: <20120921212224.GE1140@sgi.com>
References: <1348147961-7520-1-git-send-email-cmaiolino@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1348147961-7520-1-git-send-email-cmaiolino@redhat.com>
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
To: Carlos Maiolino <cmaiolino@redhat.com>
Cc: xfs@oss.sgi.com

Hey Carlos,

On Thu, Sep 20, 2012 at 10:32:35AM -0300, Carlos Maiolino wrote:
> This patch set adds inode64 as the default allocation mode, but also includes 2
> patches to remove duplicated code and another one to make inode32 able to be
> remounted.
> 
> NOTE: This patch has as dependency "Make inode64 a remountable option" patch.
> 
> V4 properly set pagf_metadata in patch 5
> 
> V3 has a better factoring of each patch goal, including other dchinner's
> suggestions in V2. 
> Also it contains a fix in how m_agirotor reset is made (patch 01) that I've
> found while doing tests with these patches.
> 
> Carlos Maiolino (6):
>   xfs: Fix m_agirotor reset during AG selection
>   xfs: make inode64 as the default allocation mode
>   xfs: reduce code duplication handling inode32/64 options
>   xfs: Fix mp->m_maxagi update during inode64 remount
>   xfs: add inode64->inode32 transition into xfs_set_inode32()
>   xfs: Make inode32 a remountable option
> 
>  fs/xfs/xfs_ialloc.c |   2 +-
>  fs/xfs/xfs_mount.c  |  43 +++----------------
>  fs/xfs/xfs_super.c  | 117 ++++++++++++++++++++++++++++++++++++++++------------
>  fs/xfs/xfs_super.h  |   2 +
>  4 files changed, 99 insertions(+), 65 deletions(-)

This patch does not apply cleanly on the master branch.  What are you running?

Thanks,
	Ben

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
