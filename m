Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 70B8B7CBF
	for <xfs@oss.sgi.com>; Mon,  5 Aug 2013 15:51:46 -0500 (CDT)
Message-ID: <52001061.409@sgi.com>
Date: Mon, 05 Aug 2013 15:51:45 -0500
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH 26/49] libxfs: move transaction code to trans.c
References: <1374216324-8781-1-git-send-email-david@fromorbit.com>
	<1374216324-8781-27-git-send-email-david@fromorbit.com>
In-Reply-To: <1374216324-8781-27-git-send-email-david@fromorbit.com>
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
> There is very little code left in xfs_trans.c. So little it is not
> worthtrying to share this file with kernel space any more. Move the
> code to libxfs/trans.c, and remove libxfs/xfs_trans.c.
>
> Signed-off-by: Dave Chinner<dchinner@redhat.com>
> ---

xfsprogs equivalent of the for 3.12 kernel patch 11/49.

change zone allocator/zone free to calloc/free, change function names to 
libxfs_trans_XX.

Reviewed-by: Mark Tinguely <tinguely@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
