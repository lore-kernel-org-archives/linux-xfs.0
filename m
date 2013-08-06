Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id DE59329DFB
	for <xfs@oss.sgi.com>; Tue,  6 Aug 2013 10:26:35 -0500 (CDT)
Message-ID: <520115AB.5030704@sgi.com>
Date: Tue, 06 Aug 2013 10:26:35 -0500
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH 33/49] xfsprogs: sync minor kernel header differences
References: <1374216324-8781-1-git-send-email-david@fromorbit.com>
	<1374216324-8781-34-git-send-email-david@fromorbit.com>
In-Reply-To: <1374216324-8781-34-git-send-email-david@fromorbit.com>
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
> There are lots of little differences between kernel and userspace
> headers noticable now that the files are largely the same. Clean up
> all the formatting, whitespace and other minor differences in the
> userspace headers.
>
> Signed-off-by: Dave Chinner<dchinner@redhat.com>
> ---

  This patch is the user equivalent of the for Linux 3.12 kernel patch 
22/49.

  xfs_dir2.h kernel file has entry not in user:
extern int xfs_dir3_data_readahead(struct xfs_trans *tp, struct 
xfs_inode *dp,
		xfs_dablk_t bno, xfs_daddr_t mapped_bno);

  xfs_inode_buf.h kernel file has entry not in user:
bool		xfs_can_free_eofblocks(struct xfs_inode *, bool);

  xfs_trans.h user has several entries mentioned in previous patches.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
