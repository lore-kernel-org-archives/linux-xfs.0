Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id E81697F3F
	for <xfs@oss.sgi.com>; Sat,  3 Aug 2013 10:23:05 -0500 (CDT)
Message-ID: <51FD2059.3060001@sgi.com>
Date: Sat, 03 Aug 2013 10:23:05 -0500
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH 17/49] xfs: split out inode log item format definition
References: <1374216324-8781-1-git-send-email-david@fromorbit.com>
	<1374216324-8781-18-git-send-email-david@fromorbit.com>
In-Reply-To: <1374216324-8781-18-git-send-email-david@fromorbit.com>
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
> Th elog item format definitions are shared with userspace. split the
> out of header files that contain kernel only defintions to make it
> simple to shared them.
>
> Signed-off-by: Dave Chinner<dchinner@redhat.com>
> ---

sync the new user/kernel xfs_inode.h and xfs_log_format.h to patch 02/49 
of the for Linux 3.12 kernel patch series which also means remove 
kernel-only headers.
		---
Kernel commit 92f8ff73 added "i_pdquot" to the xfs_inode structure. If 
you want we can refresh this patch on commit rather than rebase the series.

Reviewed-by: Mark Tinguely <tinguely@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
