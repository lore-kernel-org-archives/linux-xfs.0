Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 8AAC57CBF
	for <xfs@oss.sgi.com>; Mon,  5 Aug 2013 09:18:30 -0500 (CDT)
Message-ID: <51FFB434.6000304@sgi.com>
Date: Mon, 05 Aug 2013 09:18:28 -0500
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH 20/49] xfs: separate dquot on disk format definitions
	out of xfs_quota.h
References: <1374216324-8781-1-git-send-email-david@fromorbit.com>
	<1374216324-8781-21-git-send-email-david@fromorbit.com>
In-Reply-To: <1374216324-8781-21-git-send-email-david@fromorbit.com>
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
> The on disk format definitions of the on-disk dquot, log formats and
> quota off log formats are all intertwined with other definitions for
> quotas. Separate them out into their own header file so they can
> easily be shared with userspace.
>
> Signed-off-by: Dave Chinner<dchinner@redhat.com>
> ---

xfsprogs equivalent of the for 3.12 kernel patch 05/49.

quota entries moved to new xfs_format.h. quota log entries to 
xfs_log_format.h and a def to xfs_types.h - all synced to kernel patch 
05/49. xfs_quota.h is not synced to kernel 05/49, but in user patch 
24/49 is removed.

Reviewed-by: Mark Tinguely <tinguely@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
