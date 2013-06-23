Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 27B6E7F37
	for <xfs@oss.sgi.com>; Sun, 23 Jun 2013 12:29:53 -0500 (CDT)
Message-ID: <51C7308D.9010505@sgi.com>
Date: Sun, 23 Jun 2013 12:29:49 -0500
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH 10/60] xfs: Inode create transaction reservations
References: <1371617468-32559-1-git-send-email-david@fromorbit.com>
	<1371617468-32559-11-git-send-email-david@fromorbit.com>
In-Reply-To: <1371617468-32559-11-git-send-email-david@fromorbit.com>
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

On 06/18/13 23:50, Dave Chinner wrote:
> Define the log and space transaction sizes. Factor the current
> create log reservation macro into the two logical halves and reuse
> one half for the new icreate transactions. The icreate transaction
> is transparent to all the high level create code - the
> pre-calculated reservations will correctly set the reservations
> dependent on whether the filesystem supports the icreate
> transaction.
>
> Signed-off-by: Dave Chinner<david@fromorbit.com>
> ---

Looks good.

Reviewed-by: Mark Tinguely <tinguely@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
