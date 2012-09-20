Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q8KDnvTp091203 for <xfs@oss.sgi.com>; Thu, 20 Sep 2012 08:49:57 -0500
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id t3ACvieab6etwZX5 for
	<xfs@oss.sgi.com>; Thu, 20 Sep 2012 06:51:09 -0700 (PDT)
Received: from int-mx11.intmail.prod.int.phx2.redhat.com
	(int-mx11.intmail.prod.int.phx2.redhat.com [10.5.11.24])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id q8KDp99G028246
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Thu, 20 Sep 2012 09:51:09 -0400
Message-ID: <505B1F62.30105@redhat.com>
Date: Thu, 20 Sep 2012 09:51:30 -0400
From: Brian Foster <bfoster@redhat.com>
MIME-Version: 1.0
Subject: Re: [PATCH 0/6 V4] inode32/inode64 allocation changes
References: <1348147961-7520-1-git-send-email-cmaiolino@redhat.com>
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

On 09/20/2012 09:32 AM, Carlos Maiolino wrote:
> This patch set adds inode64 as the default allocation mode, but also includes 2
> patches to remove duplicated code and another one to make inode32 able to be
> remounted.
> 
> NOTE: This patch has as dependency "Make inode64 a remountable option" patch.
> 
> V4 properly set pagf_metadata in patch 5
> 

Hi Carlos,

With that fix, this patchset looks good to me, thanks.

Reviewed-by: Brian Foster <bfoster@redhat.com>

Brian

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
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
