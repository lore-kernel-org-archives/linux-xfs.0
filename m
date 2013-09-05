Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id A0D4C7F51
	for <xfs@oss.sgi.com>; Thu,  5 Sep 2013 10:37:13 -0500 (CDT)
Message-ID: <5228A528.1060907@sgi.com>
Date: Thu, 05 Sep 2013 10:37:12 -0500
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH 05/55] libxfs: ensure btree root split sets blkno correctly
References: <1378332359-14737-1-git-send-email-david@fromorbit.com>
	<1378332359-14737-6-git-send-email-david@fromorbit.com>
In-Reply-To: <1378332359-14737-6-git-send-email-david@fromorbit.com>
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
> For CRC enabled filesystems, the BMBT is rooted in an inode, so it
> passes through a difference code path on root splits to the
> freespace and inode btrees. The inode based btree root has a
> corruption problem on split - it's the same problem we saw in the
> directory/attr code where headers are memcpy()d from one block to
> another without updating the self describing metadata.
>
> Simple fix - when copying the header out of the root block, make
> sure the block number is updated correctly.
>
> Signed-off-by: Dave Chinner<dchinner@redhat.com>
> ---

This patch has not changed since last posting. It brings xfsprogs to
kernel commit ade1335a

Review-by: Mark Tinguely <tinguely@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
