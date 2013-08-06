Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id BE51C29DFB
	for <xfs@oss.sgi.com>; Tue,  6 Aug 2013 10:41:35 -0500 (CDT)
Message-ID: <5201192E.1040205@sgi.com>
Date: Tue, 06 Aug 2013 10:41:34 -0500
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH 35/49] xfs: move swap extent code to xfs_extent_ops
References: <1374216324-8781-1-git-send-email-david@fromorbit.com>
	<1374216324-8781-36-git-send-email-david@fromorbit.com>
In-Reply-To: <1374216324-8781-36-git-send-email-david@fromorbit.com>
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
> Swapping extents is clearly an extent operaiton, and it is not
> shared with userspace. Move the code to xfs_extent_ops.[ch], and
> the userspace ioctl structure definition to xfs_fs.h where most of
> the other ioctl structure definitions are. The means xfs_dfrag.h is
> no longer needed in userspace.
>
> Signed-off-by: Dave Chinner<dchinner@redhat.com>
> ---

Equivalent to patch kernel patch 27/49.

It is out of sequence but the files are the same.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
