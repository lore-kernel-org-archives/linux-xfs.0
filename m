Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id C105F7CB4
	for <xfs@oss.sgi.com>; Thu,  5 May 2016 09:11:10 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 75D53304051
	for <xfs@oss.sgi.com>; Thu,  5 May 2016 07:11:10 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id f4ByyEnCUxrFU7ZM (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 05 May 2016 07:11:09 -0700 (PDT)
Received: from int-mx14.intmail.prod.int.phx2.redhat.com
	(int-mx14.intmail.prod.int.phx2.redhat.com [10.5.11.27])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mx1.redhat.com (Postfix) with ESMTPS id 2DE18627D5
	for <xfs@oss.sgi.com>; Thu,  5 May 2016 14:11:09 +0000 (UTC)
Date: Thu, 5 May 2016 10:11:07 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 0/7] Configurable error behavior [V3]
Message-ID: <20160505141107.GG1231@bfoster.bfoster>
References: <1462376600-8617-1-git-send-email-cmaiolino@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1462376600-8617-1-git-send-email-cmaiolino@redhat.com>
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

On Wed, May 04, 2016 at 05:43:13PM +0200, Carlos Maiolino wrote:
> This is the new revision of this patchset, according to last comments.
> 
> This patchset is aimed to implement a configurable error behavior in XFS, and
> most of the design has been done by Dave, so, that's why I kept his signed-off
> in the patches.
> 
> This new revision has the detailed changelog written on each patch, but the
> major changes are:
> 
> 	- Detailed changelog by-patch and description fixed to become
> 	  (hopefuly) more clear
> 	- kept fail_at_unmount as a sysfs attribute
> 
> 
> Regarding fail_at_unmount, I left it almost exactly as Dave's design, giving his
> comments on the last revision, although, I still think there is no need to keep
> it as a per-error granularity, so, I was wondering if a single, global option in
> /sys/fs/xfs/<dev>/error/fail_at_unmount wouldn't suffice, but, this will require
> a new place to store the value inside kernel, instead of keeping it inside
> struct xfs_error_cfg, or maybe use the same structure but use it outside of the
> m_error_cfg array?
> 

I agree with regard to the granularity of fail_at_unmount. This was
brought up previously:

http://oss.sgi.com/archives/xfs/2016-02/msg00558.html

... and I haven't heard a use case for per-error granularity.

I suggest just to pull it out of the error classification stuff entirely
and place it under xfs_mount. E.g., at the same level as "fail_writes"
(but not a DEBUG mode only option).

I'm also wondering whether we need more mechanism for the
fail_at_unmount behavior. For example, instead of defining
XFS_MOUNT_UNMOUNTING, could we just call a function that resets
max_retries (of each class) to 0 in the unmount path? Then maybe call
the mount tunable retry_on_unmount or something like that. Thoughts?

Brian

> First 6 patches are ready, the fail_at_unmount one, need to be re-worked if we
> want it in a less granular way, but until now I don't think we reached any
> decision about how it should be implemented.
> 
>  fs/xfs/xfs_buf.h      |  22 ++++
>  fs/xfs/xfs_buf_item.c | 126 ++++++++++++++--------
>  fs/xfs/xfs_mount.c    |  19 +++-
>  fs/xfs/xfs_mount.h    |  32 ++++++
>  fs/xfs/xfs_sysfs.c    | 283 +++++++++++++++++++++++++++++++++++++++++++++++++-
>  fs/xfs/xfs_sysfs.h    |   3 +
>  6 files changed, 437 insertions(+), 48 deletions(-)
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
