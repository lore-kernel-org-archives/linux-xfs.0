Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 28E007CBF
	for <xfs@oss.sgi.com>; Thu,  5 Sep 2013 16:21:40 -0500 (CDT)
Message-ID: <5228F5E3.2050908@sgi.com>
Date: Thu, 05 Sep 2013 16:21:39 -0500
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH 22/55] xfs: split out on-disk transaction definitions
References: <1378332359-14737-1-git-send-email-david@fromorbit.com>
	<1378332359-14737-23-git-send-email-david@fromorbit.com>
In-Reply-To: <1378332359-14737-23-git-send-email-david@fromorbit.com>
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

On 09/04/13 17:05, Dave Chinner wrote:
> From: Dave Chinner<dchinner@redhat.com>
>
> There's a bunch of definitions in xfs_trans.h that define on-disk
> formats - transaction headers taht get written into the log, log
> item type definitions, etc. Split out everything into a separate
> file so that all which remains in xfs_trans.h are kernel only
> definitions.
>
> Signed-off-by: Dave Chinner<dchinner@redhat.com>
> ---

xfsprogs equivalent of the for 3.12 kernel patch 07/50.

Yeah, this patch syncs up to the kernel very nicely (this is where the 
sync started to deviate in the previous series).

Minor log reservation differences in xfs_trans.h but we know they are 
addressed in future patches.

Reviewed-by: Mark Tinguely <tinguely@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
