Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 62E2129E11
	for <xfs@oss.sgi.com>; Fri, 26 Jul 2013 09:16:48 -0500 (CDT)
Message-ID: <51F284CD.4070006@sgi.com>
Date: Fri, 26 Jul 2013 09:16:45 -0500
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH 31/49] xfs: remove __KERNEL__ check from xfs_dir2_leaf.c
References: <1374215120-7271-1-git-send-email-david@fromorbit.com>
	<1374215120-7271-32-git-send-email-david@fromorbit.com>
In-Reply-To: <1374215120-7271-32-git-send-email-david@fromorbit.com>
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

On 07/19/13 01:25, Dave Chinner wrote:
> From: Dave Chinner<dchinner@redhat.com>
>
> It's actually an ifndef section, which means it is only included in
> userspace. however, it's deep within the libxfs code, so it's
> unlikely that the condition checked in userspace can actually occur
> (search an empty leaf) through the libxfs interfaces. i.e. if it can
> happen in usrspace, it can happen in the kernel, so remove it from
> userspace too....
>
> Signed-off-by: Dave Chinner<dchinner@redhat.com>
> ---

Looks good for the kernel.

Reviewed-by: Mark Tinguely <tinuguely@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
