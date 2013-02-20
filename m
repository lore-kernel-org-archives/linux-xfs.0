Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id BE8DF7F50
	for <xfs@oss.sgi.com>; Wed, 20 Feb 2013 16:10:01 -0600 (CST)
Message-ID: <512549B6.70705@sgi.com>
Date: Wed, 20 Feb 2013 16:09:58 -0600
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH 0/8] xfsprogs: misc small fixes
References: <1359240032-11576-1-git-send-email-sandeen@redhat.com>
In-Reply-To: <1359240032-11576-1-git-send-email-sandeen@redhat.com>
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
> A handful of fixes from looking over a Coverity scan.
>
> The strncpy fixes (1/8, 5/8) might not be too critical,
> but I think they can't hurt.
>
> The libxfs xfs_alloc_arg initialization (2/8) might clash with Dave's
> libxfs syncup, it can be dropped if it makes things difficult.
> Fixes a real bug though.
>
> Tested by a quick run through xfstests -g auto
>
> Thanks,
> -Eric
>
> [PATCH 1/8] libhandle: Guard against string overflow in path_to_fspath()
> [PATCH 2/8] libxfs: initialize xfs_alloc_arg structures
> [PATCH 3/8] libxfs: fix setup_cursor array allocation
> [PATCH 4/8] xfs_repair: Fix free of uninit ptr in xfs_acl_valid() error path
> [PATCH 5/8] xfs_fsr: guard against path string overflows
> [PATCH 6/8] xfs_fsr: check strdup results properly in initallfs()
> [PATCH 7/8] xfs_fsr: fix attribute no_change_count logic
> [PATCH 8/8] xfs_fsr: remove extraneous close() in fsrallfs()
>
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

patch 1, 3-8 do not interfere with the UBER patch. Patches look good to me.

Reviewed-by: Mark Tinguely <tinguely@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
