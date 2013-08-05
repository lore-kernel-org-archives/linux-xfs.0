Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 6B47B7CBF
	for <xfs@oss.sgi.com>; Mon,  5 Aug 2013 14:09:14 -0500 (CDT)
Message-ID: <51FFF856.1050600@sgi.com>
Date: Mon, 05 Aug 2013 14:09:10 -0500
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH 24/49] xfs: introduce xfs_quota_defs.h
References: <1374216324-8781-1-git-send-email-david@fromorbit.com>
	<1374216324-8781-25-git-send-email-david@fromorbit.com>
In-Reply-To: <1374216324-8781-25-git-send-email-david@fromorbit.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On 07/19/13 01:44, Dave Chinner wrote:
> From: Dave Chinner<dchinner@redhat.com>
>
> There are a lot of quota flag definitions that are shared by user
> and kernel space. Move them all to xfs_quota_defs.h so we can
> unshare xfs_quota.h and remove the __KERNEL__ regions from it.
>
> Signed-off-by: Dave Chinner<dchinner@redhat.com>
> ---


xfsprogs equivalent of the for 3.12 kernel patch 09/49.

move remaining quota shared entries from xfs_quota.h to xfs_quota_defs.h 
- as mentioned in patch 20, xfs_quota.h is now kernel-only and removed.
            ----

   should shared files have a common name? - so far the ended in -format.X

Reviewed-by: Mark Tinguely <tinguely@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
