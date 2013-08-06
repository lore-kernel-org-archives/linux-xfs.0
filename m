Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id C6F8729DFB
	for <xfs@oss.sgi.com>; Tue,  6 Aug 2013 11:16:49 -0500 (CDT)
Message-ID: <52012170.5060203@sgi.com>
Date: Tue, 06 Aug 2013 11:16:48 -0500
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH 39/49] xfs: move kernel specific type definitions to xfs.h
References: <1374216324-8781-1-git-send-email-david@fromorbit.com>
	<1374216324-8781-40-git-send-email-david@fromorbit.com>
In-Reply-To: <1374216324-8781-40-git-send-email-david@fromorbit.com>
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

On 07/19/13 01:45, Dave Chinner wrote:
> From: Dave Chinner<dchinner@redhat.com>
>
> xfs_types.h is shared with userspace, so having kernel specific
> types defined in it is problematic. Move all the kernel specific
> defines to xfs_linux.h so we can remove the __KERNEL__ guards from
> xfs_types.h
>
> Signed-off-by: Dave Chinner<dchinner@redhat.com>
> ---


user equivalent of the for Linux 3.12 kernel patch 33/49.

patches are the same,

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
