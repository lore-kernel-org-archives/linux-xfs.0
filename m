Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 1E1737F3F
	for <xfs@oss.sgi.com>; Tue, 22 Oct 2013 12:16:58 -0500 (CDT)
Date: Tue, 22 Oct 2013 12:16:54 -0500
From: Ben Myers <bpm@sgi.com>
Subject: Re: [PATCH 08/19] xfs: decouple log and transaction headers
Message-ID: <20131022171654.GO1935@sgi.com>
References: <1381789085-21923-1-git-send-email-david@fromorbit.com>
	<1381789085-21923-9-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1381789085-21923-9-git-send-email-david@fromorbit.com>
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On Tue, Oct 15, 2013 at 09:17:54AM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> xfs_trans.h has a dependency on xfs_log.h for a couple of
> structures. Most code that does transactions doesn't need to know
> anything about the log, bu this dependency means that they have to
> include xfs_log.h. Decouple the xfs_trans.h and xfs_log.h header
> files and clean up the includes to be in dependency order.
> 
> In doing this, remove the direct include of xfs_trans_reserve.h from
> xfs_trans.h so that we remove the dependency between xfs_trans.h and
> xfs_mount.h. Hence the xfs_trans.h include can be moved to the
> indicate the actual dependencies oher header files have on it.
> 
> Note that these are kernel only header files, so this does not
> translate to any userspace changes at all.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>

Reviewed-by: Ben Myers <bpm@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
