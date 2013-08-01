Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 9319F29DFB
	for <linux-xfs@oss.sgi.com>; Thu,  1 Aug 2013 09:50:38 -0500 (CDT)
Message-ID: <51FA75BE.9080705@sgi.com>
Date: Thu, 01 Aug 2013 09:50:38 -0500
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH] xfsprogs: fix unint var in repair phase6
References: <51F9B626.4010707@redhat.com>
In-Reply-To: <51F9B626.4010707@redhat.com>
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
To: Eric Sandeen <sandeen@redhat.com>
Cc: "'linux-xfs@oss.sgi.com'" <linux-xfs@oss.sgi.com>

On 07/31/13 20:13, Eric Sandeen wrote:
> 2 calls to libxfs_bmapi_write exist in repair's phase6
> where "first" is uninitialized, but is accessed
> in that function.
>
> Normally we call xfs_bmap_init() first to initialize
> both the free list and the first block, but in these
> cases, the free list var is sent as NULL.
>
> So in these 2 cases, explicitly initialize the "first"
> variable to NULLFSBLOCK as xfs_bmap_init() does
> elsewhere.
>
> Coverity caught this.
>
> Signed-off-by: Eric Sandeen<sandeen@redhat.com>
> ---

Looks good.

Reviewed-by: Mark Tinguely <tinguely@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
