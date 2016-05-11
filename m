Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 4CB5C7CA4
	for <xfs@oss.sgi.com>; Wed, 11 May 2016 09:16:02 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 1A8048F8054
	for <xfs@oss.sgi.com>; Wed, 11 May 2016 07:16:02 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id RRgKxxJIZopFsyAD (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 11 May 2016 07:16:01 -0700 (PDT)
Received: from int-mx11.intmail.prod.int.phx2.redhat.com
	(int-mx11.intmail.prod.int.phx2.redhat.com [10.5.11.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mx1.redhat.com (Postfix) with ESMTPS id B550FBF9C6
	for <xfs@oss.sgi.com>; Wed, 11 May 2016 14:16:00 +0000 (UTC)
Date: Wed, 11 May 2016 10:15:59 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 0/7] Configurable error behavior [V4]
Message-ID: <20160511141558.GE42410@bfoster.bfoster>
References: <1462882581-30859-1-git-send-email-cmaiolino@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1462882581-30859-1-git-send-email-cmaiolino@redhat.com>
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
To: Carlos Maiolino <cmaiolino@redhat.com>
Cc: xfs@oss.sgi.com

On Tue, May 10, 2016 at 02:16:14PM +0200, Carlos Maiolino wrote:
> New revision ot the patchset according with comments for V3.
> 
> This patchset is aimed to implement a configurable error behavior in XFS, and,
> most of the design has been done by Dave, so, I kept his signed-off.
> 
> Detailed changelog is written on each patch, but, major changes are:
> 
> 	- make fail_at_unmount a global configuration option inside
> 	  ../xfs/<dev>/err/fail_at_unmount
> 

Any reason you didn't carry the reviewed-by tags from v3?

For Dave's convenience (and based on the reviews of v3 and v4), for the
series:

Reviewed-by: Brian Foster <bfoster@redhat.com>

> Carlos Maiolino (7):
>   xfs: configurable error behavior via sysfs
>   xfs: introduce metadata IO error class
>   xfs: add configurable error support to metadata buffers
>   xfs: introduce table-based init for error behaviors
>   xfs: add configuration of error failure speed
>   xfs: add configuration handlers for specific errors
>   xfs: add "fail at unmount" error handling configuration
> 
>  fs/xfs/xfs_buf.h      |  20 ++++
>  fs/xfs/xfs_buf_item.c | 121 +++++++++++++--------
>  fs/xfs/xfs_mount.c    |  22 +++-
>  fs/xfs/xfs_mount.h    |  34 ++++++
>  fs/xfs/xfs_sysfs.c    | 291 +++++++++++++++++++++++++++++++++++++++++++++++++-
>  fs/xfs/xfs_sysfs.h    |   3 +
>  fs/xfs/xfs_trace.h    |   1 -
>  7 files changed, 446 insertions(+), 46 deletions(-)
> 
> -- 
> 2.4.11
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
