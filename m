Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 7B9D37F3F
	for <xfs@oss.sgi.com>; Wed, 11 Dec 2013 11:25:40 -0600 (CST)
Message-ID: <52A8A010.8070909@sgi.com>
Date: Wed, 11 Dec 2013 11:25:36 -0600
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH v3] xfs: free the efi AIL entry on log recovery failure
References: <20131206212037.560711585@sgi.com>
	<20131208005224.696001432@sgi.com>
	<20131211113126.GA6248@infradead.org>
In-Reply-To: <20131211113126.GA6248@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

On 12/11/13 05:31, Christoph Hellwig wrote:
> Btw, I really think we need to get rid of abusing the AIL for
> tracking EFIs during log recovery before looking at the various
> leaks in this area.  I've actually got a lightly tested patch for
> that, but didn't make much progress on that series.  If you have
> and interest in that area and some spare QA cycles I'd recommend
> to base this on the patch below:
>
> ---
>> From b90935eaba9eb13c67101e5d723513bc6ca6e722 Mon Sep 17 00:00:00 2001
> From: Christoph Hellwig<hch@lst.de>
> Date: Sat, 23 Nov 2013 20:11:09 +0100
> Subject: [PATCH] xfs: simplify EFI/EFD recovery
>
> Use a cancellation table, similar to how we handle buffers instead of
> abusing the AIL during recovery.
>
> Signed-off-by: Christoph Hellwig<hch@lst.de>
> ---
>   fs/xfs/xfs_extfree_item.c |    8 +-
>   fs/xfs/xfs_extfree_item.h |    6 --
>   fs/xfs/xfs_log_priv.h     |    1 +
>   fs/xfs/xfs_log_recover.c  |  183 +++++++++++++--------------------------------
>   4 files changed, 56 insertions(+), 142 deletions(-)


Good idea to remove EFI item recovery from the AIL. It may take some 
time before I get to it.

--Mark.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
