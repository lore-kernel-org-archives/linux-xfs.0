Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 14E817F47
	for <xfs@oss.sgi.com>; Mon, 28 Jan 2013 08:21:06 -0600 (CST)
Message-ID: <51068954.4000205@sgi.com>
Date: Mon, 28 Jan 2013 08:21:08 -0600
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH 2/8] libxfs: initialize xfs_alloc_arg structures
References: <1359240032-11576-1-git-send-email-sandeen@redhat.com>
	<1359240032-11576-3-git-send-email-sandeen@redhat.com>
In-Reply-To: <1359240032-11576-3-git-send-email-sandeen@redhat.com>
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
Cc: xfs@oss.sgi.com

On 01/26/13 16:40, Eric Sandeen wrote:
> This is a merge-to-userspace of kernel commit a0041684
> xfs: zero allocation_args on the kernel stack
>
> When calling xfs_alloc_vextent args.userdata was uninitialized,
> and if we had args.type==XFS_ALLOCTYPE_START_BNO, this uninit
> structure member got tested, leading to some random allocator
> behavior.
>
> Signed-off-by: Eric Sandeen<sandeen@redhat.com>
> ---

I remember seeing this in Dave's:

	[UBER-PATCH, RFC] xfsprogs: sync libxfs to 3.8-rc2 kernel code

http://patchwork.xfs.org/patch/4683/

--Mark.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
