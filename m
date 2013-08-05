Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id F26C47CBF
	for <xfs@oss.sgi.com>; Mon,  5 Aug 2013 16:22:22 -0500 (CDT)
Date: Mon, 5 Aug 2013 16:22:22 -0500
From: Ben Myers <bpm@sgi.com>
Subject: Re: [PATCH 46/48] libxfs: fix dir3 freespace block corruption
Message-ID: <20130805212222.GV3111@sgi.com>
References: <1370564771-4929-1-git-send-email-david@fromorbit.com>
	<1370564771-4929-47-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1370564771-4929-47-git-send-email-david@fromorbit.com>
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

On Fri, Jun 07, 2013 at 10:26:09AM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> When the directory freespace index grows to a second block (2017
> 4k data blocks in the directory), the initialisation of the second
> new block header goes wrong. The write verifier fires a corruption
> error indicating that the block number in the header is zero. This
> was being tripped by xfs/110.
> 
> The problem is that the initialisation of the new block is done just
> fine in xfs_dir3_free_get_buf(), but the caller then users a dirv2
> structure to zero on-disk header fields that xfs_dir3_free_get_buf()
> has already zeroed. These lined up with the block number in the dir
> v3 header format.
> 
> While looking at this, I noticed that the struct xfs_dir3_free_hdr()
> had 4 bytes of padding in it that wasn't defined as padding or being
> zeroed by the initialisation. Add a pad field declaration and fully
> zero the on disk and in-core headers in xfs_dir3_free_get_buf() so
> that this is never an issue in the future. Note that this doesn't
> change the on-disk layout, just makes the 32 bits of padding in the
> layout explicit.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>

Goes with commit 5170711df79b28

Reviewed-by: Ben Myers <bpm@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
